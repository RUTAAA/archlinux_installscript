#!/bin/bash

read -s -p "Password for new root: " root_password
echo
read -p "Username for new user: " username
read -s -p "Password for new user: " user_password
echo
read -p "Configure the defaut rice? [Y/n] " rice

printf "\n\n\nUpdate"
pacman -Sy

printf "\n\n\nDisk"
sfdisk /dev/sda < sda.dump
mkfs.ext4 /dev/sda2
mkfs.fat -F 32 /dev/sda1
mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot

printf "\n\n\nInstallation"
pacstrap -K /mnt base linux linux-firmware grub efibootmgr base-devel networkmanager nano

printf "\n\n\nfstab"
genfstab -U /mnt >> /mnt/etc/fstab

printf "\n\n\nChange root"
cp ./chroot_script.sh /mnt/chroot_script.sh
arch-chroot /mnt ./chroot_script.sh $root_password $username $user_password
rm /mnt/chroot_script.sh
if [ $rice != "n" ]
then
  cp ./ricing.sh /mnt/ricing.sh
  arch-chroot /mnt ./ricing.sh $username
  rm /mnt/ricing.sh
fi

printf "\n\n\nTerminé!"
