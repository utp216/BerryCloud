# Swap
mkswap -L PI_SWAP /dev/sda1
swapon /dev/sda1
echo "/dev/sda1 none swap sw 0 0" >> /etc/fstab
	
# External HD	
echo -ne '\n' | sudo mke2fs -t ext4 -b 4096 -L 'PI_ROOT' -I /dev/sda2
dd bs=4M conv=sync,noerror if=/dev/mmcblk0p2 of=/dev/sda2
sed -i 's|/dev/mmcblk0p2|/dev/sda2|g' /etc/fstab
	
# Change back root/.profile
ROOT_PROFILE="/root/.profile"

rm /root/.profile

cat <<-ROOT-PROFILE > "$ROOT_PROFILE"
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
if [ -x /var/scripts/setup.sh ]; then
        /var/scripts/setup.sh
fi
if [ -x /var/scripts/history.sh ]; then
        /var/scripts/history.sh
fi
mesg n
ROOT-PROFILE