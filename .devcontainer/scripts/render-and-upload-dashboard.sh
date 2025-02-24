#!/usr/bin/env bash
# shellcheck disable=SC2015
set -euo pipefail

jsonnet_file="${1}"
json_file="${2}"

# Render
echo "Will render to $json_file"
JSONNET_PATH="$(realpath vendor)"
export JSONNET_PATH
jsonnet-lint "$jsonnet_file"
jsonnet -o "$json_file" "$jsonnet_file"

# Enable editable flag and upload via Grafana API
jq '{"dashboard":.,"folderId":0,"overwrite":true} | .dashboard.editable = true' "$json_file" \
	| curl \
		--fail-with-body \
		-sS \
		-X POST \
		-H "Authorization: Bearer ${GRAFANA_API_KEY}" \
		-H "Content-Type: application/json" \
		--data-binary @- "${GRAFANA_URL}api/dashboards/db" \
	&& printf '\nDashboard uploaded at: %s\n' "$(date)" \
	|| { >&2 printf '\nERROR: Failed to upload dashboard\n'; exit 1; }