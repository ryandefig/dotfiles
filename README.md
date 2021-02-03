# Dotfiles

## Overview
This repository maintains shell and terminal configuration, and is designed to be flexible enough for use across multiple machines.

The config files are split between two separate directories: `local` and `global`. Any changes made to local configuration are ignored by git. This allows you to maintain both common config across all of your machines as well as machine-specific config without worrying about muddying up your repository.

_Note: Currently, `zsh` is the only supported shell. In the future, flexibility will be added to support other shells._

## Installation
To install this configuration, first fork the repository, then clone your forked repository to your local machine, e.g.
```
git clone git@github.com:<your_username>/dotfiles.git ~/.dotfiles
```

Next, go to your new dotfiles directory and run the install script:
```
cd ~/.dotfiles
./install.sh
```

The installation script will do the following:
1. Check for an installation of homebrew, and install it if it isn't found.
1. Check for a homebrew installation of `zsh` at `/usr/local/bin/zsh`, and install it if it isn't found.
1. Set the default shell to `zsh`.
1. Configure the local configuration settings according to your installation directory, and wire everything together.

## Customization

### Command line prompt
Custom prompts can be written and placed in `modules/prompt`. In order to use a custom prompt, simply add the following line to your `local/runcom/zsh/zshrc` file:
```
setprompt std-prompt
```

You may replace `std-prompt` with your custom prompt; `std-prompt` is the standard prompt that comes built-in with this repository.
