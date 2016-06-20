#!/usr/bin/env bash
set -euo pipefail
IFS=$'\t\n'
#set -x

PLUGINS_DIR="${JENKINS_HOME}/plugins/"

set +e
OAUTH_PLUGIN_VERSION=$(./get-plugin-version.sh openam-oauth)
KRAKEN_PLUGIN_VERSION=$(./get-plugin-version.sh cloud-kraken-plugin)
ENV_VARS=$(env | grep -E "^OAUTH2_ACCESS_TOKEN_URL=")
JENKINS_URL=${HUDSON_URL:-}
JENKINS_VERSION=${JENKINS_VERSION:-}
MASTER_IMAGE=$(./get-docker-container-image.sh taupageapp)
INODE_USE=$(df -i | grep "^none" | awk '{print $5}' | sed -E 's/%//')
set -e

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

JSON=$(echo "{}" | jq ".timestamp=\"$DATE\"" \
    | jq ".oauth2_plugin_version=\"$OAUTH_PLUGIN_VERSION\"" \
    | jq ".kraken_plugin_version=\"$KRAKEN_PLUGIN_VERSION\"" \
    | jq ".env_vars=\"$ENV_VARS\"" \
    | jq ".master_image=\"$MASTER_IMAGE\"" \
    | jq ".jenkins_version=\"$JENKINS_VERSION\"" \
    | jq ".inode_use=\"$INODE_USE\"" \
    | jq ".jenkins_url=\"$JENKINS_URL\"")

FROM="$JENKINS_URL"
if [[ $FROM =~ ^[^/]+//([^\.]+)\. ]]; then
    FROM="${BASH_REMATCH[1]}"
fi
FROM=$(echo "$FROM" | cut -c 1-25)

./send-hipchat-notification.sh "$JSON" "$FROM"
