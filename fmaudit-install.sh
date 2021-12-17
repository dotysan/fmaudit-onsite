#! /usr/bin/env bash

if [ -e /fmaudit.onsite.jar ]
then
    java -jar /fmaudit.onsite.jar <<<"1"
    rm /fmaudit.onsite.jar
fi

systemctl disable fmaudit-install.service
rm /etc/systemd/system/fmaudit-install.service
rm /fmaudit-install.sh
