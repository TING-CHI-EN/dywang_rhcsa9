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

ssh deyu5@kvm8

podman pull registry.csie.cyut.edu.tw/rsyslog
podman pull registry.csie.cyut.edu.tw/dywrsyslog

echo 'FROM registry.csie.cyut.edu.tw/rsyslog
MAINTAINER dywang@csie.cyut.edu.tw

RUN echo 'local4.*     /var/log/journal/podmanfile.log' >> /etc/rsyslog.conf' > Podmanfile

podman build --tag=pmrsyslog --file Podmanfile
podman build --tag=podimg http://dywang.csie.cyut.edu.tw/materials/Podmanfile

podman create --name mserver dywrsyslog
podman create --name pserver podimg

mkdir -p .config/systemd/user/
cd .config/systemd/user/

podman generate systemd --name mserver --files 
podman generate systemd --name pserver --files

systemctl --user daemon-reload 
systemctl --user enable --now container-mserver.service 
systemctl --user enable --now container-pserver.service

exit

loginctl enable-linger deyu5

reboot

ssh deyu5@kvm8

mkdir cjournal1
mkdir djournal1

podman create --name mserver --privileged --volume /home/deyu5/cjournal1/:/var/log/journal/:Z dywrsyslog:latest
podman create --name pserver --privileged --volume /home/deyu5/djournal1/:/var/log/journal/:Z podimg:latest

mkdir -p .config/systemd/user/
cd .config/systemd/user/

podman generate systemd --name mserver --files
podman generate systemd --name pserver --files
systemctl --user daemon-reload

systemctl --user enable --now container-mserver.service 
systemctl --user enable --now container-pserver.service 

podman exec -it mserver /bin/bash
logger -p local3.info 'nhy qaz vsfr'
exit

podman exec -it pserver /bin/bash
logger -p local4.info 'iiis sas qsa afr'
exit
