#!/bin/bash

# --- Configuration ---
# List of packages to install via pacman
PACKAGES="base-devel go git vim yazi firefox vlc gparted kitty filelight xdg-utils shared-mime-info perl-file-mimeinfo xdg-desktop-portal-hyprland xdg-desktop-portal-gtk jdk-openjdk nerd-fonts imv pavucontrol adwaita-icon-theme breeze-icons sddm qt6 qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick bcachefs-tools btrfs-progs dosfstools exfatprogs f2fs-tools gpart jfsutils mtools nilfs-utils ntfs-3g polkit udftools flatpak xfsprogs xorg-xhost"

DOTFILES_DIR="$HOME/SensibleDots"
YAY_URL="https://aur.archlinux.org/yay.git"
SDDM_REPO="https://github.com/uiriansan/SilentSDDM"

echo "Starting dotfiles installation script..."

# 1. Install packages from the defined list (pacman)
echo "--- 1. Installing packages from the defined list ---"
if [ -n "$PACKAGES" ]; then
    echo "Installing packages: ${PACKAGES}"
    # Install packages in one go
    sudo pacman -S --noconfirm ${PACKAGES}
else
    echo "--- Warning: PACKAGES variable is empty. Skipping package installation. ---"
fi

# 2. Install yay
echo "--- 2. Installing yay ---"
git clone "$YAY_URL"
cd yay
makepkg -si
cd ..

# 3. Add flathub repository
echo "--- 3. Adding flathub repository ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 4. Enable sddm service
echo "--- 4. Enabling sddm service ---"
sudo systemctl enable sddm.service

echo "--- 5. Cloning and installing SilentSDDM ---"
git clone "$SDDM_REPO"
cd SilentSDDM
./install.sh
cd ..

echo "--- 6. Installing Noctalia ---"
yay -S noctalia-shell

# 7. Copy dotfiles to home directory, overwriting existing files
echo "--- 7. Copying dotfiles from $DOTFILES_DIR to home directory ---"
# Copy .config folder and its contents
if [ -d "$DOTFILES_DIR/.config" ]; then
    echo "Copying ~/.config/"
    cp -r "$DOTFILES_DIR/.config" "$HOME"
else
    echo "Warning: ~/.config/ folder not found in $DOTFILES_DIR, skipping copy."
fi

# Copy specific files
echo "Copying .vimrc"
cp "$DOTFILES_DIR/.vimrc" "$HOME"

echo "Copying .bashrc"
cp "$DOTFILES_DIR/.bashrc" "$HOME"

echo "Dotfiles installation complete!"

echo "--------------------------------------------------"
