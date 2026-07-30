"""Podklady pro interaktivni mapu vsi (website/mapa.html).

Vyrabi zarovnane rastrove vrstvy spolecneho ctverce 600 m EPSG:5514
(levy horni roh X=-706072, Y=-1117850; stejny ram jako
vytvorit_zarovnane_srovnani.py) a uklada je zmensene do website/img/mapa/.

Letecke roky se zarovnavaji stejnymi podobnostnimi maticemi jako v
vytvorit_zarovnane_srovnani.py (geometrie ortofota CENIA 1953). Cisarsky
otisk 1829 se registruje retezenim: kontrolni body S-JTSK -> vyrez
cisarsky_otisk_statek_st1.jpg (prevzato z diagnostika_1829_lokalni.py)
a posun vyrezu uvnitr celeho listu II nalezeny korelaci. Jde o badatelske
zarovnani, ne o uredni georeferenci.
"""

from pathlib import Path
import json

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "prameny_online" / "letecke_snimky"
OUT = ROOT / "website" / "img" / "mapa"
OUT.mkdir(parents=True, exist_ok=True)

SIZE = 2048          # pracovni rozliseni ramu
WEB = 1600           # vystupni rozliseni pro web
FRAME_X0, FRAME_Y0, FRAME_M = -706072.0, -1117850.0, 600.0

SOURCES = {
    "1949": BASE / "1949" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "1953": BASE / "1953" / "historicke_ortofoto_cenia_epsg5514_600m.jpg",
    "1961": BASE / "1961" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "1967": BASE / "1967" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "1975": BASE / "1975" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "1978": BASE / "1978" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "1990": BASE / "1990" / "georeferencovany_vyrez_epsg5514_600m_ram_12091.jpg",
    "1992": BASE / "1992" / "georeferencovany_vyrez_epsg5514_600m.jpg",
    "2022": BASE / "2022" / "referencni_ortofoto_epsg5514_600m.jpg",
}

# Shodne s vytvorit_zarovnane_srovnani.py (zdroj -> geometrie 1953).
TRANSFORMS = {
    "1949": [[1.002, -0.000, 76.929], [0.000, 1.002, 161.125]],
    "1961": [[1.059, 0.008, -73.266], [-0.008, 1.059, -156.848]],
    "1967": [[1.045, 0.019, 15.033], [-0.019, 1.045, 115.440]],
    "1975": [[1.066, -0.022, 17.075], [0.022, 1.066, -652.743]],
    "1978": [[0.999, 0.047, -177.038], [-0.047, 0.999, 187.931]],
    "1990": [[1.050, -0.004, -468.595], [0.004, 1.050, 177.621]],
    "1992": [[1.040, -0.040, -71.280], [0.040, 1.040, -517.085]],
}


def load_2048(path: Path) -> Image.Image:
    im = Image.open(path).convert("RGB")
    if im.size != (SIZE, SIZE):
        im = im.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    return im


def warp_affine(im: Image.Image, forward_2x3, size=(SIZE, SIZE)) -> Image.Image:
    """Ekvivalent cv2.warpAffine: forward matice zdroj -> cil."""
    m = np.vstack([np.asarray(forward_2x3, float), [0.0, 0.0, 1.0]])
    inv = np.linalg.inv(m)
    data = (inv[0, 0], inv[0, 1], inv[0, 2], inv[1, 0], inv[1, 1], inv[1, 2])
    return im.transform(size, Image.Transform.AFFINE, data,
                        resample=Image.Resampling.BILINEAR,
                        fillcolor=(245, 245, 245))


def save_web(im: Image.Image, name: str):
    im.resize((WEB, WEB), Image.Resampling.LANCZOS).save(
        OUT / name, quality=72, optimize=True, progressive=True)
    print("ulozeno", OUT / name)


def letecke_vrstvy():
    for year, path in SOURCES.items():
        im = load_2048(path)
        matrix = TRANSFORMS.get(year)
        if matrix is not None:
            im = warp_affine(im, matrix)
        save_web(im, f"podklad_{year}.jpg")


# --- Cisarsky otisk 1829 ---------------------------------------------------
#
# Kontrolni body S-JTSK -> pixely vyrezu cisarsky_otisk_statek_st1.jpg jsou
# prevzaty z diagnostika_1829_lokalni.py (rohy st. 1 a teziste rybnika 21).
# Vyrez je 1200x1000 px z listu II na pozici (1250, 700), zvetseny 1.5x;
# doleceno korelaci gradientu s NCC 0.979 presne pri meritku 2/3.

OTISK = ROOT / "prameny_online" / "mapy_katastralni" / "1829" / "cisarsky_otisk_list_II.jpg"
PARCEL_GEOJSON = ROOT / "prameny_online" / "mapy_katastralni" / "2026" / "parcela_st1_ruian.geojson"
NEIGHBORS_GEOJSON = ROOT / "prameny_online" / "mapy_katastralni" / "2026" / "kontrolni_parcely_2_21_ruian.geojson"
CROP_DST = [(310.5, 554.0), (432.5, 475.5), (470.0, 578.0), (378.5, 671.0)]
POND_DST = (249.48, 645.25)
CROP_IN_LIST = (2.0 / 3.0, 1250.0, 700.0)  # meritko a posun vyrezu v listu II


def solve_affine(src, dst):
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
    shift = np.array([[1, 0, -origin[0]], [0, 1, -origin[1]], [0, 0, 1]], float)
    return h_local @ shift


def polygon_centroid(ring):
    p = np.asarray(ring, float)
    if not np.allclose(p[0], p[-1]):
        p = np.vstack([p, p[0]])
    cross = p[:-1, 0] * p[1:, 1] - p[1:, 0] * p[:-1, 1]
    area2 = cross.sum()
    return np.array([
        ((p[:-1, 0] + p[1:, 0]) * cross).sum() / (3 * area2),
        ((p[:-1, 1] + p[1:, 1]) * cross).sum() / (3 * area2),
    ])


def sjtsk_do_listu():
    """Afinni matice 3x3: S-JTSK -> pixely celeho listu II."""
    parcel = json.loads(PARCEL_GEOJSON.read_text())["features"][0]["geometry"]["coordinates"][0]
    src = [parcel[6], parcel[2], parcel[1], parcel[9]]
    dst = list(CROP_DST)
    neighbors = json.loads(NEIGHBORS_GEOJSON.read_text())["features"]
    by_number = {f["properties"]["cisloparcely"]: f for f in neighbors} if neighbors else {}
    key = "21" if "21" in by_number else 21 if 21 in by_number else None
    if key is not None:
        src.append(polygon_centroid(by_number[key]["geometry"]["coordinates"][0]))
        dst.append(POND_DST)
    h_crop = solve_affine(src, dst)
    f, ox, oy = CROP_IN_LIST
    to_list = np.array([[f, 0, ox], [0, f, oy], [0, 0, 1]], float)
    return to_list @ h_crop


def otisk_1829():
    h = sjtsk_do_listu()
    # ram 2048 px -> S-JTSK
    px_to_sjtsk = np.array([
        [FRAME_M / SIZE, 0, FRAME_X0],
        [0, -FRAME_M / SIZE, FRAME_Y0],
        [0, 0, 1],
    ])
    frame_to_list = h @ px_to_sjtsk
    im = Image.open(OTISK).convert("RGB")
    data = tuple(frame_to_list[:2].ravel())
    out = im.transform((SIZE, SIZE), Image.Transform.AFFINE, data,
                       resample=Image.Resampling.BICUBIC,
                       fillcolor=(236, 229, 214))
    save_web(out, "podklad_1829.jpg")


if __name__ == "__main__":
    letecke_vrstvy()
    otisk_1829()
