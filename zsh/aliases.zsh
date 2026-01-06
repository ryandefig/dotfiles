#!/usr/bin/env zsh
# Command aliases

# ============================================================================
# Directory Navigation
# ============================================================================
setopt AUTO_CD              # Type directory name to cd
setopt AUTO_PUSHD           # Make cd push old directory onto stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias d='dirs -v'           # List directory stack
alias 1='cd -1'             # Jump to recent directories
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'

# ============================================================================
# Quick Navigation
# ============================================================================
alias dev='cd $DEV_DIR'
alias dots='cd $DOTFILES'

# ============================================================================
# Directory Listing
# ============================================================================
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'
alias lt='ls -lhtr'         # Sort by date, most recent last
alias lS='ls -lhSr'         # Sort by size, largest last

# ============================================================================
# Safety Nets
# ============================================================================
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# ============================================================================
# Git Aliases
# ============================================================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gm='git merge'
alias gr='git remote -v'
alias gst='git stash'
alias gstp='git stash pop'

# ============================================================================
# Python
# ============================================================================
alias py='python3'
alias pip='pip3'
alias mkvenv='python3 -m venv .venv'
alias venv='[ -f .venv/bin/activate ] && source .venv/bin/activate || echo "No .venv found"'
alias serve='python3 -m http.server'

# ============================================================================
# System Utilities
# ============================================================================
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Network
alias ports='netstat -tulanp'
alias listening='lsof -i -P | grep LISTEN'
alias myip='curl -s ifconfig.me'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# ============================================================================
# Misc
# ============================================================================
alias h='history'
alias hg='history | grep'
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR ~/.zshrc'
alias dotfiles='cd $DOTFILES'

# Quick edit configs
alias ea='$EDITOR $DOTFILES/zsh/aliases.zsh'
alias ef='$EDITOR $DOTFILES/zsh/functions.zsh'
alias ee='$EDITOR $DOTFILES/zsh/env.zsh'
alias el='$EDITOR ~/.zshrc.local'