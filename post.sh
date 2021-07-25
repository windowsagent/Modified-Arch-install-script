#!/bin/bash

# Installing desktop environment
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf

# Installing yay
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
sudo chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
makepkg -si
cd /home/windowsagent/
rm -rf /home/windowsagent/yay

#Install greeter

yay -Sy lightdm-slick-greeter

# Update DE config, theme and icons
wget https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/Xfce4-stuff.zip -P /home/windowsagent/
sudo unzip Xfce4-stuff.zip
sudo rm -rf Xfce4-stuff.zip

# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol pulseaudio alsa-firmware

# Fix weird vblank issue
xfconf-query -c xfwm4 -p /general/vblank_mode -s off

# Install ocs-url (for themes)
sudo pacman -S qt5-base qt5-svg qt5-declarative qt5-quickcontrols
wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/ocs-url-3.1.0-1-x86_64.pkg.tar.xz -P /home/windowsagent
sudo pacman -U /home/windowsagent/ocs-url-3.1.0-1-x86_64.pkg.tar.xz
