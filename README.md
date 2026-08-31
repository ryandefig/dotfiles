# Dotfiles

Personal development environment configuration.

## Quick Start
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Structure

- `zsh/` - Zsh shell configuration (modular)
- `git/` - Git configuration
- `terminal` - Terminal configuration
- `local-example/` - Examples for machine-specific configs (not tracked)

## Local Configuration

Create these files for machine-specific overrides (they're gitignored):

- `~/.zshrc.local` - Shell overrides, secrets, machine-specific aliases
- `~/.dotfiles/zsh/env.local.zsh` - Additional environment variables

Copy from examples:
```bash
cp local-example/zshrc.local.example ~/.zshrc.local
cp local-example/env.local.example zsh/env.local.zsh
```

## Customization

Edit files in `zsh/` directory and changes will take effect after:
```zsh
source ~/.zshrc
```

### Prompt themes

The default three-line `apollo` prompt shows the working directory and Git
state, left-aligned command metadata, and a clean input line. Its metadata
starts with time and active development environments, followed by command
duration, exit status, and jobs.

Switch themes for the current session:
```zsh
prompt_theme classic
prompt_theme apollo
```

Set `DOTFILES_PROMPT_THEME=classic` in `zsh/env.local.zsh` to choose a default,
or set it to `none` to leave prompt configuration untouched. New themes can be
added as files under `zsh/prompts/`.

Apollo segment colors can be adapted to the active terminal palette with
`zstyle` settings in `zsh/env.local.zsh`:
```zsh
zstyle ':dotfiles:prompt:apollo:directory' background blue
zstyle ':dotfiles:prompt:apollo:directory' foreground black
zstyle ':dotfiles:prompt:apollo:clock' enabled no
```

Supported segment names are `context`, `directory`, `git-clean`, `git-dirty`,
`environment`, `duration`, `error`, `jobs`, and `clock`. Each accepts
`background`, `foreground`, and `enabled`; colors may be ANSI names or 256-color
indexes. The complete default palette is listed in
`local-example/env.local.example`.

`~/.zshrc` is a Zsh configuration and must be sourced from a Zsh session. If
Zsh is not installed, install it with your operating system's package manager,
then start it with:
```bash
exec zsh
```

## Updating
```bash
cd ~/.dotfiles
git pull
exec zsh
```
