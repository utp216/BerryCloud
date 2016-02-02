#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud
device=/dev/mmcblk0
ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')

# Add repository's
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid universe|deb http://ports.ubuntu.com/ubuntu-ports/ vivid universe|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid universe|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid universe|g" /etc/apt/sources.list
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid-updates universe|deb http://ports.ubuntu.com/ubuntu-ports/ vivid-updates universe|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-updates universe|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-updates universe|g" /etc/apt/sources.list
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid-backports main restricted|deb http://ports.ubuntu.com/ubuntu-ports/ vivid-backports main restricted|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-backports main restricted|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-backports main restricted|g" /etc/apt/sources.list
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security main restricted|deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security main restricted|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security main restricted|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security main restricted|g" /etc/apt/sources.list
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security universe|deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security universe|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security universe|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security universe|g" /etc/apt/sources.list
sed -i "s|# deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security multiverse|deb http://ports.ubuntu.com/ubuntu-ports/ vivid-security multiverse|g" /etc/apt/sources.list
sed -i "s|# deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security multiverse|deb-src http://ports.ubuntu.com/ubuntu-ports/ vivid-security multiverse|g" /etc/apt/sources.list

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
