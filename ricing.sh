printf "\n\n\nRicing installations"
pacman -S --noconfirm xorg ly bspwm sxhkd picom feh polybar rofi wezterm firefox zsh ttf-nerd-fonts-symbols-mono

printf "\n\n\nX11 - Display Server"
localectl --no-convert set-x11-keymap fr pc105 azerty
cp /etc/X11/xinit/xinitrc /home/$1/.xinitrc
head -n -5 /home/$1/.xinitrc > /home/$1/.xinitrc
echo "exec bspwm" >> /home/$1/.xinitrc

printf "\n\n\nLy - Display Manager"
systemctl enable ly.service

printf "\n\n\nbspwm - Window Manager"
install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc /home/$1/.config/bspwm/bspwmrc

printf "\n\n\nsxhkd - Hotkey Deamon"
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc /home/$1/.config/sxhkd/sxhkdrc

printf "\n\n\npicom - Compositor"
echo "picom &" >> /home/$1/.config/bspwm/bspwmrc

printf "\n\n\nfeh - Desktop Wallpaper"
mkdir /home/$1/.config/wallpapers
curl https://w.wallhaven.cc/full/jx/wallhaven-jxogjw.jpg --output /home/$1/.config/wallpapers/wallpaper.jpg
echo "feh --bg-fill /home/$1/.config/wallpapers/wallpaper.jpg &" >> /home/$1/.config/bspwm/bspwmrc

printf "\n\n\nPolybar - Status Bar"
mkdir /home/$1/.config/polybar
cp /etc/polybar/config.ini /home/$1/.config/polybar/config.ini
touch /home/$1/.config/polybar/launch.sh
printf "#!/bin/bash\nkillall -q polybar\npolybar mybar 2>&1 | tee -a /tmp/polybar.log & disown" > /home/$1/.config/polybar/launch.sh
chmod +x /home/$1/.config/polybar/launch.sh

printf "\n\n\nRofi - Application Launcher"
sed -i "s/dmenu_run/rofi --show drun/" /home/$1/.config/sxhkd/sxhkdrc

printf "\n\n\nWezTerm - Terminal Emulator"
mkdir /home/$1/.config/wezterm
touch /home/$1/.config/wezterm/wezterm.lua
printf "local wezterm = require 'wezterm'\nlocal config = wezterm.config_builder()\nreturn config" > /home/$1/.config/wezterm/wezterm.lua
sed -i "s/urxvt/wezterm/" /home/$1/.config/sxhkd/sxhkdrc

printf "\n\n\nFirefox - Internet Browser"
touch /home/$1/.config/sxhkd/sxhkdrc_new
head -n 11 /home/$1/.config/sxhkd/sxhkdrc > /home/$1/.config/sxhkd/sxhkdrc_new
echo -e "\n# internet browser\nsuper + b\n\tfirefox" >> /home/$1/.config/sxhkd/sxhkdrc_new
sed -i "s/^/wezterm/" /home/$1/.config/sxhkd/sxhkdrc
tail -n +12 /home/$1/.config/sxhkd/sxhkdrc >> /home/$1/.config/sxhkd/sxhkdrc_new
rm /home/$1/.config/sxhkd/sxhkdrc
mv /home/$1/.config/sxhkd/sxhkdrc_new /home/$1/.config/sxhkd/sxhkdrc

