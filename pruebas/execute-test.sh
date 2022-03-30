#! /bin/bash 
echo "VS"
sed -i 's#^DAEMON_CONF=.*#DAEMON_CONF=/etc/hostapd/hostapd.conf#' /etc/init.d/hostapd
cat <<EOF > /etc/network/interfaces
auto lo
iface inet loopback
#eno1 inteface ethernet
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
log-queries
EOF
echo "fin"
service dnsmasq start
#inteface wifi  es wlo1 para mi
ifconfig wlan0 up
ifconfig wlan0 127.0.0.1/24 #AQUI PONER EL IP DE DEL ROUTER

iptables -t nat -F
iptables -F
iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
iptables -A FORWARD -i wlp1s0 -o enp2s0 -j ACCEPT
echo '1' > /proc/sys/net/ipv4/ip_forward

echo "inicio conf apd"
cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlp1s0
driver=nl80211
ssid=myhotspot
#hw_mode=g
channel=1
#macaddr_acl=0
#auth_algs=1
#ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=KaaVLievaC
wpa_key_mgmt=WPA-PSK
#wpa_pairwise=TKIP
rsn_pairwise=CCMP
wpa_group_rekey=600
wpa_gmk_rekey=86400
EOF
echo "fin"
echo "conf ip"
# Setup the interface
#ip link set lo down
#ip addr flush dev lo
#ip link set lo up
#ip addr add 10.10.10.5/24 dev wlp1s0
echo "fin"