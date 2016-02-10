device="/dev/sda"
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

# Swap
sudo apt-get install parted
mkswap -L PI_SWAP /dev/sda1 # format as swap
swapon /dev/sda1 # announce to system
echo "/dev/sda1 none swap sw 0 0" >> /etc/fstab

# Update tables
partprobe # notify kernel with the changes made
#sudo bash /var/scripts/usbhd2.sh
#sed -i 's|bash /var/scripts/usbhd.sh|#bash /var/scripts/usbhd.sh|g' /root/.profile
#sed -i 's|#bash /var/scripts/usbhd2.sh|bash /var/scripts/usbhd2.sh|g' /root/.profile

# External HD	
echo "This might take a while, copying everything from SD card to HD. Just wait untill system continues."
echo -ne '\n' | sudo mke2fs -t ext4 -b 4096 -L 'PI_ROOT' /dev/sda2 # make ext4 partition to hold ROOT
dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda2 # copy the content of the SD ROOT partition to the new HD ROOT partition
sed -i 's|/dev/mmcblk0p2|/dev/sda2|g' /etc/fstab # change ROOT device so the system will know which one to use as ROOT
	
# Change back root/.profile
ROOT_PROFILE="/root/.profile"

rm /root/.profile

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
ROOT-PROFILE

else
echo
# Install swapfile of 2 GB
fallocate -l 2048M /swapfile # create swapfile and set size
chmod 600 /swapfile # give it the right permissions
mkswap /swapfile # format as swap
swapon /swapfile # announce to system
echo "/swapfile none swap defaults 0 0" >> /etc/fstab # let the system know what file to use as swap after reboot
fi
