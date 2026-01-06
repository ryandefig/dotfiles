#!/usr/bin/env zsh
# Environment variables and PATH configuration

# ============================================================================
# PATH Setup
# ============================================================================
# Use macOS path_helper to read /etc/paths and /etc/paths.d/*
if [[ -x /usr/libexec/path_helper ]]; then
  eval "$(/usr/libexec/path_helper -s)"
fi

# Homebrew (prioritize over system binaries)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Custom bin directories
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/dev/bin:$PATH"

# ============================================================================
# Editor Settings
# ============================================================================
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# ============================================================================
# Development Directories
# ============================================================================
export DEV_DIR="$HOME/dev/src"

# ============================================================================
# Less Configuration
# ============================================================================
export LESS='-R -i -w -M -z-4'

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'      # begin bold
export LESS_TERMCAP_md=$'\e[1;32m'      # begin blink
export LESS_TERMCAP_me=$'\e[0m'         # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'         # reset reverse video
export LESS_TERMCAP_so=$'\e[01;33m'     # begin reverse video
export LESS_TERMCAP_ue=$'\e[0m'         # reset underline
export LESS_TERMCAP_us=$'\e[1;4;31m'    # begin underline

# ============================================================================
# Language-Specific Paths (Uncomment as needed)
# ============================================================================

# Node.js / NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

# Python
# export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"

# Go
# export GOPATH="$HOME/go"
# export PATH="$PATH:$GOPATH/bin"

# Rust
# export PATH="$HOME/.cargo/bin:$PATH"

# Ruby (rbenv)
# export PATH="$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init - zsh)"

# Java
# export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
# export PATH="$JAVA_HOME/bin:$PATH"

# ============================================================================
# Development Tools
# ============================================================================
# Disable Python bytecode generation
export PYTHONDONTWRITEBYTECODE=1

# Enable colored output
export CLICOLOR=1

# Set default AWS region (if using AWS)
# export AWS_DEFAULT_REGION="us-east-1"