#!/bin/bash
find ~/.local/share/omarchy/themes -type f -name "colors.toml" | while read -r file; do theme=$(basename "$(dirname "$file")"); mkdir -p ~/dotfiles/.config/ghostty/themes/"$theme"; cp "$file" ~/dotfiles/.config/ghostty/themes/"$theme"/ghostty.conf; done
