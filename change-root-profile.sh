#!/bin/bash

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
