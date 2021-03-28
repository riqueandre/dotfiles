#!/bin/bash

function get_swap_size() {
    local mem_total=$(awk '/Mem:/ {print $4}' <(free -g))
    local swap_size=1

    if (( mem_total < 2 ))
    then
        swap_size=$((3 * mem_total))
    elif (( mem_total >= 2 && mem_total <=8 ))
    then
        swap_size=$((2 * mem_total))
    elif (( mem_total > 8 ))
    then
        swap_size=$((1.5 * mem_total))
    fi

    echo $swap_size
}

### setup root
unset root_password
prompt="[ root ] password: "
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
        break
    fi
    prompt='*'
    root_password+="$char"
done
echo

### setup default user system
echo -n "[ system user ] username: "
read userdef_username 

unset userdef_password
prompt="[ system user ] password: "
while IFS= read -p "$prompt" -r -s -n 1 char
do
    if [[ $char == $'\0' ]]
    then
        break
    fi
    prompt='*'
    userdef_password+="$char"
done
echo

userdef_password_crypt=$(echo ${userdef_password} | openssl passwd -6 -stdin)
root_password_crypt=$(echo ${root_password} | openssl passwd -6 -stdin)

### begin install
timedatectl set-ntp true

parted -a optimal -s /dev/sda -- mklabel msdos \
    mkpart primary linux-swap 2048s $(get_swap_size)GiB \
    mkpart primary ext4 $(get_swap_size)GiB 100% \ 
    set 2 boot on
    
mkfs.ext4 /dev/sda2
mkswap /dev/sda1

swapon /dev/sda1
mount /dev/sda2 /mnt

pacman -Syy
pacman -S --noconfirm --needed --noprogressbar --quiet reflector
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

#
cat <<- EOF > /mnt/core.sh
sed -i '/Color/s/^#//g' /etc/pacman.conf 
pacman -Syu
pacman -S  --noconfirm --needed archlinux-keyring
pacman -S  --noconfirm --needed alsa-utils \
                                asp \
                                base-devel \
                                dhcpcd \
                                fzf \
                                git \
                                grub \
                                gtkmm \
                                gtkmm3 \
                                htop \
                                linux-headers \
                                lsof \
                                man \
                                man-pages \
                                man-pages-pt_br \
                                mlocate \
                                nano \
                                net-tools \
                                networkmanager \
                                networkmanager-openvpn \
                                open-vm-tools \
                                openssh \
                                openssl \
                                paprefs \
                                pavucontrol \
                                pulseaudio \
                                pulseaudio-alsa \
                                rsync \
                                sudo \
                                syslog-ng \
                                systemd-resolvconf \
                                ttf-dejavu \
                                vi \
                                vim \
                                wget \
                                zip \
                                zsh

ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
hwclock --systohc

sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

echo dev > /etc/hostname
echo -e "127.0.0.1 \t   localhost" >> /etc/hosts
echo -e "::1        \t  localhost" >> /etc/hosts

cat /proc/version > /etc/arch-release

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable syslog-ng@default
systemctl enable vmware-vmblock-fuse
systemctl enable vmtoolsd
systemctl enable NetworkManager
systemctl enable systemd-resolved

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo 'root:${root_password_crypt}' | chpasswd -e

useradd -m -p ${userdef_password_crypt} ${userdef_username}
usermod -G wheel ${userdef_username}

exit
EOF

#
arch-chroot /mnt /bin/bash -e -x /core.sh
rm /mnt/core.sh
echo "finished :-) umount -R /mnt and reboot?"
