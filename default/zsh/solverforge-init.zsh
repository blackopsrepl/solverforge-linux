# Completion
zstyle ':completion:*' menu select
fpath+=~/.zfunc
autoload -Uz compinit && compinit

# Optional local shell bootstrap for machine-specific tools.
[[ -f "$HOME/.config/solverforge/local-init.zsh" ]] && source "$HOME/.config/solverforge/local-init.zsh"
