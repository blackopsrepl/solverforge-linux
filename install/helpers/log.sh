#!/bin/bash
# SolverForge — log helpers

sf_info()    { printf '\033[0;34m[info]\033[0m %s\n' "$*"; }
sf_warn()    { printf '\033[0;33m[warn]\033[0m %s\n' "$*"; }
sf_error()   { printf '\033[0;31m[error]\033[0m %s\n' "$*" >&2; }
sf_success() { printf '\033[0;32m[ok]\033[0m %s\n' "$*"; }
