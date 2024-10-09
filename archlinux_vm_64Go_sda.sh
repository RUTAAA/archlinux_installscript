#!/bin/bash

read -p "New username: " username
echo

read -s -p "New user password: " password
echo

read -s -p "New root password: " root_password
echo


echo
echo
echo
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
echo "Localization"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
touch /mnt/etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /mnt/etc/locale.conf
touch /mnt/etc/vconsole.conf
echo "KEYMAP=fr" > /mnt/etc/vconsole.conf

echo
echo
echo
echo "Hostname"
touch /mnt/etc/hostname
echo "archlinux" > /mnt/etc/hostname

echo
echo
echo
echo "Datetime"
ln -sf /mnt/usr/share/zoneinfo/Europe/Paris /mnt/etc/localtime
arch-chroot /mnt hwclock --systohc

echo
echo
echo
echo "User and password"
arch-chroot /mnt (echo $root_password | passwd --stdin)
arch-chroot /mnt useradd --groups wheel --create-home --shell /bin/bash
arch-chroot /mnt (echo $password | passwd --stdin $username)

echo
echo
echo
echo "GRUB bootloader"
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo
echo
echo
echo "Terminé!"
