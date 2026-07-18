#!/usr/bin/env bash
# NVIDIA GPU stats for Waybar (JSON output).
# Prints temp + utilization; tooltip has VRAM, power, and the GPU name.
set -euo pipefail

# Numeric fields only — parsed positionally (name has spaces, queried separately).
read -r temp util mem_used mem_total power < <(
    nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used,memory.total,power.draw \
        --format=csv,noheader,nounits 2>/dev/null | tr -d ',' | head -1
)
name=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)

# Fallback if the query failed for any reason.
if [[ -z "${temp:-}" ]]; then
    printf '{"text":"n/a","tooltip":"nvidia-smi unavailable"}\n'
    exit 0
fi

text="${temp}°C · ${util}%"
tooltip="${name}\nTemp: ${temp}°C\nUtil: ${util}%\nVRAM: ${mem_used} / ${mem_total} MiB\nPower: ${power} W"

printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"
