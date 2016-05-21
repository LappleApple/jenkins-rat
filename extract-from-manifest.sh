#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'

JAR_NAME="$1"
PARAM_NAME="$2"

LINE=$(unzip -q -c "$JAR_NAME" META-INF/MANIFEST.MF | grep "$PARAM_NAME")
regex="$PARAM_NAME[[:space:]]*:[[:space:]]*([^[:space:]]+)"
[[ $LINE =~ $regex ]] && echo -n "${BASH_REMATCH[1]}"
