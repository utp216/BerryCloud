#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud

sudo apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
sudo useradd -d /home/$USERNAME -m $USERNAME && sudo usermod -aG sudo $USERNAME && echo $USERNAME:$USERPASS | chpasswd
sudo reboot
