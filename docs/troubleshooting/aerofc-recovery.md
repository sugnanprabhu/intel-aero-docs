# Aero Flight controller
The Aero Flight Controller is connected to compute board via MAX10 FPGA.

The OS image comes with certain recommended versions of the FPGA firmware.

[More details on the available fpga firmware](https://intel-aero.github.io/getting-started/update/#fpga)

# Recovery methods 
If flight controller is not responding and not able to flash with [standard commands](https://intel-aero.github.io/getting-started/update/#flight-controller)

One of the following recovery methods can be used to force the aero flight controller in to bootloader and flash flight controller firmware.

### Method 1
Connect to aero compute board over serial or ssh via USB/WIFI

Ignore the following step if FPGA is already flashed with the aero-rtf.jam firmware
```console
# jam -aprogram /etc/fpga/aero-rtf.jam          
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
configuring SRAM device(s)...
full-chip erasing Max 10 FPGA device(s) ...
programming Max 10 FPGA DSM block ...
performing operation on MAX 10 FPGA CFM0 block at sector 4 ...
performing operation on MAX 10 FPGA CFM0 block at sector 5 ...
performing operation on MAX 10 FPGA UFM block at sector 1 ...
performing operation on MAX 10 FPGA UFM block at sector 2 ...
performing operation on MAX 10 FPGA UFM block at sector 3 ...
DONE
Exit code = 0... Success
```

Force aerofc bootloader pin to high
```console
# aerofc-force-bootloader-pin.py 1
Writing force bootloader pin...
Done!
Reading force bootloader pin...
Force bootloader pin value = 0x1
```

Flash flight controller firmware
```console
# aerofc-update.sh /etc/aerofc/<flight controller firmware>
```

Force aerofc bootloader pin back to low
```console
# aerofc-force-bootloader-pin.py 0
```

### Method 2

Connect to aero compute board over serial or ssh via USB/WIFI

Flash recovery FPGA firmware
```console
# jam -aprogram /etc/fpga/aero-rtf-recovery.jam 
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
full-chip erasing Max 10 FPGA device(s) ...
programming Max 10 FPGA CFM0 block at sector 4 ...
programming Max 10 FPGA CFM0 block at sector 5 ...
programming Max 10 FPGA UFM block at sector 1 ...
programming Max 10 FPGA UFM block at sector 2 ...
programming Max 10 FPGA UFM block at sector 3 ...
verifying Max 10 FPGA CFM0 block at sector 4 ...
verifying Max 10 FPGA CFM0 block at sector 5 ...
verifying Max 10 FPGA UFM block at sector 1 ...
verifying Max 10 FPGA UFM block at sector 2 ...
verifying Max 10 FPGA UFM block at sector 3 ...
programming Max 10 FPGA DSM block ...
DONE
Exit code = 0... Success
```
After flashing power cycle the aero board.

Flash flight controller firmware
```console
# aerofc-update.sh /etc/aerofc/<flight controller firmware>
```

Flash aero-rtf.jam to change FPGA back to rtf mode
```console
# jam -aprogram /etc/fpga/aero-rtf.jam          
```

