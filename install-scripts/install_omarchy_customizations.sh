#!/usr/bin/env bash
set -euo pipefail

################################
# Dry-run mode: bash setup.sh --dry-run
################################
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

################################
# Colors
################################
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

################################
# Logging
################################
log()          { echo -e "${BLUE}[INFO]${NC}  $1"; }
warn()         { echo -e "${YELLOW}[WARN]${NC}  $1"; WARNINGS=$((WARNINGS + 1)); }
success()      { echo -e "${GREEN}[OK]${NC}    $1"; }
error()        { echo -e "${RED}[ERROR]${NC} $1" >&2; }
notice()       { echo -e "${CYAN}[ACTION]${NC} $1"; NOTICES+=("$1"); }
error_exit()   { error "$1"; exit 1; }
step()         { echo -e "\n${BOLD}==> $1${NC}"; }
dry()          { echo -e "${CYAN}[DRY-RUN]${NC} Would run: $*"; }

# Run or dry-run a command
run(){
  if $DRY_RUN; then
    dry "$@"
  else
    "$@"
  fi
}

################################
# Trap: report failure location
################################
WARNINGS=0
NOTICES=()

on_error(){
  local exit_code=$?
  local line=$1
  error "Script failed at line $line (exit code $exit_code)"
  print_summary
  exit "$exit_code"
}
trap 'on_error $LINENO' ERR

################################
# Summary printed at end (or on failure)
################################
print_summary(){
  echo ""
  echo -e "${BOLD}--- Setup Summary ---${NC}"
  if [[ ${#NOTICES[@]} -gt 0 ]]; then
    echo -e "${CYAN}Manual actions required:${NC}"
    for n in "${NOTICES[@]}"; do
      echo -e "  ${CYAN}*${NC} $n"
    done
  fi
  if [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}Completed with $WARNINGS warning(s).${NC}"
  else
    echo -e "${GREEN}Completed successfully with no warnings.${NC}"
  fi
}

################################
# Paths
################################
CONFIG_DIR="$HOME/.config"
OMARCHY_DIR="$CONFIG_DIR/omarchy"
DOTFILES_DIR="$HOME/dotfiles"
SHARE_DIR="$HOME/.local/share"
STATE_DIR="$HOME/.local/state"

################################
# Helpers
################################
safe_remove(){
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    log "Removing: $target"
    run rm -rf "$target"
  fi
}

package_installed(){
  pacman -Qi "$1" &>/dev/null
}

install_packages(){
  for pkg in "$@"; do
    if package_installed "$pkg"; then
      log "$pkg already installed — skipping"
    else
      log "Installing $pkg"
      run omarchy-pkg-add "$pkg" || {
        warn "Failed to install $pkg — will retry once"
        run omarchy-pkg-add "$pkg" || error_exit "Could not install $pkg after retry"
      }
    fi
  done
}

remove_packages(){
  for pkg in "$@"; do
    if package_installed "$pkg"; then
      log "Removing $pkg"
      run omarchy-pkg-drop "$pkg" || warn "Failed to remove $pkg — may need manual removal"
    else
      log "$pkg not installed — skipping removal"
    fi
  done
}

remove_webapps(){
  for app in "$@"; do
    log "Removing webapp: $app"
    # Expected to be a no-op if not installed; failures are non-fatal
    run omarchy-webapp-remove "$app" 2>/dev/null && true
  done
}

docker_container_exists(){
  docker inspect "$1" &>/dev/null
}

dev_env_installed(){
  # Use mise ls --installed to avoid fragile grep on formatted output
  mise ls --installed 2>/dev/null | awk '{print $1}' | grep -qx "$1"
}

theme_installed(){
  [[ -d "$OMARCHY_DIR/themes/$1" ]]
}

################################
# Notices: things requiring manual attention
# Printed upfront AND in the summary
################################
step "Pre-flight notices"
notice "Verify GPU driver: vulkan-radeon + lib32-vulkan-radeon (radeon) OR nvidia + lib32-nvidia-utils (NVIDIA)"

################################
# Directories
################################
step "Ensuring base directories exist"
run mkdir -p "$CONFIG_DIR"
run mkdir -p "$HOME/.local/share"
run mkdir -p "$HOME/.local/state"
success "Directories ready"

################################
# Packages
################################
step "Installing packages"
install_packages \
  stow \
  discord \
  minecraft-launcher \
  yt-dlp \
  caligula

################################
# Theme
################################
step "Theme"
if theme_installed nes; then
  log "NES theme already installed — skipping"
else
  log "Installing NES theme"
  run omarchy-theme-install https://github.com/bjarneo/omarchy-nes-theme
fi

# Set theme unconditionally so re-runs correct any drift
log "Setting theme to ristretto"
run omarchy-theme-set ristretto
success "Theme set"

################################
# Steam
################################
step "Steam"
if package_installed steam; then
  log "Steam already installed — skipping"
else
  log "Installing Steam"
  run omarchy-install-steam
fi

################################
# Dev environments
################################
step "Dev environments"
dev_envs=(bun npm go python)
for env in "${dev_envs[@]}"; do
  if dev_env_installed "$env"; then
    log "$env already installed — skipping"
  else
    log "Installing dev env: $env"
    run omarchy-install-dev-env "$env" || {
      warn "Failed to install dev env: $env — will retry"
      run omarchy-install-dev-env "$env" || warn "Could not install $env — skipping"
    }
  fi
done

################################
# Docker DBs
################################
step "Docker databases"
if docker_container_exists postgres18; then
  log "Postgres container already exists — skipping"
else
  log "Installing PostgreSQL docker db"
  run omarchy-install-docker-dbs PostgreSQL
fi

################################
# Remove webapps
################################
step "Removing webapps"
remove_webapps \
  Basecamp \
  Discord \
  "Google Contacts" \
  "Google Messages" \
  "Google Photos" \
  HEY \
  WhatsApp \
  X \
  Zoom

################################
# Remove packages
################################
step "Removing unwanted packages"
remove_packages \
  signal-desktop \
  1password-beta \
  1password-cli

################################
# Cleanup configs
################################
step "Cleaning configs"

# nvim: if it's a stow symlink just remove the link;
# if it's a real dir (e.g. from a previous manual install), nuke data dirs too
if [[ -L "$CONFIG_DIR/nvim" ]]; then
  log "Removing nvim symlink (stow-managed)"
  run rm "$CONFIG_DIR/nvim"
elif [[ -e "$CONFIG_DIR/nvim" ]]; then
  log "Removing nvim config + data dirs (non-symlink install)"
  safe_remove "$CONFIG_DIR/nvim"
  safe_remove "$SHARE_DIR/nvim"
  safe_remove "$STATE_DIR/nvim"
else
  log "nvim config not present — nothing to clean"
fi

safe_remove "$CONFIG_DIR/ghostty"
safe_remove "$OMARCHY_DIR/branding/screensaver.txt"

################################
# Dotfiles
################################
step "Applying dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
  error_exit "Dotfiles directory not found: $DOTFILES_DIR"
fi

# Auto-resolve stow conflicts:
#
# Two conflict types we handle:
#   1. "cannot stow X over existing target" — a real file is in the way;
#      the dotfiles version should win, so we back up and remove it.
#   2. "source is an absolute symlink" — stow warns but this is harmless;
#      we suppress it and let stow proceed normally.
#
# Any other unexpected conflict lines are flagged as fatal.
resolve_stow_conflicts(){
  local stow_output
  # Capture stderr (where stow writes warnings) and stdout together
  stow_output=$(stow --no-folding -n -R -d "$DOTFILES_DIR" -t "$HOME" . 2>&1 || true)

  local has_fatal=false

  while IFS= read -r line; do
    # Type 1: file conflict — extract the target path and remove it
    if [[ "$line" =~ "cannot stow" && "$line" =~ "over existing target" ]]; then
      # Pull the target path from the conflict message, e.g.:
      # "  * cannot stow dotfiles/.config/foo over existing target .config/foo ..."
      local target
      target=$(echo "$line" | grep -oP 'over existing target \K\S+')
      local full_target="$HOME/$target"
      if [[ -n "$target" && ( -e "$full_target" || -L "$full_target" ) ]]; then
        local backup="${full_target}.bak.$(date +%s)"
        warn "Conflict: backing up $full_target → $backup"
        run mv "$full_target" "$backup"
      else
        warn "Could not parse conflict target from: $line"
        has_fatal=true
      fi

    # Type 2: absolute symlink warning — safe to ignore, stow handles it fine
    elif [[ "$line" =~ "source is an absolute symlink" ]]; then
      log "Ignoring absolute symlink warning (harmless): $line"

    # Any other WARNING/conflict line is unexpected — flag it
    elif [[ "$line" =~ "WARNING" || "$line" =~ "conflict" || "$line" =~ "cannot" ]]; then
      warn "Unexpected stow output: $line"
      has_fatal=true
    fi
  done <<< "$stow_output"

  if $has_fatal; then
    error_exit "Unresolvable stow conflicts detected — review warnings above"
  fi
}

log "Checking for stow conflicts and auto-resolving..."
if $DRY_RUN; then
  dry "stow --no-folding -n -R -d $DOTFILES_DIR -t $HOME ."
  dry "Auto-conflict resolution would run here"
else
  resolve_stow_conflicts
fi

log "Applying stow..."
run stow --no-folding -R -d "$DOTFILES_DIR" -t "$HOME" .
success "Dotfiles applied"

################################
# Done
################################
step "Complete"
print_summary
