#!/bin/bash

echo "Mise à jour"
pacman -Sy

echo "Partitionnement, formatage, montage"
sfdisk /dev/sda < sda.dump
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

echo "Installation"
pacstrap -K /mnt base linux linux-firmware base-devel nano grub efibootmgr

echo "fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Langue et layout"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
touch /mnt/etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /mnt/etc/locale.conf
touch /mnt/etc/vconsole.conf
echo "KEYMAP=fr" > /mnt/etc/vconsole.conf

echo "Hostname"
touch /mnt/etc/hostname
echo "archlinux" > /mnt/etc/hostname

echo "Date et heure"
ln -sf /mnt/usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

echo "GRUB bootloader"
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "Terminé!"
