#!/bin/zsh
set -euo pipefail

cd "${0:A:h:h}"

zahradka_job_id=$(jq -r '.jobId' tmp/lms_token_job.json)
zahradka_token_response=$(curl -sS "https://ags.cuzk.gov.cz/arcgis2/rest/services/GenerateToken/Token/GPServer/GenerateToken/jobs/${zahradka_job_id}?f=json")
zahradka_archive_token=$(printf '%s' "${zahradka_token_response}" | jq -r '.messages[] | select(.description|startswith("Token je:")) | .description | sub("^Token je:";"") | gsub("^ +| +$";"")')
test -n "${zahradka_archive_token}"

curl -sS -e 'https://ags.cuzk.gov.cz/archiv/' --get \
  'https://ags.cuzk.gov.cz/arcgis4/rest/services/Archiv/klady/MapServer/16/query' \
  --data-urlencode "token=${zahradka_archive_token}" \
  --data-urlencode 'f=json' \
  --data-urlencode 'geometry=-705760,-1118170' \
  --data-urlencode 'geometryType=esriGeometryPoint' \
  --data-urlencode 'inSR=5514' \
  --data-urlencode 'spatialRel=esriSpatialRelIntersects' \
  --data-urlencode 'outFields=*' \
  --data-urlencode 'returnGeometry=false' \
  -o tmp/klady_layer16_st1.json

jq '{error, count: (.features | length), records: [.features[]?.attributes]}' tmp/klady_layer16_st1.json
