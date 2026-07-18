#!/usr/bin/env bash
# Clipboard history picker: cliphist history -> wofi -> back to clipboard.
set -euo pipefail

cliphist list \
    | wofi --dmenu --prompt "Clipboard" \
           --width 700 --height 500 --cache-file /dev/null \
           --style "$HOME/.config/wofi/style.css" \
    | cliphist decode \
    | wl-copy
