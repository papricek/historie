#!/bin/zsh
set -euo pipefail

cd "${0:A:h:h}"
zahradka_job_id=$(jq -r '.jobId' tmp/lms_token_job.json)
zahradka_token_response=$(curl -sS "https://ags.cuzk.gov.cz/arcgis2/rest/services/GenerateToken/Token/GPServer/GenerateToken/jobs/${zahradka_job_id}?f=json")
zahradka_archive_token=$(printf '%s' "${zahradka_token_response}" | jq -r '.messages[] | select(.description|startswith("Token je:")) | .description | sub("^Token je:";"") | gsub("^ +| +$";"")')
test -n "${zahradka_archive_token}"

mkdir -p tmp/originalni_mapy_8865

export_one() {
  local object_id="$1"
  local bbox="$2"
  local size="$3"
  local name="$4"
  curl -sS -e 'https://ags.cuzk.gov.cz/archiv/' --get \
    'https://ags.cuzk.gov.cz/arcgis4/rest/services/Archiv/archiv_nespojene_stable/ImageServer/exportImage' \
    --data-urlencode "token=${zahradka_archive_token}" \
    --data-urlencode "bbox=${bbox}" \
    --data-urlencode 'bboxSR=102067' \
    --data-urlencode 'imageSR=102067' \
    --data-urlencode "size=${size}" \
    --data-urlencode 'format=jpgpng' \
    --data-urlencode "mosaicRule={\"mosaicMethod\":\"esriMosaicLockRaster\",\"lockRasterIds\":[${object_id}]}" \
    --data-urlencode 'f=image' \
    -o "tmp/originalni_mapy_8865/${name}.jpg"
}

export_one 59785 '0,0,27.8367,22.7833' '4096,3353' 'B2_a_4C_8865_1'
export_one 59787 '0,0,9.4733,22.84' '1699,4096' 'B2_a_4C_8865_ad1v'
export_one 59788 '0,0,27.92,8.45' '4096,1240' 'B2_a_4C_8865_ad2j'
export_one 59789 '0,0,8.4733,21.7767' '1594,4096' 'B2_a_4C_8865_ad2v'

identify tmp/originalni_mapy_8865/*.jpg
