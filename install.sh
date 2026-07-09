#!/usr/bin/env bash

# ==============================================================================
# STEP-BASED EXTENSIBLE FRAMEWORK
# ==============================================================================

# --- STEP DEFINITIONS ---
# Define your custom steps as standard Bash functions here.

PACKAGES="base-devel pacman-contrib eza hyprland nodejs npm starship adwaita-fonts ttc-iosevka ttf-nerd-fonts-symbols-mono btop uwsm libreoffice-fresh mission-center go git github-cli vim neovim luarocks tree-sitter-cli yazi firefox vlc gparted kitty filelight xdg-utils shared-mime-info perl-file-mimeinfo xdg-desktop-portal-hyprland xdg-desktop-portal-gtk jdk-openjdk imv pavucontrol adwaita-icon-theme breeze-icons greetd greetd-tuigreet qt6 qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bcachefs-tools btrfs-progs dosfstools exfatprogs f2fs-tools gpart jfsutils mtools nilfs-utils ntfs-3g polkit hyprpolkitagent udftools flatpak xfsprogs xorg-xhost fastfetch zsh rustup"

DOTFILES_DIR="$HOME/SensibleDots"
YAY_URL="https://aur.archlinux.org/yay.git"
LINK_TARGET="/run/media/$USER/"
SYMLINK_PATH="$HOME/Drives/"

step_one() {
    echo "-> Running Step 1: Installing packages from the defined list..."
    sudo pacman -Sy --noconfirm --needed ${PACKAGES}
    rustup default stable
    sleep 1
    echo "-> Step 1 completed successfully."
}

step_two() {
    echo "-> Running Step 2: Installing yay..."
    # Add your actual logic here
    git clone "$YAY_URL"
    cd yay
    makepkg -si
    cd ..
    sleep 1
    echo "-> Step 2 completed successfully."
}

step_three() {
    echo "-> Running Step 3: Adding flathub repository..."
    # Add your actual logic here
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sleep 1
    echo "-> Step 3 completed successfully."
}

step_four() {
    echo "-> Running Step 4: Installing greetd config..."
    sudo cp "$DOTFILES_DIR/config.toml" /etc/greetd/config.toml
    sleep 1
    echo "-> Step 4 completed successfully."
}

step_five() {
    echo "-> Running Step 5: Enabling greetd service..."
    sudo systemctl enable greetd.service
    systemctl --user enable hyprpolkitagent.service
    sleep 1
    echo "-> Step 5 completed successfully."
}

step_six() {
    echo "-> Running Step 6: Installing AUR Packages..."
    yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git zsh-antidote zsh-patina-bin ripdrag
    sleep 1
    echo "-> Step 6 completed successfully."
}

step_seven() {
    echo "-> Running Step 7: Copying dotfiles from $DOTFILES_DIR to home directory and enabling music service..."
    cp -r "$DOTFILES_DIR/.config" "$HOME"
    sudo cp "$DOTFILES_DIR/yazi.desktop" /usr/share/applications/
    cp "$DOTFILES_DIR/.vimrc" "$HOME"
    cp "$DOTFILES_DIR/.bashrc" "$HOME"
    cp "$DOTFILES_DIR/.zshrc" "$HOME"
    cp "$DOTFILES_DIR/.zsh_plugins.txt" "$HOME"
    systemctl --user enable --now mpd
    mpc update
    sleep 1
    echo "-> Step 7 completed successfully."
}

step_eight() {
    echo "-> Running Step 8: setting zsh as default..."
    chsh -s $(which zsh)
    sleep 1
    echo "-> Step 8 completed successfully."
}

step_nine() {
    echo "-> Running step 9: Installing yazi plugins..."
    ya pkg add macydnah/office
    ya pkg add yazi-rs/plugins:mount
    ya pkg add imsi32/yatline
    sleep 1
    echo "-> Step 9 completed successfully."
}

step_ten() {
    echo "-> Running step 10: Creating folders and symlinks..."
    mkdir -p ~/Downloads ~/Documents ~/Drives ~/Pictures ~/Videos
    mkdir -p ~/Pictures/Wallpapers
    ln -s "$LINK_TARGET" "$SYMLINK_PATH"
    sleep 1
    echo "-> Step 10 completed successfully."
}

step_eleven() {
    echo "-> Running step 11: Setting xdg-mime defaults..."
    xdg-mime default yazi.desktop inode/directory
    xdg-mime default vlc.desktop video/x-matroska
    xdg-mime default imv.desktop image/jpeg
    sleep 1
    echo "-> Step 11 completed successfully"
}

# --- CORE ENGINE ---
# This function manages the prompts, validation loop, skips, and exits.

run_step() {
    local step_name="$1"
    local step_function="$2"

    while true; do
        # Prompt the user for input
        read -r -p "Do you want to run '$step_name'? (y/n/q): " user_choice

        case "$user_choice" in
            [Yy])
                echo -e "\n[EXECUTING] $step_name"
                echo "--------------------------------------------------"
                # Execute the passed function name
                $step_function
                echo "--------------------------------------------------"
                echo -e "Done.\n"
                break
                ;;
            [Nn])
                echo -e "[SKIPPED] $step_name.\n"
                break
                ;;
            [Qq])
                echo -e "\n[QUIT] Exiting script entirely. Goodbye!"
                exit 0
                ;;
            *)
                # Error handling / Type checking wrapper
                echo -e "Invalid input: '$user_choice'. Please type 'y' to continue, 'n' to skip, or 'q' to quit.\n"
                ;;
        esac
    done
}


# --- MAIN EXECUTIONFLOW ---
# This is where you orchestrate and sequence your script pipeline.

main() {
    echo "=================================================="
    echo " Starting Installation of SensibleDots"
    echo "=================================================="
    echo -e "Controls: [Y]es/Continue  |  [N]o/Skip  |  [Q]uit Script\n"

    # Register your steps here: run_step "Friendly Name" function_name
    run_step "Installing packages from defined list" step_one
    run_step "Installing yay" step_two
    run_step "Adding flathub repository" step_three
    run_step "Installing greetd config" step_four
    run_step "Enabling greetd service" step_five
    run_step "Installing AUR Packages" step_six
    run_step "Copying dotfiles from $DOTFILES_DIR to home directory" step_seven
    run_step "setting zsh as default" step_eight
    run_step "Installing yazi plugins" step_nine
    run_step "Creating folders and symlinks" step_ten
    run_step "Setting xdg-mime defaults" step_eleven

    echo "=================================================="
    echo " Installation of SensibleDots Completed"
    echo "=================================================="
}

# Fire off the main pipeline
main
