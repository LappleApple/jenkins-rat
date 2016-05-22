#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'
#set -x

PLUGIN_NAME=$1

list-files() {
    find $1 -name "$2" -type f -depth 1
}

format-version-from-file() {
    echo -n "$(basename "$1"):$(./extract-from-manifest.sh "$1" Implementation-Version)"
}

PLUGINS_DIR="${JENKINS_HOME}/plugins"
files=($(list-files "$PLUGINS_DIR" "$PLUGIN_NAME.*pi"))
if [ ${#files[@]} -eq 0 ]; then
    files=($(list-files "$PLUGINS_DIR" "$PLUGIN_NAME*.*pi"))
fi

versions=()
if [ ${#files[@]} -gt 0 ]; then
    for f in "${files[@]}"; do
        versions+=($(format-version-from-file "$f"))
    done
    echo -n "${versions[@]}"
fi
