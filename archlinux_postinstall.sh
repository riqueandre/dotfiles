#!/bin/bash

mkdir -p .config
mkdir -p .local/share

if [[ -d $HOME/pamac-aur ]]
then
    echo "skipping pamac installation"
else
    git clone https://aur.archlinux.org/pamac-aur.git
    cd pamac-aur
    makepkg -si
    sudo sed -i '/EnableAUR/s/^#//g' /etc/pamac.conf
    cd ~
fi

if [[ -d $HOME/dotfiles ]]
then
    echo "skipping clone dotfiles"
else
    git clone https://github.com/riqueandre/dotfiles
fi

case $1 in
  i3)
    wm="i3status i3blocks i3-gaps i3exit i3-scrot"
    ;;

  bspwm)
    wm="bspwm sxhkd"
    ;;
esac

pkgs="
    $wm \
    alacritty \
    alsa-utils \
    autotiling \
    bat \
    calc \
    cava \
    conky \
    dunst \
    exo \
    feh \
    gnome-font-viewer \
    google-chrome \
    gsfonts \
    hsetroot \
    imwheel \
    lightdm lightdm-gtk-greeter \
    mesa \
    mpd \
    ncmpcpp \
    nemo \
    neovim  \
    nerd-fonts-complete \
    network-manager-applet \
    networkmanager-dmenu-git \
    noto-fonts \
    numlockx \
    papirus-icon-theme \
    paprefs \
    pavucontrol \
    pfetch \
    picom-ibhagwan-git \
    polkit-gnome \
    polybar \
    pulseaudio \
    pulseaudio-alsa \
    python-pip \
    python-pip \
    python-pywal \
    rofi \
    rofi-dmenu \
    siji-git \
    terminus-font \
    ttf-fantasque-sans-mono
    ttf-sarasa-gothic \
    ttf-ubuntu-font-family \
    tty-clock \
    unzip \
    volumeicon \
    xdg-user-dirs \
    xf86-input-vmmouse \
    xf86-video-vmware \
    xfce4-power-manager \
    xorg-server \
    xorg-xfd \
    xorg-xinput xorg-xinit \
    xorg-xrdb \
    xorg-xsetroot \
    xss-lock \
    "

sudo pamac install --no-confirm $pkgs


if [[ -d $HOME/.oh-my-zsh ]]
then
    echo "skipping oh-my-zsh installation"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]
then
    echo "skipping p10k installation"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi


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
xdg-user-dirs-update
chsh -s $(which zsh)
