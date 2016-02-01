# Use external harddrive to mount os and sd card to boot
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Do you want to use an external HD for ROOT partition? Also attach it before typing yes!!") ]]
then
# Format and create partition
	echo -e "\e[32m"
	read -p "If it asks to overwrite anything just hit yes, make sure there are no needed files on the hd. Press any key to start the script..." -n1 -s
	echo -e "\e[0m"
	sudo mkfs.ext4 /dev/sda1
fdisk /dev/sda1 << EOF
wipefs
EOF
fdisk /dev/sda1 << EOF
o
n
p
1
1

w
EOF

	dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda1
	sed -i 's|/dev/mmcblk0p2|/dev/sda1|g' /etc/fstab
else
echo
    echo "If you want to do this later: bash /var/scripts/usbhd.sh"
    echo -e "\e[32m"
    read -p "Press any key to continue... " -n1 -s
    echo -e "\e[0m"
fi
