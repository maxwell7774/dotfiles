#!/bin/bash

CONFIG_DIR=~/.config
OMARCHY_DIR=~/.config/omarchy
DOTFILES=~/dotfiles
SHARE_DIR=~/.local/share
STATE_DIR=~/.local/state
GITHUB_URL=https://github.com/maxwell7774
WORKSPACE_DIR=~/workspace
GITHUB_DIR=$WORKSPACE_DIR/github.com/maxwell7774

# Set up theme hook
rm $OMARCHY_DIR/hooks/theme-set.sample
rm $OMARCHY_DIR/hooks/theme-set
ln -sf $DOTFILES/omarchy/hooks/theme-set $OMARCHY_DIR/hooks/theme-set

omarchy-theme-set gruvbox

# Install extra themes
omarchy-theme-install https://github.com/bjarneo/omarchy-nes-theme

# Sets up nvim
if [ -L "$CONFIG_DIR/nvim"]; then
  echo "nvim is a symlink"
  rm $CONFIG_DIR/nvim
else
  echo "nvim is not a symbolic link"
  rm -rf $CONFIG_DIR/nvim
  rm -rf $SHARE_DIR/nvim
  rm -rf $STATE_DIR/nvim
fi

ln -sf $DOTFILES/nvim $CONFIG_DIR/nvim

# Sets up ghostty
omarchy-install-terminal ghostty

if [ -L "$CONFIG_DIR/ghostty"]; then
  echo "nvim is a symlink"
  rm $CONFIG_DIR/ghostty
else
  echo "nvim is not a symbolic link"
  rm -rf $CONFIG_DIR/ghostty
fi

ln -sf $DOTFILES/ghostty $CONFIG_DIR/ghostty

# Tmux
sudo pacman -S tmux
rm ~/.tmux.conf
ln -sf $DOTFILES/tmux/.tmux.conf ~/.tmux.conf
