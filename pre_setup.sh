#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
USERNAME=ocadmin
USERPASS=owncloud
device=/dev/mmcblk0
ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
SCRIPTS=/var/scripts

# Check if root
        if [ "$(whoami)" != "root" ]; then
        echo
        echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash /var/scripts/pre_setup.sh"
        echo
        exit 1
fi

apt-get autoremove -y && apt-get autoclean -y && apt-get update && apt-get upgrade -y && apt-get -f install -y
apt-get install expect lvm2 openssh-server -y
#useradd -d /home/$USERNAME -m $USERNAME && sudo usermod -aG sudo $USERNAME && echo $USERNAME:$USERPASS | chpasswd
apt-get update && apt-get upgrade -y && apt-get -f install -y

# Ask overclock
bash $SCRIPTS/set_overclock.sh

# Change login scripts
sed -i 's|#bash /var/scripts/instructions.sh|bash /var/scripts/instructions.sh|g' /home/ocadmin/.profile
sed -i 's|bash /var/scripts/pre_setup_message.sh|#bash /var/scripts/pre_setup_message.sh|g' /home/ocadmin/.profile

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
#bash /var/scripts/usbhd2.sh
ROOT-PROFILE

# Change back rc.local
rm /etc/rc.local
cat << RCLOCAL > "/etc/rc.local"
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
sysctl -w net.core.somaxconn=65535

exit 0

RCLOCAL

# Set permissions for rc.local
chmod 755 /etc/rc.local

clear
# Success!
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| Your ip is $ADDRESS ssh is now installed so you can disconnect your|"
echo    "| Monitor and continue the installation over ssh, after the reboot.  |"
echo    "| After this reboot log back in with ocadmin///owncloud              |"
echo    "| The installation will then automatically begin.                    |"
echo    "|                                                                    |"
echo    "|                        ***SSH***                                   |"
echo    "| 1. Open a terminal on laptop/desktop (ctrl + alt + T for linux)    |"
echo    "| 2. Execute the command: sudo apt-get install openssh-client        |"
echo    "| 3. Execute the command: ssh -l ocadmin $ADDRESS                    |"
echo    "| 4. Type password: owncloud                                         |"
echo    "| 5. Follow the instructions                                         |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to continue..." -n1 -s
echo -e "\e[0m"
echo
clear

# Reboot
reboot

exit 0
