# ocservAuto
OnClick Install OpenConnecet VPN Server Unlimited

install it Below Link for CentOS 7

[root@ocserv ~]# wget https://raw.githubusercontent.com/shorifmrh/OcservAuto/blob/master/setupocservAuto.sh && sed -i -e 's/\r$//' setupocservAuto.sh && chmod 755 setupocservAuto.sh && ./setupocservAuto.sh

# Follow The instruction Below Some Tricks for Start
Installing Ocserv on Centos7 is a very simple thing, but I also encountered some pitfalls, such as unable to forward data normally after connecting. It is not mentioned in many documents, and it is organized here.
# Centos7 installation pit of Ocserv

# Close Selinux

setenforce 0

Permanently closed: (Cut this "#" & Commenting )

[root@ocserv ~]# cat /etc/selinux/config 

SELINUX=disabled

SELINUXTYPE=targeted

# Install Ocserv - Which Given Already 

[root@ocserv ~]# yum install ocserv - its not necessary if you already installed auto 

# Optimized configuration (PAM certification template) Checked

[root@ocserv ~]# nano /etc/ocserv/ocserv.config

auth = "pam"

tcp-port = 443

udp-port = 443

run-as-user = ocserv

run-as-group = ocserv

socket-file = ocserv.sock


chroot-dir = / var / lib / ocserv

isolate-workers = true

max-clients = 0

max-same-clients = 1

rate-limit-ms = 0

keepalive = 32400

dpd = 90

mobile-dpd = 1800

switch-to-tcp-timeout = 25

try-person-discovery = false

server-cert = /etc/pki/ocserv/public/server.crt

server-key = /etc/pki/ocserv/private/server.key

ca-cert = /etc/pki/ocserv/cacerts/ca.crt

cert-user-oid = 0.9.2342.19200300.100.1.1

compression = true

tls-priorities = "NORMAL:%SERVER_PRECEDENCE:%COMPAT:-VERS-SSL3.0

auth-timeout = 240

min-reauth-time = 300

max-ban-score = 50

cookie-timeout = 300

deny-roaming = false

rekey-time = 172800

rekey-method = ssl

use-occtl = true

pid-file = /var/run/ocserv.pid

device = vpns

predictable-ips = true

default-domain = example.com

ipv4-network = 1.2.3.0

ipv4-netmask = 255.255.255.128

ipv6-network = fda9:4efe:7e3b:03ea::/64

tunnel-all-dns = true

dns = 8.8.8.8

dns = 8.8.4.4

ping-leases = false

output-buffer = 50

route = default

cisco-client-compat = true

dtls-legacy = true

user-profile = profile.xml

# Enable IPv4 Forwarding
echo "net.ipv4.ip_forward = 1">> /etc/sysctl.conf

[root@ocserv ~]# nano /usr/lib/sysctl.d/50-default.conf

kernel.sysrq = 16

kernel.core_uses_pid = 1

net.ipv4.conf.default.rp_filter = 1

net.ipv4.conf.all.rp_filter = 1

net.ipv4.conf.default.accept_source_route = 0

net.ipv4.conf.all.accept_source_route = 0

net.ipv4.conf.default.promote_secondaries = 1

net.ipv4.conf.all.promote_secondaries = 1

fs.protected_hardlinks = 1

fs.protected_symlinks = 1

net.ipv4.ip_forward = 1

# Set up a firewall
[root@ocserv ~]# iptables -t nat -A POSTROUTING -s 1.2.3.0/25 -o ens192 -j MASQUERADE

[root@ocserv ~]# iptables -A FORWARD -i vpns+ -j ACCEPT 

[root@ocserv ~]# iptables -A FORWARD -o vpns+ -j ACCEPT

[root@ocserv ~]# iptables-save > /etc/sysconfig/iptables

# Setting up RHEL7 firewall
# Setup firewalld
[root@ocserv ~]# cat > /etc/firewalld/services/ocserv.xml <<EOF

= <?xml version="1.0" encoding="utf-8" ?>

= <service>

= <short>ocserver</short>

= <description>Cisco AnyConnect</description>

= <port protocol="tcp" port='443' />

= <port protocol="udp" port='443' />

= </service>

EOF

# Open firewall port and packet forwarding feature
[root@ocserv ~]# firewall-cmd --permanent --add-port=443/tcp

[root@ocserv ~]# firewall-cmd --permanent --add-port=443/udp

[root@ocserv ~]# firewall-cmd --permanent --add-port=80/tcp

[root@ocserv ~]# firewall-cmd --permanent --add-port=8080/tcp

[root@ocserv ~]# firewall-cmd --permanent --add-service=ocserv

[root@ocserv ~]# firewall-cmd --permanent --add-masquerade

[root@ocserv ~]# firewall-cmd --reload

# Self-starting
[root@ocserv ~]# systemctl enable ocserv

[root@ocserv ~]# systemctl start ocserv

[root@ocserv ~]# systemctl status ocserv

# Add Users Accounts
[root@ocserv ~]# useradd Salman

[root@ocserv ~]# passwd Salman
