#! /bin/bash 
echo "VS"
sed -i 's#^DAEMON_CONF=.*#DAEMON_CONF=/etc/hostapd/hostapd.conf#' /etc/init.d/hostapd
cat <<EOF > /etc/network/interfaces
auto lo
iface inet loopback
#enp2s0 inteface ethernet
iface enp2s0 inet manual
#wlo1 interface wireless card
iface wlp1s0 inet manual
EOF
echo "fin"
echo "inicio conf dnsmasq"
cat <<EOF > /etc/dnsmasq.conf
log-facility=/var/log/dnsmasq.log
interface=wlp1s0
dhcp-range=10.10.10.0,10.10.10.20,12h
dhcp-option=3,127.0.0.1
dhcp-option=6,127.0.0.1

interface=enp2s0
dhcp-range=10.10.10.5,10.10.10.25,12h
dhcp-option=3,127.0.0.1
dhcp-option=6,127.0.0.1
log-queries
EOF
echo "fin"
service dnsmasq start
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

interface=enp2s0
driver=nl80211
ssid=myhotspot
hw_mode=a
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
ip addr add 10.10.10.10/24 dev enp2s0
echo "fin"