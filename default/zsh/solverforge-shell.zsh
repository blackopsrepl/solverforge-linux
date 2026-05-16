export ZSH="$HOME/.oh-my-zsh"

# Cursor CLI needs a simpler theme
if [[ "$PAGER" == "head -n 10000 | cat" ]]; then
  ZSH_THEME="robbyrussell"
else
  ZSH_THEME="agnoster"
fi

plugins=(git fzf-zsh-plugin)
source $ZSH/oh-my-zsh.sh
autoload -U colors; colors
