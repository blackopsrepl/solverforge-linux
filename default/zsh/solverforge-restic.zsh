# SolverForge — Restic backup dispatcher
# Sources shared backup.conf for single source of truth

bk() {
  # Load backup configuration (default layer, then user override)
  local _sf="${SOLVERFORGE_PATH:-$HOME/.local/share/solverforge}"
  source "$_sf/default/bash/backup.conf"
  [[ -f "$HOME/.config/solverforge/backup.conf" ]] && source "$HOME/.config/solverforge/backup.conf"

  local repo="$RESTIC_REPO"
  local passfile="$RESTIC_PASSWORD_FILE"
  local excludes="$RESTIC_EXCLUDE_FILE"

  local cmd=${1:-ls}
  [[ $# -gt 0 ]] && shift

  case "$cmd" in
    ls|snap)
      restic -r "$repo" --password-file "$passfile" snapshots "$@"
      ;;
    up|backup)
      restic -r "$repo" --password-file "$passfile" backup --exclude-file="$excludes" "$@"
      ;;
    restore)
      restic -r "$repo" --password-file "$passfile" restore "$@"
      ;;
    forget)
      restic -r "$repo" --password-file "$passfile" forget "$@"
      ;;
    prune)
      restic -r "$repo" --password-file "$passfile" forget --keep-within 7d --prune "$@"
      ;;
    help|--help|-h)
      cat <<'EOF'
bk                        list snapshots (default)
bk ls                     list snapshots
bk up <paths>             backup paths
bk restore <id> <target>  restore snapshot
bk forget <id>            forget snapshot
bk prune                  forget --keep-within 7d + prune
EOF
      ;;
    *)
      echo "bk: unknown command '$cmd' (try: bk help)" >&2
      return 1
      ;;
  esac
}
