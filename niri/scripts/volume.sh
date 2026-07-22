#!/usr/bin/env bash
# Adjust or mute volume across ALL audio sinks at once (global volume), rather
# than only @DEFAULT_AUDIO_SINK@. This keeps speakers and headphones moving
# together, so switching output devices never lands on a stale volume.
# Bound to the volume keys in niri config.kdl and the Waybar pulseaudio module.
set -euo pipefail

step="0.1"

# All sink IDs from `wpctl status` (the Sinks section). Parsed with awk to avoid
# a jq dependency; the ID is the integer preceding the "." on each sink line.
mapfile -t sinks < <(
    wpctl status | awk '
        /─ Sinks:/   {in_s=1; next}
        /─ Sources:/ {in_s=0}
        in_s && match($0, /[0-9]+\./) { print substr($0, RSTART, RLENGTH-1) }'
)

[ "${#sinks[@]}" -eq 0 ] && exit 0

case "${1:-}" in
    up)   for id in "${sinks[@]}"; do wpctl set-volume -l 1.0 "$id" "${step}+"; done ;;
    down) for id in "${sinks[@]}"; do wpctl set-volume "$id" "${step}-"; done ;;
    mute)
        # Deterministic global mute: read the default sink's state, invert it,
        # then apply the SAME state to every sink so they never desync.
        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
            target=0   # currently muted -> unmute all
        else
            target=1   # currently unmuted -> mute all
        fi
        for id in "${sinks[@]}"; do wpctl set-mute "$id" "$target"; done
        ;;
    *) echo "usage: ${0##*/} {up|down|mute}" >&2; exit 1 ;;
esac
