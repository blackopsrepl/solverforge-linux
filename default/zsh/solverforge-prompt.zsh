# SolverForge — Agnoster prompt customizations (hackerman via terminal ANSI colors)
AGNOSTER_DIR_BG=green
AGNOSTER_DIR_FG=black

# Smart path shortening: full when short, abbreviated when long
smart_path() {
  local cur_path="${PWD/#$HOME/~}"
  local max_len=40

  if [[ ${#cur_path} -le $max_len ]]; then
    echo "$cur_path"
  else
    local parts=("${(@s:/:)cur_path}")
    local result=""
    local last_idx=${#parts[@]}
    local i=1

    for part in "${parts[@]}"; do
      if [[ $i -eq $last_idx ]]; then
        result+="$part"
      elif [[ -n "$part" ]]; then
        if [[ "$part" == "~" ]]; then
          result+="~/"
        else
          result+="${part:0:1}/"
        fi
      fi
      ((i++))
    done

    echo "$result"
  fi
}

prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    local user_color="green"
    [[ $UID -eq 0 ]] && user_color="red"
    prompt_segment "$AGNOSTER_CONTEXT_BG" "$AGNOSTER_CONTEXT_FG" "%{%F{$user_color}%}%n%{%f%}@%{%F{cyan}%}%m%{%f%}"
  fi
}

prompt_dir() {
  if [[ $AGNOSTER_GIT_INLINE == 'true' ]] && $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" "$(git_toplevel | sed "s:^$HOME:~:")"
  else
    prompt_segment "$AGNOSTER_DIR_BG" "$AGNOSTER_DIR_FG" "$(smart_path)"
  fi
}

prompt_virtualenv() {
  [[ -z "$VIRTUAL_ENV" ]] && return
  prompt_segment 208 black "§"
}

build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_aws
  prompt_terraform
  prompt_context
  prompt_dir
  prompt_git
  prompt_virtualenv
  prompt_bzr
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
