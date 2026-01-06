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
```bash
source ~/.zshrc
```

## Updating
```bash
cd ~/.dotfiles
git pull
source ~/.zshrc
```