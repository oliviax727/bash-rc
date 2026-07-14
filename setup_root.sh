#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -n "${1:-}" ]]; then
	su -c "cd \"${SCRIPT_DIR}\" && ./setup.sh \"$1\""
else
	su -c "cd \"${SCRIPT_DIR}\" && ./setup.sh"
fi
