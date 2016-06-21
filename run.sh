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
INODE_USE=$(df -i | grep "^/dev/xvdf" | awk '{print $5}' | sed -E 's/%//')
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

INODE_USE_LEVEL=3
if [ $INODE_USE -gt 40 ]; then INODE_USE_LEVEL=2; fi
if [ $INODE_USE -gt 60 ]; then INODE_USE_LEVEL=1; fi
if [ $INODE_USE -gt 80 ]; then INODE_USE_LEVEL=0; fi

LEVELS=($INODE_USE_LEVEL)
echo ${LEVELS[@]}
MIN_LEVEL=$(IFS=$'\n' printf '%s\n' "${LEVELS[@]}" | sort -n | head -n1)

COLORS=(red yellow gray green)

./send-hipchat-notification.sh "$JSON" "$FROM" ${COLORS[$MIN_LEVEL]}

echo "$JSON"
