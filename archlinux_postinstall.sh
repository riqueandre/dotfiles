#!/bin/bash

mkdir -p .config
mkdir -p .local/share

if [[ -d $HOME/yay-git ]]
then
	echo "skip yay install"
else
	git clone https://aur.archlinux.org/yay-git.git
	cd yay-git
	makepkg -si
	cd ~
fi


if [[ -d $HOME/dotfiles ]]
then
	echo "skip clone dotfiles"
else
	git clone https://github.com/riqueandre/dotfiles
fi


pacman_pkgs=(xorg-server \
	xorg-xinput xorg-xinit \
	xorg-xfd \
	xorg-xrdb \
	xorg-xsetroot \
	hsetroot \
	mesa \
	xf86-input-vmmouse \
	xf86-video-vmware \
	lightdm lightdm-gtk-greeter \
	i3status \
	i3blocks \
	rofi \
	imwheel \
	alsa-utils \
	pulseaudio \
	paprefs \
	pavucontrol \
	pulseaudio-alsa \
	nitrogen \
	chromium  \
	networkmanager \
	network-manager-applet \
	networkmanager-openvpn \
	unzip \
	python-pywal \
	calc \
	mpd \
	volumeicon \
	xfce4-power-manager \
	polkit-gnome \
	neovim  \
	ttf-ubuntu-font-family \
	noto-fonts \
	gsfonts \
	terminus-font \
	nemo \
	gnome-font-viewer \
	ttf-fantasque-sans-mono)
for pkg in "${pacman_pkgs[@]}"
do
	sudo pacman -S --noconfirm --needed $pkg
done


yay_pkgs=(i3-gaps \
	alacritty \
	autotiling \
	polybar \
	pfetch \
	i3exit \
	nerd-fonts-complete \
	networkmanager-dmenu-git \
	siji-git \
	picom-ibhagwan-git \
	i3-scrot)

for pkg in "${yay_pkgs[@]}"
do
	yay -S $pkg
done


sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

cp -r ~/dotfiles/.imwheelrc   ~/
cp -r ~/dotfiles/.p10k.zsh    ~/
cp -r ~/dotfiles/.zshrc       ~/
cp -r ~/dotfiles/.Xresources  ~/
cp -r ~/dotfiles/.config      ~/
cp -r ~/dotfiles/fonts        .local/share/fonts/

sudo systemctl enable lightdm
sudo systemctl enable mpd
sudo systemctl enable NetworkManager

chsh -s $(which zsh)
