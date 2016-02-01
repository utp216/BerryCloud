# Use external harddrive to mount os and sd card to boot
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "We are now setting up your USB harddrive to mount the os, please attach your USB harddrive now, if you have not done so and type yes.") ]]
then
	dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda1
	sed -i 's|root=/dev/mmcblk0p2|root=/dev/sda1|g' /boot/cmdline.txt
#else
echo
    echo "If you want to do this later: bash /var/scripts/usbhd.sh"
    echo -e "\e[32m"
    read -p "Press any key to continue... " -n1 -s
    echo -e "\e[0m"
fi
