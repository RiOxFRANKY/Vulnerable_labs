#!/usr/bin/env bash
#
# Byte-compile every first-party Python exploit client to catch syntax errors.
# The legacy upstream Python 2 PoCs are excluded (kept verbatim for reference).
#
# Usage: scripts/compile-clients.sh
# Exit status: 0 if all files compile, non-zero otherwise.

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root" || exit 1

# Legacy upstream Python 2 PoCs kept verbatim for reference; they do not
# byte-compile under Python 3 and are intentionally not maintained.
mapfile -d '' files < <(
  find . -type f -name '*.py' \
    -not -path '*/jenkins/CVE-2018-1000861/poc.py' \
    -not -path '*/jenkins/CVE-2018-1000861/exp.py' \
    -not -path '*/.venv/*' \
    -print0 | sort -z
)

echo "Byte-compiling ${#files[@]} Python file(s) (excluding legacy Python 2 PoC)..."
python -m py_compile "${files[@]}"
status=$?

if [ "$status" -eq 0 ]; then
  echo "All Python files compiled successfully."
else
  echo "Python compilation failed." >&2
fi
exit "$status"
