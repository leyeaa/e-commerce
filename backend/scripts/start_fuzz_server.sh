#!/usr/bin/env bash
set -euo pipefail

SKIP_RESET=0
if [[ "${1:-}" == "--skip-reset" ]]; then
    SKIP_RESET=1
elif [[ $# -gt 0 ]]; then
    echo "Usage: $0 [--skip-reset]" >&2
    exit 2
fi

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKEND_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$BACKEND_ROOT")"
PYTHON="$REPO_ROOT/.venv/bin/python"

if [[ ! -x "$PYTHON" ]]; then
    echo "Project Python executable was not found at $PYTHON" >&2
    echo "Create it with: python3 -m venv .venv" >&2
    exit 2
fi

export DJANGO_SETTINGS_MODULE=backend.settings_fuzz
cd "$BACKEND_ROOT"

"$PYTHON" manage.py migrate --settings backend.settings_fuzz
if [[ $SKIP_RESET -eq 1 ]]; then
    "$PYTHON" manage.py seed_experiment --settings backend.settings_fuzz
else
    "$PYTHON" manage.py seed_experiment --settings backend.settings_fuzz --reset
fi

printf '%s\n' 'Fuzz server: http://127.0.0.1:8000' 'Schema:      http://127.0.0.1:8000/api/schema/'
exec "$PYTHON" manage.py runserver 127.0.0.1:8000 --noreload --settings backend.settings_fuzz