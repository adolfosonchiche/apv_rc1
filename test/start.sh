#! /bin/bash 
echo "STARTING"
killall dnsmasq
service hostapd start
service dnsmasq start