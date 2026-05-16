#!/bin/bash
# SolverForge — preflight guards

sf_guard_os() {
  if ! grep -qi 'opensuse' /etc/os-release 2>/dev/null; then
    # shellcheck source=/dev/null
    sf_error "SolverForge Linux requires openSUSE. Detected: $(. /etc/os-release 2>/dev/null && echo "$NAME" || echo "unknown")"
    exit 1
  fi
}

sf_guard_not_root() {
  if [[ "$EUID" -eq 0 ]]; then
    sf_error "Do not run the installer as root. It will use sudo when needed."
    exit 1
  fi
}
