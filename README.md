# ownCloud server on your RaspberryPI2
* Redis cache
* Fail2ban
* Apache2
* MySql
* Libre Office Writer
* Much more, see the setup.sh and other scripts

Base OS: ubuntu core 15.04 with apt-get package manager (NOTE THIS IS NOT SNAPPY CORE)

# How to: 

1. Download the Ubuntu Core 15.04 RaspberryPI2 .img from:
2. Write .img to sdcard see this page: https://www.raspberrypi.org/documentation/installation/installing-images/
3. Boot RaspberryPI2 with the newly made sdcard
4. login with ocadmin///owncloud (Connected to monitor with keyboard)
5. Follow the instructions
6. For now only use Rapi-Config tool for overclocking. (RECOMMENDED FOR SPEED, this tool uses non warrenty void settings, if you dont care about that... remove the old config.txt from PI_BOOT partition and cp config.txt above to PI_BOOT)

# Unpacking the image on unix:
1. Install p7zip-full if not already installed (enter in terminal):

sudo apt-get install p7zip-full

2. Execute this command to extract .tar.7z file (go to directory where is your file, if myfile.tar.7z is your file name):

7za x myfile.tar.7z

tar -xvf myfile.tar
3. That's it. Actually first command extracts in .tar file then next command extracts it completely.
4. On linux you can also use your archive manager to unpack

# Unpacking the image on windows:
1. Download winrar, double click the archive and extract it.

# Minimal req.
1. 8 gb Class 10 Micro SDCard (16+ is recommended)
2. 2A 5V power supply
3. Keyboard / HDMI cable / Monitor (for first setup, after pre-setup you can ssh)
4. *Optional 3x heatsink for RPI2* (Heatsinks, fan + case go for around 5 dollar on the internet, just google it)
5. *Optional CPU fan for RPI2*

# If you encounter any issues please use the issue tracker here on github: https://github.com/ezraholm50/BerryCloud/issues

**This project is created by ezraholm50 with much support of en0ch85, I also use his scripts to automate this installation.
For great guides on Linux, ownCloud and Virtual Machines visit https://www.techandme.se**

**We can not be held responsible for anything whatsoever, we do our utmost best to make this build perfect. Use this build at your own risk.**

