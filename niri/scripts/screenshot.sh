#!/usr/bin/env bash
# Region screenshot straight to the clipboard (Win+Shift+S style).
# slurp selects the area; grim captures it; wl-copy puts the PNG on the clipboard.
set -euo pipefail

geom=$(slurp) || exit 0            # Esc / right-click cancels -> exit quietly
grim -g "$geom" - | wl-copy --type image/png
notify-send -t 1500 "Screenshot" "Область скопирована в буфер"
