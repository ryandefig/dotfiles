#!/usr/bin/env zsh
# Completion system configuration

# Load completion system
autoload -Uz compinit

# Only regenerate compdump once per day for performance
if [[ -n ~/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion options
setopt ALWAYS_TO_END           # Move cursor to end of word after completion
setopt AUTO_MENU               # Show completion menu on tab
setopt AUTO_LIST               # Automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD        # Allow completion from within a word
unsetopt MENU_COMPLETE         # Don't auto-select first completion entry

# Completion styles
zstyle ':completion:*' menu select                                    # Select completions with arrow keys
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'            # Case insensitive matching
zstyle ':completion:*' list-colors ''                                 # Colored completion
zstyle ':completion:*:descriptions' format '%B%F{green}%d%f%b'       # Group descriptions
zstyle ':completion:*:warnings' format '%F{red}No matches found%f'   # No matches message
zstyle ':completion:*' group-name ''                                 # Group completions by type

# Cache completions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Better directory completion
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,comm'