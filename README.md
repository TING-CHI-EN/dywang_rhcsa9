# dywang_rhcsa9
#### 上課sid
```
echo '4-2 159 11227608 丁啟恩' > sid
```
```
echo '4-1 197 11227603 林明煌' > sid
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
# [2023.11.02]
# [群組管理](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node76.html)
#### 增加 sharegrp 群組
```
groupadd sharegrp
```
#### 查詢 sharegrp 群組是否存在？ 
```
getent group sharegrp
```
#### 刪除 sharegrp 群組
```
groupdel sharegrp
```
# [帳號與身份管理](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node82.html)
#### useradd：增加使用者
```
useradd [-ungGmMd] user
參數：
-u:  指定帳號的 UID。 
-n:  群組為 users。 
-g:  後接之群組為「主要群組(primary group)」，變動 /etc/passwd。 
-G:  後接之群組為「附屬群組(supplementary group)」，變動 /etc/group。 
-M:  不要建立使用者家目錄。 
-m:  建立使用者家目錄。 
-d:  指定某個目錄為家目錄，而不使用預設目錄。 
-s:  指定使用的 shell。
```
#### 新增帳號 deyu1，其附屬群組為 sharegrp
```
useradd -G sharegrp deyu1
```
#### 新增帳號 deyu2，其附屬群組為 sharegrp。
```
useradd -G sharegrp deyu2
```
#### 新增帳號 deyu3，此帳號不能使用互動式 shell 登入。 
```
useradd -s /sbin/nologin deyu3
```
#### 檢查帳號 deyu1 及 deyu2，附屬群組為 sharegrp，帳號 deyu3 沒有附屬群組。 
```
[root@kvm8 ~]# id deyu1
uid=1000(deyu1) gid=1001(deyu1) groups=1001(deyu1),1000(sharegrp)
[root@kvm8 ~]# id deyu2
uid=1001(deyu2) gid=1002(deyu2) groups=1002(deyu2),1000(sharegrp)
[root@kvm8 ~]# id deyu3
uid=1002(deyu3) gid=1003(deyu3) groups=1003(deyu3)
```
#### 新增帳號 deyu4，並指定其 uid 為 3584。
```
useradd -u 3584 deyu4
```
#### userdel 刪除帳號 deyu1
```
userdel -r deyu1
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node91.html)

    建立用戶帳號
        deyu1 附屬群組為 sharegrp
        deyu2 附屬群組為 sharegrp
        deyu3 無法使用 shell 登入
        deyu4 指定 uid 為 3854
        四個帳號的密碼皆設定為 123qwe
    帳號名稱、UID、附屬群組設定錯誤皆可使用 usermod 修改。
    若刪除帳號重新新增，刪除時必須連「家目錄」一併刪除，否則新增的帳號可能無法存取家目錄。
```
useradd -G s11227608g felix
useradd -G s11227608g cara
useradd -s /sbin/nologin mono
useradd -u 3569 ann
echo 'hdw2csk' | passwd --stdin felix
echo 'hdw2csk' | passwd --stdin cara
echo 'hdw2csk' | passwd --stdin mono
echo 'hdw2csk' | passwd --stdin ann
```
# [su與sudo](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node92.html)
#### 範例：visudo 編輯 /etc/sudoers，增加用戶 deyu9 可免密碼以 root 權限從任何主機執行任何命令。
```
visudo
```
deyu9	ALL=(ALL) 	NOPASSWD:ALL 
#### 新增用戶 deyu9
```
useradd deyu9
```
#### 範例：visudo 編輯 /etc/sudoers，增加群組 dygrp 可以 root 權限從任何主機執行命令 /sbin/hwclock。 
```
visudo
```
%dygrp	ALL=(ALL) 	/sbin/hwclock
#### 新增群組 dygrp，並新增用戶 deyu21，其附屬群組為 dygrp。 
```
groupadd dygrp
useradd deyu21 -G dygrp
```
#### 設定 deyu21 的密碼 
```
echo qweqwe | passwd --stdin deyu21
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node97.html)
#### 切換用戶 deyu9 
#### 執行 vgs，標準錯誤(stderr) 導向到 ~/vgs.9.err。 
#### 執行 sudo vgs，標準輸出(stdout) 導向到 ~/vgs.9.out。 
#### 切換用戶 deyu21
#### 執行 vgs，標準錯誤(stderr) 導向到 ~/vgs.21.err。 
#### 執行 sudo vgs，標準輸出(stdout) 導向到 ~/vgs.21.out。 
```
su - amy
```
```
vgs 2> ~/vgs.9.err
sudo vgs > ~/vgs.9.out
```
```
su - tina
```
```
vgs 2> ~/vgs.21.err
sudo vgs > ~/vgs.21.out
```
# [2023.11.09]
# [帳號密碼策略](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node98.html)

```
vim /etc/login.defs
```
```
# Password aging controls:
#
# 密碼需要重新變更的天數，99999 表示密碼不需要重新設定。
#	PASS_MAX_DAYS	Maximum number of days a password may be used.
# 密碼不可被更動的天數，0 表示密碼隨時可以更動。
#	PASS_MIN_DAYS	Minimum number of days allowed between password changes.
# 密碼最短長度，5 表示密碼不能少於5個字元。
#	PASS_MIN_LEN	Minimum acceptable password length.
# 密碼需要變更前的警告，7 表示7天之內系統會警告帳號。
#	PASS_WARN_AGE	Number of days warning given before a password expires.
#
PASS_MAX_DAYS	99999
PASS_MIN_DAYS	0
PASS_MIN_LEN	5
PASS_WARN_AGE	7
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node103.html)
```
要看參數檔
設定預設密碼過期略策，也就是新增的帳號，其密碼會有以下策略。
    最長不用變更天數 30
    可以變更的最短天數 4
    密碼過期前 6 天警告
    密碼長度至少 8
新增帳號 deyu11，chage 查看是否如預設，以管線命令配合 tee 命令導向到 /root/chage1。
新增帳號 deyu12，chage 設定
    最長不用變更天數 20
    可以變更的最短天數 7
    密碼過期前 4 天警告
chage 查看 deyu12帳號，是否如變更，並導向 /root/chage2。
```
```
useradd deyu11
useradd deyu12
chage -M 29 deyu12
chage -m 8 deyu12
chage -W 9 deyu12
chage -l deyu11 | tee > /root/chage1
chage -l deyu12 | tee > /root/chage2
```
# [Linux 檔案權限與屬性](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node104.html)
#### 要讓 deyu6 的 umask 維持 0002，必須將其寫入 .bashrc。 
```
vim .bashrc
```
umask 0002
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node111.html)
1. 建立用戶的預設權限。
    + 設定帳號 deyu6 預設權限為 0002，且登入後必須立即生效。
    + deyu6 登入後，分別建立 maskf 檔案及 maskd 目錄。
    + 觀察檔案 maskf 的屬性是否為 664？目錄 maskd 的屬性是否為 775？
2. 建立 sharegrp 團隊工作目錄， deyu1.f, deyu2.f 中的 deyu1, deyu2 請依參數檔變更。
    + 建立 /home/shared 目錄，並設定其為群組 sharegrp 團隊工作目錄，擁有者及群組有rwx權限，其他沒有任何權限，且SETGID。
    + deyu1 與 deyu2 都屬於 sharegrp 群組，分別用 deyu1 及 deyu2 帳號在 /home/shared 目錄中建立檔案 deyu1.f 及 deyu2.f。
    + 觀察 deyu1.f 及 deyu2.f 所屬的群組，看看 deyu1 能不能更改 deyu2.f 內容？deyu2 是否可以變更 deyu1.f 內容？
    + deyu4 不屬於 sharegrp 群組，測試 deyu4 是否可以進入 /home/shared 目錄？將標準錯誤(stderr)導向到 /home/deyu4/cd.shared。
```
touch mfile2t
mkdir mdir2t
```
```
mkdir /home/s11227608d
chgrp s11227608g /home/s11227608d/
chmod 2770 /home/11227608d/
```
```
su - felix
touch /home/s11227608d/felix.f
```
```
su - cara
touch /home/s11227608d/cara.f
```
```
su - ann
cd /home/s11227608d/ 2> /home/ann/cd.shared
```
# [2023.11.16]
# [Access Control Lists](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node112.html)
#### 先複製測試檔案 (參數檔看fstab)
```
cp /etc/auto.net /var/tmp/
```
#### 查看複製的檔案擁有者，群組皆為 root，目前權限為 644，root 有讀取及寫入的權限。 
```
ll /var/tmp/auto.net
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node116.html)
```
1. 建立包含 ACL 的檔案
    - 複製 /etc/fstab 到 /var/tmp 目錄下
    - 查看 /var/tmp 目錄下的 fstab 檔案，其 acl 有無特殊的用戶權限設定？
    - 設定 deyu1 可讀寫 fstab
    - 設定 deyu2 不可讀寫 fstab
    - 不要變動其他設定
2. 變更 ACL 的檔案
    - 查看 /var/tmp 目錄下的 fstab 檔案，其 acl 有無特殊的用戶權限設定？
    - 設定 deyu4 可讀寫 fstab
    - 刪除 deyu4 可讀寫 fstab
    - 不要變動其他設定
```
```
setfacl -m u:felix:rw /var/tmp/auto.net
setfacl -m u:cara:- /var/tmp/auto.net
```
# [例行性命令](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node117.html)
#### 分 時 日 月 周
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node121.html)
```
crontab -u alice -e
```
```
* */18 * * * /bin/echo hello_s11227608_sa
24 3-16 * * * /bin/echo hello_s11227608_sa
45 13 10,29 * * /bin/echo hello_s11227608_sa
*/25 3 * * 1 /bin/echo hello_s11227608_sa
52 8 * * * /bin/echo hello_s11227608_sa
```
# [Chronyd vs. ntpd 校時](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node122.html)
```
vim /etc/chrony.conf
```
```
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (https://www.pool.ntp.org/join.html).
pool 2.almalinux.pool.ntp.org iburst
pool server.deyu.wang iburst
```
```
systemctl restart chronyd.service
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node127.html)
```
設定自動效時
    自動校時伺服器 server.deyu.wang
    確認 chronyd 服務是否開機啟動 (enable)？導向到 /root/chronyd-enabled。
    確認 chronyd 服務是否啟動 (active)？導向到 /root/chronyd-active
    chronyc 查詢設定的伺服器是否出現？管線處理過濾 deyu，導向到 /root/chronyc-sources。
```
```
systemctl is-active chronyd.service > /root/chronyd-active
systemctl is-enabled chronyd.service > /root/chronyd-enabled
chronyc sources | grep deyu > /root/chronyc-sources
```
# [2023.11.23]
# [Network File System, NFS](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node128.html)
#### 如果沒有 nfs-utils，必須先安裝。 
```
dnf install nfs-utils
```
#### 如果沒安裝 autofs 套件，必須先安裝。
```
dnf install autofs
```
#### 建立主要設定檔 /etc/auto.master
    1. 格式：<預設目錄> <資料對應檔>
    2. 預設目錄：用戶端要使用 /home/guests/ldapuser1，會到資料對應檔中找次目錄 ldapuser1 的對應。
    3. 資料對應檔的檔名是可以自行設定的，此例中使用 /etc/auto.dyw。
```
vim /etc/auto.master
```
```
#
# Sample auto.master file
# This is a 'master' automounter map and it has the following format:
# mount-point [map-type[,format]:]map [options]
# For details of the format look at auto.master(5).
#
/rhome /etc/auto.dyw
/misc   /etc/auto.misc
```
#### 建立資料對應檔內的掛載資訊，若 NFS server 有限制版本為 v3，則必須加入參數 -vers=3。 
```
vim /etc/auto.dyw
```
```
*  -vers=3  deyu.wang:/home/guests/&
```
#### 設定開機即啟動 autofs 
```
systemctl enable autofs
```
#### 重新啟動 autofs 服務
```
systemctl restart autofs
```
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node135.html)
```
autofs = /home/quests = /rhome
自動掛載設定
    - 查看 deyu.wang 分享的 NFS 目錄，看是否有 /home/guests？查詢結果導向到 /root/smount。
    - getent 查看系統中是否有 ldapuser1 帳號，導向到 /root/ldapuser，觀察其家目錄在哪？
    - 設定自掛載伺服器 deyu.wang:/home/guests 到本機的 /home/guests。
    - 掛載 NFS 版本為 3。
    - 切換用戶為 ldapuser1，看是否有家目錄？
    - 確認 autofs 服務是否開機啟動 (enable)？導向到 /root/autofs-enabled。
    - 確認 autofs 服務是否啟動 (active)？導向到 /root/autofs-active。
```
```
showmount -e deyu.wang > /root/smount
getent passwd ldapuser3 > /root/ldapuser
systemctl is-enabled autofs.service > /root/autofs-enabled
systemctl is-active autofs.service > /root/autofs-active
```
# [檔案搜尋](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node136.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node141.html)
```
找用戶檔案
    找系統中所有屬於 deyu8 的檔案
    建立目錄 /root/findresults
    將找到的檔案複製到 /root/findresults 目錄中
找特定大小檔案
    找目錄 /usr/share 中大於 1M 的檔案，導向到 /root/find1
    找目錄 /usr/share 中小於 5M 的檔案，導向到 /root/find2
    找目錄 /usr/share 中小於 300k 且大於 250k 的檔案，導向到 /root/find3
找特定屬性檔案
    找目錄 /etc/systemd 屬性包含 664 的檔案，導向到 /root/find4
    找系統中屬性包含 SUID 的檔案，導向到 /root/find5
    找系統中屬性包含 SGID 的檔案，導向到 /root/find6
    找系統中屬性包含 SBIT 的檔案，導向到 /root/find7
```
```
mkdir /root/mfindr
find / -user deyu8 2> /dev/null | xargs cp -t /root/mfindr/
find /usr/share -size +1M > /root/find1
find /usr/share -size -5M > /root/find2
find /usr/share -size +250k -size -300k > /root/find3
find /etc/systemd/ -perm -664 > /root/find4
find / -perm -4000 > /root/find5
find / -perm -2000 > /root/find6
find / -perm -1000 > /root/find7
```
# [2023.11.30]
# [Shell Script](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node142.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node141.html)
```
寫腳本 newfind.sh
    第一行 shebang 宣告使用的直譯器指令
    newfind.sh 所有人可執行
    找目錄 /usr 中小於 300k 且大於 250k 的檔案，導向到 /root/newfind.txt
    把 newfind.sh 放到 PATH 路徑可以找到的 /usr/local/bin 目錄，讓所有人可以不用指定路徑就可執行。
寫腳本 newfind1.sh 找特定屬性檔案
    第一行 shebang 宣告使用的直譯器指令
    腳本包含以下三行命令
        找系統中屬性包含 SUID 的檔案
        找系統中屬性包含 SGID 的檔案
        找系統中屬性包含 SBIT 的檔案
    把 newfind1.sh 放到 PATH 路徑可以找到的 /usr/bin 目錄，讓所有人可以不用指定路徑就可執行。
```
```
vim nfindf
```
```
#!/bin/bash
find /usr -size +250k -size -300k > /root/nfindf.txt
```
```
mv nfindf /usr/local/bin/
```
```
vim nfinde
```
```
#!/bin/bash
find / -perm -4000
find / -perm -2000
find / -perm -1000
```
```
mv nfinde /usr/local/bin/
```
# [檔案打包壓縮](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node148.html)
## [實機練習](https://dywang.csie.cyut.edu.tw/dywang/rhcsa9/node151.html)
```
將整個 /usr/local (由變數 tzdir 決定) 目錄整個打包壓縮成以下檔案：
    壓縮方式 gzip，存成檔案 /root/tzfile.tgz。
    壓縮方式 bzip2，存成檔案 /root/tzfile.tar.bz2。
    壓縮方式 xz，存成檔案 /root/tzfile.tar.xz。
不解開打包壓縮檔的情況下，查看以下檔案的內容，看是否與原始資料相同？
    /root/tzfile.tgz 查看結果導向到 /root/tzfile.tgz.t。
    /root/tzfile.tar.bz2 查看結果導向到 /root/tzfile.tar.bz2.t。
    /root/tzfile.tar.xz 查看結果導向到 /root/tzfile.tar.xz.t。
解壓縮打包，查看解開的檔案是否與原始資料相同？
    建立目錄 /root/mytar.gz
    切換工作目錄到 /root/mytar.gz
    解打包壓縮 /root/tzfile.tgz
    建立目錄 /root/mytar.bz
    切換工作目錄到 /root/mytar.bz
    解打包壓縮 /root/tzfile.tar.bz2
    建立目錄 /root/mytar.xz
    切換工作目錄到 /root/mytar.xz
    解打包壓縮 /root/tzfile.tar.xz
```
```
tar zcvf /root/tarf.tgz /etc/pki/
tar jcvf /root/tarf.tar.bz2 /etc/pki/
tar Jcvf /root/tarf.tar.xz /etc/pki/

tar ztvf /root/tarf.tgz > /root/tarf.tgz.t
tar jtvf /root/tarf.tar.bz2 > /root/tarf.tar.bz2.t
tar jtvf /root/tarf.tar.xz > /root/tarf.tar.xz.t
```
