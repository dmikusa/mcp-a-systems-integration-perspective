#!/usr/bin/env bash
set -eo pipefail

if [ ! -d "./slides" ]; then
    echo "Error: slides directory not found. Please run this script from the root of the repository."
    exit 1
fi

rm -rf ./out/
mkdir ./out/
marp -o ./out/ \
    -I ./slides \
    --no-config-file \
    --html \
    --title "Model Context Protocol: A Systems Integration Perspective" \
    --author "Daniel Mikusa" \
    --keywords "ai, mcp, python" \
    --url "https://github.com/dmikusa/mcp-a-systems-integration-perspective"
