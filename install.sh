timedatectl set-ntp true
sfdisk /dev/sda < partitions.txt
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
swapon /dev/sda1
mount /dev/sda2 /mnt
pacman -Syy
pacman -S reflector
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware linux-headers asp vi vim nano dhcpcd grub sudo open-vm-tools gtkmm gtkmm3 git wget 
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
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
Root password
passwd
Boot loader
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
Reboot
exit
umount -R /mnt
reboot
