#!/bin/bash
# Phase 6: Install swaytiles, the per-workspace layout manager

if "$SOLVERFORGE_PATH/bin/solverforge-swaytiles" --install; then
  sf_success "Installed swaytiles layout manager"
else
  sf_warn "swaytiles install failed — retry with: solverforge-swaytiles --install"
fi
