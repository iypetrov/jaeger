#!/bin/bash

packages="$(mktemp)"
GOMAXPROCS=1 go test -count 1 -parallel 128 -p 16 -json ./... | jq -r '.Package' | sort -u > "${packages}"

mkdir -p results
while read -r package; do
    package_name="$(echo "${package}" | cut -d '/' -f 4-)"
    echo "Running tests for package: ${package_name}"
    GOMAXPROCS=1 go test -count 1 -parallel 128 -json "./${package_name}" | vgt -print-html > "results/$(echo ${package_name} | tr '/' '_').html"
done < "${packages}"
