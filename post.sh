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

# Install theme
cd /usr/share/
sudo wget https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/share.zip -P /usr/share/
sudo unzip share.zip

sudo cp -R /usr/share/themes/IndigoMagic /home/windowsagent/.themes/
sudo cp -R /usr/share/icons/sgi-elementary-xfce /home/windowsagent/.icons/

xfconf-query -c xfwm4 -p /general/vblank_mode -s off
