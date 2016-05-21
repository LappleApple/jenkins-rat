#!/usr/bin/env bats
set -o pipefail
IFS=$'\t\n'

@test "Can extract from manifest if there are no spaces after :" {
    run ./extract-from-manifest.sh test/test.jar Version-Foo
    echo 0.1.2$output >tmp
    [ "$output" = "0.1.2" ]
}

@test "Can extract from manifest if there are spaces after :" {
    run ./extract-from-manifest.sh test/test.jar Version-Bar
    [ "$output" = "0.1.2" ]
}

@test "Output is empty when the value is not found, error code is set" {
    run ./extract-from-manifest.sh test/test.jar Version-Foobar
    [ $status -ne 0 ]
    [ "$output" = "" ]
}
