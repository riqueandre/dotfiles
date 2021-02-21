#
parted -s /dev/sda -- mklabel msdos \
    mkpart primary linux-swap 1MiB 1.1GiB\
    mkpart primary ext4 1.1GiB 100% set 1 boot on
timedatectl set-ntp true
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
pacman -S  --noconfirm --needed base-devel linux-headers asp vi vim nano dhcpcd grub sudo open-vm-tools gtkmm gtkmm3 git wget
ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
hwclock --systohc
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo dev > /etc/hostname
echo -e "127.0.0.1 \t   localhost" >> /etc/hosts
echo -e "::1        \t  localhost" >> /etc/hosts
cat /proc/version > /etc/arch-release
systemctl enable vmware-vmblock-fuse
systemctl enable vmtoolsd
echo root:root | chpasswd
passwd root -e
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
EOF

#
arch-chroot /mnt /bin/bash -e -x /core.sh
rm /mnt/core.sh
echo "finished :-) reboot?"
