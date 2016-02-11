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
SCRIPTS=/var/scripts
HTML=/var/www/html
WWW=/var/www
      	# Create dir
if 		[ -d $SCRIPTS ];
	then
      		sleep 1
      	else
      		mkdir $SCRIPTS
fi
      	# Create dir
if 		[ -d $WWW ];
	then
      		sleep 1
      	else
      		mkdir $WWW
fi
      	# Create dir
if 		[ -d $HTML ];
	then
      		sleep 1
      	else
      		mkdir $HTML
fi

# fail2ban
if 		[ -f $SCRIPTS/fail2ban.sh ];
        then
                echo "fail2ban.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/fail2ban.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded fail2ban.sh."
	sleep 1
fi

# Setup
if 		[ -f $SCRIPTS/setup.sh ];
        then
                echo "setup.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/setup.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded setup.sh."
	sleep 1
fi

# Pre script
if 		[ -f $SCRIPTS/pre.sh ];
        then
                echo "pre.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/pre.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded pre.sh."
	sleep 1
fi
#
# Welcome message after login (change in /home/ocadmin/.profile
if 		[ -f $SCRIPTS/instruction.sh ];
        then
                echo "instruction.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/instructions.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded instruction.sh."
	sleep 1
fi

# Pre1.sh
if 		[ -f $SCRIPTS/pre1.sh ];
        then
                echo "pre1.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/pre1.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded pre1.sh."
	sleep 1
fi

# Get Redis install script
if 		[ -f $SCRIPTS/install-redis-php-7.sh ];
        then
        	echo "install-redis-php-7.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/install-redis-php-7.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded install-redis-php-7.sh."
	sleep 1
fi

# Activate SSL
if 		[ -f $SCRIPTS/activate-ssl.sh ];
        then
        	echo "activate-ssl.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/lets-encrypt/activate-ssl.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded activate-ssl.sh."
	sleep 1
fi

# The update script
if 		[ -f $SCRIPTS/owncloud_update.sh ];
        then
        	echo "owncloud_update.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/owncloud_update.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded owncloud_update.sh."
	sleep 1
fi

# Sets static IP to UNIX
if 		[ -f $SCRIPTS/ip.sh ];
        then
        	echo "ip.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/ip.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded ip.sh."
	sleep 1
fi

# Tests connection after static IP is set
if 		[ -f $SCRIPTS/test_connection.sh ];
        then
        	echo "test_connection.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/test_connection.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded test_connection.sh."
	sleep 1
fi

# Sets root partition to external drive
if 		[ -f $SCRIPTS/usbhd.sh ];
        then
        	echo "usbhd.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/usbhd.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded usbhd.sh."
	sleep 1
fi

# Sets root partition to external drive
if 		[ -f $SCRIPTS/usbhd2.sh ];
        then
        	echo "usbhd.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/usbhd2.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded usbhd2.sh."
	sleep 1
fi

# Trusted ip conf script
if 		[ -f $SCRIPTS/trusted.sh ];
        then
        	echo "trusted.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/trusted.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded trusted.sh."
	sleep 1
fi

# Update-config script
if 		[ -f $SCRIPTS/update-config.php ];
        then
        	echo "update-config.php  exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/update-config.php -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded update-config.php."
	sleep 1
fi

# Clears command history on every login
if 		[ -f $SCRIPTS/history.sh ];
        then
                echo "history.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/enoch85/ownCloud-VM/master/beta/history.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded history.sh."
	sleep 1
fi

# Change roots .bash_profile
if 		[ -f $SCRIPTS/change-root-profile.sh ];
        then
                echo "change-root-profile.sh exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/change-root-profile.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded change-root-profile.sh."
	sleep 1
fi

# Change ocadmin .bash_profile
if 		[ -f $SCRIPTS/change-ocadmin-profile.sh ];
        then
        	echo "change-ocadmin-profile.sh  exists"
        else
        	wget -q https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/change-ocadmin-profile.sh -P $SCRIPTS
fi
if [[ $? > 0 ]]
then
	echo "Download of scripts failed. System will reboot in 10 seconds..."
	sleep 10
	reboot
else
	echo "Downloaded change-ocadmin-profile.sh."
	sleep 1
fi

# Make $SCRIPTS excutable
        	chmod +x -R $SCRIPTS
        	chown root:root -R $SCRIPTS

# Allow ocadmin to run theese scripts
        	chown ocadmin:ocadmin $SCRIPTS/instructions.sh
        	chown ocadmin:ocadmin $SCRIPTS/history.sh
        	chown ocadmin:ocadmin $SCRIPTS/pre.sh
        	chown ocadmin:ocadmin $SCRIPTS/pre1.sh

# Change root profile
        	bash $SCRIPTS/change-root-profile.sh
if [[ $? > 0 ]]
then
	echo "change-root-profile.sh were not executed correctly. System will reboot in 5 seconds..."
	sleep 5
	reboot
else
	echo "change-root-profile.sh script executed OK."
fi

# Change ocadmin profile
        	bash $SCRIPTS/change-ocadmin-profile.sh
if [[ $? > 0 ]]
then
	echo "change-ocadmin-profile.sh were not executed correctly. System will reboot in 5 seconds..."
	sleep 5
	reboot
else
	echo "change-ocadmin-profile.sh executed OK."
fi

# Fix ownership issue
sudo chown ocadmin:ocadmin /home/ocadmin/.profile

exit 0