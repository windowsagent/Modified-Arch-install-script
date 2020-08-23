#!/usr/bin/env bash
function pacman_install() {
    set +e
    IFS=' ' PACKAGES=($1)
    for VARIABLE in {1..5}
    do
        arch-chroot /mnt pacman -Syu --noconfirm --needed ${PACKAGES[@]}
        if [ $? == 0 ]; then
            break
        else
            sleep 10
        fi
    done
    set -e
}
function create_user_useradd() {
    USER_NAME=$1
    USER_PASSWORD=$2
    arch-chroot /mnt useradd -m -G wheel,storage,optical -s /bin/bash $USER_NAME
    printf "$USER_PASSWORD\n$USER_PASSWORD" | arch-chroot /mnt passwd $USER_NAME
}

timedatectl set-ntp true
sgdisk --zap-all /dev/sda
wipefs -a /dev/sda
mklabel msdos mkpart primary ext4 4MiB 512MiB mkpart primary $FILE_SYSTEM_TYPE 512MiB 100% set 1 boot on
wipefs -a /dev/sda2
wipefs -a /dev/sda1
mkfs.ext4 -L boot /dev/sda1
mkfs.ext4 -L root /dev/sda2
mount /dev/sda2 /mnt
curl "https://www.archlinux.org/mirrorlist/?country=US&protocol=http&protocol=https&ip_version=4" >> /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt ln -s -f /usr/share/zoneinfo/USA/Eastern /etc/localtime
arch-chroot /mnt hwclock --systohc
sed -i "en_GB.UTF-8 UTF-8" /etc/locale.gen
sed -i "en_GB.UTF-8 UTF-8" /etc/etc/locale.gen
locale-gen
arch-chroot /mnt locale-gen
echo Insert the host name, please.
read HOSTNAME
echo Welcome to the world of Arch linux, $HOSTNAME!
echo $HOSTNAME > /mnt/etc/hostname
pacman_install "networkmanager"
arch-chroot /mnt systemctl enable NetworkManager.service
create_user "windowsagent" "2006"
pacman_install "sudo"
arch-chroot /mnt sed -i 'windowsagent ALL=(ALL)' /etc/sudoers
pacman_install "xdg-user-dirs"
pacman_install "grub dosfstools"
    arch-chroot /mnt sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/' /etc/default/grub
    arch-chroot /mnt sed -i 's/#GRUB_SAVEDEFAULT="true"/GRUB_SAVEDEFAULT="true"/' /etc/default/grub
    arch-chroot /mnt sed -i -E 's/GRUB_CMDLINE_LINUX_DEFAULT="(.*) quiet"/GRUB_CMDLINE_LINUX_DEFAULT="\1"/' /etc/default/grub
    arch-chroot /mnt sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="'"$CMDLINE_LINUX"'"/' /etc/default/grub
    echo "" >> /mnt/etc/default/grub
    echo "# alis" >> /mnt/etc/default/grub
    echo "GRUB_DISABLE_SUBMENU=y" >> /mnt/etc/default/grub
    arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt systemctl set-default graphical.target
pacman_install "xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xorg-server"
arch-chroot /mnt systemctl enable lightdm.service
arch-chroot /mnt sed -i 's/%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
pacman_install "git"
arch-chroot /mnt bash -c "echo -e \"2006\n2006\n2006\n2006\n\" | su windowsagent -c \"cd /home/windowsagent && git clone https://aur.archlinux.org/$AUR.git && (cd $AUR && makepkg -si --noconfirm) && rm -rf $AUR\""
echo " "
echo -e "${GREEN}Arch Linux installed successfully" ' ! ' "${NC}"
echo " "
echo "You can now proceed to reboot your system :3"
echo "*computer* Huh, this was a whole journey!"
echo " "
### This code is a mess, I know.