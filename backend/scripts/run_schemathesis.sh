#!/usr/bin/env bash
set -euo pipefail

MAX_EXAMPLES=500
SEED=9839
BASE_URL=http://127.0.0.1:8000

usage() {
    echo "Usage: $0 [--max-examples NUMBER] [--seed NUMBER] [--base-url URL]" >&2
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --max-examples)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            MAX_EXAMPLES=$2
            shift 2
            ;;
        --seed)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            SEED=$2
            shift 2
            ;;
        --base-url)
            [[ $# -ge 2 ]] || { usage; exit 2; }
            BASE_URL=${2%/}
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage
            exit 2
            ;;
    esac
done

[[ "$MAX_EXAMPLES" =~ ^[1-9][0-9]*$ ]] || { echo "--max-examples must be a positive integer" >&2; exit 2; }
[[ "$SEED" =~ ^[0-9]+$ ]] || { echo "--seed must be a non-negative integer" >&2; exit 2; }

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKEND_ROOT="$(dirname "$SCRIPT_DIR")"
REPO_ROOT="$(dirname "$BACKEND_ROOT")"
PYTHON="$REPO_ROOT/.venv/bin/python"
ST="$REPO_ROOT/.venv/bin/st"
RESULTS="$REPO_ROOT/docs/project/results"
USERNAME="${EXPERIMENT_USERNAME:-experiment_user}"
PASSWORD="${EXPERIMENT_PASSWORD:-CourseProject-Only-Password-Change-Me}"

if [[ ! -x "$PYTHON" ]]; then
    echo "Project Python executable was not found at $PYTHON" >&2
    exit 2
fi
if [[ ! -x "$ST" ]]; then
    echo "Schemathesis executable was not found at $ST. Install backend/requirements-dev.txt." >&2
    exit 2
fi

export PYTHONUTF8=1
export PYTHONIOENCODING=utf-8
TOKEN=$("$PYTHON" -c 'import json,sys,urllib.request; url,user,password=sys.argv[1:]; body=json.dumps({"username":user,"password":password}).encode(); request=urllib.request.Request(url+"/api/token/",data=body,headers={"Content-Type":"application/json"},method="POST"); print(json.load(urllib.request.urlopen(request))["access"])' "$BASE_URL" "$USERNAME" "$PASSWORD")
AUTHORIZATION="Authorization: Bearer $TOKEN"

mkdir -p "$RESULTS"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_PATH="$RESULTS/schemathesis-${TIMESTAMP}.log"
cd "$BACKEND_ROOT"

set +e
"$ST" \
    --config-file schemathesis.toml \
    run "$BASE_URL/api/schema/" \
    --url "$BASE_URL" \
    --include-path-regex '^/api/(cart/update|orders/create)/$' \
    --header "$AUTHORIZATION" \
    --mode all \
    --checks 'not_a_server_error,status_code_conformance,content_type_conformance,response_schema_conformance,negative_data_rejection' \
    --max-examples "$MAX_EXAMPLES" \
    --seed "$SEED" \
    --continue-on-failure \
    --no-color 2>&1 | tee "$OUTPUT_PATH"
RUN_EXIT_CODE=${PIPESTATUS[0]}
set -e

printf 'Schemathesis log: %s\n' "$OUTPUT_PATH"
exit "$RUN_EXIT_CODE"