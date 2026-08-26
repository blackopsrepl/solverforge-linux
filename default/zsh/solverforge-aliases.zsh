# SolverForge — Shell aliases

# Filesystem
_eza="eza --color=always --group-directories-first --icons=auto"
alias ls="$_eza -lg"
alias ll="$_eza -alg"
alias la="$_eza -ag"
alias lt="$_eza -aTg"

# Editors
alias vi='vim'
alias em='emacsclient --tty'

# Tools
alias cat='bat'
alias python='python3'
alias ssh='ssh -o ServerAliveInterval=100'
alias grep='rg'

# System
alias jctl='journalctl -p 3 -xb'
alias anacron-check='sudo journalctl -u cron | command grep -i anacron'
alias anacron-reload='env -i HOME="$HOME" LOGNAME="$LOGNAME" USER="$USER" SHELL=/bin/sh PATH="${SOLVERFORGE_PATH:-$HOME/.local/share/solverforge}/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin" anacron -t "$HOME/.anacrontab" -S "$HOME/.var/spool/anacron"'

# Zypper
alias zypin='sudo zypper install -y'
alias zyprm='sudo zypper remove -y'
alias zypup='sudo zypper update -y'
alias zypdup='sudo zypper dup -y'
alias zypsearch='sudo zypper search'

# Git
alias gl='gitleaks detect --verbose --redact'

# Podman
alias docker='podman'
alias docker-compose='podman-compose'
alias p='podman'
alias pc='podman-compose'

# Ansible
alias a='ansible'
alias ap='ansible-playbook'

# Terraform
alias t='terraform'
alias tf='terraform'
