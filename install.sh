#!/usr/bin/env bash

set -e

echo "🚀 Installing dotfiles..."

# Get the dotfiles directory (should be ~/.dotfiles)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup existing configs
backup_if_exists() {
  if [[ -f "$1" ]] && [[ ! -L "$1" ]]; then
    echo "  📦 Backing up existing $1 to $1.backup"
    mv "$1" "$1.backup"
  fi
}

# Create symlink
create_symlink() {
  local src=$1
  local dest=$2
  
  if [[ -L "$dest" ]]; then
    rm "$dest"
  fi
  
  ln -sf "$src" "$dest"
  echo "  ✓ Linked $dest"
}

# Zsh configuration
echo ""
echo "📝 Setting up Zsh..."
if ! command -v zsh >/dev/null 2>&1; then
  echo "  ! Zsh is not installed; install it before starting a Zsh session"
fi
backup_if_exists "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"

# Git configuration
echo ""
echo "🔧 Setting up Git..."
backup_if_exists "$HOME/.gitconfig"
backup_if_exists "$HOME/.gitignore.global"
cp "$DOTFILES_DIR/git/gitconfig.example" "$DOTFILES_DIR/git/gitconfig"
create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/gitignore.global" "$HOME/.gitignore.global"

# Create local configs in the repository so they remain easy to manage while
# staying gitignored. Home-directory entry points are symlinked to them.
echo ""
echo "📄 Setting up local config examples..."
LOCAL_ZSHRC="$DOTFILES_DIR/zsh/zshrc.local.zsh"

if [[ ! -f "$LOCAL_ZSHRC" ]]; then
  if [[ -f "$HOME/.zshrc.local" ]] && [[ ! -L "$HOME/.zshrc.local" ]]; then
    echo "  ℹ️  Moving existing ~/.zshrc.local to zsh/zshrc.local.zsh"
    mv "$HOME/.zshrc.local" "$LOCAL_ZSHRC"
  else
    echo "  ℹ️  Creating zsh/zshrc.local.zsh from example"
    cp "$DOTFILES_DIR/local-example/zshrc.local.example" "$LOCAL_ZSHRC"
  fi
  echo "  ✓ Created zsh/zshrc.local.zsh (customize as needed)"
else
  echo "  ℹ️  zsh/zshrc.local.zsh already exists (not overwriting)"
fi

backup_if_exists "$HOME/.zshrc.local"
create_symlink "$LOCAL_ZSHRC" "$HOME/.zshrc.local"

if [[ ! -f "$DOTFILES_DIR/zsh/env.local.zsh" ]]; then
  echo "  ℹ️  Creating zsh/env.local.zsh from example"
  cp "$DOTFILES_DIR/local-example/env.local.example" "$DOTFILES_DIR/zsh/env.local.zsh"
  echo "  ✓ Created zsh/env.local.zsh (customize as needed)"
else
  echo "  ℹ️  zsh/env.local.zsh already exists (not overwriting)"
fi

# Set DOTFILES environment variable
export DOTFILES="$DOTFILES_DIR"

echo ""
echo "✨ Installation complete!"
echo ""
echo "📌 Next steps:"
echo "   1. Start Zsh with: exec zsh (install Zsh first if needed)"
echo "   2. Edit ~/.zshrc.local for machine-specific configs"
echo "   3. Edit ~/.dotfiles/git/gitconfig with your name and email"
echo "   4. Reload from Zsh with: source ~/.zshrc"
echo ""
echo "💡 Tip: Files ending in .local are gitignored for secrets/machine-specific configs"
