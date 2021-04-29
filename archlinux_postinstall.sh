#!/bin/bash

projectsPath="$HOME/Projects"
dotfilesPath="$projectsPath/dotfiles"

echo "1) bspwm  2) i3"
read -r -p "Choose your WM: " wm
case $wm in
    1)
        wm_selected='bspwm sxhkd'
        echo 'installing bspwm'
        ;;
    2)
        wm_selected='i3status i3blocks i3-gaps i3exit i3-scrot autotiling'
        echo 'installing i3status'
        ;;
    *)
        echo 'Select bspwm or i3'
        exit 0
        ;;
esac


echo "1) b4skyx  2) cut  3) not install"
read -r -p "Choose your theme: " wm_theme
case $wm_theme in
    1)
        wm_theme_actions="
                         cp -r $dotfilesPath/themes/b4skyx/.Xresources                 ~/                              ;
                         cp -r $dotfilesPath/themes/b4skyx/polybar                     ~/.config/                      ;
                         cp -r $dotfilesPath/themes/b4skyx/picom                       ~/.config/                      ;
                         cp -r $dotfilesPath/themes/b4skyx/dunst                       ~/.config/                      ;
                         cp -r $dotfilesPath/themes/b4skyx/rofi                        ~/.config/                      ;
                         cp -r $dotfilesPath/themes/b4skyx/wallpapers                  ~/.config/                      ;
                         ln -sf $dotfilesPath/themes/b4skyx/wallpapers/astronaut.jpg   ~/.config/wallpapers/default    ;
                         "
        ;;
    2)
        wm_theme_actions="
                         cp -r $dotfilesPath/themes/cuts/.Xresources    ~/                                             ;
                         cp -r $dotfilesPath/themes/cuts/polybar        ~/.config/                                     ;
                         cp -r $dotfilesPath/themes/cuts/picom          ~/.config/                                     ;
                         cp -r $dotfilesPath/themes/cuts/dunst          ~/.config/                                     ;
                         cp -r $dotfilesPath/themes/cuts/rofi           ~/.config/                                     ;
                         cp -r $dotfilesPath/themes/cuts/wallpapers     ~/.config/                                     ;
                         ln -sf $dotfilesPath/themes/cuts/wallpapers/arch_purple.png   ~/.config/wallpapers/default    ;
                         "
        ;;
    *)
        echo 'skipping theme install'
        ;;
esac



# does full system update
echo "Doing a system update"
sudo pacman --noconfirm -Syu


mkdir -p .config
mkdir -p .local/share
mkdir -p $projectsPath


if [[ -d $HOME/pamac-aur ]]
then
    echo "skipping pamac installation"
else
    git clone https://aur.archlinux.org/pamac-aur.git
    cd pamac-aur
    makepkg -si --noconfirm
    sudo sed -i '/EnableAUR/s/^#//g'        /etc/pamac.conf
    sudo sed -i '/CheckAURUpdates/s/^#//g'  /etc/pamac.conf
    sudo sed -i '/NoUpdateHideIcon/s/^#//g' /etc/pamac.conf

    cd ~
fi


if [[ -d $dotfilesPath ]]
then
    echo "skipping clone dotfiles"
else
    git clone https://github.com/riqueandre/dotfiles $dotfilesPath
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
    xdg-user-dirs
    xdg-utils
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

pkgs_network="
    network-manager-applet
    networkmanager-dmenu-git
    "


pkgs_util="
    alacritty
    bat
    bind
    calc
    conky
    exo
    feh
    file-roller
    gnome-font-viewer
    gnome-keyring
    google-chrome
    hsetroot
    imwheel
    inetutils
    mpd
    ncmpcpp
    nemo
    neovim
    numlockx
    papirus-icon-theme
    pfetch
    polkit-gnome
    pulsemixer
    scrot
    sshpass
    tdrop-git
    tree
    unzip
    xss-lock
    "


pkgs_fonts="
    gsfonts
    nerd-fonts-fira-code
    nerd-fonts-fira-mono
    nerd-fonts-jetbrains-mono
    nerd-fonts-source-code-pro
    noto-fonts
    siji-git
    terminus-font
    ttf-fantasque-sans-mono
    ttf-sarasa-gothic
    ttf-ubuntu-font-family
    "


pkgs_dev="
    httpie
    openjdk11-doc
    openjdk11-src
    python-pip
    "


pkgs="
    ${pkgs_video}
    ${pkgs_dm}
    ${pkgs_wm}
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


cp -r $dotfilesPath/.imwheelrc                         ~/
cp -r $dotfilesPath/.p10k.zsh                          ~/
cp -r $dotfilesPath/.zshrc                             ~/
cp -r $dotfilesPath/.zshenv                            ~/
cp -r $dotfilesPath/.config                            ~/
cp -r $dotfilesPath/.local/                            ~/
eval ${wm_theme_actions}


sudo sed -i 's/\#display-setup-script=/display-setup-script=\/usr\/bin\/vmware-user-suid-wrapper/g' /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm
sudo systemctl enable mpd

git config --global credential.helper store
pip install dbus-python
xdg-user-dirs-update

current_shell=$(grep "^$USER" /etc/passwd | awk -F ':' '{print $7}')
if [ "$current_shell" == "$(which zsh)" ]; then
    echo "Shell already set to: $current_shell"
else
    chsh -s $(which zsh)
    zsh
fi
