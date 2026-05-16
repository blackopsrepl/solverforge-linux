#!/bin/bash
# Phase 3: Generate config files

if [[ "$SOLVERFORGE_FRESH" -eq 0 ]]; then
  sf_info "Update mode — skipping config generation"
  return 0
fi

# a) Sway orchestrator
mkdir -p "$HOME/.config/sway/config.d"
cat > "$HOME/.config/sway/config.d/solverforge.conf" << SWAY
# SolverForge Linux — Sway configuration orchestrator
# Sources all default layer configs from the SolverForge framework.
# User overrides go in additional files in this directory (config.d/).

# Qt/KDE apps use the KDE platform theme to read hackerman colors from kdeglobals
exec_always dbus-update-activation-environment --systemd QT_QPA_PLATFORMTHEME=kde

# Override the default wofi launcher to use SolverForge styling
set \$menu solverforge-menu apps
set \$browser zen

# Disable the openSUSE default bar (50-openSUSE.conf launches waybar via swaybar_command,
# but SolverForge launches its own waybar in autostart.conf — this prevents duplicates)
bar bar-0 {
    swaybar_command true
}

include ${SOLVERFORGE_PATH}/default/theme/generated/sway-colors.conf
include ${SOLVERFORGE_PATH}/default/sway/output.conf
include ${SOLVERFORGE_PATH}/default/sway/input.conf
include ${SOLVERFORGE_PATH}/default/sway/autostart.conf
include ${SOLVERFORGE_PATH}/default/sway/rules.conf
include ${SOLVERFORGE_PATH}/default/sway/bindings.conf
include ${SOLVERFORGE_PATH}/default/sway/voxtype.conf
SWAY
sf_success "Generated sway orchestrator"

# b) systemd environment
mkdir -p "$HOME/.config/environment.d"
cat > "$HOME/.config/environment.d/solverforge.conf" << ENV
# SolverForge Linux — systemd user environment
# Ensures solverforge/bin is on PATH for graphical sessions (sway, waybar, etc.)
SOLVERFORGE_PATH=${SOLVERFORGE_PATH}
PATH=${SOLVERFORGE_PATH}/bin:\${PATH}
SWAYLOCK_CONFIG=${SOLVERFORGE_PATH}/default/theme/generated/swaylock.conf
QT_QPA_PLATFORMTHEME=kde
ENV
sf_success "Generated environment.d config"

# c) voxtype user service
if command -v voxtype &>/dev/null; then
  mkdir -p "$HOME/.config/systemd/user"
  cat > "$HOME/.config/systemd/user/voxtype.service" << 'UNIT'
[Unit]
Description=Voxtype push-to-talk voice-to-text daemon
Documentation=man:voxtype(1)
PartOf=graphical-session.target
After=graphical-session.target pipewire.service pipewire-pulse.service
Wants=ydotool.service

[Service]
Type=simple
# Sway imports DISPLAY/WAYLAND_DISPLAY/SWAYSOCK into the user manager after
# graphical-session.target is already active. The launcher waits for those vars
# before exec'ing voxtype so the service reliably comes up on login.
ExecStart=%h/.local/share/solverforge/bin/solverforge-voxtype-daemon
Restart=on-failure
RestartSec=5

# Note: User must be in 'input' group for evdev access
# Before enabling this service, run: voxtype setup --download

# GPU Selection (for systems with multiple GPUs):
# Create ~/.config/systemd/user/voxtype.service.d/gpu.conf with:
#   [Service]
#   Environment="VOXTYPE_VULKAN_DEVICE=nvidia"
# Valid values: nvidia, amd, intel
# Run: voxtype setup gpu  to see detected GPUs

[Install]
WantedBy=graphical-session.target
UNIT
  sf_success "Generated voxtype user service"
else
  sf_info "voxtype not installed — skipped user service"
fi

# d) Waybar symlinks
mkdir -p "$HOME/.config/waybar"
ln -sf "$SOLVERFORGE_PATH/default/waybar/config" "$HOME/.config/waybar/config"
ln -sf "$SOLVERFORGE_PATH/default/waybar/style.css" "$HOME/.config/waybar/style.css"
sf_success "Linked waybar config"

# e) Zsh integration
ZSH_LINE="# SolverForge Linux
export SOLVERFORGE_PATH=\"$SOLVERFORGE_PATH\"
for f in \"\$SOLVERFORGE_PATH\"/default/zsh/solverforge-*.zsh; do source \"\$f\"; done"

if [[ -f "$HOME/.zshrc" ]]; then
  if ! grep -q 'solverforge' "$HOME/.zshrc"; then
    printf '\n%s\n' "$ZSH_LINE" >> "$HOME/.zshrc"
    sf_success "Added SolverForge to .zshrc"
  else
    sf_info "SolverForge already in .zshrc — skipped"
  fi
else
  printf '%s\n' "$ZSH_LINE" > "$HOME/.zshrc"
  sf_success "Created .zshrc with SolverForge integration"
fi

# f) Codex MCP integration
if command -v codex &>/dev/null && [[ -x "$SOLVERFORGE_PATH/bin/solverforge-computer-use" ]]; then
  if "$SOLVERFORGE_PATH/bin/solverforge-computer-use" --install-codex-mcp; then
    sf_success "Registered SolverForge Computer Use MCP server"
  else
    sf_info "SolverForge Computer Use MCP registration failed — run solverforge-computer-use --doctor"
  fi
else
  sf_info "Codex not available — skipped SolverForge Computer Use MCP registration"
fi
