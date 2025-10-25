# Dotfiles

## Omarchy Install

- Github Login
  - gh auth login
- dotfiles
  - git clone https://github.com/maxwell7774/dotfiles
- Omarchy hooks
  - ln -sf ~/dotfiles/omarchy/hooks/theme-set ~/.config/omarchy/hooks/theme-set
  - change theme to initialize custom folder
- Extra Themes
  - install extra themes in dotfiles -> omarchy -> themes
- Backgrounds
  - copy backgrounds from dotfiles -> omarchy -> themes to themes
- Neovim
  - rm -rf ~/.config/nvim
  - rm -rf ~/.local/state/nvim
  - rm -rf ~/.local/share/nvim
  - ln -sf ~/dotfiles/nvim ~/.config/nvim

- Ghostty
  - Install
  - Set as default terminal
  - Remove padding in ghostty config

- Tmux
  - Install
  - ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

- Hyprland
  - Copy over monitor settings
  - Copy over bindings

