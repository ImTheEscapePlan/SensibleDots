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
        
        # Convert to lowercase for case-insensitive comparison
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

# 1. Install packages from the defined list (pacman)
if prompt_for_user "1. Installing packages from the defined list"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Installing packages: ${PACKAGES}"
        # Install packages in one go
        sudo pacman -Sy --noconfirm --needed ${PACKAGES}
        ;;
    1) # 'n'
        echo "Skipping package installation."
        ;;
    *) # Should only happen if prompt_for_user returns non-standard, but kept for safety
        echo "Package step cancelled or invalid choice."
        ;;
esac

# 2. Install yay
if prompt_for_user "2. Installing yay"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Cloning yay repository..."
        git clone "$YAY_URL"
        cd yay
        makepkg -si
        cd ..
        ;;
    1) # 'n'
        echo "Skipping yay installation."
        ;;
    *)
        echo "Yay step cancelled or invalid choice."
        ;;
esac

# 3. Add flathub repository
if prompt_for_user "3. Adding flathub repository"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Adding flathub repository."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        ;;
    1) # 'n'
        echo "Skipping flathub repository addition."
        ;;
    *)
        echo "Flathub step cancelled or invalid choice."
        ;;
esac

# 4. Enable sddm service
if prompt_for_user "4. Enabling sddm service"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Enabling sddm service."
        sudo systemctl enable sddm.service
        ;;
    1) # 'n'
        echo "Skipping sddm service enablement."
        ;;
    *)
        echo "SDDM step cancelled or invalid choice."
        ;;
esac

# 5. Cloning and installing SilentSDDM
if prompt_for_user "5. Cloning and installing SilentSDDM"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Cloning SilentSDDM repository..."
        git clone "$SDDM_REPO"
        cd SilentSDDM
        ./install.sh
        cd ..
        ;;
    1) # 'n'
        echo "Skipping SilentSDDM installation."
        ;;
    *)
        echo "SilentSDDM step cancelled or invalid choice."
        ;;
esac

# 6. Installing AUR Packages
if prompt_for_user "6. Installing AUR packages"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Installing AUR Packages"
        echo "Installing packages via yay:"
        echo "yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git"
        yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git
        ;;
    1) # 'n'
        echo "Skipping Noctalia installation."
        ;;
    *)
        echo "AUR Packages step cancelled or invalid choice."
        ;;
esac

# 7. Copying dotfiles to home directory, overwriting existing files
if prompt_for_user "7. Copying dotfiles from $DOTFILES_DIR to home directory"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
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
    1) # 'n'
        echo "Skipping dotfiles copy."
        ;;
    *)
        echo "Dotfiles copy step cancelled or invalid choice."
        ;;
esac

# 8. Create standard user folders and a symlink
if prompt_for_user "8. Creating standard user folders and the drives symlink"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Creating standard user folders and the drives symlink..."
        
        # Create directories
        mkdir -p ~/Downloads ~/Documents ~/Drives ~/Pictures ~/Videos
        mkdir -p ~/Pictures/Wallpapers
        echo "Created folders: ~/Downloads, ~/Documents, ~/Drives, ~/Pictures, ~/Videos, and ~/Pictures/Wallpapers"
        
        # Create symlink
        LINK_TARGET="/run/media/$USER/"
        SYMLINK_PATH="$HOME/Drives/"
        
        echo "Creating symlink: $SYMLINK_PATH -> $LINK_TARGET"
        ln -s "$LINK_TARGET" "$SYMLINK_PATH"
        echo "Successfully created symlink: $SYMLINK_PATH"
        ;;
    1) # 'n'
        echo "Skipping standard folder creation and symlink."
        ;;
    *)
        echo "Folder/Symlink step cancelled or invalid choice."
        ;;
esac

# 9. Setting xdg-mime defaults based on installed packages
if prompt_for_user "9. Setting xdg-mime defaults based on installed packages"; then
    choice=$?
fi

case "$choice" in
    0) # 'y'
        echo "Setting xdg-mime defaults..."
        
        # Set specific defaults mentioned by the user
        xdg-mime default yazi.desktop inode/directory
        xdg-mime default vlc.desktop video/x-matroska
        xdg-mime default imv.desktop image/jpeg
        
        # General principle: Set defaults for .desktop files if they exist
        # This part could be extended based on other installed .desktop files, 
        # but here we focus on the explicit request.
        
        echo "xdg-mime defaults set."
        ;;
    1) # 'n'
        echo "Skipping xdg-mime default setting."
        ;;
    *)
        echo "MIME defaults step cancelled or invalid choice."
        ;;
esac

echo "--------------------------------------------------"
echo "Dotfiles installation finished."
