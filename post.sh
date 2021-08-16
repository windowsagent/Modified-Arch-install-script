#!/bin/bash

# Installing desktop environment
# This line below is now stupid because I'm too lazy to write a sed script to replace every single thing on the lightdm config
#sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf

# Installing yay
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
sudo chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
makepkg -si
cd /home/windowsagent/
rm -rf /home/windowsagent/yay

#Install greeter

yay -Sy lightdm-slick-greeter

# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol pulseaudio alsa-firmware

# Fix weird vblank issue
xfconf-query -c xfwm4 -p /general/vblank_mode -s off

# Install ocs-url (for themes)
sudo pacman -S qt5-base qt5-svg qt5-declarative qt5-quickcontrols
wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/ocs-url-3.1.0-1-x86_64.pkg.tar.xz -P /home/windowsagent
sudo pacman -U /home/windowsagent/ocs-url-3.1.0-1-x86_64.pkg.tar.xz

# Place lightdm config + xsessions cause again, I'm too lazy to write several sed commands even though it'd probably be easier than tampering with permissions and those stuffs

