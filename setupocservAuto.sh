#!/bin/bash

clear
echo "Point a Domain or Sub-Domain With Your VPS IP"
 echo "Make Sure Your VPS is in Centos7 64x "
echo ""
echo "Inter Your Domain / SubDomain that pointed to VPS IP"
read -p "Domain/Subdomain: " DomainTool
echo ""
echo "Finally, Input Your Email For Free SSL "
echo "This Free SSL is powered by letsencrypt"
read -p " Email: " EmailTool
echo ""
echo "Okay, that's all.Ready to setup your OpenConnect VPN Server Now?"
read -n1 -r -p "Press any key to continue..."


yum update -y
yum install wget -y
yum install dnf -y
sudo dnf install epel-release -y
sudo dnf install ocserv -y
sudo yum install firewalld -y
sudo systemctl enable firewalld
sudo systemctl start firewalld
sudo firewall-cmd --zone=public --permanent --add-port=443/tcp
sudo firewall-cmd --zone=public --permanent --add-port=443/udp
sudo firewall-cmd --zone=public --permanent --add-port=80/tcp
sudo firewall-cmd --zone=public --permanent --add-masquerade
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sudo systemctl reload firewalld
sudo dnf install certbot -y
sudo certbot certonly --standalone --preferred-challenges http --agree-tos --email $EmailTool -d $DomainTool


 cd ..
 sudo systemctl restart ocserv




