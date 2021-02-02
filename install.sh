#!/usr/bin/env sh

# Setup
DOTFILES_ROOT=~0 # The current directory is the local repository root

# Install homebrew
echo "\nChecking for homebrew..."
if which brew | grep -q 'not found'; then
    echo "Homebrew (required for installation) is not installed. Install now?"
    while true; do
        read -p "[y/n]: " yn
        case $yn in
            [Yy] ) echo "Installing homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
                break
                ;;
            [Nn] ) echo "Aborting installation."
                exit
                ;;
        esac
    done
else
    echo "Homebrew already installed."
fi

# Install zsh
echo "\nChecking zsh installation..."
if cat /etc/shells | grep -q '/usr/local/bin/zsh'; then
    echo "Zsh already installed."
else
    echo "Zsh not found. Installing zsh via homebrew..."
    brew install zsh
fi

# Change default shell to homebrew-installed zsh
echo "\nSetting default shell to zsh..."
if [[ "/usr/local/bin/zsh" != $SHELL ]]; then
    chsh -s /usr/local/bin/zsh
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

# Clean up
unset DOTFILES_ROOT

echo "\nInstallation complete. Changes will take effect in the next shell session.\n"
