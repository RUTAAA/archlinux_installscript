read -p "New username: " username
read -s -p "New user password: " password
echo
read -s -p "New root password: " root_password
echo

echo
echo
echoecho
echo
echo
echo "Localization"
sed -i "s/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
touch /etc/vconsole.conf
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
touch /etc/vconsole.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

echo
echo
echo
echo "Hostname"
touch /etc/hostname
echo "archlinux" > /etc/hostname

echo
echo
echo
echo "Datetime"
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo
echo
echo
echo "User and password"
echo $root_password | passwd --stdin
useradd --groups wheel --create-home --shell /bin/bash $username
echo $password | passwd --stdin $username
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

echo
echo
echo
echo "GRUB bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
