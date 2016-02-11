#!/bin/bash
#
# Tech and Me, 2016 - www.techandme.se
#
echo -e "\e[32m"
echo    "+--------------------------------------------------------------------+"
echo    "| After pressing any key, enter password: owncloud                   |"
echo    "| A pre-setup script will run now followed by a reboot.              |"
echo    "| After the reboot log back in with ocadmin///owncloud               |"
echo    "| Then the setup script will run.                                    |"
echo    "+--------------------------------------------------------------------+"
echo
read -p "Press any key to continue..." -n1 -s
echo -e "\e[0m"
echo

exit 0
