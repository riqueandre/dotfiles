#!/bin/bash

mkdir -p .config
mkdir -p .local/share

if [[ -d $HOME/yay-git ]]
then
    echo "skipping yay installation"
else
    git clone https://aur.archlinux.org/yay-git.git
    cd yay-git
    makepkg -si
    cd ~
fi


if [[ -d $HOME/dotfiles ]]
then
    echo "skipping clone dotfiles"
else
    git clone https://github.com/riqueandre/dotfiles
fi


pacman_pkgs=(xorg-server \
    xorg-xinput xorg-xinit \
    xorg-xfd \
    xorg-xrdb \
    xdg-user-dirs \
    xss-lock \
    xorg-xsetroot \
    hsetroot \
    mesa \
    xf86-input-vmmouse \
    xf86-video-vmware \
    lightdm lightdm-gtk-greeter \
    bspwm \
    sxhkd \
    papirus-icon-theme \
    numlockx \
    rofi \
    imwheel \
    alsa-utils \
    pulseaudio \
    paprefs \
    pavucontrol \
    pulseaudio-alsa \
    python-pip \
    feh \
    bat \
    network-manager-applet \
    unzip \
    python-pywal \
    calc \
    mpd \
    dunst \
    volumeicon \
    xfce4-power-manager \
    polkit-gnome \
    neovim  \
    ttf-ubuntu-font-family \
    noto-fonts \
    gsfonts \
    terminus-font \
    nemo \
    exo \
    gnome-font-viewer \
    ncmpcpp \
    python-pip \
    ttf-fantasque-sans-mono)
for pkg in "${pacman_pkgs[@]}"
do
    sudo pacman -S --noconfirm --needed $pkg
done


yay_pkgs=(alacritty \
    autotiling \
    google-chrome \
    polybar \
    pfetch \
    rofi-dmenu \
    ttf-sarasa-gothic \
    nerd-fonts-complete \
    networkmanager-dmenu-git \
    siji-git \
    picom-ibhagwan-git \
    tty-clock \
    cava)
for pkg in "${yay_pkgs[@]}"
do
    yay --answerclean None --answerdiff None -S --noconfirm --needed $pkg
done


if [[ -d $HOME/.oh-my-zsh ]]
then
    echo "skipping oh-my-zsh installation"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]
then
    echo "skipping p10k installation"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

cp -r ~/dotfiles/.imwheelrc                         ~/
cp -r ~/dotfiles/.p10k.zsh                          ~/
cp -r ~/dotfiles/.zshrc                             ~/
cp -r ~/dotfiles/.zshenv                            ~/
cp -r ~/dotfiles/.config                            ~/
cp -r ~/dotfiles/.local/                            ~/
cp -r ~/dotfiles/themes/bspwm-b4skyx/.Xresources    ~/
cp -r ~/dotfiles/themes/bspwm-b4skyx/polybar        ~/.config/
cp -r ~/dotfiles/themes/bspwm-b4skyx/picom          ~/.config/
cp -r ~/dotfiles/themes/bspwm-b4skyx/dunst          ~/.config/
cp -r ~/dotfiles/themes/bspwm-b4skyx/rofi           ~/.config/


sudo systemctl enable lightdm
sudo systemctl enable mpd


pip install dbus-python


xdg-user-dir-update


chsh -s $(which zsh)
