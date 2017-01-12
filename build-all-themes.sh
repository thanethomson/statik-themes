#!/bin/bash

function build_theme {
    echo "Building theme: $1"
    cd "themes/$1"
    bower install
    cd ../..
    statik -p "config-$1.yml" -o "public-$1"
}

# Build the themes here
build_theme alabaster

echo "Done."

