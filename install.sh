#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Variables ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACMAN_PACKAGES_FILE="$DOTFILES_DIR/packages/pacman-packages.txt"
AUR_PACKAGES_FILE="$DOTFILES_DIR/packages/aur-packages.txt"

# --- Helper Functions ---
info() {
    echo "INFO: $1"
}

error() {
    echo "ERROR: $1" >&2
    exit 1
}

# --- Main Functions ---

check_dependencies() {
    info "Checking for required dependencies..."
    if ! command -v stow &> /dev/null; then
        error "'stow' is not installed. Please install it before running this script."
    fi

    if ! command -v yay &> /dev/null; then
        error "'yay' is not installed. Please install an AUR helper (like yay) before running this script."
    fi
    info "All dependencies are satisfied."
}

install_packages() {
    info "Starting package installation..."

    # Install official repository packages
    if [ -f "$PACMAN_PACKAGES_FILE" ]; then
        info "Installing packages from pacman-packages.txt..."
        sudo pacman -S --noconfirm --needed - < "$PACMAN_PACKAGES_FILE"
    else
        info "pacman-packages.txt not found, skipping."
    fi

    # Install AUR packages
    if [ -f "$AUR_PACKAGES_FILE" ]; then
        info "Installing packages from aur-packages.txt..."
        yay -S --noconfirm --needed - < "$AUR_PACKAGES_FILE"
    else
        info "aur-packages.txt not found, skipping."
    fi

    info "Package installation complete."
}

stow_dotfiles() {
    info "Stowing configuration files..."
    cd "$DOTFILES_DIR"
    
    # Stow all directories in the root of the dotfiles repo, excluding .git and packages
    for dir in */; do
        # Trim trailing slash
        dir=${dir%/}
        if [ "$dir" != ".git" ] && [ "$dir" != "packages" ] && [ "$dir" != "sddm-themes" ]; then
            info "Stowing $dir..."
            stow -R "$dir"
        fi
    done

    info "Dotfiles have been stowed."
}

copy_sddm_themes() {
    info "Copying SDDM themes..."
    if [ -d "$DOTFILES_DIR/sddm-themes" ]; then
        info "SDDM themes directory found. Copying to /usr/share/sddm/themes/"
        sudo cp -r "$DOTFILES_DIR/sddm-themes"/* /usr/share/sddm/themes/
    else
        info "sddm-themes directory not found, skipping."
    fi
    info "SDDM themes copied."
}


# --- Main Execution ---
main() {
    check_dependencies
    install_packages
    stow_dotfiles
    copy_sddm_themes
    info "Installation complete! Please reboot or log out for all changes to take effect."
}

main
