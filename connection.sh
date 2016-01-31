sudo ifdown -a
sudo ifup -a
mkdir /var/scripts
sudo wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/setup.sh -P /var/scripts
sudo wget https://raw.githubusercontent.com/ezraholm50/BerryCloud/master/pre.sh -P /var/scripts
sudo bash /var/scripts/pre.sh
