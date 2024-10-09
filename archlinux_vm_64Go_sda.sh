#!/bin/bash

echo "Update"
pacman -Sy

echo
echo
echo
echo "Disk"
sfdisk /dev/sda < sda.dump
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

echo
echo
echo
echo "Installation"
pacstrap -K /mnt base linux linux-firmware grub efibootmgr base-devel nano

echo
echo
echo
echo "fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo
echo
echo
echo "Change root"
cp ./chroot_script.sh /mnt/chroot_script.sh
arch-chroot /mnt ./chroot_script.sh
rm /mnt/chroot_script.sh

echo
echo
echo
echo "Terminé!"
