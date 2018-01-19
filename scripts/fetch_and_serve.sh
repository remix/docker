#!/bin/bash

set -e

export DATA_DIR=${DATA_DIR:-"/data/valhalla"}
export REGION=${REGION:-"us-east-1"}

mkdir -p "${DATA_DIR}"

if [ -n "$S3_TILES_URL" ]; then
    echo "[INFO] pulling tiles archive."
    aws --region "${REGION}" s3 cp --quiet "${S3_TILES_URL}" "${DATA_DIR}"/tiles.tar
fi

exec /scripts/start_valhalla.sh
