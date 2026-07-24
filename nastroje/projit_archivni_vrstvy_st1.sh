#!/bin/zsh
set -euo pipefail

cd "${0:A:h:h}"

zahradka_job_id=$(jq -r '.jobId' tmp/lms_token_job.json)
zahradka_token_response=$(curl -sS "https://ags.cuzk.gov.cz/arcgis2/rest/services/GenerateToken/Token/GPServer/GenerateToken/jobs/${zahradka_job_id}?f=json")
zahradka_archive_token=$(printf '%s' "${zahradka_token_response}" | jq -r '.messages[] | select(.description|startswith("Token je:")) | .description | sub("^Token je:";"") | gsub("^ +| +$";"")')
test -n "${zahradka_archive_token}"

mkdir -p tmp/archiv_klady_bod_st1

for zahradka_layer in 3 4 5 6 7 8 9 10 11 12 14 15 16; do
  curl -sS -e 'https://ags.cuzk.gov.cz/archiv/' --get \
    "https://ags.cuzk.gov.cz/arcgis4/rest/services/Archiv/klady/MapServer/${zahradka_layer}/query" \
    --data-urlencode "token=${zahradka_archive_token}" \
    --data-urlencode 'f=json' \
    --data-urlencode 'geometry=-705760,-1118170' \
    --data-urlencode 'geometryType=esriGeometryPoint' \
    --data-urlencode 'inSR=5514' \
    --data-urlencode 'spatialRel=esriSpatialRelIntersects' \
    --data-urlencode 'outFields=*' \
    --data-urlencode 'returnGeometry=false' \
    -o "tmp/archiv_klady_bod_st1/layer_${zahradka_layer}.json"
  jq -r --arg layer "${zahradka_layer}" '[.error.message // "OK", (.features | length // 0)] | @tsv | $layer + "\t" + .' "tmp/archiv_klady_bod_st1/layer_${zahradka_layer}.json"
done
