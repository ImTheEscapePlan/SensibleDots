#!/bin/bash

# --- Configuration ---
# List of packages to install via pacman
PACKAGES="base-devel pacman-contrib go git vim yazi firefox vlc gparted kitty filelight xdg-utils shared-mime-info perl-file-mimeinfo xdg-desktop-portal-hyprland xdg-desktop-portal-gtk jdk-openjdk imv pavucontrol adwaita-icon-theme breeze-icons sddm qt6 qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bcachefs-tools btrfs-progs dosfstools exfatprogs f2fs-tools gpart jfsutils mtools nilfs-utils ntfs-3g polkit hyprpolkitagent udftools flatpak xfsprogs xorg-xhost fastfetch"

DOTFILES_DIR="$HOME/SensibleDots"
YAY_URL="https://aur.archlinux.org/yay.git"
SDDM_REPO="https://github.com/uiriansan/SilentSDDM"

# Function to get user confirmation
prompt_for_user() {
    local step_desc=$1
    local choice
    while true; do
        echo ""
        echo "--------------------------------------------------"
        echo "STEP: $step_desc"
        echo "--------------------------------------------------"
        read -r -p "Enter choice (y=yes/continue, n=no/skip): " choice
        
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
        
        case "$choice" in
            y)
                echo "--> Continuing with step."
                echo ""
                return 0 # Return success/continue
                ;;
            n)
                echo "--> Skipping step."
                echo ""
                return 1 # Return skip/exit signal
                ;;
            *)
                echo "--> Invalid choice: '$choice'. Please enter 'y' or 'n'."
                prompt_for_user "$step_desc" # Loop back
                ;;
        esac
    done
}

echo "Starting dotfiles installation script..."

# Define the sequence of steps
STEPS=(
    "1. Installing packages from the defined list"
    "2. Installing yay"
    "3. Adding flathub repository"
    "4. Enabling sddm service"
    "5. Cloning and installing SilentSDDM"
    "6. Installing AUR Packages (Noctalia)"
    "7. Copying dotfiles from $DOTFILES_DIR to home directory"
    "8. Creating standard user folders and the drives symlink"
    "9. Setting xdg-mime defaults based on installed packages"
)

# Loop through all steps
for step in "${STEPS[@]}"; do
    echo ""
    echo "=================================================="
    echo "Processing Step: $step"
    echo "=================================================="
    
    if prompt_for_user "$step" == 0; then
        choice=$?
        
        case "$choice" in
            0) # 'y'
                echo "--> Executing step: $step"
                # Execute the command specific to this step
                case "$step" in
                    "1. Installing packages from the defined list")
                        echo "Installing packages: ${PACKAGES}"
                        sudo pacman -Sy --noconfirm --needed ${PACKAGES}
                        ;;
                    "2. Installing yay")
                        echo "Cloning yay repository..."
                        git clone "$YAY_URL"
                        cd yay
                        makepkg -si
                        cd ..
                        ;;
                    "3. Adding flathub repository")
                        echo "Adding flathub repository."
                        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
                        ;;
                    "4. Enabling sddm service")
                        echo "Enabling sddm service."
                        sudo systemctl enable sddm.service
                        ;;
                    "5. Cloning and installing SilentSDDM")
                        echo "Cloning SilentSDDM repository..."
                        git clone "$SDDM_REPO"
                        cd SilentSDDM
                        ./install.sh
                        cd ..
                        ;;
                    "6. Installing AUR Packages (Noctalia)")
                        echo "Installing AUR Packages"
                        echo "Installing packages via yay:"
                        echo "yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git"
                        yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git
                        ;;
                    "7. Copying dotfiles from $DOTFILES_DIR to home directory")
                        echo "Copying ~/.config/"
                        if [ -d "$DOTFILES_DIR/.config" ]; then
                            cp -r "$DOTFILES_DIR/.config" "$HOME"
                        else
                            echo "Warning: ~/.config/ folder not found in $DOTFILES_DIR, skipping copy."
                        fi
                        
                        echo "Copying yazi.desktop to /usr/share/applications/ (will prompt for sudo password if necessary)"
                        sudo cp "$DOTFILES_DIR/yazi.desktop" /usr/share/applications/
                        echo "Copying .vimrc"
                        cp "$DOTFILES_DIR/.vimrc" "$HOME"
                        
                        echo "Copying .bashrc"
                        cp "$DOTFILES_DIR/.bashrc" "$HOME"
                        ;;
                    "8. Creating standard user folders and the drives symlink")
                        echo "Creating standard user folders and the drives symlink..."
                        mkdir -p ~/Downloads ~/Documents ~/Drives ~/Pictures ~/Videos
                        mkdir -p ~/Pictures/Wallpapers
                        
                        LINK_TARGET="/run/media/$USER/"
                        SYMLINK_PATH="$HOME/Drives/"
                        
                        echo "Creating symlink: $SYMLINK_PATH -> $LINK_TARGET"
                        ln -s "$LINK_TARGET" "$SYMLINK_PATH"
                        echo "Successfully created symlink: $SYMLINK_PATH"
                        ;;
                    "9. Setting xdg-mime defaults based on installed packages")
                        echo "Setting xdg-mime defaults..."
                        xdg-mime default yazi.desktop inode/directory
                        xdg-mime default vlc.desktop video/x-matroska
                        xdg-mime default imv.desktop image/jpeg
                        echo "xdg-mime defaults set."
                        ;;
                    *)
                        echo "Unknown step in case statement for step: $step"
                        ;;
                esac
                ;;
            1) # 'n'
                echo "--> Skipping step: $step"
                ;;
            *)
                echo "--> Invalid choice received for step: $step. Skipping."
                ;;
        esac
    else
        # This branch handles unexpected failure in prompt_for_user itself
        echo "--> Step prompt failed unexpectedly for: $step. Stopping further steps."
        break
    fi
done
echo "--------------------------------------------------"
echo "Dotfiles installation finished."
