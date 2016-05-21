#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'
#set -x

PLUGINS_DIR="${JENKINS_HOME}/plugins/"

set +e
OAUTH_PLUGIN_VERSION=$(./extract-from-manifest.sh "$PLUGINS_DIR/openam-oauth.jpi" Implementation-Version)
KRAKEN_PLUGIN_VERSION=$(./extract-from-manifest.sh "$PLUGINS_DIR/cloud-kraken-plugin.jpi" Implementation-Version)
ENV_VARS=$(env | grep -E "^OAUTH2_ACCESS_TOKEN_URL=")
JENKINS_URL=${HUDSON_URL:-}

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

JSON=$(echo "{}" | jq ".timestamp=\"$DATE\"" \
    | jq ".oauth2_plugin_version=\"$OAUTH_PLUGIN_VERSION\"" \
    | jq ".kraken_plugin_version=\"$KRAKEN_PLUGIN_VERSION\"" \
    | jq ".env_vars=\"$ENV_VARS\"" \
    | jq ".jenkins_url=\"$JENKINS_URL\"")

echo "$JSON"
