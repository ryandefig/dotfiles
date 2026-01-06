#!/usr/bin/env zsh
# Custom functions

# ============================================================================
# Directory Management
# ============================================================================

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Go up N directories
up() {
  local d=""
  local limit="${1:-1}"
  for ((i=1; i<=limit; i++)); do
    d="../$d"
  done
  cd "$d" || return
}

# Find and cd to a directory in ~/dev/src
fcd() {
  local dir
  dir=$(find "${1:-$DEV_DIR}" -type d 2>/dev/null | fzf --height 40% --reverse) && cd "$dir"
}

# Quickly cd to a repo in ~/dev/src
repo() {
  local search="${1:-.}"
  local dir
  dir=$(find "$DEV_DIR" -maxdepth 3 -type d -name "*$search*" 2>/dev/null | head -1)
  if [[ -n "$dir" ]]; then
    cd "$dir"
  else
    echo "No repository matching '$search' found in $DEV_DIR"
    return 1
  fi
}

# ============================================================================
# Git Repository Management
# ============================================================================

# Clone repository into organized structure under ~/dev/src
clone() {
  if [[ -z "$1" ]]; then
    echo "Usage: clone <git-url>"
    return 1
  fi
  
  local repo_url="$1"
  local org_name repo_name
  
  # Extract organization and repo name from URL
  if [[ "$repo_url" =~ github\.com[/:](.*?)/(.*?)(\.git)?$ ]]; then
    org_name="${match[1]}"
    repo_name="${match[2]}"
  elif [[ "$repo_url" =~ gitlab\.com[/:](.*?)/(.*?)(\.git)?$ ]]; then
    org_name="${match[1]}"
    repo_name="${match[2]}"
  else
    # Fallback: use basename
    org_name="misc"
    repo_name=$(basename "$repo_url" .git)
  fi
  
  local target_dir="$DEV_DIR/$org_name/$repo_name"
  
  echo "Cloning into: $target_dir"
  mkdir -p "$(dirname "$target_dir")"
  git clone "$repo_url" "$target_dir" && cd "$target_dir"
}

# ============================================================================
# File Operations
# ============================================================================

# Extract various archive types
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.tar.xz)    tar xJf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a backup of a file
backup() {
  cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# ============================================================================
# Git Functions
# ============================================================================

# Quick commit with message
qc() {
  git add -A && git commit -m "$*"
}

# Quick commit and push
qcp() {
  git add -A && git commit -m "$*" && git push
}

# Git branch cleanup - delete merged branches
gitclean() {
  git branch --merged | grep -v "\*" | grep -v "main" | grep -v "master" | xargs -n 1 git branch -d
}

# Show git branch with most recent commit
gitrecent() {
  git for-each-ref --sort=-committerdate refs/heads/ --format='%(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}

# ============================================================================
# Development
# ============================================================================

# Find files by name
ff() {
  find . -type f -name "*$1*"
}

# Find in files (grep recursively)
fif() {
  grep -rnw . -e "$1"
}

# Show file size in human readable format
filesize() {
  du -sh "$1"
}

# Generate a random password
randpass() {
  local length=${1:-20}
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c "$length"; echo
}

# ============================================================================
# Network
# ============================================================================

# Get external IP
whatsmyip() {
  echo "External IP: $(curl -s ifconfig.me)"
  echo "Local IP: $(ipconfig getifaddr en0 2>/dev/null || hostname -I | awk '{print $1}')"
}

# Test website response time
webtest() {
  curl -o /dev/null -s -w "Connect: %{time_connect}s\nStart Transfer: %{time_starttransfer}s\nTotal: %{time_total}s\n" "$1"
}

# ============================================================================
# System
# ============================================================================

# Show disk usage of current directory
duh() {
  du -sh "${1:-.}" | sort -hr
}

# Show processes using the most CPU
topcpu() {
  ps aux | sort -nrk 3,3 | head -n ${1:-10}
}

# Show processes using the most memory
topmem() {
  ps aux | sort -nrk 4,4 | head -n ${1:-10}
}

# Kill process by name
killnamed() {
  ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}