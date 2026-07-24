from pathlib import Path
import json

import cv2
import numpy as np


ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "prameny_online" / "letecke_snimky"
OUT = BASE / "srovnani_zarovnane"
OUT.mkdir(parents=True, exist_ok=True)

SIZE = 2048
# Výřez zahrnuje celý areál st. 1, rybníček a přilehlé cesty jako orientační body.
CROP = (760, 780, 1390, 1410)
# Definiční bod parcely st. 1 podle VDP/RÚIAN, přepočtený do výřezu.
PARCEL_POINT = (1021, 1035)
PARCEL_GEOJSON = ROOT / "prameny_online" / "mapy_katastralni" / "2026" / "parcela_st1_ruian.geojson"
BUILDING_GEOJSON = ROOT / "prameny_online" / "mapy_katastralni" / "2026" / "stavebni_objekt_cp11_ruian.geojson"

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

# Výzkumné podobnostní transformace do geometrie ortofota CENIA 1953.
# Matice byly odhadnuty mimo vlastní areál statku ze stabilních cest a mezí.
TRANSFORMS = {
    "1949": np.array([[1.002, -0.000, 76.929], [0.000, 1.002, 161.125]], dtype=np.float32),
    "1961": np.array([[1.059, 0.008, -73.266], [-0.008, 1.059, -156.848]], dtype=np.float32),
    "1967": np.array([[1.045, 0.019, 15.033], [-0.019, 1.045, 115.440]], dtype=np.float32),
    "1975": np.array([[1.066, -0.022, 17.075], [0.022, 1.066, -652.743]], dtype=np.float32),
    "1978": np.array([[0.999, 0.047, -177.038], [-0.047, 0.999, 187.931]], dtype=np.float32),
    "1990": np.array([[1.050, -0.004, -468.595], [0.004, 1.050, 177.621]], dtype=np.float32),
    "1992": np.array([[1.040, -0.040, -71.280], [0.040, 1.040, -517.085]], dtype=np.float32),
}


def load(path: Path) -> np.ndarray:
    image = cv2.imread(str(path), cv2.IMREAD_COLOR)
    if image is None:
        raise RuntimeError(f"Nelze načíst {path}")
    if image.shape[:2] != (SIZE, SIZE):
        image = cv2.resize(image, (SIZE, SIZE), interpolation=cv2.INTER_AREA)
    return image


def align(year: str, image: np.ndarray) -> np.ndarray:
    matrix = TRANSFORMS.get(year)
    if matrix is None:
        return image
    return cv2.warpAffine(
        image,
        matrix,
        (SIZE, SIZE),
        flags=cv2.INTER_LINEAR,
        borderMode=cv2.BORDER_CONSTANT,
        borderValue=(245, 245, 245),
    )


def label_panel(image: np.ndarray, year: str, suffix: str = "", mark_parcel: bool = False) -> np.ndarray:
    panel = cv2.resize(image, (560, 560), interpolation=cv2.INTER_AREA)
    if mark_parcel:
        x1, y1, x2, y2 = CROP
        def read_polygon(path: Path) -> np.ndarray:
            with path.open(encoding="utf-8") as source:
                coordinates = json.load(source)["features"][0]["geometry"]["coordinates"][0]
            polygon = []
            for x_sjtsk, y_sjtsk in coordinates:
                x_full = (x_sjtsk - (-706072.0)) * SIZE / 600.0
                y_full = ((-1117850.0) - y_sjtsk) * SIZE / 600.0
                polygon.append(
                    [
                        round((x_full - x1) * 560 / (x2 - x1)),
                        round((y_full - y1) * 560 / (y2 - y1)),
                    ]
                )
            return np.array(polygon, dtype=np.int32).reshape((-1, 1, 2))

        polygon = read_polygon(PARCEL_GEOJSON)
        mask = panel.copy()
        cv2.fillPoly(mask, [polygon], (0, 125, 255))
        panel = cv2.addWeighted(mask, 0.17, panel, 0.83, 0)
        cv2.polylines(panel, [polygon], True, (0, 0, 0), 5, cv2.LINE_AA)
        cv2.polylines(panel, [polygon], True, (0, 125, 255), 3, cv2.LINE_AA)
        building = read_polygon(BUILDING_GEOJSON)
        mask = panel.copy()
        cv2.fillPoly(mask, [building], (255, 150, 0))
        panel = cv2.addWeighted(mask, 0.32, panel, 0.68, 0)
        cv2.polylines(panel, [building], True, (0, 0, 0), 5, cv2.LINE_AA)
        cv2.polylines(panel, [building], True, (255, 150, 0), 3, cv2.LINE_AA)
        px = round((PARCEL_POINT[0] - x1) * 560 / (x2 - x1))
        py = round((PARCEL_POINT[1] - y1) * 560 / (y2 - y1))
        cv2.circle(panel, (px, py), 13, (0, 0, 0), 4, cv2.LINE_AA)
        cv2.circle(panel, (px, py), 13, (0, 125, 255), 2, cv2.LINE_AA)
        cv2.line(panel, (px - 19, py), (px + 19, py), (0, 125, 255), 2, cv2.LINE_AA)
        cv2.line(panel, (px, py - 19), (px, py + 19), (0, 125, 255), 2, cv2.LINE_AA)
    canvas = np.full((620, 560, 3), 248, dtype=np.uint8)
    canvas[60:, :] = panel
    cv2.putText(
        canvas,
        year + (f" ({suffix})" if suffix else ""),
        (18, 40),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.82 if not suffix else 0.60,
        (25, 25, 25),
        2,
        cv2.LINE_AA,
    )
    return canvas


aligned = {}
x1, y1, x2, y2 = CROP
for year, path in SOURCES.items():
    registered = align(year, load(path))
    crop = registered[y1:y2, x1:x2]
    aligned[year] = crop
    cv2.imwrite(
        str(OUT / f"{year}_st1_zarovnano_k_1953.jpg"),
        crop,
        [cv2.IMWRITE_JPEG_QUALITY, 94],
    )

order = ["1949", "1953", "1961", "1967", "1975", "1978", "1990", "1992", "2022"]
suffixes = {"1953": "referencni geometrie", "2022": "kontrolni ortofoto"}
panels = [label_panel(aligned[year], year, suffixes.get(year, ""), True) for year in order]
rows = [cv2.hconcat(panels[i : i + 3]) for i in range(0, 9, 3)]
board = cv2.vconcat(rows)
footer = np.full((58, board.shape[1], 3), 248, dtype=np.uint8)
cv2.putText(
    footer,
    "Oranzova: dnesni st. 1. Modra: dnesni stavebni objekt cp. 11 (RUIAN). Kriz: definicni bod.",
    (22, 38),
    cv2.FONT_HERSHEY_SIMPLEX,
    0.72,
    (35, 35, 35),
    2,
    cv2.LINE_AA,
)
board = cv2.vconcat([board, footer])
cv2.imwrite(
    str(OUT / "srovnani_zarovnane_st1_1949-2022.jpg"),
    board,
    [cv2.IMWRITE_JPEG_QUALITY, 94],
)

# Diagnostická tabule: průsvit každého historického letu přes rok 1953.
reference = aligned["1953"]
overlay_panels = []
for year in ["1949", "1961", "1967", "1975", "1978", "1990", "1992"]:
    overlay = cv2.addWeighted(reference, 0.50, aligned[year], 0.50, 0)
    overlay_panels.append(label_panel(overlay, f"{year} / 1953", mark_parcel=True))
blank = np.full_like(overlay_panels[0], 248)
cv2.putText(blank, "1968: nezarazeno", (95, 300), cv2.FONT_HERSHEY_SIMPLEX, 0.85, (45, 45, 45), 2, cv2.LINE_AA)
cv2.putText(blank, "snimek je prilis neostry", (60, 345), cv2.FONT_HERSHEY_SIMPLEX, 0.68, (80, 80, 80), 2, cv2.LINE_AA)
overlay_panels.extend([blank, label_panel(reference, "1953", mark_parcel=True)])
overlay_rows = [cv2.hconcat(overlay_panels[i : i + 3]) for i in range(0, 9, 3)]
overlay_board = cv2.vconcat(overlay_rows)
cv2.imwrite(
    str(OUT / "kontrola_zarovnani_proti_1953.jpg"),
    overlay_board,
    [cv2.IMWRITE_JPEG_QUALITY, 92],
)

print(OUT)
print(OUT / "srovnani_zarovnane_st1_1949-2022.jpg")
