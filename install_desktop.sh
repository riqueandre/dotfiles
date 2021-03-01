sudo pacman -S --noconfirm --needed xorg-server xorg-xinput xorg-xinit xorg-xfd xorg-xrdb xorg-xsetroot mesa xf86-input-vmmouse xf86-video-vmware
sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
sudo pacman -S --noconfirm --needed i3status i3blocks
sudo pacman -S --noconfirm --needed rofi picom xnumlock imwheel alsa-utils pulseaudio paprefs pavucontrol pulseaudio-alsa nitrogen polybar pfetch chromium network-manager-applet networkmanager-openvpn unzip python-pywal calc
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family noto-fonts gsfonts

yay -S i3-gaps alacritty autotiling polybar pfetch i3exit nerd-fonts-complete networkmanager-dmenu-git

systemctl enable lightdm

#homectl update --shell=$(which zsh) henrique
