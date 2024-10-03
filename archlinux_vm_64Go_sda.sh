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

echo "Changement de racine"
arch-chroot /mnt

echo "Langue et layout"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
touch /etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
touch /etc/vconsole.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

echo "Hostname"
touch /etc/hostname
echo "archlinux" > /etc/hostname

echo "Date et heure"
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo "GRUB bootloader"
grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Terminé!"
