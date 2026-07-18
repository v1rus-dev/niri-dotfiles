#!/usr/bin/env bash
# Lock wrapper: show the current wallpaper on the lock screen if known,
# otherwise fall back to a screenshot. Blur/effects come from swaylock config.
set -euo pipefail

img="$HOME/.cache/wallpaper/current.img"

if [ -f "$img" ]; then
    exec swaylock -f -i "$img"
else
    exec swaylock -f --screenshots
fi
