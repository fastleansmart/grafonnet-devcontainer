#!/usr/bin/env bash
set -eu -o pipefail

echo "Watching files in src directory..."

error() {
	>&2 echo "ERROR:" "${@}"
	exit 1
}

[ -n "${GRAFANA_API_KEY:-}" ] || error "Invalid GRAFANA_API_KEY"
[[ "${GRAFANA_URL:-}" =~ ^https?://[^/]+/$ ]] || error "Invalid GRAFANA_URL (example: 'http://localhost:3001/' incl. slash at end)"

[ $# = 1 ] || error "Usage: $(basename "${0}") JSONNET_FILE_OF_DASHBOARD"

dir_to_watch="${1}"

# watch all files in the given directory
while true; do
	# need to add "|| true", so we ignore errors, because entr throws an error on directory changes
	find "$dir_to_watch" | entr -d -n .devcontainer/scripts/render-and-upload-all-dashboards.sh "$(find "$dir_to_watch")" || true
done