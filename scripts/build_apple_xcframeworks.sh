#!/bin/bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
readonly PYENV_BIN="/opt/homebrew/bin/pyenv"

if [[ "${1:-}" == "--print-build-plan" ]]; then
  if [[ -x "${PYENV_BIN}" ]]; then
    exec "${PYENV_BIN}" exec python "${SCRIPT_DIR}/spm_release.py" print-build-plan
  fi
  exec python3 "${SCRIPT_DIR}/spm_release.py" print-build-plan
fi

if [[ -x "${PYENV_BIN}" ]]; then
  exec "${PYENV_BIN}" exec python "${SCRIPT_DIR}/spm_release.py" build-xcframeworks "$@"
fi

exec python3 "${SCRIPT_DIR}/spm_release.py" build-xcframeworks "$@"
