#!/bin/bash
# Phase 6: Post-install

VERSION=$(cat "$SOLVERFORGE_PATH/version")

printf '\n'
sf_success "SolverForge Linux $VERSION installed successfully"

if [[ "$SOLVERFORGE_FRESH" -eq 1 ]]; then
  sf_info "Log out and back in to start Sway with SolverForge"
else
  sf_info "Done. Changes applied."
fi
