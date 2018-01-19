#!/bin/bash

set -e

export EXTRACT_URL=${EXTRACT_URL:-"http://planet.osm.org/pbf/planet-latest.osm.pbf"}
export EXTRACTS_DIR=${EXTRACTS_DIR:-"${DATA_DIR}/extracts"}

echo "[INFO] fetching extract."
wget -q "${EXTRACT_URL}" -P "${EXTRACTS_DIR}"

exec /scripts/cut_tiles.sh
