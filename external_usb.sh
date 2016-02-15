#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
device="/dev/sda"
ROOT_PROFILE="/root/.profile"

# Use external harddrive to mount os and sd card to boot
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Do you want to use an external HD for the ROOT partition, recommended! (SSD preferred)? Also attach it before typing yes!!") ]]
then
# Format and create partition
echo -ne '\n' | wipefs $device
fdisk $device << EOF
o
n
p
1

+2000M
w
EOF

fdisk $device << EOF
n
p
2


w
EOF
sync

# Swap
#sudo apt-get install parted -y
mkswap -L PI_SWAP /dev/sda1 # format as swap
swapon /dev/sda1 # announce to system
echo "/dev/sda1 none swap sw 0 0" >> /etc/fstab

# Update tables
#partprobe
#sed -i 's|bash /var/scripts/external_usb.sh|#bash /var/scripts/external_usb.sh|g' /root/.profile

# Set cmdline.txt
mount /dev/mmcblk0p1 /mnt
sed -i 's|smsc95xx.turbo_mode=N dwc_otg.fiq_fix_enable=1 root=/dev/mmcblk0p2|smsc95xx.turbo_mode=N dwc_otg.fiq_fix_enable=1 root=/dev/sda2 rootfstype=ext4 bootdelay rootdelay rootwait|g' /mnt/cmdline.txt
umount /mnt

# Change back root/.profile
rm $ROOT_PROFILE
cat <<-ROOT-PROFILE > "$ROOT_PROFILE"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/setup.sh ]; then
        /var/scripts/setup.sh
fi
if [ -x /var/scripts/history.sh ]; then
        /var/scripts/history.sh
fi
mesg n
bash /var/scripts/pre_setup.sh
ROOT-PROFILE

# External HD	
echo -e "\e[32m"
echo "This might take a while, copying everything from SD card to HD. Just wait untill system continues."
echo -e "\e[0m"
sleep 2
sed -i 's|/dev/mmcblk0p2|/dev/sda2|g' /etc/fstab # change ROOT device so the system will know which one to use as ROOT
echo -ne '\n' | sudo mke2fs -t ext4 -b 4096 -L 'PI_ROOT' /dev/sda2 # make ext4 partition to hold ROOT
dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda2 # copy the content of the SD ROOT partition to the new HD ROOT partition

# Remove SD card ROOT partition
fdisk /dev/mmcblk0 << EOF
d
2
w
EOF

 echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| After this reboot log back in with ocadmin///owncloud              |"
echo    "| The installation will then automatically begin.                    |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to continue..." -n1 -s
echo -e "\e[0m"
echo
reboot
fi

else
# Really dont want to use external usb?
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Usb connected press y. n to use sd card, not recommended.") ]]
then
# Format and create partition
echo -ne '\n' | wipefs $device
fdisk $device << EOF
o
n
p
1

+2000M
w
EOF

fdisk $device << EOF
n
p
2


w
EOF
sync

# Swap
#sudo apt-get install parted -y
mkswap -L PI_SWAP /dev/sda1 # format as swap
swapon /dev/sda1 # announce to system
echo "/dev/sda1 none swap sw 0 0" >> /etc/fstab

# Update tables
#partprobe
#sed -i 's|bash /var/scripts/external_usb.sh|#bash /var/scripts/external_usb.sh|g' /root/.profile

# Set cmdline.txt
mount /dev/mmcblk0p1 /mnt
sed -i 's|smsc95xx.turbo_mode=N dwc_otg.fiq_fix_enable=1 root=/dev/mmcblk0p2|smsc95xx.turbo_mode=N dwc_otg.fiq_fix_enable=1 root=/dev/sda2 rootfstype=ext4 bootdelay rootdelay rootwait|g' /mnt/cmdline.txt
umount /mnt

# Change back root/.profile
rm $ROOT_PROFILE
cat <<-ROOT-PROFILE > "$ROOT_PROFILE"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/setup.sh ]; then
        /var/scripts/setup.sh
fi
if [ -x /var/scripts/history.sh ]; then
        /var/scripts/history.sh
fi
mesg n
bash /var/scripts/pre_setup.sh
ROOT-PROFILE

# External HD	
echo -e "\e[32m"
echo "This might take a while, copying everything from SD card to HD. Just wait untill system continues."
echo -e "\e[0m"
sleep 2
sed -i 's|/dev/mmcblk0p2|/dev/sda2|g' /etc/fstab # change ROOT device so the system will know which one to use as ROOT
echo -ne '\n' | sudo mke2fs -t ext4 -b 4096 -L 'PI_ROOT' /dev/sda2 # make ext4 partition to hold ROOT
dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda2 # copy the content of the SD ROOT partition to the new HD ROOT partition

# Remove SD card ROOT partition
fdisk /dev/mmcblk0 << EOF
d
2
w
EOF

echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| After this reboot log back in with ocadmin///owncloud              |"
echo    "| The installation will then automatically begin.                    |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to continue..." -n1 -s
echo -e "\e[0m"
echo
reboot

else
# Resize sd card
fdisk $device << EOF
d
2
w
EOF
sync

fdisk $device << EOF
n
p
2


w
EOF
sync

echo
# Install swapfile of 2 GB
fallocate -l 2048M /swapfile # create swapfile and set size
chmod 600 /swapfile # give it the right permissions
mkswap /swapfile # format as swap
swapon /swapfile # announce to system
echo "/swapfile none swap defaults 0 0" >> /etc/fstab # let the system know what file to use as swap after reboot

# Change back root/.profile
rm $ROOT_PROFILE
ouch $ROOT_PROFILE
at <<-ROOT-PROFILE > "$ROOT_PROFILE"
## ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/setup.sh ]; then
        /var/scripts/setup.sh
fi
if [ -x /var/scripts/history.sh ]; then
        /var/scripts/history.sh
fi
mesg n
bash /var/scripts/pre_setup.sh
ROOT-PROFILE
fi

exit 0
