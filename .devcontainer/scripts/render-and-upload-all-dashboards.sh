#!/usr/bin/env bash
set -euo pipefail

for dashboard in $(echo "${1}" | grep -E '.*\.jsonnet');
do
	./.devcontainer/scripts/render-and-upload-dashboard.sh "$dashboard" "/tmp/$(echo "$dashboard" | grep -oP '[^/]+(?=\.[^/.]+$)').rendered.json"
done