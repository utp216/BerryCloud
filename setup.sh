#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
# MySql
MYSQL_PASS=$(cat /dev/urandom | tr -dc "a-zA-Z0-9@#*=" | fold -w $SHUF | head -n 1)
SHUF=$(shuf -i 27-38 -n 1)
PW_FILE=/var/mysql_password.txt
# ownCloud
CONFIG=$HTML/owncloud/config/config.php
OCVERSION=owncloud-9.0.0.zip
SCRIPTS=/var/scripts
HTML=/var/www/html
OCPATH=/var/www/html/owncloud
DATA=/owncloud/data
MYSQL_PASS_OC=$(cat /var/mysql_password.txt)
# Network
ssl_conf="/etc/apache2/sites-available/owncloud_ssl_domain_self_signed.conf"
IFACE="eth0"
IFCONFIG="/sbin/ifconfig"
IP="/sbin/ip"
INTERFACES="/etc/network/interfaces"
ADDRESS=$(ip route get 1 | awk '{print $NF;exit}')
NETMASK=$(ifconfig eth0 | grep Mask | sed s/^.*Mask://)
GATEWAY=$(/sbin/ip route | awk '/default/ { print $3 }')

# Check if root
        if [ "$(whoami)" != "root" ]; then
        echo
        echo -e "\e[31mSorry, you are not root.\n\e[0mYou must type: \e[36msudo \e[0mbash $SCRIPTS/setup.sh"
        echo
        exit 1
fi
# Resize sdcard
resize2fs /dev/mmcblk0p2
clear
dpkg-reconfigure keyboard-configuration

# Set hostname and ServerName
hostnamectl set-hostname owncloud 
echo "127.0.0.1 localhost" >> /etc/hosts
echo "127.0.1.1 owncloud" >> /etc/hosts

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

# Update
apt-get update && apt-get upgrade -y && apt-get -f install -y

# Update checker
#wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/update_checker.sh
#chmod 750 $SCRIPTS/update_checker.sh
#sed -i 's/sudo -i/bash /var/scripts/update_checker.sh/g' /home/ocadmin/.profile
sed -i 's/sudo -i//g' /home/ocadmin/.profile

# Remove locale error over ssh in other language
sed -i 's|    SendEnv LANG LC_*|#   SendEnv LANG LC_*|g' /etc/ssh/ssh_config
sed -i 's|AcceptEnv LANG LC_*|#AcceptEnv LANG LC_*|g' /etc/ssh/sshd_config

# Set locales
sudo locale-gen "en_US.UTF-8" && sudo dpkg-reconfigure locales

# Show MySQL pass, and write it to a file in case the user fails to write it down
touch $PW_FILE
echo
echo "$MYSQL_PASS" >> $PW_FILE
chmod 600 $PW_FILE
sleep 5
echo -e "Your MySQL root password is: \e[32m$MYSQL_PASS_OC\e[0m"
echo "Please save this somewhere safe. The password is also saved in this file: $PW_FILE."
echo -e "\e[32m"
read -p "Press any key to continue..." -n1 -s
echo -e "\e[0m"
sleep 5

# Install MYSQL 5.6
echo "mysql-server-5.6 mysql-server/root_password password $MYSQL_PASS_OC" | debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_PASS_OC" | debconf-set-selections
apt-get install mysql-server-5.6 -y

# mysql_secure_installation
apt-get -y install expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL_PASS_OC\r\"
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
sh -c "echo 'ServerName owncloud' >> /etc/apache2/apache2.conf"
service apache2 restart

# Remove the regular index.html if it exists
if		[ -f $HTML/index.html ];
        then
                rm -f $HTML/index.html
fi

# Test page
wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/index.php -P $HTML

# Install PHP 7
echo -ne '\n' | sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get install -y \
        php \
        php-common \
        php-mysql \
        php-intl \
        php-mcrypt \
        php-ldap \
        php-imap \
        php-cli \
        php-gd \
        php-pgsql \
        php-json \
        php-sqlite3 \
        php-curl \
        libsm6 \
        libsmbclient \
        smbclient

# Download $OCVERSION
wget https://download.owncloud.org/community/$OCVERSION -P $HTML
apt-get install unzip -y
unzip -q $HTML/$OCVERSION -d $HTML 
rm $HTML/$OCVERSION

# Create data folder, occ complains otherwise
mkdir $OCPATH/data

# Secure permissions
wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/setup_secure_permissions_owncloud.sh -P $SCRIPTS
bash $SCRIPTS/setup_secure_permissions_owncloud.sh

# Install ownCloud
sudo -u www-data php $OCPATH/occ maintenance:install --database "mysql" --database-name "owncloud_db" --database-user "root" --database-pass "$MYSQL_PASS_OC" --admin-user "ocadmin" --admin-pass "owncloud"

# Change data dir
sudo -u www-data php $OCPATH/occ config:system:set datadirectory --value="$DATA"
cp -aR $OCPATH/data/.htaccess $DATA
cp -aR $OCPATH/data/* $DATA
rm -rf $OCPATH/data
touch $DATA/.ocdata
rm $SCRIPTS/setup_secure_permissions_owncloud.sh

cat <<-PERMISSION > "$SCRIPTS/setup_secure_permissions_owncloud.sh"
#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
ocpath='/var/www/html/owncloud'
htuser='www-data'
htgroup='www-data'
rootuser='root'
data='/owncloud'


printf "Creating possible missing Directories\n"
mkdir -p $data
mkdir -p $ocpath/assets
mkdir -p $data/data

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
find ${data}/ -type f -print0 | xargs -0 chmod 0640
find ${data}/ -type d -print0 | xargs -0 chmod 0750

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${rootuser}:${htgroup} ${data}/
chown -R ${htuser}:${htgroup} ${data}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/

chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${data}/data/.htaccess ]
 then
  chmod 0644 ${data}/data/.htaccess
  chown ${rootuser}:${htgroup} ${data}/data/.htaccess
fi
PERMISSION

bash $SCRIPTS/setup_secure_permissions_owncloud.sh

# Setup fail2ban
#sudo bash $SCRIPTS/fail2ban.sh

# Show version and status
echo
echo ownCloud version:
sudo -u www-data php $OCPATH/occ status
echo
sleep 3

# Set trusted domain
bash $SCRIPTS/trusted.sh

# Prepare cron.php to be run every 15 minutes
# The user still has to activate it in the settings GUI
crontab -u www-data -l | { cat; echo "*/15  *  *  *  * php -f $OCPATH/cron.php > /dev/null 2>&1"; } | crontab -u www-data -
# Update virus defenitions daily at 03:30
crontab -u root -l | { cat; echo "*30  3  *  *  *  /usr/local/bin/freshclam –quiet"; } | crontab -u root -
# Run secure permissions script daily
cp -ar $SCRIPTS/setup_secure_permissions_owncloud.sh /etc/cron.daily/setup_secure_permissions_owncloud.sh
chmod 755 /etc/cron.daily/setup_secure_permissions_owncloud.sh

# Change values in php.ini (increase max file size)
# max_execution_time
sed -i "s|max_execution_time = 30|max_execution_time = 7000|g" /etc/php/7.0/apache2/php.ini
# max_input_time
sed -i "s|max_input_time = 60|max_input_time = 7000|g" /etc/php/7.0/apache2/php.ini
# memory_limit
sed -i "s|memory_limit = 128M|memory_limit = 512M|g" /etc/php/7.0/apache2/php.ini
# post_max
sed -i "s|post_max_size = 8M|post_max_size = 2000M|g" /etc/php/7.0/apache2/php.ini
# upload_max
sed -i "s|upload_max_filesize = 2M|upload_max_filesize = 1800M|g" /etc/php/7.0/apache2/php.ini

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

# Set config values
# Experimental apps
sudo -u www-data php $OCPATH/occ config:system:set appstore.experimental.enabled --value="true"
# Default mail server (make this user configurable?)
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpmode --value="smtp"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpauth --value="1"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpport --value="465"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtphost --value="smtp.gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpauthtype --value="LOGIN"
sudo -u www-data php $OCPATH/occ config:system:set mail_from_address --value="www.techandme.se"
sudo -u www-data php $OCPATH/occ config:system:set mail_domain --value="gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpsecure --value="ssl"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtpname --value="www.en0ch.se@gmail.com"
sudo -u www-data php $OCPATH/occ config:system:set mail_smtppassword --value="techandme_se"

# Install Libreoffice Writer to be able to read MS documents.
echo -ne '\n' | sudo add-apt-repository ppa:libreoffice/libreoffice-4-4
apt-get update
apt-get install --no-install-recommends libreoffice-writer -y

# Download and antivirus
if [ -d $OCPATH/apps/files_antivirus ]; then
sleep 1
else
wget https://github.com/owncloud/files_antivirus/archive/master.zip -P $OCPATH/apps
cd $OCPATH/apps
unzip -q stable8.2.zip
rm stable8.2.zip
mv files_antivirus-master/ files_antivirus/
fi

# Enable antivirus
if [ -d $OCPATH/apps/files_antivirus ]; then
sudo -u www-data php $OCPATH/occ app:enable files_antivirus
fi

# Download and install Documents
#if [ -d $OCPATH/apps/documents ]; then
#sleep 1
#else
#wget https://github.com/owncloud/documents/archive/master.zip -P $OCPATH/apps
#cd $OCPATH/apps
#unzip -q master.zip
#rm master.zip
#mv documents-master/ documents/
#fi

# Enable documents
if [ -d $OCPATH/apps/documents ]; then
sudo -u www-data php $OCPATH/occ app:enable documents
sudo -u www-data php $OCPATH/occ config:system:set preview_libreoffice_path --value="/usr/bin/libreoffice"
fi

# Download and install Contacts
#if [ -d $OCPATH/apps/contacts ]; then
#sleep 1
#else
#wget https://github.com/owncloud/contacts/archive/master.zip -P $OCPATH/apps
#unzip -q $OCPATH/apps/master.zip -d $OCPATH/apps
#cd $OCPATH/apps
#rm master.zip
#mv contacts-master/ contacts/
#fi

# Enable Contacts
if [ -d $OCPATH/apps/contacts ]; then
sudo -u www-data php $OCPATH/occ app:enable contacts
fi

# Download and install Calendar
#if [ -d $OCPATH/apps/calendar ]; then
#sleep 1
#else
#wget https://github.com/owncloud/calendar/archive/master.zip -P $OCPATH/apps
#unzip -q $OCPATH/apps/master.zip -d $OCPATH/apps
#cd $OCPATH/apps
#rm master.zip
#mv calendar-master/ calendar/
#fi

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
echo
echo "Webmin is installed, access it from your browser: https://$ADDRESS:10000"
sleep 2
clear

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [root]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
passwd root

# Change password
echo -e "\e[0m"
echo "For better security, change the Linux password for [ocadmin]"
echo "The current password is [owncloud]"
echo -e "\e[32m"
read -p "Press any key to change password for Linux... " -n1 -s
echo -e "\e[0m"
passwd ocadmin
if [[ $? > 0 ]]
then
    passwd ocadmin
else
    sleep 2
fi
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

# Add clamav-freshclam cmd to cron to update antivirus def.
echo "#!/bin/sh" >> /etc/cron.daily/freshclam.sh
echo "/usr/bin/freshclam --quiet" >> /etc/cron.daily/freshclam.sh
chmod 755 /etc/cron.daily/freshclam.sh

# Redirect http to https
echo "RewriteEngine On" >> $OCPATH/.htaccess
echo "RewriteCond %{HTTPS} off" >> $OCPATH/.htaccess
echo "RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R,L]" >> $OCPATH/.htaccess

# Get the latest active-ssl script
        cd /var/scripts
        rm /var/scripts/activate-ssl.sh
        wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/lets-encrypt/activate-ssl.sh
        chmod 755 /var/scripts/activate-ssl.sh
clear
# Let's Encrypt
#function ask_yes_or_no() {
#    read -p "$1 ([y]es or [N]o): "
#    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
#        y|yes) echo "yes" ;;
#        *)     echo "no" ;;
#    esac
#}
#if [[ "yes" == $(ask_yes_or_no "Last but not least, do you want to install a real SSL cert (from Let's Encrypt) on this machine?") ]]
#then
#	sudo bash /var/scripts/activate-ssl.sh
#else
#echo
#    echo "If you want to run the installation of a real ssl cert later, just type: bash /var/scripts/activate-ssl.sh"
#    echo -e "\e[32m"
#    read -p "Press any key to continue... " -n1 -s
#    echo -e "\e[0m"
#fi

# Install Redis
cd
bash /var/scripts/install-redis-php-7.sh
echo
redis-cli ping
echo Testing Redis: PING
echo
sleep 3

# Redis performance tweaks
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
sed -i 's|# unixsocket /tmp/redis.sock|unixsocket /var/run/redis.sock|g' /etc/redis/6379.conf
sed -i 's|# unixsocketperm 700|unixsocketperm 777|g' /etc/redis/6379.conf
sed -i 's|port 6379|port 0|g' /etc/redis/6379.conf
sed -i 's|host' => 'localhost|host' => '/var/run/redis.sock|g' $CONFIG
sed -i 's|port' => 6379,|port' => 0,|g' $CONFIG
service redis_6379 restart
sed -i 's|REDISPORT="6379"/REDISPORT="6379"\\\nSOCKET=/var/run/redis.sock/g' /etc/init.d/redis_6379
sed -i 's|$CLIEXEC -p $REDISPORT shutdown|$CLIEXEC -s $SOCKET shutdown|g' /etc/init.d/redis_6379
clear

# Upgrade system
clear
echo System will now upgrade...
sleep 2
echo
echo
apt-get update
apt-get upgrade -y
apt-get -f install -y
dpkg --configure --pending

# Cleanup 1
apt-get autoremove -y
CLEARBOOT=$(dpkg -l linux-* | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e [0-9] | xargs sudo apt-get -y purge)
echo "$CLEARBOOT"
clear

# Success!
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| You have sucessfully installed ownCloud! System will now reboot... |"
echo    "|                                                                    |"
echo -e "| \e[0mLogin to ownCloud in your browser:\e[36m" https://$ADDRESS/owncloud"\e[32m           |"
echo    "|                                                                    |"
echo    "| \e[0mLogin to Webmin to manage your server:\e[36m" https://$ADDRESS:10000"\e[32m           |"
echo    "|                                                                    |"
echo -e "|    \e[0mPublish your server online! \e[36mhttps://goo.gl/iUGE2U\e[32m           |"
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
rm /var/www/html/index.html
shopt -s extglob
cd /var/scripts
rm !(setup_secure_permissions_owncloud.sh|history.sh|update_checker.sh)
cd
wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/lets-encrypt/activate-ssl.sh -P $SCRIPTS
rm $DATA/owncloud.log
cat /dev/null > ~/.bash_history
cat /dev/null > /var/spool/mail/root
cat /dev/null > /var/spool/mail/ocadmin
cat /dev/null > /var/log/apache2/access.log
cat /dev/null > /var/log/apache2/error.log
cat /dev/null > /var/log/cronjobs_success.log
sed -i 's/#bash /var/scripts/pre_setup_message.sh/echo "ownCloud server Tech and me. VERSION 1.0"/g' /home/ocadmin/.profile
sed -i 's/bash /var/scripts/instructions.sh//g' /home/ocadmin/.profile

# Change root .profile
rm /root/.profile
cat <<-ROOT-PROFILE > "/root/.profile"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/history.sh ]; then
        /var/scripts/history.sh
fi
mesg n
ROOT-PROFILE

# Reboot
reboot

exit 0
