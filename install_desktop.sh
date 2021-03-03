sudo pacman -S --noconfirm --needed xorg-server xorg-xinput xorg-xinit xorg-xfd xorg-xrdb xorg-xsetroot mesa xf86-input-vmmouse xf86-video-vmware
sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
sudo pacman -S --noconfirm --needed i3status i3blocks
sudo pacman -S --noconfirm --needed rofi imwheel alsa-utils pulseaudio paprefs pavucontrol pulseaudio-alsa nitrogen chromium networkmanager network-manager-applet networkmanager-openvpn unzip python-pywal calc mpd volumeicon xfce4-power-manager polkit-gnome
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family noto-fonts gsfonts terminus-font nemo gnome-font-viewer ttf-fantasque-sans-mono

git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
cd ~

yay -S i3-gaps alacritty autotiling polybar pfetch i3exit nerd-fonts-complete networkmanager-dmenu-git siji-git ttf-material-design-icons-git numlockx ttf-icomoon-feather picom-ibhagwan-git

sudo systemctl enable lightdm
sudo systemctl enable mpd
sudo systemctl enable NetworkManager

#homectl update --shell=$(which zsh) henrique
