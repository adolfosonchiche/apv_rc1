#! /bin/bash 
echo "VS"
apt-get install -y hostapd dnsmasq wireless-tools iw wvdial
apt-get install iptables

sed -i 's#^DAEMON_CONF=.*#DAEMON_CONF=/etc/hostapd/hostapd.conf#' /etc/init.d/hostapd


cat <<EOF > /etc/network/interfaces
auto lo
iface inet loopback
#eno1 inteface ethernet
iface enp2s0 inet manual
auto usb0
allow-hotplug usb0
#wlo1 interface wireless card
#iface wlp1s0 inet manual
auto br0
iface br0 inet dhcp
bridge-ports usb0 wlp1s0
EOF

cat <<EOF > /etc/dnsmasq.conf
#log-facility=/var/log/dnsmasq.log
interface=wlp1s0
dhcp-range=10.0.0.0,10.0.0.20,12h #RANGO DE IP para siganr automatico
dhcp-option=3,10.10.10.5 
dhcp-option=6,10.10.10.10  
#no-resolv
EOF

#service dnsmasq start
#ifconfig wlp1s0 up
#ifconfig wlp1s0 192.168.42.6/24
#iptables --flush
#iptables -t nat -F
#iptables -F
#iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE
#iptables -A FORWARD -i wlp1s0 -o usb0 -j ACCEPT
#echo '1' > /proc/sys/net/ipv4/ip_forward

cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlp1s0
driver=nl80211
channel=11
bridge=br0
ssid=myhotspot
wpa=2
wpa_passphrase=KaaVLievaC
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
# Change the broadcasted/multicasted keys after this many seconds.
wpa_group_rekey=600
# Change the master key after this many seconds. Master key is used as a basis
wpa_gmk_rekey=86400

EOF
service dnsmasq start
ifconfig wlp1s0 up
ifconfig wlp1s0 192.168.42.6/24
iptables --flush
iptables -t nat -F
iptables -F
iptables -t nat -A POSTROUTING -o usb0 -j MASQUERADE
iptables -A FORWARD -i wlp1s0 -o usb0 -j ACCEPT
echo '1' > /proc/sys/net/ipv4/ip_forward
systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd
sudo killall dnsmasq