#!/bin/bash
# Installing desktop environment
sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies lightdm lightdm-webkit2-greeter xorg 
sudo systemctl enable lightdm
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
# Installing yay
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
sudo chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
makepkg -si
cd /home/windowsagent/

# Update DE config, theme and icons
wget https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/configs.zip -P /home/windowsagent/
sudo unzip configs.zip

# Install alsa and pavucontrol
sudo pacman -S --noconfirm --needed pulseaudio-alsa pavucontrol
