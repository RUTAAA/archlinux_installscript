#!/bin/bash

read -s -p "Root password in the new installation: " password
echo

echo "\n\n\nUpdate"
pacman -Sy

echo "\n\n\nDisk"
sfdisk /dev/sda < sda.dump
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

echo "\n\n\nInstallation"
pacstrap -K /mnt base linux linux-firmware grub efibootmgr base-devel nano

echo "\n\n\nfstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "\n\n\nLocalization"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
touch /mnt/etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /mnt/etc/locale.conf
touch /mnt/etc/vconsole.conf
echo "KEYMAP=fr" > /mnt/etc/vconsole.conf

echo "\n\n\nHostname"
touch /mnt/etc/hostname
echo "archlinux" > /mnt/etc/hostname

echo "\n\n\nDatetime"
ln -sf /mnt/usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

echo "\n\n\nRoot password"
arch-chroot /mnt echo $password | passwd --stdin

echo "\n\n\nGRUB bootloader"
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "\n\n\nTerminé!"
