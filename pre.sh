#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud

sudo apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
#sudo useradd -d /home/$USERNAME -m $USERNAME && sudo usermod -aG sudo $USERNAME && echo $USERNAME:$USERPASS | chpasswd
#userdel ubuntu
#rm -rf /home/ubuntu
fdisk $device << EOF
d
2
n
p
2


w
EOF
cd /tmp
wget http://archive.raspberrypi.org/debian/pool/main/r/raspi-config/raspi-config_20150131-5_all.deb
apt-get install libnewt0.52 whiptail parted triggerhappy lua5.1 -y
dpkg -i raspi-config_20150131-5_all.deb
raspi-config
sudo reboot
