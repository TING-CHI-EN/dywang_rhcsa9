# dywang_rhcsa9
# IPv4 網路設定 
[kvm8 console]
nmcli connection modify enp1s0 ipv4.addresses 192.168.122.8/24 ipv4.gateway 192.168.122.1 ipv4.dns 192.168.122.1 ipv4.method manual

nmcli connection up enp1s0

vim /etc/ssh/sshd_config

#PermitRootLogin prohibit-password

PermitRootLogin yes

#the setting of "PermitRootLogin without-password".

systemctl restart sshd.service

[terminal]
ssh root@kvm8.deyu.wang

hostnamectl hostname kvm8.deyu.wang

echo 'enp1s0' > /root/netif
echo 'enp1s0' > /root/netcon

# [YUM 套件管理]
vim /etc/yum.repos.d/redhat.repo
[AppStream]
name=App Stream
baseurl=http://dywang.csie.cyut.edu.tw/alma9/AppStream
gpgcheck=0

[BaseOS]
name=Base OS
baseurl=http://dywang.csie.cyut.edu.tw/alma9/BaseOS
gpgcheck=0

# [systemctl 系統服務控制 ]
systemctl is-active chronyd.service > /root/systemd-active
systemctl is-enabled chronyd.service > /root/systemd-enable
echo 'systemctl stop chronyd.service' > /root/systemd-stop
echo 'systemctl start chronyd.service' > /root/systemd-start
echo 'systemctl restart chronyd.service' > /root/systemd-restart
echo 'systemctl status chronyd.service' > /root/systemd-status
