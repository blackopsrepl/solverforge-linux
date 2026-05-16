# SolverForge — Environment bootstrap for zsh
# Sets SOLVERFORGE_PATH and prepends bin/ to PATH

export SOLVERFORGE_PATH="${SOLVERFORGE_PATH:-$HOME/.local/share/solverforge}"

# Prepend SolverForge bin to PATH (idempotent)
if [[ ":$PATH:" != *":$SOLVERFORGE_PATH/bin:"* ]]; then
  export PATH="$SOLVERFORGE_PATH/bin:$PATH"
fi

# Theme: fzf, eza, bat color env vars
[[ -f "$SOLVERFORGE_PATH/default/theme/generated/fzf.env" ]] && source "$SOLVERFORGE_PATH/default/theme/generated/fzf.env"
[[ -f "$SOLVERFORGE_PATH/default/theme/generated/eza.env" ]] && source "$SOLVERFORGE_PATH/default/theme/generated/eza.env"
export BAT_THEME=ansi

# Optional local overrides live outside the shared repo copy.
[[ -f "$HOME/.config/solverforge/local-env.sh" ]] && source "$HOME/.config/solverforge/local-env.sh"
