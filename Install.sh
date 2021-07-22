#!/bin/bash

mkdir /mnt/boot
curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/mirrorlist > /etc/pacman.d/mirrorlist
pacman -Sy
timedatectl set-ntp true
pacstrap /mnt base base-devel
pacstrap /mnt linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt  ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
arch-chroot /mnt hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen
sed -i "s/#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/mirrorlist > /etc/pacman.d/mirrorlist
arch-chroot /mnt pacman -Syyu
arch-chroot /mnt pacman -S --noconfirm grub os-prober efibootmgr nano
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
echo Insert the host name, please.
read HOSTNAME
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
arch-chroot /mnt pacman -S --noconfirm --needed networkmanager curl
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt pacman -S --noconfirm dhcpcd
arch-chroot /mnt useradd -m windowsagent
arch-chroot /mnt echo -en "2006\n2006" | passwd windowsagent
arch-chroot /mnt echo -en "2006\n2006" | passwd root
mkdir /mnt/home/windowsagent
arch-chroot /mnt pacman -S --noconfirm --needed sudo git curl zip unzip wget
arch-chroot /mnt systemctl enable dhcpcd

# Sudoers
curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/sudoers > /mnt/etc/sudoers

# Drop post installation script on user's home directory
curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/post.sh > /home/windowsagent/runme.sh

echo " "
echo -e "${GREEN}Arch Linux installed successfully" ' ! ' "${NC}"
echo " "
echo "You can now proceed to reboot your system :3"
echo "Do not forget to run the file on your home directory, in your user home directory, future Knox!"
echo " "
# This code is a mess, I know.
