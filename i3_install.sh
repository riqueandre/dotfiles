sudo pacman -S --noconfirm --needed xorg-server xorg-xinput xorg-xinit xorg-xfd xorg-xrdb mesa xf86-input-vmmouse xf86-video-vmware
sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
sudo pacman -S --noconfirm --needed i3status i3blocks
sudo pacman -S --noconfirm --needed rofi picom xnumlock imwheel alsa-utils pulseaudio paprefs pavucontrol pulseaudio-alsa nitrogen polybar pfetch chromium
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family noto-fonts gsfonts

yay -S i3-gaps alacritty autotiling polybar pfetch i3exit nerd-fonts-complete

systemctl enable lightdm


