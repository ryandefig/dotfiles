#!/usr/bin/env zsh
# fzf shell integration (including interactive history search on Ctrl-R)
if (( $+commands[fzf] )); then
  export FZF_CTRL_R_OPTS='--color=hl:#69a9e6,hl+:#b9ddff,fg+:#e8f2fc,bg+:#2b3541,pointer:#86c3f5,marker:#86c3f5,prompt:#86c3f5'
  eval "$(fzf --zsh)"
fi
