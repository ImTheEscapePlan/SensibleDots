#!/bin/bash

# --- Configuration ---
# List of packages to install via pacman
PACKAGES="base-devel go git vim yazi firefox vlc gparted kitty filelight xdg-utils shared-mime-info perl-file-mimeinfo xdg-desktop-portal-hyprland xdg-desktop-portal-gtk jdk-openjdk imv pavucontrol adwaita-icon-theme breeze-icons sddm qt6 qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bcachefs-tools btrfs-progs dosfstools exfatprogs f2fs-tools gpart jfsutils mtools nilfs-utils ntfs-3g polkit hyprpolkitagent udftools flatpak xfsprogs xorg-xhost fastfetch"

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
        read -r -p "Enter choice (y=yes/continue, n=no/skip, q=quit): " choice
        
        # Convert to lowercase for case-insensitive comparison
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

        case "$choice" in
            y)
                echo "--> Continuing with step."
                echo ""
                ;;
            n)
                echo "--> Skipping step."
                echo ""
                return 0 # Return success/skip
                ;;
            q)
                echo "--> Quitting script."
                echo ""
                return 1 # Return quit signal
                ;;
            *)
                echo "--> Invalid choice: '$choice'. Please enter 'y', 'n', or 'q'."
                prompt_for_user "$step_desc" # Loop back
                ;;
        esac
    done
}

echo "Starting dotfiles installation script..."

# 1. Install packages from the defined list (pacman)
prompt_for_user "1. Installing packages from the defined list"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Installing packages: ${PACKAGES}"
        # Install packages in one go
        sudo pacman -S --noconfirm --needed ${PACKAGES}
        ;;
    n)
        echo "Skipping package installation."
        ;;
    q)
        exit 0
        ;;
esac

# 2. Install yay
prompt_for_user "2. Installing yay"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Cloning yay repository..."
        git clone "$YAY_URL"
        cd yay
        makepkg -si
        cd ..
        ;;
    n)
        echo "Skipping yay installation."
        ;;
    q)
        exit 0
        ;;
esac

# 3. Add flathub repository
prompt_for_user "3. Adding flathub repository"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Adding flathub repository."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        ;;
    n)
        echo "Skipping flathub repository addition."
        ;;
    q)
        exit 0
        ;;
esac

# 4. Enable sddm service
prompt_for_user "4. Enabling sddm service"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Enabling sddm service."
        sudo systemctl enable sddm.service
        ;;
    n)
        echo "Skipping sddm service enablement."
        ;;
    q)
        exit 0
        ;;
esac

# 5. Cloning and installing SilentSDDM
prompt_for_user "5. Cloning and installing SilentSDDM"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Cloning SilentSDDM repository..."
        git clone "$SDDM_REPO"
        cd SilentSDDM
        ./install.sh
        cd ..
        ;;
    n)
        echo "Skipping SilentSDDM installation."
        ;;
    q)
        exit 0
        ;;
esac

# 6. Installing AUR Packages
prompt_for_user "6. Installing AUR packages"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Installing AUR Packages"
        echo "Installing packages via yay:"
        echo "yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git"
        yay -S noctalia-shell xdg-desktop-portal-termfilechooser-hunkyburrito-git
        ;;
    n)
        echo "Skipping Noctalia installation."
        ;;
    q)
        exit 0
        ;;
esac

# 7. Copying dotfiles to home directory, overwriting existing files
prompt_for_user "7. Copying dotfiles from $DOTFILES_DIR to home directory"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
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
    n)
        echo "Skipping dotfiles copy."
        ;;
    q)
        exit 0
        ;;
esac

# 8. Create standard user folders and a symlink
prompt_for_user "8. Creating standard user folders and the drives symlink"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
        echo "Creating standard user folders and the drives symlink..."
        
        # Create directories
        mkdir -p ~/Downloads ~/Documents ~/Drives ~/Pictures ~/Videos
        mkdir -p ~/Pictures/Wallpapers
        echo "Created folders: ~/Downloads, ~/Documents, ~/Drives, ~/Pictures, ~/Videos, and ~/Pictures/Wallpapers"
        
        # Create symlink
        LINK_TARGET="/run/media/ctrlescape/"
        SYMLINK_PATH="$HOME/Drives/ctrlescape"
       
        echo "Creating symlink: $SYMLINK_PATH -> $LINK_TARGET"
        ln -s "$LINK_TARGET" "$SYMLINK_PATH"
        echo "Successfully created symlink: $SYMLINK_PATH"
        ;;
    n)
        echo "Skipping standard folder creation and symlink."
        ;;
    q)
        echo "Quitting script."
        exit 0
        ;;
    *)
        echo "Invalid choice: '$choice'. Please enter 'y', 'n', or 'q'."
        prompt_for_user "8. Creating standard user folders and the drives symlink" # Loop back
        ;;
esac


# 9. Setting xdg-mime defaults based on installed packages
prompt_for_user "9. Setting xdg-mime defaults based on installed packages"
choice=$(read -r -p "Enter choice (y/n/q): " | tr '[:upper:]' '[:lower:]')

case "$choice" in
    y)
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
    n)
        echo "Skipping xdg-mime default setting."
        ;;
    q)
        echo "Quitting script."
        exit 0
        ;;
    *)
        echo "Invalid choice: '$choice'. Please enter 'y', 'n', or 'q'."
        prompt_for_user "9. Setting xdg-mime defaults based on installed packages" # Loop back
        ;;
esac
echo "--------------------------------------------------"
echo "Dotfiles installation finished."
