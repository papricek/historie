"""Pomocne obrazky pro lokalni registraci stabilniho katastru 1829.

Skript pouze kresli souradnicovou mrizku do historickeho vyrezu a cisla
vrcholu dnesni parcely st. 1. Samotne kontrolni body se doplni az po
vizualni kontrole, aby nevznikla falesna presnost.
"""

from pathlib import Path
import json

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
HIST = ROOT / "prameny_online/mapy_katastralni/1829/cisarsky_otisk_statek_st1.jpg"
PARCEL = ROOT / "prameny_online/mapy_katastralni/2026/parcela_st1_ruian.geojson"
OUT_GRID = ROOT / "tmp/cisarsky_otisk_statek_st1_mrizka.jpg"
OUT_PARCEL = ROOT / "tmp/parcela_st1_vrcholy.png"
OUT_OVERLAY = ROOT / "prameny_online/mapy_katastralni/1829/prekryv_st1_cp11_1829-2026.png"
NEIGHBORS = ROOT / "prameny_online/mapy_katastralni/2026/kontrolni_parcely_2_21_ruian.geojson"


def font(size: int):
    try:
        return ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", size)
    except OSError:
        return ImageFont.load_default()


def draw_grid():
    im = Image.open(HIST).convert("RGB")
    dr = ImageDraw.Draw(im, "RGBA")
    small = font(22)
    for x in range(0, im.width, 100):
        color = (0, 110, 255, 130) if x % 500 else (0, 70, 220, 210)
        width = 1 if x % 500 else 3
        dr.line((x, 0, x, im.height), fill=color, width=width)
        dr.text((x + 4, 4), str(x), fill=(0, 40, 180, 255), font=small)
    for y in range(0, im.height, 100):
        color = (0, 110, 255, 130) if y % 500 else (0, 70, 220, 210)
        width = 1 if y % 500 else 3
        dr.line((0, y, im.width, y), fill=color, width=width)
        dr.text((4, y + 4), str(y), fill=(0, 40, 180, 255), font=small)
    im.save(OUT_GRID, quality=94)


def draw_parcel():
    data = json.loads(PARCEL.read_text())
    pts = data["features"][0]["geometry"]["coordinates"][0]
    xs = [p[0] for p in pts]
    ys = [p[1] for p in pts]
    margin = 120
    scale = min((1200 - 2 * margin) / (max(xs) - min(xs)),
                (1000 - 2 * margin) / (max(ys) - min(ys)))

    def px(p):
        # S-JTSK: kreslime x doprava, -y nahoru (sever priblizne nahoru).
        return (margin + (p[0] - min(xs)) * scale,
                margin + (max(ys) - p[1]) * scale)

    im = Image.new("RGB", (1200, 1000), "white")
    dr = ImageDraw.Draw(im, "RGBA")
    poly = [px(p) for p in pts]
    dr.polygon(poly, fill=(255, 155, 0, 70), outline=(255, 110, 0, 255), width=5)
    big = font(28)
    for i, p in enumerate(poly[:-1]):
        r = 7
        dr.ellipse((p[0] - r, p[1] - r, p[0] + r, p[1] + r), fill=(0, 80, 220, 255))
        dr.text((p[0] + 10, p[1] - 13), str(i), fill=(0, 50, 180, 255), font=big)
    dr.line((1090, 160, 1090, 70), fill=(0, 0, 0, 255), width=5)
    dr.polygon([(1090, 45), (1074, 77), (1106, 77)], fill=(0, 0, 0, 255))
    dr.text((1074, 8), "N", fill=(0, 0, 0, 255), font=big)
    im.save(OUT_PARCEL)


draw_grid()
draw_parcel()


def solve_affine(src, dst):
    """Afinní transformace z vice dvojic bodu, bez zavislosti na OpenCV."""
    import numpy as np

    src = np.asarray(src, float)
    dst = np.asarray(dst, float)
    origin = src.mean(axis=0)
    a = np.c_[src - origin, np.ones(len(src))]
    coeff, _, _, _ = np.linalg.lstsq(a, dst, rcond=None)
    h_local = np.array([
        [coeff[0, 0], coeff[1, 0], coeff[2, 0]],
        [coeff[0, 1], coeff[1, 1], coeff[2, 1]],
        [0.0, 0.0, 1.0],
    ])
    shift = np.array([[1.0, 0.0, -origin[0]], [0.0, 1.0, -origin[1]], [0.0, 0.0, 1.0]])
    return h_local @ shift


def transform(points, h):
    import numpy as np

    p = np.c_[np.asarray(points, float), np.ones(len(points))]
    q = p @ h.T
    return q[:, :2] / q[:, 2:3]


def polygon_centroid(ring):
    """Teziste jednoducheho polygonu (posledni bod muze opakovat prvni)."""
    import numpy as np

    p = np.asarray(ring, float)
    if not np.allclose(p[0], p[-1]):
        p = np.vstack([p, p[0]])
    cross = p[:-1, 0] * p[1:, 1] - p[1:, 0] * p[:-1, 1]
    area2 = cross.sum()
    return np.array([
        ((p[:-1, 0] + p[1:, 0]) * cross).sum() / (3 * area2),
        ((p[:-1, 1] + p[1:, 1]) * cross).sum() / (3 * area2),
    ])


def draw_overlay():
    data = json.loads(PARCEL.read_text())
    parcel = data["features"][0]["geometry"]["coordinates"][0]
    building_data = json.loads((ROOT / "prameny_online/mapy_katastralni/2026/stavebni_objekt_cp11_ruian.geojson").read_text())
    building = building_data["features"][0]["geometry"]["coordinates"][0]

    neighbors = json.loads(NEIGHBORS.read_text())["features"] if NEIGHBORS.exists() else []
    by_number = {f["properties"]["cisloparcely"]: f for f in neighbors}

    # Ctyri hlavni rohy st. 1 a teziste sousedniho rybnika 21. Rybnik
    # pridava nezavisly bod mimo cilovou parcelu a brani preuceni jen na
    # jejim obvodu.
    src = [parcel[6], parcel[2], parcel[1], parcel[9]]
    dst = [(310.5, 554.0), (432.5, 475.5), (470.0, 578.0), (378.5, 671.0)]
    control_names = ["K6", "K2", "K1", "K9"]
    if "21" in by_number:
        src.append(polygon_centroid(by_number["21"]["geometry"]["coordinates"][0]))
        dst.append((249.48, 645.25))
        control_names.append("P21")
    h = solve_affine(src, dst)
    p_hist = transform(parcel, h)
    b_hist = transform(building, h)

    im = Image.open(HIST).convert("RGBA")
    translucent = Image.new("RGBA", im.size, (0, 0, 0, 0))
    td = ImageDraw.Draw(translucent)
    td.polygon([tuple(p) for p in b_hist], fill=(0, 100, 255, 70))
    pond_hist = None
    if "21" in by_number:
        pond = by_number["21"]["geometry"]["coordinates"][0]
        pond_hist = transform(pond, h)
        td.polygon([tuple(p) for p in pond_hist], fill=(0, 180, 80, 45))
    im = Image.alpha_composite(im, translucent)
    dr = ImageDraw.Draw(im, "RGBA")
    dr.line([tuple(p) for p in p_hist], fill=(255, 120, 0, 245), width=7, joint="curve")
    dr.line([tuple(p) for p in b_hist], fill=(0, 80, 235, 255), width=7, joint="curve")
    if pond_hist is not None:
        dr.line([tuple(p) for p in pond_hist], fill=(0, 145, 60, 230), width=5, joint="curve")
    labels = font(22)
    for n, p in zip(control_names, dst):
        r = 8
        dr.ellipse((p[0] - r, p[1] - r, p[0] + r, p[1] + r), fill=(0, 70, 220, 255))
        dr.text((p[0] + 10, p[1] - 10), n, fill=(0, 50, 180, 255), font=labels)
    legend_font = font(18)
    dr.rounded_rectangle((150, 355, 490, 444), radius=10, fill=(255, 255, 255, 235))
    for y, color, label in [
        (370, (255, 120, 0, 255), "dnešní parcela st. 1"),
        (397, (0, 80, 235, 255), "dnešní objekt čp. 11"),
        (424, (0, 145, 60, 255), "kontrolní parcela rybníka 21"),
    ]:
        dr.line((165, y + 8, 200, y + 8), fill=color, width=6)
        dr.text((212, y), label, fill=(10, 10, 10, 255), font=legend_font)
    im = im.crop((140, 350, 700, 770)).resize((1120, 840), Image.Resampling.LANCZOS)
    im.convert("RGB").save(OUT_OVERLAY, optimize=True)
    print("affine", h.tolist())
    fitted = transform(src, h)
    print("control residuals px", [float(((a - b) ** 2).sum() ** .5) for a, b in zip(fitted, dst)])
    print("building historical pixels", b_hist.tolist())


draw_overlay()
print(OUT_GRID)
print(OUT_PARCEL)
print(OUT_OVERLAY)
