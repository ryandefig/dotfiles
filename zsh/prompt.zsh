#!/usr/bin/env zsh
# Prompt theme loader. Themes own only the hooks and variables they install.

setopt PROMPT_SUBST

if (( ! ${+DOTFILES_PROMPT_ORIGINAL_PROMPT} )); then
  typeset -g DOTFILES_PROMPT_ORIGINAL_PROMPT="$PROMPT"
  typeset -g DOTFILES_PROMPT_ORIGINAL_RPROMPT="$RPROMPT"
fi

prompt_themes() {
  local theme_file

  for theme_file in "$DOTFILES/zsh/prompts"/*.zsh(N); do
    print -r -- "${theme_file:t:r}"
  done
}

prompt_theme() {
  local theme="${1:-apollo}"
  local theme_file="$DOTFILES/zsh/prompts/${theme}.zsh"

  if [[ "$theme" == "none" ]]; then
    (( $+functions[dotfiles_prompt_teardown] )) && dotfiles_prompt_teardown
    typeset -g PROMPT="$DOTFILES_PROMPT_ORIGINAL_PROMPT"
    typeset -g RPROMPT="$DOTFILES_PROMPT_ORIGINAL_RPROMPT"
    unset DOTFILES_PROMPT_ACTIVE
    return 0
  fi

  if [[ -z "$theme" || "$theme" == *[^A-Za-z0-9_-]* || ! -r "$theme_file" ]]; then
    print -u2 -- "Unknown prompt theme: $theme"
    print -u2 -- "Available themes: ${(j:, :)$(prompt_themes)}"
    return 1
  fi

  (( $+functions[dotfiles_prompt_teardown] )) && dotfiles_prompt_teardown
  unfunction dotfiles_prompt_teardown 2>/dev/null

  source "$theme_file"
  typeset -g DOTFILES_PROMPT_ACTIVE="$theme"
}

prompt_theme "${DOTFILES_PROMPT_THEME:-apollo}"
