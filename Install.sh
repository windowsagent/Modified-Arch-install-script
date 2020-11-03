#!/usr/bin/env bash
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda2 /mnt
mkdir /mnt/boot
timedatectl set-ntp true
basestrap /mnt base base-devel openrc
basestrap /mnt linux linux-firmware
fstabgen -U /mnt >> /mnt/etc/fstab
artools-chroot /mnt  ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
artools-chroot /mnt hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen
sed -i "s/#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/" /mnt/etc/locale.gen
artools-chroot /mnt locale-gen
artools-chroot /mnt pacman -S --noconfirm grub os-prober efibootmgr
artools-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
artools-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
echo Insert the host name, please.
read HOSTNAME
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
artools-chroot /mnt pacman -S --noconfirm --needed networkmanager
artools-chroot /mnt systemctl enable NetworkManager.service
artools-chroot /mnt pacman -S dhcpcd
useradd -m windowsagent
artools-chroot /mnt pacman -S --noconfirm --needed sudo
artools-chroot /mnt sed -i 'windowsagent ALL=(ALL)' /etc/sudoers
artools-chroot /mnt pacman -S nvidia
# Run a script inside a chroot environment


cat <<EOF > /mnt/root/yayinstall.sh
git clone https://aur.archlinux.org/yay.git /home/windowsagent/
chmod 777 /home/windowsagent/
cd /home/windowsagent/yay/
makepkg -si
rm -rf /home/windowsagent/yay/
exit # to leave the chroot
EOF

arch-chroot /mnt /root/yayinstall.sh

# Exit out of the chroot enviroment
echo " "
echo -e "${GREEN}Arch Linux installed successfully" ' ! ' "${NC}"
echo " "
echo "You can now proceed to reboot your system :3"
echo "*computer* Huh, this was a whole journey!"
echo " "
# This code is a mess, I know.
