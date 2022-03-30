#! /bin/bash 
echo "STARTING"
killall dnsmasq
service hostapd start
killall dnsmasq
service dnsmasq start