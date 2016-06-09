#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'

CONTAINER=$1

docker inspect "$CONTAINER" | jq -r '.[0].Config.Image'
