#!/usr/bin/env bash
set -euo pipefail

RESULT_PREFIX="${1:-manual-formal}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKEND_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$BACKEND_ROOT")"
PYTHON="$REPO_ROOT/.venv/bin/python"
RESULTS="$REPO_ROOT/docs/project/results"

if [[ ! -x "$PYTHON" ]]; then
    echo "Project Python executable was not found at $PYTHON" >&2
    echo "Create it with: python3 -m venv .venv" >&2
    exit 2
fi

mkdir -p "$RESULTS"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG="$RESULTS/${RESULT_PREFIX}-${TIMESTAMP}.log"
JUNIT="$RESULTS/${RESULT_PREFIX}-${TIMESTAMP}.xml"
COVERAGE_XML="$RESULTS/${RESULT_PREFIX}-coverage-${TIMESTAMP}.xml"

cd "$BACKEND_ROOT"
"$PYTHON" -m coverage erase
STARTED=$SECONDS

set +e
"$PYTHON" -m coverage run -m pytest tests/manual --junitxml "$JUNIT" 2>&1 | tee "$LOG"
RUN_EXIT_CODE=${PIPESTATUS[0]}
set -e

"$PYTHON" -m coverage report 2>&1 | tee -a "$LOG"
"$PYTHON" -m coverage xml -o "$COVERAGE_XML"
"$PYTHON" -m coverage html
printf 'Wall-clock seconds: %s\n' "$((SECONDS - STARTED))" >> "$LOG"
printf 'Manual log: %s\nJUnit XML: %s\nCoverage XML: %s\n' "$LOG" "$JUNIT" "$COVERAGE_XML"

exit "$RUN_EXIT_CODE"