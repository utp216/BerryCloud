# BerryCloud
Try out for the Raspberry + ownCloud project collab with WD

Installation:


1.Download ubuntu snappy core

2.Install on sd card

Installing the image on to your MicroSD card is covered on the Raspberry Pi2 website.

https://www.raspberrypi.org/documentation/installation/installing-images/windows.md - Windows
https://www.raspberrypi.org/documentation/installation/installing-images/mac.md - Apple
https://www.raspberrypi.org/documentation/installation/installing-images/linux.md - Linux

3.Boot it on your RaspberryPi2

MAKE SURE AN EXTERNAL HD/SSD/USB DRIVE IS CONNECTED, ONLY 1 EXTERNAL STORAGE DRIVE!
this is because the RPI2 is supposed to eat sd cards, this setup boots of of the sd card and runs the OS on a HD/USB drive.

4.Login with ocadmin/owncloud

5.Run: sudo mkdir /var/scripts

5.Run: wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/pre-img-cmd.sh -P /var/scripts/

7.Run: bash /var/scripts/pre-img-cmd.sh

8.Run: wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/setup.sh -P /var/scripts/

9.Run: bash /var/scripts/setup.sh

10.Enjoy
