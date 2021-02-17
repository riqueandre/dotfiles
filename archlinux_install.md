# Pre-installation
## Check Network
```
ip link
ip address 
ping archlinux.org
```

## Update the system clock
```
timedatectl set-ntp true
date
```

## Manage Disks
```
fdisk /dev/sda
cfdisk /dev/sda
```

## Format the partitions
```
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
```

## Mount the file systems
```
mount /dev/sda2 /mnt
swapon /dev/sda1
```

# Installation
## Install essential packages
```
pacman -Syy
pacman -S reflector
reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware vi vim nano dhcpcd grub sudo
```

## Fstab
```
genfstab -U /mnt >> /mnt/etc/fstab
```

## Chroot
```
arch-chroot /mnt
```

## Time zone
```
ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
hwclock --systohc
```

## Localization
```
vim /etc/locale.gen
    -  uncomment en_US.UTF-8 UTF-8
locale-gen
```

## Network configuration
```
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo dev > /etc/hostname
echo -e "127.0.0.1 \t   localhost" >> /etc/hosts
echo -e "::1        \t  localhost" >> /etc/hosts
systemctl enable dhcpcd
```

## Root password
```
passwd
```

## Boot loader
```
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

## Reboot
```
exit
umount -R /mnt
reboot
```
