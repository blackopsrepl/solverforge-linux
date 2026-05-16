#!/bin/bash
# Phase 1: Preflight checks

sf_guard_not_root
sf_guard_os

for cmd in git zypper; do
  if ! command -v "$cmd" &>/dev/null; then
    sf_error "Required command not found: $cmd"
    exit 1
  fi
done

sf_success "Preflight checks passed"
