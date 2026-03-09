#!/bin/bash

HOME_DIR=~
CONFIG_DIR=$HOME_DIR/.config
OMARCHY_DIR=$CONFIG_DIR/omarchy
DOTFILES_DIR=$HOME_DIR/dotfiles
SHARE_DIR=$HOME_DIR/.local/share
STATE_DIR=$HOME_DIR/.local/state
GITHUB_URL=https://github.com/maxwell7774
WORKSPACE_DIR=$HOME_DIR/workspace
GITHUB_DIR=$WORKSPACE_DIR/github.com/maxwell7774

omarchy-pkg-add stow

# Install extra themes
# omarchy-theme-install https://github.com/bjarneo/omarchy-nes-theme

omarchy-theme-set gruvbox

echo "SHOULD BE vulkan-radeon for 9070 xt and lib32-vulkan-radeon"
omarchy-install-steam

# Discord
omarchy-pkg-add discord

# Minecraft Launcher
omarchy-pkg-add minecraft-launcher

# Youtube downloader
omarchy-pkg-add yt-dlp

# Disk imager
omarchy-pkg-add caligula

# Zen Browser
# omarchy-pkg-aur-add zen-browser

# Dev tools
omarchy-install-dev-env bun
omarchy-install-dev-env npm
omarchy-install-dev-env go
omarchy-install-dev-env python

# DBs
omarchy-install-docker-dbs PostgreSQL

# Remove unused web apps
# omarchy-webapp-remove Basecamp
# omarchy-webapp-remove Discord
# omarchy-webapp-remove "Google Contacts"
# omarchy-webapp-remove "Google Messages"
# omarchy-webapp-remove "Google Photos"
# omarchy-webapp-remove HEY
# omarchy-webapp-remove WhatsApp
# omarchy-webapp-remove X
# omarchy-webapp-remove Zoom

# omarchy-pkg-drop spotify
# omarchy-pkg-drop signal-desktop
# omarchy-pkg-drop 1password-beta
# omarchy-pkg-drop 1password-cli

# Sets up nvim
# if [ -L "$CONFIG_DIR/nvim"]; then
#   echo "nvim is a symlink"
#   rm $CONFIG_DIR/nvim
# else
#   echo "nvim is not a symbolic link"
rm -rf $CONFIG_DIR/nvim
rm -rf $SHARE_DIR/nvim
rm -rf $STATE_DIR/nvim
# fi

rm -rf $CONFIG_DIR/ghostty

rm $OMARCHY_DIR/branding/screensaver.txt

stow -d $DOTFILES_DIR -t $HOME_DIR

# if [ -L "$CONFIG_DIR/ghostty"]; then
#   echo "nvim is a symlink"
#   rm $CONFIG_DIR/ghostty
# else
#   echo "nvim is not a symbolic link"
#   rm -rf $CONFIG_DIR/ghostty
# fi

# Tmux
# pacman -S tmux
# rm ~/.tmux.conf
# ln -sf $DOTFILES/tmux/.tmux.conf ~/.tmux.conf
