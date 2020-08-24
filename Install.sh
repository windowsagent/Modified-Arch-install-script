#!/usr/bin/env bash
mkfs.ext4 /dev/sda2
mkswap /dev/sda3
swapon /dev/sda3
mount /dev/sda2 /mnt
timedatectl set-ntp true
curl "https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/mirrorlist" >> mirrorlist
cp mirrorlist /etc/pacman.d/mirrorlist
pacstrap /mnt base
arch-chroot /mnt pacman -S --noconfirm --needed linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ln -s -f /usr/share/zoneinfo/USA/Eastern /etc/localtime
arch-chroot /mnt hwclock --systohc
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen
locale-gen
arch-chroot /mnt locale-gen
echo Insert the host name, please.
read HOSTNAME
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
arch-chroot /mnt pacman -S --noconfirm --needed networkmanager
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt useraddd windowsagent
arch-chroot /mnt echo "2006" | passwd "windowsagent" --stdin
arch-chroot /mnt pacman -S --noconfirm --needed sudo
arch-chroot /mnt sed -i 'windowsagent ALL=(ALL)' /etc/sudoers
arch-chroot /mnt pacman -S --noconfirm --needed grub
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt systemctl set-default graphical.target
arch-chroot /mnt pacman -S --noconfirm --needed xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xorg-server
arch-chroot /mnt systemctl enable lightdm.service
arch-chroot /mnt sed -i 's/%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
arch-chroot /mnt pacman -S --noconfirm --needed git base-devel
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
