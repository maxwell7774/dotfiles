#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────
#  Colors & Logging
# ─────────────────────────────────────────────
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"

log_header()  { echo -e "\n${BOLD}${MAGENTA}══════════════════════════════════════${RESET}"; \
                echo -e "${BOLD}${MAGENTA}  $1${RESET}"; \
                echo -e "${BOLD}${MAGENTA}══════════════════════════════════════${RESET}"; }
log_info()    { echo -e "${CYAN}[INFO]${RESET}    $1"; }
log_success() { echo -e "${GREEN}[OK]${RESET}      $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RESET}    $1"; }
log_error()   { echo -e "${RED}[ERROR]${RESET}   $1"; }
log_step()    { echo -e "${BLUE}[STEP]${RESET}    ${BOLD}$1${RESET}"; }
log_skip()    { echo -e "${DIM}[SKIP]    $1${RESET}"; }

# ─────────────────────────────────────────────
#  Detect OS
# ─────────────────────────────────────────────
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if grep -qi ubuntu /etc/os-release 2>/dev/null; then
                echo "ubuntu"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

OS=$(detect_os)

if [[ "$OS" == "unknown" ]]; then
    log_error "Unsupported OS: $(uname -s). This script supports Ubuntu and macOS only."
    exit 1
fi

log_info "Detected OS: $OS"

# ─────────────────────────────────────────────
#  Directories
# ─────────────────────────────────────────────
HOME_DIR=~
CONFIG_DIR=$HOME_DIR/.config
OMARCHY_DIR=$CONFIG_DIR/omarchy
DOTFILES_DIR=$HOME_DIR/dotfiles
SHARE_DIR=$HOME_DIR/.local/share
STATE_DIR=$HOME_DIR/.local/state

NVIM_CONFIG_DIR=$CONFIG_DIR/nvim
THEME_LINK=$NVIM_CONFIG_DIR/lua/stitch/lazy/theme.lua
CURRENT_THEME_DIR=$OMARCHY_DIR/current/theme

# ─────────────────────────────────────────────
#  Argument Parsing
# ─────────────────────────────────────────────
THEME="gruvbox"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--theme)
            if [[ -z "${2:-}" ]]; then
                log_error "Option $1 requires an argument"
                exit 1
            fi
            THEME="$2"
            shift 2
            ;;
        *)
            log_error "Unknown argument: $1"
            echo -e "Usage: $0 [-t|--theme <theme_name>]"
            exit 1
            ;;
    esac
done

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────

# Remove a path only if it exists and is NOT already a stow-managed symlink
safe_remove() {
    local target="$1"
    if [ -L "$target" ]; then
        log_skip "Already a symlink (stow-managed): $target"
    elif [ -e "$target" ]; then
        log_info "Removing: $target"
        rm -rf "$target"
        log_success "Removed: $target"
    else
        log_skip "Already absent: $target"
    fi
}

# ─────────────────────────────────────────────
#  Install stow
# ─────────────────────────────────────────────
install_stow() {
    if command -v stow &>/dev/null; then
        log_skip "stow already installed ($(stow --version 2>&1 | head -1))"
        return
    fi

    log_step "Installing stow..."

    case "$OS" in
        macos)
            if ! command -v brew &>/dev/null; then
                log_error "Homebrew not found. Install it first: https://brew.sh"
                exit 1
            fi
            brew install stow && log_success "stow installed via Homebrew" || { log_error "Failed to install stow"; exit 1; }
            ;;
        ubuntu|linux)
            sudo apt-get update -qq
            sudo apt-get install -y stow && log_success "stow installed via apt" || { log_error "Failed to install stow"; exit 1; }
            ;;
    esac
}

# ─────────────────────────────────────────────
#  Apply theme
#  - Cleans and recreates ~/.config/omarchy/current
#  - Copies all files from ~/.config/omarchy/themes/<theme>/
#  - Copies ghostty.conf from ~/.config/ghostty/themes/<theme>/ghostty.conf
#  - Points the neovim theme.lua symlink at current/neovim.lua
# ─────────────────────────────────────────────
apply_theme() {
    local omarchy_theme_src="$OMARCHY_DIR/themes/$THEME"
    local ghostty_conf_src="$CONFIG_DIR/ghostty/themes/$THEME/ghostty.conf"
    local link_dir
    link_dir=$(dirname "$THEME_LINK")

    log_step "Applying theme: $THEME"

    # ── Validate sources ──────────────────────
    local missing=0

    if [ ! -d "$omarchy_theme_src" ]; then
        log_warn "Omarchy theme directory not found: $omarchy_theme_src"
        missing=1
    fi

    if [ ! -f "$ghostty_conf_src" ]; then
        log_warn "Ghostty theme config not found: $ghostty_conf_src"
        missing=1
    fi

    if [ "$missing" -eq 1 ]; then
        log_warn "One or more theme sources are missing — skipping theme apply."
        log_warn "Ensure your dotfiles are stowed, then re-run this script."
        return
    fi

    # ── Clean and recreate ~/.config/omarchy/current ──
    log_info "Cleaning current theme directory: $CURRENT_THEME_DIR"
    rm -rf "$CURRENT_THEME_DIR"
    mkdir -p "$CURRENT_THEME_DIR"
    log_success "Cleaned: $CURRENT_THEME_DIR"

    # ── Copy omarchy theme files ──────────────
    log_info "Copying omarchy theme files from: $omarchy_theme_src"
    cp -r "$omarchy_theme_src"/. "$CURRENT_THEME_DIR/"
    log_success "Copied omarchy theme files → $CURRENT_THEME_DIR"

    # ── Copy ghostty.conf ─────────────────────
    log_info "Copying ghostty.conf from: $ghostty_conf_src"
    cp "$ghostty_conf_src" "$CURRENT_THEME_DIR/ghostty.conf"
    log_success "Copied ghostty.conf → $CURRENT_THEME_DIR/ghostty.conf"

    # ── Set neovim theme symlink ──────────────
    # local neovim_target="$CURRENT_THEME_DIR/neovim.lua"
    #
    # if [ ! -f "$neovim_target" ]; then
    #     log_warn "neovim.lua not found in current theme dir: $neovim_target"
    #     log_warn "The omarchy theme directory may be missing neovim.lua."
    #     return
    # fi

    # Ensure the parent directory for the symlink exists
    if [ ! -d "$link_dir" ]; then
        log_info "Creating directory: $link_dir"
        mkdir -p "$link_dir"
    fi

    # Remove any existing file/symlink at the theme link path
    if [ -L "$THEME_LINK" ]; then
        log_info "Removing existing theme symlink: $THEME_LINK"
        rm "$THEME_LINK"
    elif [ -f "$THEME_LINK" ]; then
        log_info "Removing existing theme file: $THEME_LINK"
        rm "$THEME_LINK"
    fi

    ln -s "$neovim_target" "$THEME_LINK" \
        && log_success "Neovim theme symlink: $THEME_LINK → $neovim_target" \
        || log_error "Failed to create neovim theme symlink"
}

# ─────────────────────────────────────────────
#  Script start
# ─────────────────────────────────────────────
log_header "Dotfiles Setup ($OS)"
log_info "Running as: $(whoami)"
log_info "Home:        $HOME_DIR"
log_info "Dotfiles:    $DOTFILES_DIR"
log_info "Theme:       $THEME"

# ─────────────────────────────────────────────
#  stow
# ─────────────────────────────────────────────
log_header "Core Tooling"
install_stow

# ─────────────────────────────────────────────
#  Dotfiles — clean slate for managed configs
# ─────────────────────────────────────────────
log_header "Dotfiles (stow)"

# Neovim — wipe runtime dirs only if config/nvim isn't already stow-managed
safe_remove "$NVIM_CONFIG_DIR"
if [ ! -L "$NVIM_CONFIG_DIR" ]; then
    log_info "Clearing nvim runtime dirs (fresh install)"
    safe_remove "$SHARE_DIR/nvim"
    safe_remove "$STATE_DIR/nvim"
else
    log_skip "nvim runtime dirs preserved (config already stow-managed)"
fi

# Ghostty
safe_remove "$CONFIG_DIR/ghostty"

# Tmux
safe_remove "$CONFIG_DIR/tmux"

# Stow dotfiles
if [ -d "$DOTFILES_DIR" ]; then
    log_step "Stowing dotfiles: $DOTFILES_DIR → $HOME_DIR"
    stow -d "$DOTFILES_DIR" -t "$HOME_DIR" --restow . \
        && log_success "Dotfiles stowed successfully" \
        || log_error "stow reported an error — check for conflicts"
else
    log_warn "Dotfiles directory not found at $DOTFILES_DIR — skipping stow"
fi

# ─────────────────────────────────────────────
#  Theme
# ─────────────────────────────────────────────
log_header "Theme"
apply_theme

# ─────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────
log_header "Setup Complete"
log_success "All steps finished. Re-run at any time — already-done steps will be skipped."
echo ""
