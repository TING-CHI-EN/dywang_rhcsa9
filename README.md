# dywang_rhcsa9
# IPv4 網路設定 
[kvm8 console]

#### 1 不必刪除設定，直接使用 modify 選項變更設定。設定 ipv4 位址 192.168.122.8、遮罩 255.255.255.0、GATEWAY 192.168.122.1 及 DNS 192.168.122.1，最後一定要設定 ipv4.method 為 manual，將網路連線設定為手動，也就是自行設定 IP，不是由 DHCP 自動取得，否則原 DHCP 取得的 IP 還會存在。 
```
nmcli connection modify enp1s0 ipv4.addresses 192.168.122.8/24 ipv4.gateway 192.168.122.1 ipv4.dns 192.168.122.1 ipv4.method manual
```
#### 2 將網路連線 enp1s0 啟動。 
```
nmcli connection up enp1s0
```
#### 3 PermitRootLogin 預設是 prohibit-password，修改成 yes
```
vim /etc/ssh/sshd_config
```
#PermitRootLogin prohibit-password

PermitRootLogin yes

#the setting of "PermitRootLogin without-password".

#### 4 重新啟動 sshd 服務
```
systemctl restart sshd.service
```
[terminal]

#### 5 遠端連線 192.168.122.8
```
ssh root@kvm8.deyu.wang
```
#### 6 設定主機名稱為 kvm8.deyu.wang。 
```
hostnamectl hostname kvm8.deyu.wang
```
#### 查詢網卡名稱，將網卡名稱寫到 /root/netif。
#### 查詢網卡連線名稱，將連線名稱寫到 /root/netcon。
```
echo 'enp1s0' > /root/netif

echo 'enp1s0' > /root/netcon
```
# [YUM 套件管理]

#### 1 撰寫 yum 套件庫 (repository) 設定檔 .repo，以建立 yum 安裝來源，CentOS 8 套件分成 BaseOS 及 AppStream 兩類，必須同時設定。 
```
vim /etc/yum.repos.d/redhat.repo
```
[AppStream]

name=App Stream

baseurl=http://dywang.csie.cyut.edu.tw/alma9/AppStream

gpgcheck=0

[BaseOS]

name=Base OS

baseurl=http://dywang.csie.cyut.edu.tw/alma9/BaseOS

gpgcheck=0

# [systemctl 系統服務控制 ]

#### 查看 chronyd 服務是否啟動 (active)？結果導向到 /root/systemd-active。
```
systemctl is-active chronyd.service > /root/systemd-active
```
#### 查看 chronyd 服務是否開機啟動 (enable)？結果導向到 /root/systemd-enabled。
```
systemctl is-enabled chronyd.service > /root/systemd-enable
```
#### 把關閉 chronyd 服務的完整指令寫到 /root/systemd-stop。
```
echo 'systemctl stop chronyd.service' > /root/systemd-stop
```
#### 把啟動 chronyd 服務的完整指令寫到 /root/systemd-start。
```
echo 'systemctl start chronyd.service' > /root/systemd-start
```
#### 把重新啟動 chronyd 服務的完整指令寫到 /root/systemd-restart。
```
echo 'systemctl restart chronyd.service' > /root/systemd-restart
```
#### 把查詢 chronyd 服務狀態的完整指令寫到 /root/systemd-status。
```
echo 'systemctl status chronyd.service' > /root/systemd-status
```
# [SELinux]

#### 查詢 http_port_t，82 port 不是 httpd 程序允許訪問的 port。 
```
semanage port --list | grep http
```
#### 新增 82 為 httpd 服務允許訪問的埠號
```
semanage port -a -t http_port_t -p tcp 82
```
#### 再重新啟動 httpd 服務，成功啟動服務。
```
systemctl restart httpd.service
```
