#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud
device=/dev/mmcblk0

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
raspi-config
sudo reboot
