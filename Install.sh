#!/bin/bash

echo Insert the host name, please.
read HOSTNAME

echo Insert the root password
read PASS

echo Are you running a Vmware Workstation VM? If you are, write y. If not, write n.
read workstation

echo Are you running on a Virtualbox VM mate? If you are, write y. If not, write n.
read virtualbox

#echo Do you want to install XFCE mate? If you want, write y. If not, write n.
#read XFCE

mkdir /mnt/boot
pacman -Sy --noconfirm pacman-contrib
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
pacman -Sy
timedatectl set-ntp true
pacstrap /mnt base base-devel
pacstrap /mnt linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt  ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
arch-chroot /mnt hwclock --systohc
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /mnt/etc/locale.gen
sed -i "s/#es_MX.UTF-8 UTF-8/es_MX.UTF-8 UTF-8/" /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/mirrorlist > /etc/pacman.d/mirrorlist
arch-chroot /mnt pacman -Syyu
arch-chroot /mnt pacman -S --noconfirm grub os-prober efibootmgr nano
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
arch-chroot /mnt pacman -S --noconfirm --needed networkmanager curl
arch-chroot /mnt systemctl enable NetworkManager.service
arch-chroot /mnt pacman -S --noconfirm dhcpcd
arch-chroot /mnt useradd -m -G wheel,storage,optical -s /bin/bash windowsagent
    cat <<EOT > /mnt/tmp/temp.sh
pacman -S --noconfirm pacman-contrib
echo -en "$PASS\n$PASS" | passwd root
curl -s "https://archlinux.org/mirrorlist/?country=US&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 -
EOT
arch-chroot /mnt chmod +x /tmp/temp.sh
arch-chroot /mnt bash /tmp/temp.sh

mkdir /mnt/home/windowsagent
arch-chroot /mnt pacman -S --noconfirm --needed sudo git curl zip unzip wget
arch-chroot /mnt systemctl enable dhcpcd

# Sudoers
# curl https://raw.githubusercontent.com/windowsagent/Modified-Arch-install-script/master/sudoers > /mnt/etc/sudoers

# Install desktop environment
# arch-chroot /mnt pacman -S --noconfirm lightdm xorg lightdm-gtk-greeter xorg-server
# arch-chroot /mnt systemctl enable lightdm

# Drop post installation script on user's home directory
cd /mnt/root
curl -Lo /mnt/root/larbs.sh https://raw.githubusercontent.com/windowsagent/LARBS/master/larbs.sh
chmod +x /mnt/root/larbs.sh

# Properly setting up locale from C (default) to en_US.utf-8
arch-chroot /mnt locale-ctl set-locale LANG=en_US.UTF-8

# Install open-vm-tools if it is a virtual machine on workstation

if [ $virtualbox = y ]
then
    echo Installing open-vm-tools
    arch-chroot /mnt pacman -S --noconfirm open-vm-tools
    arch-chroot /mnt systemctl enable vmtoolsd
fi

#if [ $XFCE = y ]
#then
#    echo Installing XFCE
#    arch-chroot /mnt pacman -S --noconfirm xfce4 xfce4-goodies xfce4-whiskermenu-plugin
#fi

if [ $virtualbox = y ]
then
    echo Installing virtualbox-guest-utils
    arch-chroot /mnt pacman -S --noconfirm virtualbox-guest-utils
fi

echo " "
echo  "Arch Linux has been installed successfully owo" ' ! ' "${NC}"
echo " "
echo "You can now proceed to reboot your system, and tell your friends about it."
echo "Do not forget to run the file on your home directory, in your user home directory, future Knox!"
echo " "
# This code is a mess, I know.
