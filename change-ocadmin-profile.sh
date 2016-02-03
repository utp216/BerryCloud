#!/bin/bash

OCADMIN_PROFILE="/home/ocadmin/.profile"

rm /home/ocadmin/.profile

cat <<-OCADMIN-PROFILE > "$OCADMIN_PROFILE"
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.
# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
#bash /var/scripts/instructions.sh
bash /var/scripts/history.sh
bash /var/scripts/pre1.sh
sudo bash /var/scripts/pre.sh
#sudo -i
sed -i 's|#bash /var/scripts/instructions.sh|bash /var/scripts/instructions.sh|g' /home/ocadmin/.profile
sed -i 's|bash /var/scripts/pre1.sh|#bash /var/scripts/pre1.sh|g' /home/ocadmin/.profile
sed -i 's|bash /var/scripts/pre.sh|#bash /var/scripts/pre.sh|g' /home/ocadmin/.profile
sed -i 's|#sudo -i|sudo -i|g' /home/ocadmin/.profile

OCADMIN-PROFILE

exit 0
