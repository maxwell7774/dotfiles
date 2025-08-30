
#!/bin/bash

# set -eE
#
# CONFIG_DIR=~/.config
# SHARE_DIR=~/.local/share
# STATE_DIR=~/.local/state
# GITHUB_URL=https://github.com/maxwell7774
# WORKSPACE_DIR=~/workspace
# GITHUB_DIR=$WORKSPACE_DIR/github.com/maxwell7774
#
# git clone $GITHUB_URL/tmux_config.git $CONFIG_DIR/tmux
# ln -s $CONFIG_DIR/tmux/.tmux.conf ~/.tmux.conf
#
# rm -rf $CONFIG_DIR/nvim
# rm -rf $SHARE_DIR/nvim
# rm -rf $STATE_DIR/nvim
# git clone $GITHUB_URL/nvim_2025 $CONFIG_DIR/nvim
#
# mkdir -p $GITHUB_DIR
# git clone $GITHUB_URL/budgetingapp $GITHUB_DIR/guppygoals
#
# uv tool install --python 3.12 posting
# git clone $GITHUB_URL/posting $GITHUB_DIR/posting
#
# go install github.com/pressly/goose/v3/cmd/goose@latest
# go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
#
#
set -eE

CONFIG_DIR=~/.config
SHARE_DIR=~/.local/share
STATE_DIR=~/.local/state
GITHUB_URL=https://github.com/maxwell7774
WORKSPACE_DIR=~/workspace
GITHUB_DIR=$WORKSPACE_DIR/github.com/maxwell7774

# Function to prompt for removal if directory exists
confirm_remove() {
    local dir=$1
    if [ -d "$dir" ]; then
        read -p "Directory $dir exists. Remove and reinstall? [y/N]: " answer
        case "$answer" in
            [Yy]* ) rm -rf "$dir";;
            * ) echo "Skipping $dir"; return 1;;
        esac
    fi
    return 0
}

# Tmux config
if confirm_remove "$CONFIG_DIR/tmux"; then
    git clone $GITHUB_URL/tmux_config.git $CONFIG_DIR/tmux
    ln -sf $CONFIG_DIR/tmux/.tmux.conf ~/.tmux.conf
fi

# Neovim config
if confirm_remove "$CONFIG_DIR/nvim"; then
    rm -rf $SHARE_DIR/nvim
    rm -rf $STATE_DIR/nvim
    git clone $GITHUB_URL/nvim_2025 $CONFIG_DIR/nvim
fi

# Workspace and apps
mkdir -p $GITHUB_DIR

if confirm_remove "$GITHUB_DIR/guppygoals"; then
    git clone $GITHUB_URL/budgetingapp $GITHUB_DIR/guppygoals
fi

uv tool install --python 3.12 posting

if confirm_remove "$GITHUB_DIR/posting"; then
    git clone $GITHUB_URL/posting $GITHUB_DIR/posting
fi

# Install Go tools
go install github.com/pressly/goose/v3/cmd/goose@latest
go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest

