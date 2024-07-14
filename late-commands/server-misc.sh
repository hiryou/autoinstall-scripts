#!/bin/bash

USER="${1:-hadoop}"

# install JDk
apt-get update
apt install -y openjdk-21-jre-headless

# disable server from going to sleep https://www.unixtutorial.org/disable-sleep-on-ubuntu-server/
systemctl mask sleep.target suspend.target hibernate.target
systemctl status sleep.target

# allow $USER to own "universal" files
chown -R $USER:$USER /home/universal

