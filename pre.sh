#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud
device=/dev/mmcblk0
ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')

sudo apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
sudo apt-get install openssh-server -y
#sudo useradd -d /home/$USERNAME -m $USERNAME && sudo usermod -aG sudo $USERNAME && echo $USERNAME:$USERPASS | chpasswd

# Resize sd card
fdisk $device << EOF
d
2
n
p
2


w
EOF

# Install raspi-config
cd /tmp
wget http://archive.raspberrypi.org/debian/pool/main/r/raspi-config/raspi-config_20150131-5_all.deb
apt-get install libnewt0.52 whiptail parted triggerhappy lua5.1 -y
dpkg -i raspi-config_20150131-5_all.deb
# Overclock
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| I recommend you to use one of the overclock settings, which do not |"
echo    "| Void warrenty as stated on the RPI2 site. If you want to use the   |"
echo    "| Max overclock settings, visit BerryCloud @ gitgub                  |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to enter overclock menu (only overclock dont use other settings and don't update, it will break overclocking)..." -n1 -s
echo -e "\e[0m"
echo
raspi-config

# Change login scripts
sed -i 's|#bash /var/scripts/instructions.sh|bash /var/scripts/instructions.sh|g' /home/ocadmin/.profile
sed -i 's|bash /var/scripts/pre1.sh|#bash /var/scripts/pre1.sh|g' /home/ocadmin/.profile
sed -i 's|bash /var/scripts/pre.sh|#bash /var/scripts/pre.sh|g' /home/ocadmin/.profile
sed -i 's|#sudo -i|sudo -i|g' /home/ocadmin/.profile

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
sudo chmod 755 /etc/rc.local

# Success!
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| Your ip is $ADDRESS ssh is now install so you can disconnect your  |"
echo    "| Monitor and continue the installation over ssh, after reboot.      |"
echo    "| After this reboot log back in with ocadmin///owncloud              |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo
sudo reboot
