# ownCloud server on your RaspberryPI2

*Redis Cache (with performance tweaks)

*PHP 7

*Fail2Ban

*Apache2

*ClamAV (antivirus, scans uploaded files to owncloud. Change do daemon-socket in ownCloud admin panel)

*LVM2

*Webmin

*MySQL(random password generated)

*Libre Office Writer

*2 GB swap file / 2 GB swap partition (partition is used when using the external USB as ROOT option)

*Possibility to use an external USB device as ROOT partition (recommended, preferably an SSD)

*Base OS: Ubuntu Core 15.10 with apt-get package manager

*Default safe overclocked settings that do not void your RaspberryPI2 warranty!!! (You are asked if you want to supercharge voiding warranty AT YOUR OWN RISK, which I always use, without any problems for over 4 months.)

*Much more, see the setup.sh and other scripts


# How to: 

1. Download Ubuntu Core 15.10 RaspberryPI2 .img: CHANGE ME **************************************

 1.1 Unpacking, see below!

2. Write .img to sdcard see this page: https://www.raspberrypi.org/documentation/installation/installing-images/

3. Boot RaspberryPI2 with the newly made SD card

4. login with ocadmin///owncloud (Connected to monitor with keyboard)

5. Follow the instructions (The device will reboot a couple of times, don't worry about that. Just keep loggin in after reboot)

# Unpacking the image on unix:
Open terminal, enter following commands

(go to directory where you have just downloaded the image, eg: cd /home/yourusername/Downloads)

1. sudo apt-get install p7zip-full
2. 7za x RPI2_ownCloud_techandme.se_UbuntuCore15.10_NOT_overclocked.img.7z

On linux you can also use your archive manager to unpack

# Unpacking the image on windows:
1. Download winrar, double click the archive and extract it.

# Minimal req.
1. 8 gb Class 10 Micro SDCard (16+ is recommended) 4 gb class 10 will do if you want to use an external HD (SSD recommended, if HD, please use an additional power supply to power the drive.)
2. 2A 5V power supply
3. RaspberryPI2
4. Keyboard / HDMI cable / Monitor (for first setup, after pre-setup you can ssh)
5. Wired connection to internet
6. *Optional 3x heatsink for RPI2* (Heatsinks, fan + case go for around 5 dollar on the internet, just google it)
7. *Optional CPU fan for RPI2*

# If you encounter any issues please use the issue tracker here on github: https://github.com/ezraholm50/BerryCloud/issues

** This project is created by ezraholm50 with much support of en0ch85, I also use his scripts to automate this installation.
For great guides on Linux, ownCloud and Virtual Machines visit https://www.techandme.se **

**We can not be held responsible for anything whatsoever, we do our utmost best to make this build perfect. Use this build at your own risk.**

