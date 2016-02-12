#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
ocpath='/var/www/html/owncloud'
htuser='www-data'
htgroup='www-data'
rootuser='root'
data='/owncloud'
data.old='/var/www/html/owncloud/data'

printf "Creating possible missing Directories\n"
mkdir -p $data
mkdir -p $ocpath/assets
mkdir -p $data/data
mkdir -p $data.old

printf "chmod Files and Directories\n"
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
find ${data}/ -type f -print0 | xargs -0 chmod 0640
find ${data}/ -type d -print0 | xargs -0 chmod 0750
find ${data.old}/ -type f -print0 | xargs -0 chmod 0640
find ${data.old}/ -type d -print0 | xargs -0 chmod 0750

printf "chown Directories\n"
chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${rootuser}:${htgroup} $data/
chown -R ${htuser}:${htgroup} $data/data/
chown -R ${htuser}:${htgroup} $data.old/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/
chown -R ${htuser}:${htgroup} ${ocpath}/assets/

chmod +x ${ocpath}/occ

printf "chmod/chown .htaccess\n"
if [ -f ${ocpath}/.htaccess ]
 then
  chmod 0644 ${ocpath}/.htaccess
  chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
fi
if [ -f ${ocpath}/data/.htaccess ]
 then
  chmod 0644 ${data.old}/.htaccess
  chown ${rootuser}:${htgroup} ${data.old}/.htaccess
fi
if [ -f ${data}/.htaccess ]
 then
  chmod 0644 ${data}/.htaccess
  chown ${rootuser}:${htgroup} ${data}/.htaccess
fi
