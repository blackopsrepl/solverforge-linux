#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_home="$(mktemp -d "${TMPDIR:-/tmp}/solverforge-waybar-voxtype.XXXXXX")"
trap 'rm -rf -- "$tmp_home"' EXIT

mkdir -p "$tmp_home/.cargo/bin"
# These single-quoted lines intentionally write a literal child script.
# shellcheck disable=SC2016
printf '%s\n' \
  '#!/bin/sh' \
  'printf "%s\\n" "$*" > "$VOXTYPE_TEST_ARGS"' \
  'printf '\''{"text":"mic-ready"}\n'\''' \
  > "$tmp_home/.cargo/bin/voxtype"
chmod +x "$tmp_home/.cargo/bin/voxtype"

output="$(env -u VOXTYPE_BIN \
  HOME="$tmp_home" \
  PATH="/usr/bin:/bin" \
  VOXTYPE_TEST_ARGS="$tmp_home/args" \
  "$repo_root/bin/solverforge-waybar-voxtype")"

[[ "$output" == '{"text":"mic-ready"}' ]]
[[ "$(<"$tmp_home/args")" == 'status --follow --format json' ]]
