#!/bin/bash
set -euo pipefail

# SolverForge Linux — bootstrap installer
# Usage: curl -sL https://raw.githubusercontent.com/blackopsrepl/solverforge-linux/main/boot.sh | bash

SOLVERFORGE_REPO="${SOLVERFORGE_REPO:-https://github.com/blackopsrepl/solverforge-linux.git}"
SOLVERFORGE_REF="${SOLVERFORGE_REF:-main}"
SOLVERFORGE_PATH="${HOME}/.local/share/solverforge"

command -v git &>/dev/null || { echo "Installing git..."; sudo zypper install -y git; }

if [[ -d "$SOLVERFORGE_PATH/.git" ]]; then
  git -C "$SOLVERFORGE_PATH" fetch origin
  git -C "$SOLVERFORGE_PATH" checkout "$SOLVERFORGE_REF"
  git -C "$SOLVERFORGE_PATH" pull --ff-only
else
  git clone --branch "$SOLVERFORGE_REF" "$SOLVERFORGE_REPO" "$SOLVERFORGE_PATH"
fi

exec bash "$SOLVERFORGE_PATH/install.sh"
