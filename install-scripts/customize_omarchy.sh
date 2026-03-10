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
WHITE="\033[0;37m"

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
#  Directories
# ─────────────────────────────────────────────
HOME_DIR=~
CONFIG_DIR=$HOME_DIR/.config
OMARCHY_DIR=$CONFIG_DIR/omarchy
DOTFILES_DIR=$HOME_DIR/dotfiles
SHARE_DIR=$HOME_DIR/.local/share
STATE_DIR=$HOME_DIR/.local/state
GITHUB_URL=https://github.com/maxwell7774
WORKSPACE_DIR=$HOME_DIR/workspace
GITHUB_DIR=$WORKSPACE_DIR/github.com/maxwell7774

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

# Install a package only if it isn't already installed
pkg_add_once() {
    local pkg="$1"
    if pacman -Q "$pkg" &>/dev/null; then
        log_skip "Package already installed: $pkg"
    else
        log_step "Installing package: $pkg"
        omarchy-pkg-add "$pkg" && log_success "Installed $pkg" || log_error "Failed to install $pkg"
    fi
}

# Install a dev env only if the binary isn't already on PATH
dev_env_once() {
    local env="$1"
    local binary="${2:-$1}"   # second arg overrides binary name to check
    if command -v "$binary" &>/dev/null; then
        log_skip "Dev env already present: $env ($binary found in PATH)"
    else
        log_step "Installing dev env: $env"
        omarchy-install-dev-env "$env" && log_success "Installed dev env: $env" || log_error "Failed to install dev env: $env"
    fi
}

# Remove a directory/file only if it exists AND is not already a stow-managed symlink
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

# Install a terminal only if the binary isn't already on PATH
terminal_install_once() {
    local terminal="$1"
    local binary="${2:-$1}"
    if command -v "$binary" &>/dev/null; then
        log_skip "Terminal already installed: $terminal ($binary found in PATH)"
    else
        log_step "Installing terminal: $terminal"
        omarchy-install-terminal "$terminal" && log_success "Installed terminal: $terminal" || log_error "Failed to install terminal: $terminal"
    fi
}

# Install a Docker DB only if no container with a matching name exists
docker_db_once() {
    local db="$1"
    # Strip version numbers and lowercase for a fuzzy match (e.g. PostgreSQL → postgres, postgres18)
    local db_key
    db_key=$(echo "$db" | tr '[:upper:]' '[:lower:]' | sed 's/sql//')  # postgresql→postgre, mysql→my
    if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -qi "${db_key}"; then
        log_skip "Docker DB already exists: $db (container found)"
    else
        log_step "Installing Docker DB: $db"
        omarchy-install-docker-dbs "$db" && log_success "$db container ready" || log_error "$db install failed"
    fi
}

# ─────────────────────────────────────────────
#  Script start
# ─────────────────────────────────────────────
log_header "Omarchy System Setup"
log_info "Running as: $(whoami)"
log_info "Home: $HOME_DIR"
log_info "Dotfiles: $DOTFILES_DIR"

# ─────────────────────────────────────────────
#  Core tooling
# ─────────────────────────────────────────────
log_header "Core Tooling"

pkg_add_once stow

# ─────────────────────────────────────────────
#  Theme
# ─────────────────────────────────────────────
log_header "Theme"

log_step "Setting theme to $THEME"
omarchy-theme-set "$THEME" && log_success "Theme set to $THEME" || log_warn "Theme set may have failed (non-fatal)"

# ─────────────────────────────────────────────
#  GPU / Vulkan note
# ─────────────────────────────────────────────
log_header "GPU / Vulkan"
log_info "For RX 9070 XT: ensure vulkan-radeon and lib32-vulkan-radeon are installed"

# ─────────────────────────────────────────────
#  Steam
# ─────────────────────────────────────────────
log_header "Gaming"

if command -v steam &>/dev/null; then
    log_skip "Steam already installed"
else
    log_step "Installing Steam"
    omarchy-install-steam && log_success "Steam installed" || log_error "Steam install failed"
fi

# ─────────────────────────────────────────────
#  Terminal
# ─────────────────────────────────────────────
log_header "Terminal"

terminal_install_once ghostty

# ─────────────────────────────────────────────
#  Package & Webapp Configuration
#  Edit these arrays to add/remove items.
# ─────────────────────────────────────────────

# Packages to install via omarchy-pkg-add
PACKAGES=(
    discord
    minecraft-launcher
    yt-dlp
    caligula
    # zen-browser   # AUR — use omarchy-pkg-aur-add instead if enabling
)

# Dev environments: "env_name:binary_to_check"
# The binary after ':' is used to detect if it's already installed.
DEV_ENVS=(
    "bun:bun"
    "npm:node"      # npm ships with node; check for `node`
    "go:go"
    "python:python3"
)

# Docker DBs to install via omarchy-install-docker-dbs
DOCKER_DBS=(
    PostgreSQL
    # MySQL
    # Redis
    # MongoDB
)

# Web apps to remove via omarchy-webapp-remove
WEBAPPS_REMOVE=(
    # Basecamp
    # Discord
    # "Google Contacts"
    # "Google Messages"
    # "Google Photos"
    # HEY
    # WhatsApp
    # X
    # Zoom
)

# ─────────────────────────────────────────────
#  Applications
# ─────────────────────────────────────────────
log_header "Applications"

for pkg in "${PACKAGES[@]}"; do
    pkg_add_once "$pkg"
done

# ─────────────────────────────────────────────
#  Dev environments
# ─────────────────────────────────────────────
log_header "Dev Environments"

for entry in "${DEV_ENVS[@]}"; do
    env_name="${entry%%:*}"
    binary="${entry##*:}"
    dev_env_once "$env_name" "$binary"
done

# ─────────────────────────────────────────────
#  Databases
# ─────────────────────────────────────────────
log_header "Databases"

for db in "${DOCKER_DBS[@]}"; do
    docker_db_once "$db"
done

# ─────────────────────────────────────────────
#  Web Apps
# ─────────────────────────────────────────────
log_header "Web Apps"

if [ ${#WEBAPPS_REMOVE[@]} -eq 0 ]; then
    log_skip "No web apps configured for removal"
else
    for app in "${WEBAPPS_REMOVE[@]}"; do
        log_step "Removing web app: $app"
        omarchy-webapp-remove "$app" && log_success "Removed: $app" || log_error "Failed to remove: $app"
    done
fi

# ─────────────────────────────────────────────
#  Dotfiles — clean slate for managed configs
# ─────────────────────────────────────────────
log_header "Dotfiles (stow)"

# Neovim — only wipe runtime dirs if config/nvim isn't already stow-managed
safe_remove "$CONFIG_DIR/nvim"
if [ ! -L "$CONFIG_DIR/nvim" ]; then
    log_info "Clearing nvim runtime dirs (fresh config install)"
    safe_remove "$SHARE_DIR/nvim"
    safe_remove "$STATE_DIR/nvim"
else
    log_skip "nvim runtime dirs preserved (config already stow-managed)"
fi

# Ghostty
safe_remove "$CONFIG_DIR/ghostty"

# Omarchy screensaver branding
safe_remove "$OMARCHY_DIR/branding/screensaver.txt"

# Tmux
safe_remove "$CONFIG_DIR/tmux"

# Stow dotfiles (idempotent — stow won't re-link if already linked)
if [ -d "$DOTFILES_DIR" ]; then
    log_step "Stowing dotfiles from $DOTFILES_DIR → $HOME_DIR"
    stow -d "$DOTFILES_DIR" -t "$HOME_DIR" --ignore='~/dotfiles/.config/omarchy/^themes/[^/]+/ghostty\.conf$' --restow . \
        && log_success "Dotfiles stowed successfully" \
        || log_error "stow reported an error — check for conflicts"
else
    log_warn "Dotfiles directory not found at $DOTFILES_DIR — skipping stow"
fi

# ─────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────
log_header "Setup Complete"
log_success "All steps finished. Re-run at any time — already-done steps will be skipped."
echo ""
