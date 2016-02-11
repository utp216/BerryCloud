function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Do you want to overclock your RaspberryPI2?") ]]
then
######################################
  function ask_yes_or_no() {
      read -p "$1 ([y]es or [N]o): "
      case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
          y|yes) echo "yes" ;;
          *)     echo "no" ;;
      esac
  }
  if [[ "yes" == $(ask_yes_or_no "Do you want to overclock and keep warranty on your device enter yes, else for max speed press no?") ]]
  then
    mount /dev/mmcblk0p1 /mnt
    rm config.txt
    wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/config_warranty_overclock.txt -P /mnt
    mv /mnt/config_warranty_overclock.txt /mnt/config.txt
    umount /mnt
  else
    mount /dev/mmcblk0p1 /mnt
    rm config.txt
    wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/config_warrenty_void.txt -P /mnt
    mv /mnt/config_warranty_void.txt /mnt/config.txt
    umount /mnt
  fi
#######################################  
else
sleep 1
fi

exit 0
