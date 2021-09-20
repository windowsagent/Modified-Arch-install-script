#!/bin/bash

# Installing desktop environment
# This line below is now stupid because I'm too lazy to write a sed script to replace every single thing on the lightdm config
#sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf

#Install greeter

#yay -Sy lightdm-slick-greeter
#I became a chad and stopped using fancy display managers.. Though I'm considering getting a lightweight cli replacement one day.. One day...

# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol pulseaudio alsa-firmware

# Fix weird vblank issue
# xfconf-query -c xfwm4 -p /general/vblank_mode -s off
# Turns out I was an idiot, and installing vmware display drivers (On VMWare workstaThtion VMs) fixed it

# Install ocs-url (for themes)
#sudo pacman -S qt5-base qt5-svg qt5-declarative qt5-quickcontrols
#wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/ocs-url-3.1.0-1-x86_64.pkg.tar.xz -P /home/windowsagent
#sudo pacman -U /home/windowsagent/ocs-url-3.1.0-1-x86_64.pkg.tar.xz

# Place lightdm config + xsessions cause again, I'm too lazy to write several sed commands even though it'd probably be easier than tampering with permissions and those stuffs

#cd /usr/share/
#sudo wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/xsessions.zip
#sudo unzip xsessions.zip
#sudo rm -rf xsessions.zip

#cd /etc/
#sudo wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/lightdm.zip
#sudo unzip lightdm.zip
#sudo rm -rf lightdm.zip

# Deploy modified version of LARBS
# with Ikan ikan ikan
# I'ma just leave this out if I ever decide to switch back, but I realized that thanks to the magic of LARBS nothing of this garbage is necessary. Thanks Luke!
cd /home/windowsagent
curl -LO https://raw.githubusercontent.com/windowsagent/LARBS/master/larbs.sh
chmod +x larbs.sh
./larbs.sh
