#!/bin/bash
SCRIPT_FOLDER="$(dirname $(realpath "$BASH_SOURCE"))"
echo "Build folder: $SCRIPT_FOLDER/build"
docker run --rm -it --name "sepia-build-env" -v "$SCRIPT_FOLDER/build":"/home/admin/build" sepia/build-env:latest /bin/bash
