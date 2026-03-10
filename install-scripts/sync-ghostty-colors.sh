#!/bin/bash

USER_TEMPLATES_DIR="$HOME/.local/share/omarchy/default/themed"
TPL="$USER_TEMPLATES_DIR/ghostty.conf.tpl"

# Convert hex color to decimal RGB (e.g., "#1e1e2e" -> "30,30,46")
hex_to_rgb() {
  local hex="${1#\#}"
  printf "%d,%d,%d" "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

generate_ghostty_conf() {
  local colors_file="$1"
  local theme_name="$2"
  local output_dir="$HOME/dotfiles/.config/ghostty/themes/$theme_name"
  local output_path="$output_dir/ghostty.conf"

  if [[ ! -f "$TPL" ]]; then
    echo "Template not found: $TPL" >&2
    return 1
  fi

  local sed_script
  sed_script=$(mktemp)

  while IFS='=' read -r key value; do
    key="${key//[\"\' ]/}"                # strip quotes and spaces from key
    [[ $key && $key != \#* ]] || continue # skip empty lines and comments
    value="${value#*[\"\']}"
    value="${value%%[\"\']*}"             # extract value between quotes (ignores inline comments)
    printf 's|{{ %s }}|%s|g\n' "$key" "$value"            # {{ key }} -> value
    printf 's|{{ %s_strip }}|%s|g\n' "$key" "${value#\#}" # {{ key_strip }} -> value without leading #
    if [[ $value =~ ^# ]]; then
      rgb=$(hex_to_rgb "$value")
      echo "s|{{ ${key}_rgb }}|${rgb}|g"
    fi
  done <"$colors_file" >"$sed_script"

  mkdir -p "$output_dir"
  sed -f "$sed_script" "$TPL" > "$output_path"
  rm "$sed_script"

  echo "Generated: $output_path"
}

# 1. Built-in themes: ~/.local/share/omarchy/themes/[theme]/colors.toml
while IFS= read -r -d '' colors_file; do
  theme=$(basename "$(dirname "$colors_file")")
  generate_ghostty_conf "$colors_file" "$theme"
done < <(find "$HOME/.local/share/omarchy/themes" -mindepth 2 -maxdepth 2 -name "colors.toml" -print0)

# 2. User-overridden themes: ~/.config/omarchy/themes/[theme]/colors.toml
while IFS= read -r -d '' colors_file; do
  theme=$(basename "$(dirname "$colors_file")")
  generate_ghostty_conf "$colors_file" "$theme"
done < <(find "$HOME/.config/omarchy/themes" -mindepth 2 -maxdepth 2 -name "colors.toml" -print0 2>/dev/null)
