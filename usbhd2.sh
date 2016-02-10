# External HD	
echo "This might take a while, copying everything from SD card to HD. Just wait untill system continues."
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
