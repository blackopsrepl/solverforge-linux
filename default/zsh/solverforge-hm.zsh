# SolverForge — Himalaya mail dispatcher
hm() {
  local opts=()
  while [[ $# -gt 0 && "$1" == -* ]]; do
    opts+=("$1" "$2"); shift 2
  done

  local cmd=${1:-ls}
  [[ $# -gt 0 ]] && shift

  case "$cmd" in
    # inbox
    ls|inbox)        solverforge-himalaya envelope list "${opts[@]}" "$@" ;;
    unread)          solverforge-himalaya envelope list "${opts[@]}" not flag seen "$@" ;;
    flagged)         solverforge-himalaya envelope list "${opts[@]}" flag flagged "$@" ;;
    today)           solverforge-himalaya envelope list "${opts[@]}" after "$(date +%Y-%m-%d)" "$@" ;;
    thread)          solverforge-himalaya envelope thread "${opts[@]}" -i "$@" ;;
    from)            local p=$1; shift; solverforge-himalaya envelope list "${opts[@]}" from "$p" "$@" ;;
    about)           local p=$1; shift; solverforge-himalaya envelope list "${opts[@]}" subject "$p" "$@" ;;

    # read
    read|r)          solverforge-himalaya message read "${opts[@]}" "$@" ;;
    peek)            solverforge-himalaya message read -p "${opts[@]}" "$@" ;;
    cat)             solverforge-himalaya message thread "${opts[@]}" "$@" ;;

    # compose
    new|write|w)     solverforge-himalaya message write "${opts[@]}" "$@" ;;
    reply|re)        solverforge-himalaya message reply "${opts[@]}" "$@" ;;
    reall|rea)       solverforge-himalaya message reply -A "${opts[@]}" "$@" ;;
    fwd|forward)     solverforge-himalaya message forward "${opts[@]}" "$@" ;;
    send)            solverforge-himalaya template send "${opts[@]}" "$@" ;;
    edit)            solverforge-himalaya message edit "${opts[@]}" "$@" ;;

    # organize
    mv|move)         solverforge-himalaya message move "${opts[@]}" "$@" ;;
    cp|copy)         solverforge-himalaya message copy "${opts[@]}" "$@" ;;
    rm|delete)       solverforge-himalaya message delete "${opts[@]}" "$@" ;;
    archive)         solverforge-himalaya message move "${opts[@]}" Archive "$@" ;;

    # flags
    flag)            solverforge-himalaya flag add "${opts[@]}" "$@" ;;
    unflag)          solverforge-himalaya flag remove "${opts[@]}" "$@" ;;
    seen)            solverforge-himalaya flag add "${opts[@]}" "$1" seen ;;
    unseen)          solverforge-himalaya flag remove "${opts[@]}" "$1" seen ;;
    star)            solverforge-himalaya flag add "${opts[@]}" "$1" flagged ;;
    unstar)          solverforge-himalaya flag remove "${opts[@]}" "$1" flagged ;;

    # attachments
    attach|dl)       solverforge-himalaya attachment download "${opts[@]}" "$@" ;;

    # folders
    folders)         solverforge-himalaya folder list "${opts[@]}" "$@" ;;
    mkdir)           solverforge-himalaya folder add "${opts[@]}" "$@" ;;
    purge)           solverforge-himalaya folder purge "${opts[@]}" "$@" ;;

    # accounts
    accounts)        solverforge-himalaya account list "${opts[@]}" "$@" ;;
    doctor)          solverforge-himalaya account doctor "${opts[@]}" "$@" ;;

    # check all inboxes
    check)
      for acct in $(solverforge-himalaya account list -o json | jq -r '.[].name'); do
        local count=$(solverforge-himalaya envelope list -a "$acct" -s 100 -o json 2>/dev/null \
          | jq '[.[] | select(.flags | test("seen") | not)] | length' 2>/dev/null)
        [[ "$count" -gt 0 ]] && echo "$acct: $count unread"
      done
      ;;

    # help
    help|--help|-h)
      cat <<'EOF'
hm                        list inbox
hm unread                 unread only
hm flagged                flagged only
hm today                  today's mail
hm from <pattern>         by sender
hm about <pattern>        by subject
hm thread <id>            envelope thread

hm read <id>              read message
hm peek <id>              read without marking seen
hm cat <id>               read full thread

hm new                    compose
hm reply <id>             reply
hm reall <id>             reply all
hm fwd <id>               forward
hm edit <id>              edit draft

hm mv <folder> <id>       move
hm cp <folder> <id>       copy
hm rm <id>                delete
hm archive <id>           archive

hm star <id>              star/flag
hm unstar <id>            unstar
hm seen <id>              mark read
hm unseen <id>            mark unread

hm dl <id>                download attachments
hm folders                list folders
hm accounts               list accounts
hm check                  unread count, all accounts
hm doctor <account>       diagnose account

Flags go before the subcommand:
  hm -a gmail ls
  hm -a icloud -f Drafts ls
EOF
      ;;

    *) echo "hm: unknown command '$cmd' (try: hm help)" >&2; return 1 ;;
  esac
}
