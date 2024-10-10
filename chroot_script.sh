printf "\n\n\nLocalization"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
touch /etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
touch /etc/vconsole.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

printf "\n\n\nHostname"
touch /etc/hostname
echo "archlinux" > /etc/hostname

printf "\n\n\nDatetime"
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

printf "\n\n\nUser and password"
echo $1 | passwd --stdin
useradd --groups wheel --create-home --shell /bin/bash $2
echo $3 | passwd --stdin $2
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

printf "\n\n\nGRUB bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
