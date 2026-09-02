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

- `~/.dotfiles/zsh/zshrc.local.zsh` - Shell overrides, secrets, machine-specific aliases
- `~/.dotfiles/zsh/env.local.zsh` - Additional environment variables

Copy from examples and link the Zsh entry point:
```bash
cp local-example/zshrc.local.example zsh/zshrc.local.zsh
cp local-example/env.local.example zsh/env.local.zsh
ln -s ~/.dotfiles/zsh/zshrc.local.zsh ~/.zshrc.local
```

## Customization

Edit files in `zsh/` directory and changes will take effect after:
```zsh
source ~/.zshrc
```

### Prompt themes

The default `apollo` prompt shows time, user and host, working directory, and
Git state on its first line. Jobs, failures, and command duration add a
conditional status line, while active development environments appear beside
the command prompt.

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
