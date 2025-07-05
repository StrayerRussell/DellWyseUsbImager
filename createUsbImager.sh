#!/bin/bash

githubRepo="https://github.com/StriayerRussell/DellWyseUsbImager.git"
partOne="usbImagerContents.part00"
partTwo="usbImagerContents.part01"
contents="usbImagerContents.tar"
contents_hash="60436b3c63291bc2ccdf279efde86f1e"

if [ $# -eq 0 ]; then
    cat <<EOF
Usage: $(basename "$0") <device>
Convert block device into "Dell Wyse Usb Imaging Tool v2.0.9" compatible imaging tool
Arguments:
  <device>  Target device.
Example:
  $(basename "$0") /dev/sdX
EOF
    exit 1
fi

if [ ! -e "$partOne" ]; then
    echo "Error: $partOne not found in current working directory. Please download it from $githubRepo"
    exit 1
fi

if [ ! -e "$partTwo" ]; then
    echo "Error: $partTwo not found in current working directory. Please download it from $githubRepo"
    exit 1
fi

cat $partOne $partTwo > $contents

if [ ! $(md5sum $contents | awk '{print $1}') == $contents_hash ]; then
    echo "Error: MD5 hash verification for $contents failed."
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges."
    exit 1
fi

device=$1

if [ ! -e "$device" ]; then
    echo "Error: Device $device not found."
    exit 1
fi


read -p "Warning: This will overwrite all data on $device. Are you sure you want to continue? [y/N]: " confirm
if [ "$confirm" != "y" ]; then
    echo "Operation cancelled."
    exit 1
fi

echo "Partitioning $usb_device"

sfdisk "$device" <<EOF
label: dos
device: $device
unit: sectors
sector-size: 512
${device}1 : start=63, type=c, bootable
EOF

mkfs.fat -F 32 -n "DELLWYSE" ${device}*1

sync

mkdir wyseUsb
mount ${device}*1 wyseUsb
echo "Copying contents to drive. This may take a while."
tar -C wyseUsb -xf ${contents}

umount ${device}*1
rm -rf wyseUsb $contents

echo "Usb Imager Creation Complete!"

