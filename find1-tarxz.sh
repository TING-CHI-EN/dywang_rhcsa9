tar zcvf /root/tarff.tgz /etc/pm/
tar jcvf /root/tarff.tar.bz2 /etc/pm/
tar Jcvf /root/tarff.tar.xz /etc/pm/

tar ztvf /root/tarff.tgz > /root/tarff.tgz.t
tar jtvf /root/tarff.tar.bz2 > /root/tarff.tar.bz2.t
tar Jtvf /root/tarff.tar.xz > /root/tarff.tar.xz.t

echo '#!/bin/bash
find /usr -size +250k -size -300k > /root/nfindw.txt'>nfindw

chmod +x nfindw
mv nfindw /usr/local/bin/

echo '#!/bin/bash
find / -perm -4000
find / -perm -2000
find / -perm -1000' > nfindf1

chmod +x nfindf1
mv nfindf1 /usr/bin/

mkdir /root/mytar.gz
mkdir /root/mytar.bz
mkdir /root/mytar.xz
cd mytar.gz/
tar zxvf /root/tarff.tgz
cd ..
cd mytar.bz
tar jxvf /root/tarff.tar.bz2
cd ..
cd mytar.xz/
tar Jxvf /root/tarff.tar.xz
