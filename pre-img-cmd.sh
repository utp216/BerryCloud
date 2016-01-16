#!/bin/bash

# Tech and Me, 2016 - www.techandme.se

USERNAME=ocadmin
USERPASS=owncloud

sudo apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
sudo apt-get install -y net-tools sudo nano git linux-firmware dnsutils language-pack-en-base expect aptitude dialog lvm2 ntp curl initscripts keyboard-configuration 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
sudo useradd -d /home/$USERNAME -m $USERNAME && sudo usermod -aG sudo $USERNAME && echo $USERNAME:$USERPASS | chpasswd
sed -i 's|    SendEnv LANG LC_*|#   SendEnv LANG LC_*|g' /etc/ssh/ssh_config
sed -i 's|AcceptEnv LANG LC_*|#AcceptEnv LANG LC_*|g' /etc/ssh/sshd_config
