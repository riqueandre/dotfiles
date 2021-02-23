pacman -S --noconfirm --needed xorg-server xf86-input-vmmouse xf86-video-vmware mesa xorg-xinput xorg-xinit
pacman -S --noconfirm --needed i3-gaps i3status i3blocks
pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter

systemctl enable lightdm
