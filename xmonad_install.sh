pacman -S xorg-server xf86-input-vmmouse xf86-video-vmware mesa

pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay --noconfirm --needed -Syu
yay --noconfirm --needed -S ly

pacman -S --noconfirm --needed xmonad xmonad-contrib xmobar
