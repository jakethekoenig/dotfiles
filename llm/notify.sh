#!/bin/zsh
set -euo pipefail

get_branch_name() {
  local branch
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")"
    if [[ -n "$branch" && "$branch" != "HEAD" ]]; then
      echo "$branch"
      return 0
    fi

    branch="$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || echo "")"
    if [[ -n "$branch" ]]; then
      echo "$branch"
      return 0
    fi
  fi
  return 1
}

main() {
  local message
  if message="$(get_branch_name)"; then
    :
  else
    message="${PWD##*/}"
  fi

  # Fall back to say command to announce the target context
  say "$message"
}

main "$@"
