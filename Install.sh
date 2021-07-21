#!/bin/bash

mkdir /mnt/boot
timedatectl set-ntp true
pacstrap /mnt base base-devel
pacstrap /mnt linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt  ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
arch-chroot /mnt hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen
sed -i "s/#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt pacman -S --noconfirm grub os-prober efibootmgr nano
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
echo Insert the host name, please.
read HOSTNAME
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
arch-chroot /mnt pacman -S --noconfirm --needed networkmanager
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt pacman -S --noconfirm dhcpcd
arch-chroot /mnt useradd -m windowsagent
arch-chroot /mnt echo -e "2006\n2006" | passwd windowsagent
arch-chroot /mnt echo -e "2006\n2006" | passwd root
arch-chroot /mnt pacman -S --noconfirm --needed sudo git
arch-chroot /mnt echo 'windowsagent ALL=(ALL)' >> /etc/sudoers
# Run a script inside a chroot environment


cat <<EOF > /mnt/root/post.sh
mkdir /home/windowsagent
pacman -S --noconfirm zip unzip wget curl
git clone https://aur.archlinux.org/yay.git /home/windowsagent/yay
chmod 777 /home/windowsagent/yay/
cd /home/windowsagent/yay/
echo Run makepkg -si > /home/windowsagent/Important.txt
cd /home/windowsagent/

# 07/20/2021 -- Implemented new "experimental" patches
# I wanna kill myself, this is hard!

wget https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/configs.zip
unzip configs.zip
pacman -S --noconfirm --needed xfce4 xfce4-goodies sddm xorg
systemctl enable sddm.service

exit # to leave the chroot
EOF
arch-chroot /mnt chmod +x /root/post.sh
arch-chroot /mnt /root/post.sh


# Exit out of the chroot enviroment
echo " "
echo -e "${GREEN}Arch Linux installed successfully" ' ! ' "${NC}"
echo " "
echo "You can now proceed to reboot your system :3"
echo "*computer* Huh, this was a whole journey!"
echo "Do not forget to read important.txt, in your user home directory, future Knox!"
echo " "
# This code is a mess, I know.
