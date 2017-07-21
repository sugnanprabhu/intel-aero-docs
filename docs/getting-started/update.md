# Update Intel Aero software

The Intel Aero Compute Board and the RTF Kit comes already flashed from factory
and ready to use. The version may vary and it's recommended for developers to
update to the last available version.

## Download the latest version

The last software version can be downloaded from
[Intel's Download Center](https://downloadcenter.intel.com/download/26932/Intel-Aero-Platform-for-UAVs-Installation-Files).
You will need to download the "Operating system image" and the "Capsule/BIOS"
from that page.

!!! Tip
    The Operating system image is updated much more frequently than the BIOS.
    If you already have the last BIOS flashed you don't need to download and
    flash it again. Check [XXXXXX](#) for instructions on how to check version
    currently installed.

As of this writting the OS Image is at version 1.4 and the BIOS at version
1.00.12. After downloading it's advised to check if the download was successful
by checking its md5sum. It must match the md5sum published on the Download Center.

## Check md5sum

### Linux and macOS

Open a terminal and execute the following command:

``` sh
md5sum ~/Downloads/intel-aero-image-1.4.iso
```

The command above assumes the download has been done to your Downloads directory,
which is usually the default location but may vary across distros.

### Windows

You will need to download and install [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager/).
This software can also be used later below if you are following the Windows-specific
instructions. See picture below that contains the "MD5 hash" for an earlier
version of the OS image.

<img src="../img/win32_disk_imager_md5sum.png" class="img-center-horizontally" />


## Write OS image to USB drive

The method to write the image to the USB drive will depend on what Operating
System you are using. Below you can find options that work on each of Linux,
Windows and macOS.

### Linux, Windows and macOS

Follow these steps:

- Download and install [Etcher](https://etcher.io/). follow specific instructions
  on their website for installation
- Launch Etcher
- Select the downloaded OS image file
- Select the USB drive where it will be written to
- Click on "Flash" button

Wait for the image to be written and verified.

### Linux and macOS *(alternative)*

It's possible to use the command line to write the image to a USB drive as
below. Note that the letter *X* below should be replaced by the letter of
your USB drive (be careful not to use the wrong drive since it can overwrite
your main disk).

``` sh
dd if=~/Downloads/intel-aero-image-1.4.iso of=/dev/sdX bs=1M
```

### Windows

If you are using this method, you need to use Win32 Disk Imager
as detailed in [Check md5sum](#windows) section. After checking the
download is correct proceed with the following steps:

- Select your USB drive
- Click on "Write" button

## Flash OS image to Compute Board

In order to flash a new OS image you can connect to it either via
WiFi or USB. Since the USB port will be needed to connect the USB drive
it's recommended to use WiFi though. Follow the instructions on [XXXXX](#) to
connect establish the network connection and connect via ssh. The commands
above assume you are already connected to the Compute Board.

If you already have an OS image with version 1.2 or greater and connected
via WiFi, just type the following command. For versions before that, continue
reading for alternative instructions.

``` sh
aero-reboot-update.py

```

This will verify you have a new OS image on the USB drive and reboot in update
mode. If you are connected via USB you have to bypass the check and after
seeing the message that the system is rebooting rapidly connect the USB drive:

``` sh
aero-reboot-update.py -f
```

Before version 1.2 the command above didn't exist and you will need to manually
access the command directly from the new OS image. Use the following commands:

``` sh
mkdir -p /tmp/{iso,newroot}
mount -o ro /dev/sda1 /tmp/iso
mount -o loop,ro /tmp/iso/rootfs.img /tmp/newroot
/tmp/newroot/usr/sbin/aero-reboot-update.py
```

## Flash progress

The updated process gives feedback to the user in some forms:

1. If you have an HDMI screen connected, you will see the progress of the
   update as text on it
1. Internal RGB LED on Compute Board will blink according to the different
   phases:

    1. When the board is turned on the LED is green
    1. Before rebooting the RGB LED will become yellow: this means the board
       started the reboot progress. It takes around 20 seconds for this
       command to take effect and thus change from yellow to green again.
       If the BIOS version is older than 1.00.12, the reboot command may get
       stuck. You can safely remove power and power it on again if that happens:
       it will proceed with the update process
    1. When board is rebooted the RGB LED becomes green again
    1. During the update process the RGB LED will blink red once a second (1Hz).
       The time taken by the update process may vary, but should take around 3
       minutes.
    1. When the Compute Board is updated the RGB LED will blink fast at 10Hz for
       5 seconds and reboot. After that the update process is done and you should
       be greeted with the new version

1. On the RTF kit there are additional blue LEDs next to the power button. They
   will follow the same blink pattern as above with the exception that they don't
   change color

!!! Tip
    On the RTF kit it may be difficult to see the internal RGB LED. You can look
    to the hole through each the FAN cable is passing in order to
    check it's. See the image below for reference. You can also use your hand
    putting it near to the hole to reflect the light and monitor the progress.

    ![RGB LED on RTF kit](img/rgb-led-rtf.png)
