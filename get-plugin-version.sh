#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'

PLUGIN_NAME=$1

PLUGINS_DIR="${JENKINS_HOME}/plugins/"
files=($PLUGINS_DIR/$PLUGIN_NAME.*pi)

if [ 0 -eq ${#files[@]} ]; then
    files=($PLUGINS_DIR/$PLUGIN_NAME*.*pi)
fi

versions=()
for f in "${files[@]}"; do
    versions+=(echo -n "${f}:$(./extract-from-manifest.sh "$f" Implementation-Version)")
done
echo -n "${versions[@]}"
