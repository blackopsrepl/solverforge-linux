#!/bin/bash
# Phase 5: Install the SolverForge Linux agent skill

SKILL_NAME=solverforge-linux
SKILL_SRC="$SOLVERFORGE_PATH/skills/$SKILL_NAME"
SKILL_INSTALLER="$SOLVERFORGE_PATH/scripts/install-skill"

sf_skill_dir() {
  case "$1" in
  opencode) printf '%s' "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/skills" ;;
  claude) printf '%s' "$HOME/.claude/skills" ;;
  codex) printf '%s' "$HOME/.agents/skills" ;;
  esac
}

# Earlier releases shipped this skill as a hand-placed SKILL.md with no
# ownership marker, so the installer would refuse to replace it. Adopt a legacy
# copy that is byte-identical to the bundle; leave a divergent copy untouched
# and let the installer report it as foreign.
sf_adopt_legacy_skill() {
  local dir="$1"
  local dest="$dir/$SKILL_NAME"
  [[ -e "$dest" || -L "$dest" ]] || return 0
  [[ -f "$dest/.solverforge-skill" ]] && return 0
  [[ -L "$dest" ]] && return 0
  if diff -r -x .solverforge-skill "$SKILL_SRC" "$dest" >/dev/null 2>&1; then
    rm -rf "$dest"
    sf_info "Adopted the previously hand-placed skill at $dest"
  else
    sf_warn "Unmanaged skill at $dest differs from the bundle; leaving it untouched"
  fi
}

if [[ ! -d "$SKILL_SRC" ]]; then
  sf_warn "Bundled skill not found at $SKILL_SRC — skipped"
  return 0
fi
if [[ ! -x "$SKILL_INSTALLER" ]]; then
  sf_warn "Skill installer not found at $SKILL_INSTALLER — skipped"
  return 0
fi

# opencode is the default harness; choose others with a comma or space
# separated list, e.g. SOLVERFORGE_SKILL_AGENTS="opencode codex".
skill_agents="${SOLVERFORGE_SKILL_AGENTS:-opencode}"

skill_agent_args=()
for skill_agent in ${skill_agents//,/ }; do
  [[ -n "$skill_agent" ]] || continue
  sf_adopt_legacy_skill "$(sf_skill_dir "$skill_agent")"
  skill_agent_args+=(--agent "$skill_agent")
done

if [[ ${#skill_agent_args[@]} -eq 0 ]]; then
  sf_warn "No agent selected for the SolverForge Linux skill — skipped"
  return 0
fi

# covering is duplicate-free for a single agent and for opencode plus one other
# harness. Override with SOLVERFORGE_SKILL_LAYOUT=per-harness to accept the
# duplicate discovery the installer otherwise refuses.
skill_layout="${SOLVERFORGE_SKILL_LAYOUT:-covering}"
skill_layout_args=(--layout "$skill_layout")
if [[ "$skill_layout" == per-harness ]]; then
  skill_layout_args+=(--force)
fi

sf_info "Installing the SolverForge Linux agent skill..."
if "$SKILL_INSTALLER" "${skill_agent_args[@]}" "${skill_layout_args[@]}"; then
  sf_success "Agent skill installed"
else
  sf_warn "Agent skill install reported an error; inspect with $SKILL_INSTALLER --list"
fi
