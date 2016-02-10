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
dd if=/dev/zero of=/dev/sda
fdisk $device << EOF
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +2000M # 2000 MB swap partition
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # print the in-memory partition table
  w # write the partition table
EOF

# Swap
mkswap -L PI_SWAP /dev/sda1
swapon /dev/sda1
echo "/dev/sda1 none swap sw 0 0" >> /etc/fstab

# Update tables
partprobe
sudo bash /var/scripts/usbhd2.sh
#sed -i 's|bash /var/scripts/usbhd.sh|#bash /var/scripts/usbhd.sh|g' /root/.profile
#sed -i 's|#bash /var/scripts/usbhd2.sh|bash /var/scripts/usbhd2.sh|g' /root/.profile

else
echo
# Install swapfile of 2 GB
fallocate -l 2048M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab
fi
