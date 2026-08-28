#!/usr/bin/env zsh
# Classic: the original single-line dotfiles prompt.

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1

dotfiles_classic_precmd() {
  vcs_info
}

dotfiles_classic_virtualenv() {
  [[ -n "$VIRTUAL_ENV" ]] &&
    print -nr -- "%F{magenta}❮${VIRTUAL_ENV:t}❯%f "
}

dotfiles_classic_directory() {
  print -nr -- "%F{blue}❮%~❯%f "
}

dotfiles_classic_vcs() {
  local branch="$vcs_info_msg_0_"
  local local_color="green" remote_color remote_ref
  local local_sha remote_sha base_sha

  [[ -z "$branch" ]] && return
  [[ -n "$(command git status --porcelain --ignore-submodules 2>/dev/null)" ]] &&
    local_color="yellow"

  remote_ref="$(command git for-each-ref --format='%(upstream:short)' \
    "$(command git symbolic-ref -q HEAD)" 2>/dev/null)"

  print -nr -- "%F{$local_color}❮${branch//\%/%%}%f"

  if [[ -n "$remote_ref" ]]; then
    local_sha="$(command git rev-parse @ 2>/dev/null)"
    remote_sha="$(command git rev-parse '@{u}' 2>/dev/null)"
    base_sha="$(command git merge-base @ '@{u}' 2>/dev/null)"

    if [[ "$local_sha" == "$remote_sha" ]]; then
      remote_color="$local_color"
    elif [[ "$local_sha" == "$base_sha" ]]; then
      remote_color="red"
    elif [[ "$remote_sha" == "$base_sha" ]]; then
      remote_color="cyan"
    else
      remote_color="magenta"
    fi

    print -nr -- " %F{$remote_color}··· ${remote_ref//\%/%%}❯%f"
  else
    print -nr -- "%F{$local_color}❯%f"
  fi
}

dotfiles_prompt_teardown() {
  add-zsh-hook -d precmd dotfiles_classic_precmd
}

add-zsh-hook precmd dotfiles_classic_precmd
typeset -g PROMPT='$(dotfiles_classic_virtualenv)$(dotfiles_classic_directory)$(dotfiles_classic_vcs) '
typeset -g RPROMPT=''

vcs_info
