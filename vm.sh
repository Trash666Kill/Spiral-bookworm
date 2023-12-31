#!/bin/bash
#
cd $PWD/Repository
rm -v /etc/apt/sources.list
cp -v sources.list /etc/apt
#Update and Upgrade
echo "**UPDATING AND UPGRADING**"
apt update && apt upgrade -y
#Base packages*
echo "**INSTALLING BASE PACKAGES**"
echo "1"
apt install sudo vim sshfs nfs-common systemd-timesyncd unzip xz-utils sshpass bzip2 python3-apt screen -y
echo "2"
apt install htop stress hdparm tree zabbix-agent -y
echo "3"
apt install curl wget net-tools tcpdump traceroute iperf ethtool geoip-bin speedtest-cli nload autossh -y
#Directories
echo "**CREATING DIRECTORIES**"
mkdir -pv /etc/scripts/scheduled
mkdir -v /var/log/rc.local
chown emperor:emperor -R /var/log/rc.local
mkdir -v /var/log/rsync
chown emperor:emperor -R /var/log/rsync
mkdir -v /root/.crypt
mkdir -v /mnt/Temp
mkdir -v /mnt/Services
chown emperor:emperor -R /mnt
mkdir -v /home/emperor/Temp
mkdir -v /home/emperor/.ssh
mkdir -v /root/.ssh
chown emperor:emperor -R /home/emperor
#Conf Base
echo "**SETTING UP BASE**"
systemctl enable --now serial-getty@ttyS0.service
rm -v /etc/default/grub
cp -v grub /etc/default
chmod 644 /etc/default/grub
update-grub
systemctl disable zabbix-agent
cp -v startup.sh /etc/scripts
chmod +x /etc/scripts/startup.sh
cp -v rc.local /etc
chmod 755 /etc/rc.local
rm -v /etc/network/interfaces
cp -v interfaces /etc/network
rm -v /etc/ssh/sshd_config
cp -v sshd_config /etc/ssh
rm -v /etc/motd
cp -v useful /home/emperor/.useful
touch /etc/motd
chmod 700 /home/emperor/.ssh
su - emperor -c "echo |touch /home/emperor/.ssh/authorized_keys"
chmod 600 /home/emperor/.ssh/authorized_keys
#su - emperor -c "echo |ssh-keygen -t rsa -b 4096 -N '' <<<$'\n'" > /dev/null 2>&1
chmod 600 /root/.crypt
chmod 600 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
#ssh-keygen -t rsa -b 4096 -N '' <<<$'\n' > /dev/null 2>&1
/sbin/usermod -aG sudo emperor

#Cleaning up
echo "**CLEANING UP**"
apt autoremove -y

#End
echo "**END**"
#Manual settings
echo "1 - Add zabbix server ip address in /etc/zabbix/zabbix_agentd.conf"
su - emperor
#
