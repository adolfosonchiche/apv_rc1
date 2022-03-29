#! /bin/bash 
echo "VS"
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
echo "fin"
echo "inicio conf apd"
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
wpa_passphrase=KaaVLievaC
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
echo "fin"
echo "conf ip"
# Setup the interface
ip link set lo down
ip addr flush dev lo
ip link set lo up
ip addr add 10.10.10.5/24 dev wlp1s0
echo "fin"