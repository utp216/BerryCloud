#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
HTML=/var/www/html
OCPATH=$HTML/owncloud
DATA=/owncloud/data

# Setup fail2ban
sudo -u www-data php $OCPATH/occ config:system:set loglevel --value="2"
sudo -u www-data php $OCPATH/occ config:system:set logfile --value="$DATA/owncloud.log"

# Add fail2ban config
cat <<-FAIL2BAN-OWNCLOUD > "/etc/fail2ban/filter.d/owncloud.conf"
[Definition] failregex={"reqId":".*","remoteAddr":"<HOST>","app":"core","message":"Login failed: .*","level":2,"time":".*"}
FAIL2BAN-OWNCLOUD

# Add fail2ban jail
cat <<-FAIL2BAN-OWNCLOUD-JAIL > "/etc/fail2ban/filter.d/owncloud.conf"
[owncloud]
enabled = true
filter  = owncloud
port    = https
bantime  = 3000
findtime = 600
maxretry = 4
logpath = $DATA/owncloud.log
FAIL2BAN-OWNCLOUD-JAIL

# Restart fail2ban
sudo service fail2ban restart
