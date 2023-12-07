tar zcvf /root/tarff.tgz /etc/pm/
tar jcvf /root/tarff.tar.bz2 /etc/pm/
tar Jcvf /root/tarff.tar.xz /etc/pm/

tar ztvf /root/tarff.tgz > /root/tarff.tgz.t
tar jtvf /root/tarff.tar.bz2 > /root/tarff.tar.bz2.t
tar Jtvf /root/tarff.tar.xz > /root/tarff.tar.xz.t

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
