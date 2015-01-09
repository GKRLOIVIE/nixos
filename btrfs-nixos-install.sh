gdisk /dev/sda # make 1 partition

mkfs.vfat -n BOOT /dev/sda1
mkfs.btrfs -L root /dev/sdb
mkfs.btrfs -L docker /dev/sdc 

mount -t btrfs -o noatime,discard,ssd,autodefrag,compress=lzo,space_cache /dev/sdb /mnt/
btrfs subvolume create /mnt/nixos
umount /mnt/
mount -t btrfs -o noatime,discard,ssd,autodefrag,compress=lzo,space_cache,subvol=nixos /dev/sdb /mnt/
btrfs subvolume create /mnt/var
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/tmp

mkdir /mnt/boot
mount /dev/sda1 /mnt/boot/

mkdir /mnt/var/docker
mount -t btrfs -o noatime,discard,ssd,autodefrag,compress=lzo,space_cache /dev/sdc /mnt/var/docker
btrfs subvolume create /mnt/var/docker/docker
umount /mnt/var/docker/
mount -t btrfs -o noatime,discard,ssd,autodefrag,compress=lzo,space_cache,subvol=docker /dev/sdc /mnt/var/docker

nixos-generate-config --root /mnt/

ifconfig eth1 192.168.58.10/24
nc 192.168.58.1 1234 > gist.txt
export $REMOTE_DESKTOP_CONF ='https://gist.githubusercontent.com/alcol80/d235ee0933cc9cf1655f/raw/d979847f73526a7d2f95e3befb0fbc0445fecfc8/desktop-configuration.nix'
curl $REMOTE_DESKTOP_CONF > /mnt/etc/nixos/desktop-configuration.nix

# include desktop-configuration and checks the other configuration options
vim /mnt/etc/nixos/configuration.nix
nixos-install
reboot