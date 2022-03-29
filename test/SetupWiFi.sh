#! /bin/bash 
echo "VS"
#apt-get install -y hostapd dnsmasq wireless-tools iw wvdial

sed -i 's#^DAEMON_CONF=.*#DAEMON_CONF=/etc/hostapd/hostapd.conf#' /etc/init.d/hostapd


cat <<EOF > /etc/network/interfaces
auto lo
iface inet loopback
#eno1 inteface ethernet
iface eno1 inet manual
#wlo1 interface wireless card
iface wlo1 inet manual

EOF

cat <<EOF > /etc/dnsmasq.conf
log-facility=/var/log/dnsmasq.log
#address=/#/10.0.0.1
#address=/google.com/10.0.0.1
interface=wlo1
dhcp-range=10.0.0.10,10.0.0.250,12h #AQUI PONES UN RANGO DE IP para siganr automatico
dhcp-option=3,10.0.0.1 #AQUI PONES EL IP DE TU ROUTER
dhcp-option=6,10.0.0.1  #AQUI PONES EL IP DE TU ROUTER
#no-resolv
log-queries
EOF

service dnsmasq start
#inteface wifi  es wlo1 para mi
ifconfig wlan0 up
ifconfig wlan0 10.0.0.1/24 #AQUI PONER EL IP DE DEL ROUTER

iptables -t nat -F
iptables -F
iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
iptables -A FORWARD -i wlo1 -o eno1 -j ACCEPT
echo '1' > /proc/sys/net/ipv4/ip_forward

cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlo1
driver=nl80211
channel=1

ssid=WiFiAP
wpa=2
wpa_passphrase=HOLAROJAS123
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
# Change the broadcasted/multicasted keys after this many seconds.
wpa_group_rekey=600
# Change the master key after this many seconds. Master key is used as a basis
wpa_gmk_rekey=86400

EOF

service hostapd start