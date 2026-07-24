import json
import sys
from pathlib import Path

import cv2
import numpy as np


data = json.load(sys.stdin)
ring = np.asarray(data["features"][0]["geometry"]["rings"][0], dtype=np.float64)

width, height, margin = 1400, 1100, 80
minimum = ring.min(axis=0)
maximum = ring.max(axis=0)
scale = min((width - 2 * margin) / (maximum[0] - minimum[0]), (height - 2 * margin) / (maximum[1] - minimum[1]))

points = np.empty_like(ring)
points[:, 0] = margin + (ring[:, 0] - minimum[0]) * scale
points[:, 1] = height - margin - (ring[:, 1] - minimum[1]) * scale
points = np.rint(points).astype(np.int32)

canvas = np.full((height, width, 3), 250, dtype=np.uint8)
cv2.polylines(canvas, [points.reshape((-1, 1, 2))], True, (20, 20, 20), 4, cv2.LINE_AA)
for index, (x, y) in enumerate(points[:-1]):
    if index % 5 == 0:
        cv2.circle(canvas, (int(x), int(y)), 6, (0, 90, 220), -1, cv2.LINE_AA)
        cv2.putText(canvas, str(index), (int(x) + 8, int(y) - 8), cv2.FONT_HERSHEY_SIMPLEX, 0.52, (0, 70, 180), 1, cv2.LINE_AA)

output = Path("tmp/klad_cisarskeho_otisku_1829.png")
cv2.imwrite(str(output), canvas)
print(output)
