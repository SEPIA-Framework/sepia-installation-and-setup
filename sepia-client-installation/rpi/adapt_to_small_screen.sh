#!/bin/bash
SHIFT=20
SEPIA_CLIENT_ROOT="$HOME/clexi/www/sepia"
if [ -n "$1" ]; then
    SHIFT=$1
fi
if [ -n "$2" ]; then
    SEPIA_CLIENT_ROOT=$2
fi
echo "Shifting screen by $SHIFT pixel to the left."
sed -ri "s/<html (.*?) style=.*?>/<html \1>/" "${SEPIA_CLIENT_ROOT}/index.html"
sed -ri "s/<html (.*?)>/<html \1 style=\"margin-right: ${SHIFT}px; width: calc(100% - ${SHIFT}px);\">/" "${SEPIA_CLIENT_ROOT}/index.html"
