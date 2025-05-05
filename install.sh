#!/usr/bin/env sh

if [[ "./install.sh" != $0 ]]; then
    echo "\n[ERROR] This script must be run from the dotfiles root directory.\n"
    exit 1
fi

# Setup
DOTFILES_ROOT=~0 # The current directory is the local repository root

# Set default shell to zsh (homebrew)
echo "\nVerifying zsh installation..."
ZSH_INSTALL="/opt/homebrew/bin/zsh"
if [[ -f $ZSH_INSTALL ]]; then
    echo "Zsh (homebrew) is already installed."
else
    echo "Zsh (homebrew) is not installed. Installing via homebrew..."
    brew install zsh
fi

if [[ $ZSH_INSTALL == $SHELL ]]; then
    echo "Zsh (homebrew) is already the default shell."
else
    echo "Zsh (homebrew) is not the default shell. Making it the default shell..."
    sudo sh -c "echo ${ZSH_INSTALL} >> /etc/shells && chsh -s ${ZSH_INSTALL}"
fi
echo "Done."

# Configure local files to point to the local dotfiles root.
# This is the root of the git repository where this install script also lives.
echo "\nConfiguring dotfile root directory..."
find ./config/local/ -type f -exec sed -i '' -e "s~{{dotfiles_root}}~${DOTFILES_ROOT}~g" {} +
echo "Done."

# Link runcom files to $HOME
echo "\nShell startup files will be linked to $HOME. This will overwrite any existing shell startup files in $HOME. Proceed?"
while true; do
    read -p "[y/n]: " yn
    case $yn in
        [Yy] ) echo "Linking shell startup files to $HOME..."
            ln -sf $DOTFILES_ROOT/config/local/runcom/zsh/zshenv $HOME/.zshenv
            ln -sf $DOTFILES_ROOT/config/local/runcom/zsh/zprofile $HOME/.zprofile
            ln -sf $DOTFILES_ROOT/config/local/runcom/zsh/zshrc $HOME/.zshrc
            ln -sf $DOTFILES_ROOT/config/local/runcom/zsh/zlogin $HOME/.zlogin
            ln -sf $DOTFILES_ROOT/config/local/runcom/zsh/zlogout $HOME/.zlogout
            echo "Done."
            break
            ;;
        [Nn] ) echo "Skipping file link. Re-run this script at any time to automatically link the files."
            break
            ;;
    esac
done

# Ignore local configuration
echo "\nIsolating local configuration files to this machine..."
find ./config/local/ -type f -exec git update-index --skip-worktree {} +
echo "Done."

# Silence "Last login" terminal message
echo "\nSilencing \"Last login\" terminal message..."
touch ~/.hushlogin
echo "Done."

# Clean up
unset DOTFILES_ROOT

echo "\nInstallation complete. Changes will take effect in the next shell session.\n"
