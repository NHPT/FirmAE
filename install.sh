#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    SUDO=sudo
fi

$SUDO apt update
$SUDO apt install -y curl wget tar git ruby python python3 python3-pip bc
$SUDO python3 -m pip install --upgrade pip
$SUDO python3 -m pip install coloredlogs

# for docker
$SUDO apt install -y docker.io
$SUDO groupadd docker
$SUDO usermod -aG docker $USER

# postgresql
$SUDO apt install -y postgresql
$SUDO /etc/init.d/postgresql restart
$SUDO -u postgres bash -c "psql -c \"CREATE USER firmadyne WITH PASSWORD 'firmadyne';\""
$SUDO -u postgres createdb -O firmadyne firmware
$SUDO -u postgres psql -d firmware < ./database/schema
echo "listen_addresses = '172.17.0.1,127.0.0.1,localhost'" | $SUDO -u postgres tee --append /etc/postgresql/*/main/postgresql.conf
echo "host all all 172.17.0.1/24 trust" | $SUDO -u postgres tee --append /etc/postgresql/*/main/pg_hba.conf

$SUDO apt install -y libpq-dev
python3 -m pip install psycopg2 psycopg2-binary

$SUDO apt install -y busybox-static bash-static fakeroot dmsetup kpartx netcat-openbsd nmap python3-psycopg2 snmp uml-utilities util-linux vlan

# for binwalk
wget https://github.com/ReFirmLabs/binwalk/archive/refs/tags/v2.3.4.tar.gz && \
  tar -xf v2.3.4.tar.gz && \
  cd binwalk-2.3.4 && \
  sed -i 's/^install_ubireader//g' deps.sh && \
  echo y | ./deps.sh && \
  $SUDO python3 setup.py install
$SUDO apt install -y mtd-utils gzip bzip2 tar arj lhasa p7zip p7zip-full cabextract fusecram cramfsswap squashfs-tools sleuthkit default-jdk cpio lzop lzma srecord zlib1g-dev liblzma-dev liblzo2-dev unzip

cd - # back to root of project

$SUDO cp core/unstuff /usr/local/bin/

python3 -m pip install python-lzo cstruct ubi_reader
$SUDO apt install -y python3-magic openjdk-8-jdk unrar

# for analyzer, initializer
$SUDO apt install -y python3-bs4
python3 -m pip install selenium
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$SUDO dpkg -i google-chrome-stable_current_amd64.deb; $SUDO apt -fy install
rm google-chrome-stable_current_amd64.deb
python3 -m pip install -r ./analyses/routersploit/requirements.txt
cd ./analyses/routersploit && patch -p1 < ../routersploit_patch && cd -

# for qemu
$SUDO apt install -y qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils

if ! test -e "./analyses/chromedriver"; then
    wget https://chromedriver.storage.googleapis.com/2.38/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip -d ./analyses/
    rm -rf chromedriver_linux64.zip
fi
