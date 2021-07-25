#!/bin/bash

# Installing desktop environment
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf

# Installing yay
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
sudo chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
makepkg -si
cd /home/windowsagent/

#Install greeter

yay -Sy lightdm-slick-greeter

# Update DE config, theme and icons
wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/configs.zip -P /home/windowsagent/
sudo unzip configs.zip
sudo rm -rf configs.zip

# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol pulseaudio alsa-firmware

# Install theme
cd /usr/share/
sudo wget https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/share.zip -P /usr/share/
sudo unzip share.zip

sudo cp -R /usr/share/themes/IndigoMagic /home/windowsagent/.themes/
sudo cp -R /usr/share/icons/sgi-elementary-xfce /home/windowsagent/.icons/

xfconf-query -c xfwm4 -p /general/vblank_mode -s off
