#!/bin/bash
# Phase 2: Install packages

install_from_list() {
  local file="$1"
  local pkgs=()
  while IFS= read -r line; do
    line="${line%%#*}"
    line="${line// /}"
    [[ -n "$line" ]] && pkgs+=("$line")
  done < "$file"
  if [[ ${#pkgs[@]} -gt 0 ]]; then
    sudo zypper install --no-confirm "${pkgs[@]}"
  fi
}

sf_info "Installing required packages..."
install_from_list "$SOLVERFORGE_PATH/packages.txt"
sf_success "Required packages installed"

if [[ -t 0 ]]; then
  printf '\n'
  sf_info "Optional packages available (neovim, btop, podman, etc.)"
  read -rp "Install optional packages? [y/N] " answer
  if [[ "$answer" =~ ^[Yy] ]]; then
    install_from_list "$SOLVERFORGE_PATH/packages-optional.txt"
    sf_success "Optional packages installed"
  fi
fi
