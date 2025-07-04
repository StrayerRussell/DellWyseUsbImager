# DellWyseUsbImager
scripts and resources for creating a "Dell Wyse USB Imaging Tool v2.0.9" compatible USB drive

Modern versions of Dell's USB imaging tool for thin clients have dropped support for older devices (such as the Wyse 3020), and older versions do not work reliably on modern operating systems.

This repository contains scripts, disk images, and general information for turning a flash drive into a "USB Imager" for pushing and pulling firmware and drive images to and from Dell/Wyse thin client devices.
This repository also contains information on reverse engineering the device image format to allow uploading custom firmware and drive images.

Currently, this repository contains an 8 GB disk image that can be flashed to a USB drive to turn it into an imager. A creation/formatting script is in the works, but has a few more kinks to iron out beforehand.
The existing disk image comes with a device image on it "WTOS_TX0D_4096_999" which contains a wloader bootloader and Debian disk image for the Wyse 3020 thin client based upon the work in this forum thread (https://forum.doozan.com/read.php?2,134563)
