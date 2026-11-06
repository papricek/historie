#!/usr/bin/env python3
"""Mapová řada domu: výřezy 75 × 75 m kolem adresního bodu RÚIAN ze všech
zarovnaných vrstev website/img/mapa/podklad_*.jpg (rám 600 m, roh
-706072 / -1117850, 0,375 m/px). Výstup domy/img/mapova_rada_cpNN.jpg.
Obsahuje archivní letecké snímky ČÚZK (jen pro vlastní potřebu) – nepublikovat.

Použití: python3 -I nastroje/vytvorit_mapovou_radu_domu.py 1 2 3 ...
Potřebuje ImageMagick (magick, montage).
"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
VRSTVY = ["1829", "1878", "pk", "1949", "1953", "1967", "1978", "1990", "2022"]
body = {}
geo = json.loads((ROOT / "prameny_online/mapy_katastralni/2026/adresni_mista_zahradka_ruian.geojson").read_text())
for f in geo["features"]:
    body[str(f["properties"]["cislodomovni"])] = f["geometry"]["coordinates"]

for cp in sys.argv[1:]:
    if cp not in body:
        print(f"čp. {cp}: v RÚIAN není, přeskočeno")
        continue
    x, y = body[cp]
    px, py = int((x + 706072) / 0.375), int((-1117850 - y) / 0.375)
    with tempfile.TemporaryDirectory() as tmp:
        dily = []
        for v in VRSTVY:
            out = f"{tmp}/{v}.jpg"
            subprocess.run(["magick", str(ROOT / f"website/img/mapa/podklad_{v}.jpg"),
                            "-crop", f"200x200+{px - 100}+{py - 100}", "+repage", "-resize", "300x300",
                            "-fill", "red", "-draw", "circle 150,150 155,150",
                            "-gravity", "north", "-fill", "white", "-undercolor", "#0009",
                            "-pointsize", "22", "-annotate", "+0+4", v, out], check=True)
            dily.append(out)
        cil = ROOT / f"domy/img/mapova_rada_cp{int(cp):02d}.jpg"
        cil.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(["montage", *dily, "-tile", "5x2", "-geometry", "+2+2", str(cil)], check=True)
    print(f"čp. {cp}: {cil.relative_to(ROOT)}")
