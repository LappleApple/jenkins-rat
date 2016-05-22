#!/usr/bin/env bats
set -o pipefail
IFS=$'\t\n'

@test "Can get plugin version in good case" {
    JENKINS_HOME=test/test1 run ./get-plugin-version.sh openam-oauth
    echo $output
    [ "$output" = "openam-oauth.hpi:0.2.0" ]
}

@test "Can get plugin version in bad case" {
    JENKINS_HOME=test/test2 run ./get-plugin-version.sh openam-oauth
    echo $output
    [ "$output" = "openam-oauth-0.1.1.hpi:0.2.0 openam-oauth-0.2.0.hpi:0.2.0" ]
}
