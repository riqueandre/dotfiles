#!/bin/bash

function get_swap_size() {
        MEM_TOTAL_GB=$(awk '/Mem:/ {print $4}' <(free -g))

        SWAP_SIZE=0

        if (( MEM_TOTAL_GB < 2 ))
        then
                SWAP_SIZE=$((3 * MEM_TOTAL_GB))
        elif (( MEM_TOTAL_GB >= 2 && MEM_TOTAL_GB <=8 ))
        then
                SWAP_SIZE=$((2 * MEM_TOTAL_GB))
        elif (( MEM_TOTAL_GB > 8 ))
        then
                SWAP_SIZE=$((1.5 * MEM_TOTAL_GB))
        fi

        echo $SWAP_SIZE
}

echo $(get_swap_size)

timedatectl set-ntp true

parted -s /dev/sda -- mklabel msdos \
    mkpart primary linux-swap 2048s $(get_swap_size)GiB \
    mkpart primary ext4 0 -1 \ 
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
pacman -Syu
pacman -S  --noconfirm --needed archlinux-keyring
pacman -S  --noconfirm --needed base-devel linux-headers asp vi vim nano dhcpcd grub sudo open-vm-tools gtkmm gtkmm3 git wget man openssh

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

systemctl enable dhcpcd
systemctl enable vmware-vmblock-fuse
systemctl enable vmtoolsd

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
echo root:root | chpasswd

exit
EOF

#
arch-chroot /mnt /bin/bash -e -x /core.sh
rm /mnt/core.sh
echo "finished :-) umount -R /mnt and reboot?"
