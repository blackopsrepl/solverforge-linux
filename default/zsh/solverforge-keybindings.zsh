if 'zmodload' 'zsh/parameter' 2>'/dev/null' && (( ${+options} )); then
  __trex_keybinding_options="options=(${(j: :)${(kv)options[@]}})"
else
  () {
    __trex_keybinding_options="setopt"
    'local' '__trex_opt'
    for __trex_opt in "${(@)${(@f)$(set -o)}%% *}"; do
      if [[ -o "$__trex_opt" ]]; then
        __trex_keybinding_options+=" -o $__trex_opt"
      else
        __trex_keybinding_options+=" +o $__trex_opt"
      fi
    done
  }
fi

'emulate' 'zsh' '-o' 'no_aliases'

{

[[ -o interactive ]] || return 0

# CTRL-T - Run trex
trex-widget() {
  zle push-input
  BUFFER="trex"
  zle accept-line
}
zle     -N            trex-widget
bindkey -M emacs '^T' trex-widget
bindkey -M vicmd '^T' trex-widget
bindkey -M viins '^T' trex-widget

# CTRL-S - Fuzzy file search from current directory
fzf-file-widget() {
  zle push-input
  BUFFER="fzf"
  zle accept-line
}
zle     -N            fzf-file-widget
bindkey -M emacs '^S' fzf-file-widget
bindkey -M vicmd '^S' fzf-file-widget
bindkey -M viins '^S' fzf-file-widget

# CTRL-F - Yazi file manager
yazi-widget() {
  zle push-input
  BUFFER="yazi"
  zle accept-line
}
zle     -N            yazi-widget
bindkey -M emacs '^F' yazi-widget
bindkey -M vicmd '^F' yazi-widget
bindkey -M viins '^F' yazi-widget

# CTRL-ALT-F - Midnight Commander
mc-widget() {
  zle push-input
  BUFFER="mc"
  zle accept-line
}
zle     -N               mc-widget
bindkey -M emacs '\e^F'  mc-widget
bindkey -M vicmd '\e^F'  mc-widget
bindkey -M viins '\e^F'  mc-widget

# CTRL-E - SolverForge Mail
mail-widget() {
  zle push-input
  BUFFER="solverforge-mail"
  zle accept-line
}
zle     -N            mail-widget
bindkey -M emacs '^E' mail-widget
bindkey -M vicmd '^E' mail-widget
bindkey -M viins '^E' mail-widget

# CTRL-Y - Planner123
calendar-widget() {
  zle push-input
  BUFFER="planner123"
  zle accept-line
}
zle     -N            calendar-widget
bindkey -M emacs '^Y' calendar-widget
bindkey -M vicmd '^Y' calendar-widget
bindkey -M viins '^Y' calendar-widget

} always {
  eval $__trex_keybinding_options
  'unset' '__trex_keybinding_options'
}
