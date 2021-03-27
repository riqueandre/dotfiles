#!/bin/bash

sudo echo starting ...

case $1 in
    i3)
        wm_selected="i3status i3blocks i3-gaps i3exit i3-scrot autotiling"
    ;;

    bspwm)
        wm_selected="bspwm sxhkd"
    ;;

    *)
        echo "Select bspwm or i3"
        exit 0
    ;;
esac

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


pkgs_video="
    mesa
    xf86-input-vmmouse
    xf86-video-vmware
    xfce4-power-manager
    xorg-server
    xorg-xfd
    xorg-xinput xorg-xinit
    xorg-xrdb
    xorg-xsetroot
    "

pkgs_dm="
    lightdm
    lightdm-gtk-greeter
    "


pkgs_wm="
    ${wm_selected}
    dunst
    picom-ibhagwan-git
    polybar
    rofi
    rofi-dmenu
    "

pkgs_audio="
    cava
    "

pkgs_network="
    network-manager-applet
    networkmanager-dmenu-git
    "


pkgs_util="
    alacritty
    bat
    calc
    conky
    exo
    feh
    gnome-font-viewer
    google-chrome
    hsetroot
    imwheel
    mpd
    ncmpcpp
    nemo
    neovim
    numlockx
    papirus-icon-theme
    pfetch
    polkit-gnome
    unzip
    xdg-user-dirs
    xss-lock
    "


pkgs_fonts="
    gsfonts
    nerd-fonts-complete
    noto-fonts
    siji-git
    terminus-font
    ttf-fantasque-sans-mono
    ttf-sarasa-gothic
    ttf-ubuntu-font-family
    "


pkgs_dev="
    openjdk11-doc
    openjdk11-src
    python-pip
    "


pkgs="
    ${pkgs_video}
    ${pkgs_dm}
    ${pkgs_wm}
    ${pkgs_audio}
    ${pkgs_network}
    ${pkgs_util}
    ${pkgs_fonts}
    ${pkgs_dev}
    "
sudo pamac install --no-confirm $pkgs


if [[ -d $HOME/.oh-my-zsh ]]
then
    echo "skipping oh-my-zsh and pluggins installation"
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
case $1 in
  i3)
    cp -r ~/dotfiles/themes/i3-cuts/.Xresources    ~/
    cp -r ~/dotfiles/themes/i3-cuts/polybar        ~/.config/
    cp -r ~/dotfiles/themes/i3-cuts/picom          ~/.config/
    cp -r ~/dotfiles/themes/i3-cuts/dunst          ~/.config/
    cp -r ~/dotfiles/themes/i3-cuts/rofi           ~/.config/
    ;;
  bspwm)
    cp -r ~/dotfiles/themes/bspwm-b4skyx/.Xresources    ~/
    cp -r ~/dotfiles/themes/bspwm-b4skyx/polybar        ~/.config/
    cp -r ~/dotfiles/themes/bspwm-b4skyx/picom          ~/.config/
    cp -r ~/dotfiles/themes/bspwm-b4skyx/dunst          ~/.config/
    cp -r ~/dotfiles/themes/bspwm-b4skyx/rofi           ~/.config/
    ;;
esac


sudo systemctl enable lightdm
sudo systemctl enable mpd


pip install dbus-python
xdg-user-dirs-update
chsh -s $(which zsh)
