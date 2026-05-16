#!/bin/bash
# Phase 4: Apply theme

sf_info "Applying SolverForge theme..."

if [[ "$SOLVERFORGE_FRESH" -eq 1 ]]; then
  "$SOLVERFORGE_PATH/bin/solverforge-theme-apply"
else
  "$SOLVERFORGE_PATH/bin/solverforge-theme-apply" --reload
fi

sf_success "Theme applied"
