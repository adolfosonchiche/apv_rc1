#! /bin/bash 
echo "STARTING"
killall dnsmasq
dnsmasq
sudo hostapd /etc/hostapd/hostapd.conf