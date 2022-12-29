#!/bin/bash

# disable server from going to sleep https://www.unixtutorial.org/disable-sleep-on-ubuntu-server/
systemctl mask sleep.target suspend.target hibernate.target
systemctl status sleep.target


