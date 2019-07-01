#!/bin/bash
set -e

##################################################################################################################
#
#   Set processor cores for compiling
#
##################################################################################################################

numberofcores=$(grep -c ^processor /proc/cpuinfo)


case $numberofcores in

    16)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j17"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 16 -z -)/g' /etc/makepkg.conf
        ;;
    8)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j9"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 8 -z -)/g' /etc/makepkg.conf
        ;;
    6)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j7"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 6 -z -)/g' /etc/makepkg.conf
        ;;
    4)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf
        ;;
    2)
        echo "You have " $numberofcores" cores."
        echo "Changing the makeflags for "$numberofcores" cores."
        sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j3"/g' /etc/makepkg.conf
        echo "Changing the compression settings for "$numberofcores" cores."
        sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 2 -z -)/g' /etc/makepkg.conf
        ;;
    *)
        echo "We do not know how many cores you have."
        echo "Do it manually."
        ;;

esac

##################################################################################################################
#
#   Remove Arcolinux stuff
#
##################################################################################################################

sudo pacman -R --noconfirm arcolinux-wallpapers-git arcolinux-arc-themes-nico-git arcolinux-neofetch-git arcolinux-system-config-git

##################################################################################################################
#
#   Display Manager and Desktop
#
##################################################################################################################

sudo pacman -R xcursor-breeze --noconfirm
sudo pacman -Syyu --noconfirm
#installing displaymanager or login manager
sudo pacman -S --noconfirm --needed sddm sddm sddm-kcm
sudo pacman -S --noconfirm --needed dolphin konsole
#installing desktop environment
sudo pacman -S plasma --noconfirm --needed
#enabling displaymanager or login manager
sudo systemctl enable sddm.service -f
sudo systemctl set-default graphical.target

##################################################################################################################
#
#   Sound
#
##################################################################################################################

sudo pacman -S pulseaudio --noconfirm --needed
sudo pacman -S pulseaudio-alsa --noconfirm --needed
sudo pacman -S pavucontrol  --noconfirm --needed
sudo pacman -S alsa-utils alsa-plugins alsa-lib alsa-firmware --noconfirm --needed
sudo pacman -S gstreamer --noconfirm --needed
sudo pacman -S gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly --noconfirm --needed

##################################################################################################################
#
#   Install Bluetooth
#
##################################################################################################################

sudo pacman -S --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils
sudo pacman -S --noconfirm --needed blueberry

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

# https://github.com/linuxmint/blueberry/issues/75
sudo usermod  -a -G rfkill $USER

##################################################################################################################
#
#   Printing Support
#
##################################################################################################################

sudo pacman -S --noconfirm --needed cups cups-pdf

#first try if you can print without foomatic
#sudo pacman -S foomatic-db-engine --noconfirm --needed
#sudo pacman -S foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds foomatic-db-gutenprint-ppds --noconfirm --needed
sudo pacman -S ghostscript gsfonts gutenprint --noconfirm --needed
sudo pacman -S gtk3-print-backends --noconfirm --needed
sudo pacman -S libcups --noconfirm --needed
# sudo pacman -S hplip --noconfirm --needed
sudo pacman -S system-config-printer --noconfirm --needed

sudo systemctl enable org.cups.cupsd.service

##################################################################################################################
#
#   Network Discovery
#
##################################################################################################################

sudo pacman -S --noconfirm --needed avahi
sudo systemctl enable avahi-daemon.service
sudo systemctl start avahi-daemon.service

#shares on a mac
sudo pacman -S --noconfirm --needed nss-mdns

#shares on a linux
sudo pacman -S --noconfirm --needed gvfs-smb

#change nsswitch.conf for access to nas servers
#original line comes from the package filesystem
#hosts: files mymachines myhostname resolve [!UNAVAIL=return] dns
#ArcoLinux line
#hosts: files mymachines resolve [!UNAVAIL=return] mdns dns wins myhostname

#first part
sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf
#last part
sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf

##################################################################################################################
#
#   TLP for Laptops
#
##################################################################################################################

sudo pacman -S --noconfirm --needed tlp
sudo systemctl enable tlp.service
sudo systemctl start tlp-sleep.service

##################################################################################################################
#
#   Install Software
#
##################################################################################################################

# software from standard Arch Linux repositories
# Core, Extra, Community, Multilib repositories
echo "Installing category Accessories"

#sudo pacman -S --noconfirm --needed

echo "Installing category Development"

sudo pacman -S --noconfirm --needed code
sudo pacman -S --noconfirm --needed kate
#sudo pacman -S --noconfirm --needed

echo "Installing category Education"

#sudo pacman -S --noconfirm --needed

echo "Installing category Games"

#sudo pacman -S --noconfirm --needed

echo "Installing category Graphics"

sudo pacman -S --noconfirm --needed gimp
sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed flameshot
sudo pacman -S --noconfirm --needed okular

echo "Installing category Internet"

sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed filezilla
sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed ktorrent
sudo pacman -S --noconfirm --needed telegram-desktop

echo "Installing category Multimedia"

sudo pacman -S --noconfirm --needed simplescreenrecorder
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed audacity
sudo pacman -S --noconfirm --needed obs-studio
#sudo pacman -S --noconfirm --needed

echo "Installing category Office"

sudo pacman -S --noconfirm --needed libreoffice-fresh
#sudo pacman -S --noconfirm --needed

echo "Installing category Utilities"

sudo pacman -S --noconfirm --needed kcalc
sudo pacman -S --noconfirm --needed yakuake
#sudo pacman -S --noconfirm --needed

echo "Installing category Other"

sudo pacman -S --noconfirm --needed flatpak
#sudo pacman -S --noconfirm --needed

echo "Installing category System"

sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp
sudo pacman -S --noconfirm --needed hardinfo
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed lm_sensors
sudo pacman -S --noconfirm --needed lsb-release
sudo pacman -S --noconfirm --needed mlocate
sudo pacman -S --noconfirm --needed net-tools
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed sane
sudo pacman -S --noconfirm --needed neofetch
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed breeze-gtk
sudo pacman -S --noconfirm --needed imagemagick
sudo pacman -S --noconfirm --needed kde-gtk-config
sudo pacman -S --noconfirm --needed libappindicator-gtk3
sudo pacman -S --noconfirm --needed w3m
# File compression tools
sudo pacman -S --noconfirm --needed unace unrar zip unzip sharutils  uudeview  arj cabextract file-roller
# Package support for Discover
sudo pacman -S --noconfirm --needed packagekit-qt5

##################################################################################################################
#
#   Intel Microcode Fix
#
##################################################################################################################

sudo pacman -S intel-ucode --noconfirm
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "################################################################"
echo "####             System Installed - Reboot Now            ######"
echo "################################################################"