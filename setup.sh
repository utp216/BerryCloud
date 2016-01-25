#!/bin/bash

# Tech and Me, 2016 - www.techandme.se

mysql_pass=owncloud
OCVERSION=owncloud-8.2.2.zip
SCRIPTS=/var/scripts
HTML=/var/www/html
OCPATH=$HTML/owncloud
ssl_conf="/etc/apache2/sites-available/owncloud_ssl_domain_self_signed.conf"
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
INTERFACES="/etc/network/interfaces"
ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
NETMASK=$(ifconfig eth0 | grep Mask | sed s/^.*Mask://)
GATEWAY=$(/sbin/ip route | awk '/default/ { print $3 }')

clear
echo "+--------------------------------------------------------------------+"
echo "| This script will install your ownCloud and activate SSL.           |"
echo "| It will do alot more, nano/vi the script to see what.              |"
echo "|                                                                    |"
echo "|                                                                    |"
echo "|   The script will take about 60 minutes to finish,                 |"
echo "|   depending on your internet connection and if you overclocked     |"
echo "|                      your RaspberryPi2                             |"
echo "|                                                                    |"
echo "|   We offer more aswome Virtual Machines, guides and news           |"
echo "|         on our website https://www.techandme.se                    |"
echo "|                                                                    |"
echo "| ####################### Tech and Me - 2016 ####################### |"
echo "+--------------------------------------------------------------------+"
echo -e "\e[32m"
read -p "Press any key to start the script..." -n1 -s
clear
echo -e "\e[0m"


# Check if root
        if [ "$(whoami)" != "root" ]; then
        echo
        echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash $SCRIPTS/owncloud_install.sh"
        echo
        exit 1
fi

# Install swapfile of 2 GB
fallocate -l 2048M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap defaults 0 0" >> /etc/fstab

# Resolve network error
echo "auto eth0
   iface eth0 inet dhcp" >> /etc/network/interfaces

      	# Create dir
if 		[ -d $SCRIPTS ];
	then
      		sleep 1
      	else
      		mkdir $SCRIPTS
fi

# Get ownCloud install script
#if 		[ -f $SCRIPTS/owncloud_install.sh ];
#        then
#                echo "owncloud_install.sh exists"
#        else
#        	wget wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/owncloud_install.sh -P $SCRIPTS
#fi

# Get Redis install script
if 		[ -f $SCRIPTS/install-redis-php-7.sh ];
        then
                echo "install-redis-php-7.sh exists"
        else
        	wget wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/install-redis-php-7.sh -P $SCRIPTS
fi
# Activate SSL
if 		[ -f $SCRIPTS/activate-ssl.sh ];
        then
                echo "activate-ssl.sh exists"
        else
        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/lets-encrypt/activate-ssl.sh -P $SCRIPTS
fi
# The update script
if 		[ -f $SCRIPTS/owncloud_update.sh ];
        then
        	echo "owncloud_update.sh exists"
        else
        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/owncloud_update.sh -P $SCRIPTS
fi
# Sets static IP to UNIX
if 		[ -f $SCRIPTS/ip.sh ];
        then
                echo "ip.sh exists"
        else
      		wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/ip.sh -P $SCRIPTS
fi
# Tests connection after static IP is set
if 		[ -f $SCRIPTS/test_connection.sh ];
        then
                echo "test_connection.sh exists"
        else
        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/test_connection.sh -P $SCRIPTS
fi
# Welcome message after login (change in /home/ocadmin/.profile
#if 		[ -f $SCRIPTS/instruction.sh ];
#        then
#                echo "instruction.sh exists"
#        else
#        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/instruction.sh -P $SCRIPTS
#fi
# Clears command history on every login
if 		[ -f $SCRIPTS/history.sh ];
        then
                echo "history.sh exists"
        else
        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/history.sh -P $SCRIPTS
fi
# Change roots .bash_profile
#if 		[ -f $SCRIPTS/change-root-profile.sh ];
#        then
#                echo "change-root-profile.sh exists"
#        else
#        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/change-root-profile.sh -P $SCRIPTS
#fi
# Change ocadmin .bash_profile
#if 		[ -f $SCRIPTS/change-ocadmin-profile.sh ];
#        then
#        	echo "change-ocadmin-profile.sh  exists"
#        else
#        	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/change-ocadmin-profile.sh -P $SCRIPTS
#fi
# Get startup-script for root
#if 		[ -f $SCRIPTS/owncloud-startup-script.sh ];
#        then
#                echo "owncloud-startup-script.sh exists"
#        else
#       	wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/owncloud-startup-script.sh -P $SCRIPTS
#fi

# Make $SCRIPTS excutable
        	chmod +x -R $SCRIPTS
        	chown root:root -R $SCRIPTS

# Allow ocadmin to run theese scripts
        	chown ocadmin:ocadmin $SCRIPTS/instruction.sh
        	chown ocadmin:ocadmin $SCRIPTS/history.sh

# Get the Welcome Screen when http://$address
if 		[ -f $HTML/index.php ];
	then
 		rm $HTML/index.php
 		wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/index.php -P $HTML
 		chmod 750 $HTML/index.php && chown www-data:www-data $HTML/index.php
 	else	
		wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/index.php -P $HTML
		chmod 750 $HTML/index.php && chown www-data:www-data $HTML/index.php
fi	
# Remove the regular index.html if it exists
if		[ -f $HTML/index.html ];
        then
                rm -f $HTML/index.html
fi

# Change .profile
#        	bash $SCRIPTS/change-root-profile.sh
#        	bash $SCRIPTS/change-ocadmin-profile.sh

sudo apt-get install -y net-tools sudo nano git linux-firmware dnsutils language-pack-en-base expect aptitude dialog lvm2 ntp curl initscripts keyboard-configuration #python
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C

# Remove locale error over ssh in other language
sed -i 's|    SendEnv LANG LC_*|#   SendEnv LANG LC_*|g' /etc/ssh/ssh_config
sed -i 's|AcceptEnv LANG LC_*|#AcceptEnv LANG LC_*|g' /etc/ssh/sshd_config

# Resolve an issue with php7
#export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8

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

# Change DNS
echo "nameserver 8.26.56.26" > /etc/resolv.conf
echo "nameserver 8.20.247.20" >> /etc/resolv.conf

# Check network
sudo ifdown $IFACE && sudo ifup $IFACE
nslookup google.com
if [[ $? > 0 ]]
then
    echo "Network NOT OK. You must have a working Network connection to run this script."
    exit
else
    echo "Network OK."
fi

# Update system
apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y

# Set locales
sudo locale-gen "en_US.UTF-8" && sudo dpkg-reconfigure locales

# Install MYSQL 5.6
apt-get install software-properties-common -y
sudo LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/mysql-5.6
echo "mysql-server-5.6 mysql-server/root_password password $mysql_pass" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password $mysql_pass" | debconf-set-selections
apt-get install mysql-server-5.6 -y

# mysql_secure_installation
apt-get -y install expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$mysql_pass\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"
apt-get remove --purge expect -y

# Install Apache
apt-get install apache2 -y
a2enmod rewrite \
        headers \
        env \
        dir \
        mime \
        ssl \
        setenvif
        
# Set hostname and ServerName
sudo sh -c "echo 'ServerName owncloud' >> /etc/apache2/apache2.conf"
sudo hostnamectl set-hostname owncloud 
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 owncloud" >> /etc/hosts
service apache2 restart

# Install PHP 7
apt-get install software-properties-common -y && echo -ne '\n' | sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php-7.0
# sudo add-apt-repository ppa:ondrej/php-7.0
apt-get update
apt-get install -y \
        php7.0 \
        php7.0-common \
        php7.0-mysql \
        php7.0-intl \
        php7.0-mcrypt \
        php7.0-ldap \
        php7.0-imap \
        php7.0-cli \
        php7.0-gd \
        php7.0-pgsql \
        php7.0-json \
        php7.0-sqlite3 \
        php7.0-curl \
        libsm6 \
        libsmbclient

# Download $OCVERSION
wget https://download.owncloud.org/community/$OCVERSION -P $HTML
apt-get install unzip -y
unzip -q $HTML/$OCVERSION -d $HTML 
rm $HTML/$OCVERSION

# Create data folder, occ complains otherwise
mkdir $OCPATH/data

# Secure permissions
wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/setup_secure_permissions_owncloud.sh -P $SCRIPTS
bash $SCRIPTS/setup_secure_permissions_owncloud.sh

# Install ownCloud
cd $OCPATH
sudo -u www-data php occ maintenance:install --database "mysql" --database-name "owncloud_db" --database-user "root" --database-pass "$mysql_pass" --admin-user "ocadmin" --admin-pass "owncloud"
echo
echo ownCloud version:
sudo -u www-data php $OCPATH/occ status
echo
sleep 3

# Set trusted domain
cat <<TRUSTED >> /var/www/html/owncloud/config/config.php
'trusted_domains' =>
  array (
    0 => '$ADDRESS',
  ),
'overwrite.cli.url' => 'http://$ADDRESS/owncloud',
);
TRUSTED
#wget https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/update-config.php -P $SCRIPTS
#chmod a+x $SCRIPTS/update-config.php
#php $SCRIPTS/update-config.php $OCPATH/config/config.php 'trusted_domains[]' localhost ${ADDRESS[@]} $(hostname) $(hostname --fqdn)
#php $SCRIPTS/update-config.php $OCPATH/config/config.php overwrite.cli.url https://$ADDRESS/owncloud

# Prepare cron.php to be run every 15 minutes
# The user still has to activate it in the settings GUI
crontab -u www-data -l | { cat; echo "*/15  *  *  *  * php -f $OCPATH/cron.php > /dev/null 2>&1"; } | crontab -u www-data -

# Change values in php.ini (increase max file size)
# max_execution_time
sed -i "s|max_execution_time = 30|max_execution_time = 3500|g" /etc/php/7.0/apache2/php.ini
# max_input_time
sed -i "s|max_input_time = 60|max_input_time = 3600|g" /etc/php/7.0/apache2/php.ini
# memory_limit
sed -i "s|memory_limit = 128M|memory_limit = 512M|g" /etc/php/7.0/apache2/php.ini
# post_max
sed -i "s|post_max_size = 8M|post_max_size = 1100M|g" /etc/php/7.0/apache2/php.ini
# upload_max
sed -i "s|upload_max_filesize = 2M|upload_max_filesize = 1000M|g" /etc/php/7.0/apache2/php.ini

# Generate $ssl_conf
if [ -f $ssl_conf ];
        then
        echo "Virtual Host exists"
else
        touch "$ssl_conf"
        cat << SSL_CREATE > "$ssl_conf"
<VirtualHost *:443>
    Header add Strict-Transport-Security: "max-age=15768000;includeSubdomains"
    SSLEngine on
### YOUR SERVER ADDRESS ###
    ServerAdmin admin@test.com
    ServerName test.com
    ServerAlias test.test.com 
### SETTINGS ###
    DocumentRoot $OCPATH

    <Directory $OCPATH>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
    Satisfy Any 
    </Directory>

    Alias /owncloud "$OCPATH/"

    <IfModule mod_dav.c>
    Dav off
    </IfModule>

    SetEnv HOME $OCPATH
    SetEnv HTTP_HOME $OCPATH
### LOCATION OF CERT FILES ###
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
</VirtualHost>
SSL_CREATE
echo "$ssl_conf was successfully created"
sleep 3
fi

# Enable new config
a2ensite owncloud_ssl_domain_self_signed.conf
a2dissite default-ssl
service apache2 restart

## Set config values
# Experimental apps
sudo -u www-data php $OCPATH/occ config:system:set appstore.experimental.enabled --value="true"
# Default mail server (make this user configurable?)
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpmode --value="smtp"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpauth --value="1"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpport --value="465"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtphost --value="smtp.gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpauthtype --value="LOGIN"
sudo -u www-data php $OCPATH/occ config:system:set mail_from_address --value="www.en0ch.se"
sudo -u www-data php $OCPATH/occ config:system:set mail_domain --value="gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpsecure --value="ssl"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpname --value="www.en0ch.se@gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtppassword --value="hejasverige"

# Install Libreoffice Writer to be able to read MS documents.
echo -ne '\n' | sudo apt-add-repository ppa:libreoffice/libreoffice-4-4
apt-get update
sudo apt-get install --no-install-recommends libreoffice-writer -y

# Download and install Documents
if [ -d $OCPATH/apps/documents ]; then
sleep 1
else
wget https://github.com/owncloud/documents/archive/master.zip -P $OCPATH/apps
cd $OCPATH/apps
unzip -q master.zip
rm master.zip
mv documents-master/ documents/
fi

# Enable documents
if [ -d $OCPATH/apps/documents ]; then
sudo -u www-data php $OCPATH/occ app:enable documents
sudo -u www-data php $OCPATH/occ config:system:set preview_libreoffice_path --value="/usr/bin/libreoffice"
fi

# Download and install Contacts
if [ -d $OCPATH/apps/contacts ]; then
sleep 1
else
wget https://github.com/owncloud/contacts/archive/master.zip -P $OCPATH/apps
unzip -q $OCPATH/apps/master.zip -d $OCPATH/apps
cd $OCPATH/apps
rm master.zip
mv contacts-master/ contacts/
fi

# Enable Contacts
if [ -d $OCPATH/apps/contacts ]; then
sudo -u www-data php $OCPATH/occ app:enable contacts
fi

# Download and install Calendar
if [ -d $OCPATH/apps/calendar ]; then
sleep 1
else
wget https://github.com/owncloud/calendar/archive/master.zip -P $OCPATH/apps
unzip -q $OCPATH/apps/master.zip -d $OCPATH/apps
cd $OCPATH/apps
rm master.zip
mv calendar-master/ calendar/
fi

# Enable Calendar
if [ -d $OCPATH/apps/calendar ]; then
sudo -u www-data php $OCPATH/occ app:enable calendar
fi


# Set secure permissions final (./data/.htaccess has wrong permissions otherwise)
bash $SCRIPTS/setup_secure_permissions_owncloud.sh

# Install packages for Webmin
apt-get install --force-yes -y zip perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python

# Install Webmin
cd
wget http://prdownloads.sourceforge.net/webadmin/webmin_1.780_all.deb
dpkg --install webmin_1.780_all.deb
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
ADDRESS=$($IFCONFIG $IFACE | awk -F'[: ]+' '/\<inet\>/ {print $4; exit}')
echo
echo "Webmin is installed, access it from your browser: https://$ADDRESS:10000"
sleep 2
clear

# Set keyboard layout
echo "Current keyboard layout is English"
echo "You must change keyboard layout to your language"
echo -e "\e[32m"
read -p "Press any key to change keyboard layout... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure keyboard-configuration
echo
clear

# Change Timezone
echo "Current Timezone is Europe/Amsterdam"
echo "You must change timezone to your timezone"
echo -e "\e[32m"
read -p "Press any key to change timezone... " -n1 -s
echo -e "\e[0m"
dpkg-reconfigure tzdata
echo
sleep 3
clear

# Change IP
echo -e "\e[0m"
echo "The script will now configure your IP to be static."
echo -e "\e[36m"
echo -e "\e[1m"
echo "Your internal IP is: $ADDRESS"
echo -e "\e[0m"
echo -e "Write this down, you will need it to set static IP"
echo -e "in your router later. It's included in this guide:"
echo -e "https://www.techandme.se/open-port-80-443/ (step 1 - 5)"
echo -e "\e[32m"
read -p "Press any key to set static IP..." -n1 -s
clear
echo -e "\e[0m"
ifdown eth0
sleep 2
ifup eth0
sleep 2

cat <<-IPCONFIG > "$INTERFACES"
        auto lo $IFACE
        iface lo inet loopback
        iface $IFACE inet static
                address $ADDRESS
                netmask $NETMASK
                gateway $GATEWAY
# Exit and save:	[CTRL+X] + [Y] + [ENTER]
# Exit without saving:	[CTRL+X]
IPCONFIG

ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
echo "Testing if network is OK..."
sleep 1
echo
bash /var/scripts/test_connection.sh
sleep 2
echo
echo -e "\e[0mIf the output is \e[32mConnected! \o/\e[0m everything is working."
echo -e "\e[0mIf the output is \e[31mNot Connected!\e[0m you should change\nyour settings manually in the next step."
echo -e "\e[32m"
read -p "Press any key to open /etc/network/interfaces..." -n1 -s
echo -e "\e[0m"
nano /etc/network/interfaces
clear &&
echo "Testing if network is OK..."
ifdown eth0
sleep 2
ifup eth0
sleep 2
echo
bash /var/scripts/test_connection.sh
sleep 2
clear

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [root]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
sudo passwd root

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [ocadmin]"
echo "The current password is [owncloud]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
sudo passwd ocadmin
if [[ $? > 0 ]]
then
    sudo passwd ocadmin
else
    sleep 2
fi
echo
clear &&
echo -e "\e[0m"

echo "For better security, change the ownCloud password for [ocadmin]"
echo "The current password is [owncloud]"
echo -e "\e[32m"
read -p "Press any key to change password for ownCloud... " -n1 -s
echo -e "\e[0m"
sudo -u www-data php /var/www/html/owncloud/occ user:resetpassword ocadmin
if [[ $? > 0 ]]
then
    sudo -u www-data php /var/www/html/owncloud/occ user:resetpassword ocadmin
else
    sleep 2
fi

# Get the latest active-ssl script
        cd /var/scripts
        rm /var/scripts/activate-ssl.sh
        wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/lets-encrypt/activate-ssl.sh
        chmod 755 /var/scripts/activate-ssl.sh
clear
# Let's Encrypt
function ask_yes_or_no() {
    read -p "$1 ([y]es or [N]o): "
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) echo "yes" ;;
        *)     echo "no" ;;
    esac
}
if [[ "yes" == $(ask_yes_or_no "Last but not least, do you want to install a real SSL cert (from Let's Encrypt) on this machine?") ]]
then
	sudo bash /var/scripts/activate-ssl.sh
else
echo
    echo "OK, but if you want to run it later, just type: bash /var/scripts/activate-ssl.sh"
    echo -e "\e[32m"
    read -p "Press any key to continue... " -n1 -s
    echo -e "\e[0m"
fi

# Install Redis
bash /var/scripts/install-redis-php-7.sh
echo
redis-cli ping
echo Testing Redis: PING
echo
sleep 3

# Upgrade system
clear
echo System will now upgrade...
sleep 2
echo
echo
apt-get update
apt-get upgrade -y

# Cleanup 1
apt-get autoremove -y
CLEARBOOT=$(dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | xargs sudo apt-get -y purge)
echo "$CLEARBOOT"
clear

# Use external harddrive to mount os and sd card to boot
echo "We are now setting up your USB harddrive to mount the os, please attach your USB harddrive now, if you have not done so."
echo -e "\e[32m"
read -p "Press any key to confirm the harddrive is plugged in and only one storage device is plugged in... " -n1 -s
echo -e "\e[0m"
dd bs=1M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda1 -v
sed -i 's|root=/dev/mmcblk0p2|root=/dev/sda1|g' /boot/cmdline.txt

# Success!
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| You have sucessfully installed ownCloud! System will now reboot... |"
echo    "|                                                                    |"
echo -e "|         \e[0mLogin to ownCloud in your browser:\e[36m" $ADDRESS"\e[32m           |"
echo    "|                                                                    |"
echo -e "|         \e[0mPublish your server online! \e[36mhttp://goo.gl/H7IsHm\e[32m           |"
echo    "|                                                                    |"
echo -e "|    \e[91m#################### Tech and Me - 2016 ####################\e[32m    |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to reboot..." -n1 -s
echo -e "\e[0m"
echo

# Cleanup 2
sudo -u www-data php /var/www/html/owncloud/occ maintenance:repair
apt-get remove --purge expect
#rm /var/scripts/owncloud-startup-script.sh
#rm /var/scripts/ip.sh
#rm /var/scripts/test_connection.sh
#rm /var/scripts/change-ocadmin-profile.sh
#rm /var/scripts/change-root-profile.sh
#rm /var/scripts/install-redis-php-7.sh
#rm /var/scripts/index.html
#rm /var/scripts/update-config.php
#rm /var/www/html/index.html
#rm /var/scripts/owncloud_install.sh
#rm /var/rc.local
#rm /var/www/html/owncloud/data/owncloud.log
#cat /dev/null > ~/.bash_history
#cat /dev/null > /var/spool/mail/root
#cat /dev/null > /var/spool/mail/ocadmin
#cat /dev/null > /var/log/apache2/access.log
#cat /dev/null > /var/log/apache2/error.log
#cat /dev/null > /var/log/cronjobs_success.log
#sed -i 's/sudo -i//g' /home/ocadmin/.bash_profile
#cat << RCLOCAL > "/etc/rc.local"
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
#
#exit 0
#
#RCLOCAL

## Reboot
reboot
exit 0
