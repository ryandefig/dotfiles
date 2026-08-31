#!/usr/bin/env zsh
# Apollo: a dependency-free, three-line prompt tuned for the Apollo terminal theme.

autoload -Uz add-zsh-hook
zmodload zsh/datetime 2>/dev/null

typeset -g DOTFILES_APOLLO_COMMAND_STARTED=""
typeset -g DOTFILES_APOLLO_DURATION=""
typeset -g DOTFILES_APOLLO_EXIT_STATUS=0
typeset -g DOTFILES_APOLLO_GIT=""
typeset -g DOTFILES_APOLLO_GIT_STATE="clean"
typeset -g DOTFILES_APOLLO_JOB_COUNT=0
typeset -g DOTFILES_APOLLO_HAD_TRAPCHLD=0

dotfiles_apollo_escape() {
  print -nr -- "${1//\%/%%}"
}

dotfiles_apollo_segment() {
  local name="$1"
  local default_background="$2"
  local default_foreground="$3"
  local content="$4"
  local background foreground enabled

  zstyle -s ":dotfiles:prompt:apollo:${name}" enabled enabled || enabled=yes
  case "${enabled:l}" in
    no|false|off|0)
      return 1
      ;;
  esac

  zstyle -s ":dotfiles:prompt:apollo:${name}" background background ||
    background="$default_background"
  zstyle -s ":dotfiles:prompt:apollo:${name}" foreground foreground ||
    foreground="$default_foreground"

  print -nr -- "%K{$background}%F{$foreground} $content %f%k"
}

dotfiles_apollo_preexec() {
  DOTFILES_APOLLO_COMMAND_STARTED="${EPOCHREALTIME:-$SECONDS}"
}

dotfiles_apollo_update_jobs() {
  local job_state

  DOTFILES_APOLLO_JOB_COUNT=0
  for job_state in "${(@v)jobstates}"; do
    if [[ "$job_state" == running:* || "$job_state" == suspended:* ]]; then
      (( DOTFILES_APOLLO_JOB_COUNT++ ))
    fi
  done
}

dotfiles_apollo_trapchld() {
  dotfiles_apollo_update_jobs
  zle reset-prompt 2>/dev/null

  (( $+functions[dotfiles_apollo_previous_trapchld] )) &&
    dotfiles_apollo_previous_trapchld "$@"
  return 0
}

dotfiles_apollo_git() {
  local git_status line branch="" divergence="" stash=0
  local stash_header=0
  local staged=0 modified=0 untracked=0 ahead=0 behind=0

  git_status="$(command git status --porcelain=v2 --branch --show-stash \
    --ignore-submodules=dirty 2>/dev/null)" || {
    DOTFILES_APOLLO_GIT=""
    return
  }

  while IFS= read -r line; do
    case "$line" in
      '# branch.head '*)
        branch="${line#\# branch.head }"
        ;;
      '# branch.ab '*)
        divergence="${line#\# branch.ab }"
        ahead="${${(s: :)divergence}[1]#+}"
        behind="${${(s: :)divergence}[2]#-}"
        ;;
      '# stash '*)
        stash="${line#\# stash }"
        stash_header=1
        ;;
      [12u]' '*)
        local xy="${line[3,4]}"
        [[ "${xy[1]}" != "." ]] && staged=1
        [[ "${xy[2]}" != "." ]] && modified=1
        ;;
      '? '*)
        untracked=1
        ;;
    esac
  done <<< "$git_status"

  # Git versions before 2.35 may accept --show-stash without emitting its header.
  if (( ! stash_header )); then
    stash="$(command git rev-list --walk-reflogs --count refs/stash 2>/dev/null)"
    stash="${stash:-0}"
  fi

  if [[ -z "$branch" || "$branch" == "(detached)" ]]; then
    branch="@$(command git rev-parse --short HEAD 2>/dev/null)"
  fi
  branch="$(dotfiles_apollo_escape "$branch")"

  DOTFILES_APOLLO_GIT_STATE="clean"
  (( staged || modified || untracked )) && DOTFILES_APOLLO_GIT_STATE="dirty"

  DOTFILES_APOLLO_GIT="git:$branch"
  (( staged )) && DOTFILES_APOLLO_GIT+=" │ +"
  (( modified )) && DOTFILES_APOLLO_GIT+=" │ *"
  (( untracked )) && DOTFILES_APOLLO_GIT+=" │ ?"
  (( ahead )) && DOTFILES_APOLLO_GIT+=" │ ↑${ahead}"
  (( behind )) && DOTFILES_APOLLO_GIT+=" │ ↓${behind}"
  (( stash )) && DOTFILES_APOLLO_GIT+=" │ ≡${stash}"
}

dotfiles_apollo_precmd() {
  local exit_status=$?
  local now="${EPOCHREALTIME:-$SECONDS}"
  local elapsed=0
  integer seconds=0

  DOTFILES_APOLLO_EXIT_STATUS=$exit_status
  DOTFILES_APOLLO_DURATION=""
  dotfiles_apollo_update_jobs

  if [[ -n "$DOTFILES_APOLLO_COMMAND_STARTED" ]]; then
    elapsed=$(( now - DOTFILES_APOLLO_COMMAND_STARTED ))
    seconds=${elapsed%.*}

    if (( seconds >= 60 )); then
      DOTFILES_APOLLO_DURATION="$(( seconds / 60 ))m $(( seconds % 60 ))s"
    elif (( seconds >= 2 )); then
      DOTFILES_APOLLO_DURATION="${seconds}s"
    fi
  fi

  DOTFILES_APOLLO_COMMAND_STARTED=""
  dotfiles_apollo_git
}

dotfiles_apollo_context() {
  dotfiles_apollo_escape "${USER:-%n}@${HOST%%.*}"
}

dotfiles_apollo_environment() {
  local -a environments=()

  [[ -n "$VIRTUAL_ENV" ]] && environments+=("py:$(dotfiles_apollo_escape "${VIRTUAL_ENV:t}")")
  [[ -n "$IN_NIX_SHELL" ]] && environments+=("nix")
  [[ -n "$DIRENV_DIR" ]] && environments+=("direnv")

  if (( ${#environments} )); then
    dotfiles_apollo_segment environment magenta black "${(j: · :)environments}"
  fi
}

dotfiles_apollo_metadata() {
  dotfiles_apollo_segment clock 240 white "%D{%H:%M}"
  dotfiles_apollo_environment
  if [[ -n "$DOTFILES_APOLLO_DURATION" ]]; then
    dotfiles_apollo_segment duration yellow black "$DOTFILES_APOLLO_DURATION"
  fi
  if (( DOTFILES_APOLLO_EXIT_STATUS != 0 )); then
    dotfiles_apollo_segment error red black "exit ${DOTFILES_APOLLO_EXIT_STATUS}"
  fi
  if (( DOTFILES_APOLLO_JOB_COUNT )); then
    local job_label="jobs"
    (( DOTFILES_APOLLO_JOB_COUNT == 1 )) && job_label="job"
    dotfiles_apollo_segment jobs cyan black \
      "${DOTFILES_APOLLO_JOB_COUNT} ${job_label}"
  fi
}

dotfiles_apollo_prompt() {
  local context="$(dotfiles_apollo_context)"

  dotfiles_apollo_segment context 240 white "$context"
  dotfiles_apollo_segment directory blue black "%~"
  if [[ -n "$DOTFILES_APOLLO_GIT" ]]; then
    if [[ "$DOTFILES_APOLLO_GIT_STATE" == clean ]]; then
      dotfiles_apollo_segment git-clean green black "$DOTFILES_APOLLO_GIT"
    else
      dotfiles_apollo_segment git-dirty yellow black "$DOTFILES_APOLLO_GIT"
    fi
  fi
  print -nr -- $'\n'
  dotfiles_apollo_metadata
  print -nr -- $'\n'
  print -nr -- "%F{white}%B❯%b%f "
}

dotfiles_prompt_teardown() {
  add-zsh-hook -d preexec dotfiles_apollo_preexec
  add-zsh-hook -d precmd dotfiles_apollo_precmd

  if (( DOTFILES_APOLLO_HAD_TRAPCHLD )); then
    functions[TRAPCHLD]="${functions[dotfiles_apollo_previous_trapchld]}"
  else
    unfunction TRAPCHLD 2>/dev/null
  fi
  unfunction dotfiles_apollo_previous_trapchld 2>/dev/null
}

add-zsh-hook preexec dotfiles_apollo_preexec
add-zsh-hook precmd dotfiles_apollo_precmd

if (( $+functions[TRAPCHLD] )); then
  functions[dotfiles_apollo_previous_trapchld]="${functions[TRAPCHLD]}"
  DOTFILES_APOLLO_HAD_TRAPCHLD=1
fi
functions[TRAPCHLD]="${functions[dotfiles_apollo_trapchld]}"

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1
typeset -g PROMPT='$(dotfiles_apollo_prompt)'
typeset -g RPROMPT=''

# Populate repository state before the first command is run.
dotfiles_apollo_git
