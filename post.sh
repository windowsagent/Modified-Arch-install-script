#!/bin/bash

# Installing desktop environment
# This line below is now stupid because I'm too lazy to write a sed script to replace every single thing on the lightdm config
#sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/g" /etc/lightdm/lightdm.conf

# Place lightdm config + xsessions cause again, I'm too lazy to write several sed commands even though it'd probably be easier than tampering with permissions and those stuffs

cd /usr/share/
sudo wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/xsessions.zip
sudo unzip xsessions.zip
sudo rm -rf xsessions.zip

cd /etc/
sudo wget https://github.com/windowsagent/Modified-Arch-install-script/raw/master/lightdm.zip
sudo unzip lightdm.zip
sudo rm -rf lightdm.zip

# Deploy modified version of LARBS
# with Ikan ikan ikan

cd /tmp
sudo curl -LO https://raw.githubusercontent.com/windowsagent/LARBS/master/larbs.sh
sudo chmod +x larbs.sh
sudo sh larbs.sh
