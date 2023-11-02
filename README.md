# dywang_rhcsa9
#### 上課sid
```
echo '4-2 159 11227608 丁啟恩' > sid
```
#### 上課參數檔
```
cat /tmp/rhcsa9mpara.sh
```
#### 上課txt檔
```
mkdir /tmp/11227608.rhcsa9m
cp res*.txt /tmp/11227608.rhcsa9m
```

# [IPv4 網路設定](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node33.html)
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
# [YUM 套件管理](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node41.html)

#### 1 撰寫 yum 套件庫 (repository) 設定檔 .repo，以建立 yum 安裝來源，CentOS 8 套件分成 BaseOS 及 AppStream 兩類，必須同時設定。 
```
vim /etc/yum.repos.d/redhat.repo
```
```
[BaseOS]

name=Base OS

baseurl=http://dywang.csie.cyut.edu.tw/alma9/BaseOS

gpgcheck=0

[AppStream]

name=App Stream

baseurl=http://dywang.csie.cyut.edu.tw/alma9/AppStream

gpgcheck=0
```
# [systemctl 系統服務控制](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node47.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node54.html)
#### 查看 chronyd 服務是否啟動 (active)？結果導向到 /root/systemd-active。
#### 查看 chronyd 服務是否開機啟動 (enable)？結果導向到 /root/systemd-enabled。
#### 把關閉 chronyd 服務的完整指令寫到 /root/systemd-stop。
#### 把啟動 chronyd 服務的完整指令寫到 /root/systemd-start。
#### 把重新啟動 chronyd 服務的完整指令寫到 /root/systemd-restart。
#### 把查詢 chronyd 服務狀態的完整指令寫到 /root/systemd-status。
```
systemctl is-active chronyd.service > /root/systemd-active
systemctl is-enabled chronyd.service > /root/systemd-enable
echo 'systemctl stop chronyd.service' > /root/systemd-stop
echo 'systemctl start chronyd.service' > /root/systemd-start
echo 'systemctl restart chronyd.service' > /root/systemd-restart
echo 'systemctl status chronyd.service' > /root/systemd-status
```
# [SELinux](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node55.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node62.html)
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
#### 查看網頁伺服器根目錄下有 file1, file2 兩個檔案，權限是任何人都可讀取
```
ll /var/www/html/
```
#### 使用 curl 訪問網頁 file1，回應沒有權限存取
```
curl http://127.0.0.1:82/file1
```
#### 將 /var/www/html 目錄下所有檔案，恢復預設的 selinux contexts
```
restorecon -rv /var/www/html/
```
#### semanage -d 刪除 /var/www/html/file1 自訂的 admin_home_t
```
semanage fcontext -d -t admin_home_t /var/www/html/file1
```
#### 將 /var/www/html 目錄下所有檔案，恢復預設的 selinux contexts
```
restorecon -rv /var/www/html/
```
#### 查看 SELinux Contexts，file1 及 file2 都是 httpd_sys_contect
```
ls -Z /var/www/html/
```
#### 使用 curl 訪問網頁 file1 及 file2，都成功回應檔案內容
[root@kvm8 ~]# curl http://127.0.0.1:82/file1

web test1

[root@kvm8 ~]# curl http://127.0.0.1:82/file2

web test2
# [資料導向與管線處理](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node71.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node75.html)
#### ls /etc/audit 導向到 /root/redirect1
#### ls /etcdy 錯誤導向到 /root/redirect2
#### ls /usr/local 導向到 /root/redirect3
#### ls /usr/etcdy 錯誤累加導向到 /root/redirect3
#### ls /bin/a* /lib64/autofs1 的 stdout 及 stderr 同時導向到 /root/redirect4

#### 從檔案 /usr/share/doc/xz/README 中找出所有包含字串 info 的行列，導向到檔案 /root/info。
#### 從檔案 txtfile (例如 /usr/share/doc/systemd/LICENSES/OFL-1.1.txt) 中找出所有包含字串 str 的行列，導向到檔案 wlist。
#### 使用 nmcli 命令 show 目前的網路連線設定，經由管線命令找出包含 ipv4 IPV4 ip4 IP4 等字串的行，導向到檔案 myipv4。
```
ls /etc/audit/ > /root/redirect1
ls /etcdy 2> /root/redirect2
ls /usr/local/ > /root/redirect3
ls /usr/etcdy 2>> /root/redirect3
ls /bin/a* /lib64/autofs1 > /root/redirect4 2>&1
cat /usr/share/doc/xz/README | grep info > /root/info
cat /usr/share/doc/systemd/LICENSES/OFL-1.1.txt | grep and > /root/11227608list
nmcli connection show enp1s0 | grep -iE ipv?4 > /root/11227608ip
```
# [正規表達式](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node63.html)
## [實機練習一](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node68.html)
在自己的家目錄建立一個新的目錄 zzz。
進入目錄 zzz。
下載檔案 re1.txt
使用 grep 對 re1.txt 執行以下搜尋動作，不需要列印行號，結果分別導向到檔案 result1.txt 至 result7.txt，不要做任何的更動。
1. you 大小寫不分。
2. tast 或 test。
3. oo 前面不是 g，也不是 t。
4. 剛好四個阿拉伯數字。
5. 兩個以上阿拉伯數字。
6. 行首是大寫英文字母。
7. 行尾不是 '.' 句點。

```
cat re1.txt | grep -i 'you' > result1.txt
cat re1.txt | grep 't[ae]st' > result2.txt
cat re1.txt | egrep '[^g|^t]oo' > result3.txt
cat re1.txt | grep '[^0-9][0-9]\{4\}[^0-9]' > result4.txt
cat re1.txt | grep '[0-9]\{2,\}' > result5.txt
cat re1.txt | grep '^[A-Z]' > result6.txt
cat re1.txt | grep '[^\.]$' > result7.txt
```
