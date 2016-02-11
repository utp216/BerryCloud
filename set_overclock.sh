function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Do you want to overclock your RaspberryPI2?") ]]
then
  function ask_yes_or_no() {
      read -p "$1 ([y]es or [N]o): "
      case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
          y|yes) echo "yes" ;;
          *)     echo "no" ;;
      esac
  }
  if [[ "yes" == $(ask_yes_or_no "Do you want to overclock and keep warranty on your device enter yes, else for max speed press no?") ]]
  then

  else
  fi
else
fi
exit 0
