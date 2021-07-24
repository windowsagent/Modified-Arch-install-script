#!/bin/bash

# Installing desktop environment
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit-theme-aether/g" /etc/lightdm/lightdm.conf

# Installing yay
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
sudo chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
makepkg -si
cd /home/windowsagent/

#Install greeter

yay -Sy lightdm-webkit-theme-aether

# Update DE config, theme and icons
wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/configs.zip -P /home/windowsagent/
sudo unzip configs.zip


# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol pulseaudio alsa-firmware
