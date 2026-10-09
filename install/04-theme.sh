#!/bin/bash
# Phase 4: Apply theme
#
# Migrations run first: they retire generated files and config symlinks left
# behind by earlier framework versions, so the theme engine starts from a clean
# slate. Each migration is idempotent.

shopt -s nullglob
for migration in "$SOLVERFORGE_PATH"/migrations/*.sh; do
  # shellcheck source=/dev/null
  source "$migration"
done
shopt -u nullglob

sf_info "Applying SolverForge theme..."

if [[ "$SOLVERFORGE_FRESH" -eq 1 ]]; then
  "$SOLVERFORGE_PATH/bin/solverforge-theme-apply"
else
  "$SOLVERFORGE_PATH/bin/solverforge-theme-apply" --reload
fi

sf_success "Theme applied"
