#!/bin/bash
cd $PWD
# Packages
common="sudo vim sshfs nfs-common systemd-timesyncd unzip xz-utils sshpass bzip2 python3-apt screen htop stress hdparm tree curl wget net-tools tcpdump traceroute iperf ethtool geoip-bin speedtest-cli nload autossh socat"

workstation="cryptsetup smartmontools uuid pigz passwd lm-sensors hdparm x11-xkb-utils bc fwupd tree pm-utils acpid cpulimit btrfs-progs ntfs-3g dosfstools rsync nfs-kernel-server"

server="samba"

graphics="nvidia-driver firmware-amd-graphics"

firmware="firmware-misc-nonfree firmware-realtek firmware-atheros"

hypervisor="qemu-kvm libvirt0 bridge-utils libvirt-daemon-system"

de="xorg xserver-xorg-input-libinput xserver-xorg-input-evdev brightnessctl xserver-xorg-input-mouse xserver-xorg-input-synaptics lightdm openbox obconf lxterminal lxpanel lxhotkey-gtk lxtask lxsession-logout lxappearance lxrandr progress arc-theme nitrogen ffmpegthumbnailer gpicview evince galculator gnome-screenshot l3afpad alacarte gpick compton pcmanfm unrar firefox-esr engrampa gparted gnome-disk-utility baobab virt-manager ssh-askpass"

minide="xorg openbox"

while true; do
clear
echo '================================================
Welcome to the post installation script for Debian minimal. Choose the type of installation you want:

1) Workstation

2) Server

3) Virtual machine

4) Raspberry Pi

5) Exit

================================================'

read -p "Enter the desired installation type and start it by pressing the Enter key: " x
echo "($x)
================================================"

case "$x" in
1)
echo "**INSTALLING PACKAGES**"
apt install -qq $common $workstation $de $hypervisor
{
echo "**CREATING DIRECTORIES**"
mkdir -pv /etc/scripts/scheduled/virsh
mkdir -pv /var/log/clamav/daily
mkdir -v /var/log/virsh
mkdir -v /var/log/rc.local
chown emperor:emperor -R /var/log/rc.local
mkdir -v /var/log/rsync
chown emperor:emperor -R /var/log/rsync
mkdir -v /root/Temp
mkdir -v /root/.isolation
mkdir -v /root/.crypt
mkdir -v /mnt/Temp
mkdir -pv /mnt/Local/USB/A
mkdir -v /mnt/Local/USB/B
mkdir -v /mnt/Local/Container-A
mkdir -v /mnt/Local/Container-B
mkdir -pv /mnt/Remote/Servers
chown emperor:emperor -R /mnt
mkdir -v /home/emperor/Temp
mkdir -v /home/emperor/.ssh
mkdir -v /root/.ssh
chown emperor:emperor -R /home/emperor
#Conf Base
echo "**SETTING UP BASE**"
systemctl disable --now nfs-kernel-server
{(
    printf '#!/bin/sh
/etc/scripts/startup.sh' > /etc/rc.local
)}
chmod 755 /etc/rc.local
cp -v startup.sh /etc/scripts && chmod +x /etc/scripts/startup.sh
rm -v /etc/systemd/timesyncd.conf
{(
    printf '[Time]
NTP=a.st1.ntp.br' > /etc/systemd/timesyncd.conf
)}
rm -v /etc/network/interfaces && cp -v interfaces /etc/network
rm -v /etc/ssh/sshd_config && cp -v sshd_config /etc/ssh
chmod 644 /etc/ssh/sshd_config
rm -v /etc/motd && touch /etc/motd
{(
    printf '#/mnt/Local/Container-A 10.0.0.1(rw,sync,crossmnt,no_subtree_check,no_root_squash)' > /etc/exports
)}
cp -v avscan.sh /etc/scripts/scheduled && chmod +x /etc/scripts/scheduled/avscan.sh
cp -v sync.sh /etc/scripts/scheduled && chmod +x /etc/scripts/scheduled/sync.sh
cp -v useful /etc
ln -s /etc/useful /home/emperor/.useful
ln -s /etc/useful /root/.useful
chmod 700 /home/emperor/.ssh
su - emperor -c "echo | touch /home/emperor/.ssh/authorized_keys"
chmod 600 /home/emperor/.ssh/authorized_keys
su - emperor -c "echo | ssh-keygen -t rsa -b 4096 -N '' <<<$'\n'" > /dev/null 2>&1
chmod 600 /root/.isolation
chmod 600 /root/.crypt
chmod 600 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
ssh-keygen -t rsa -b 4096 -N '' <<<$'\n' > /dev/null 2>&1
}
{
while true; do
clear
gpasswd libvirt -a emperor
touch /etc/modprobe.d/kvm.conf
virsh net-autostart default
cpu=$(lscpu | grep 'Vendor ID' | cut -f 2 -d ":" | awk '{$1=$1}1')
echo "$cpu"
case "$cpu" in
GenuineIntel)
#Nested Intel processors
echo 'options kvm_intel nested=1' >> /etc/modprobe.d/kvm.conf
/sbin/modprobe -r kvm_intel
/sbin/modprobe kvm_intel
sleep 5
;;
esac
done
}
echo "**SETTING UP THE DESKTOP ENVIRONMENT**"
rm -v /etc/lightdm/lightdm-gtk-greeter.conf && cp -v lightdm-gtk-greeter.conf /etc/lightdm
cp -v default.jpg /usr/share/wallpapers
tar -xvf 01-Qogir.tar.xz -C /usr/share/icons > /dev/null 2>&1
tar -xvf Arc-Dark.tar.xz -C /usr/share/themes > /dev/null 2>&1
cp -v debian-swirl.png /usr/share/icons/default
mkdir -pv /etc/X11/xorg.conf.d && cp -v 40-libinput.conf /etc/X11/xorg.conf.d
echo "$USER"
rm -r /home/$USER/.config && cp -r config /home/$USER/.config
cp -v gtkrc-2.0 /home/$USER/.gtkrc-2.0
chown $USER:$USER -R /home/$USER
chown $USER:$USER /usr/share/wallpapers/default.jpg
sleep 5s
echo "Finished
================================================"
exit 0
;;
2)
echo "**INSTALLING PACKAGES**"
apt install -qq $common $workstation $server
sleep 5s
{
while true; do
clear
read -p "Deseja instalar interface gráfica? [y/n]" x
echo "================================================"
case "$x" in
y)
echo "**SETTING UP THE DESKTOP ENVIRONMENT**"
rm -v /etc/lightdm/lightdm-gtk-greeter.conf && cp -v lightdm-gtk-greeter.conf /etc/lightdm
cp -v default.jpg /usr/share/wallpapers
tar -xvf 01-Qogir.tar.xz -C /usr/share/icons > /dev/null 2>&1
tar -xvf Arc-Dark.tar.xz -C /usr/share/themes > /dev/null 2>&1
cp -v debian-swirl.png /usr/share/icons/default
mkdir -pv /etc/X11/xorg.conf.d && cp -v 40-libinput.conf /etc/X11/xorg.conf.d
echo "$USER"
rm -r /home/$USER/.config && cp -r config /home/$USER/.config
cp -v gtkrc-2.0 /home/$USER/.gtkrc-2.0
chown $USER:$USER -R /home/$USER
chown $USER:$USER /usr/share/wallpapers/default.jpg
echo "Finished
================================================"
sleep 5s
exit 0
;;
n)
echo "Finished
================================================"
sleep 5s
exit 0
;;
*) echo "Invalid option!"
esac
done
}
;;
3)
apt install -qq $common
sleep 5s
echo "Finished
================================================"
exit 0
;;
4)
sensors
sleep 5s
echo "Finished
================================================"
exit 0
;;
5)
echo "Leaving...
================================================"
sleep 5s
clear
exit 0
;;
*) echo "Invalid option!"
esac
done