# dywang_rhcsa9
[kvm8 console]
nmcli connection modify enp1s0 ipv4.addresses 192.168.122.8/24 ipv4.gateway 192.168.122.1 ipv4.dns 192.168.122.1 ipv4.method manual

nmcli connection up enp1s0

vim /etc/ssh/sshd_config
#PermitRootLogin prohibit-password
PermitRootLogin yes
# the setting of "PermitRootLogin without-password".

systemctl restart sshd.service

[terminal]
ssh root@kvm8.deyu.wang

hostnamectl hostname kvm8.deyu.wang

echo 'enp1s0' > /root/netif
echo 'enp1s0' > /root/netcon
