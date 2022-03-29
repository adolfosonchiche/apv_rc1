#!/bin/bash
apt-get install -y hostapd dnsmasq wireless-tools iw wvdial
apt-get update 
apt-get install hostapd
apt-get install dnsmasq

sed -i 's#^DAEMON_CONF=.*#DAEMON_CONF=/etc/hostapd/hostapd.conf#' /etc/init.d/hostapd

cat <<EOF > /etc/dnsmasq.conf
#log-facility=/var/log/dnsmasq.log
#address=/#/10.0.0.1
#address=/google.com/10.0.0.1
interface=wlp1s0
dhcp-range=10.10.10.5,10.10.10.10,12h
dhcp-option=3,10.10.10.5
dhcp-option=6,10.10.10.10
#no-resolv
#log-queries
EOF

service dnsmasq start

#ifconfig wlan0 up
#ifconfig wlan0 10.0.0.1/24

#iptables -t nat -F
#iptables -F
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
#echo '1' > /proc/sys/net/ipv4/ip_forward

cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlp1s0
driver=nl80211
ssid=myhotspot
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=3
wpa_passphrase=KeePGuessinG
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

EOF

#service hostapd start
# Setup the interface
ip link set lo down
ip addr flush dev lo
ip link set lo up
ip addr add 10.10.10.5/24 dev wlp1s0
# start hostapd
killall dnsmasq
dnsmasq
hostapd