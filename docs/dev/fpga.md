# MAX 10 FPGA Programming
## Introduction
_References used in this page are from [Altera.com](https://www.altera.com/)_

Intel Aero Dev Kit has integrated a MAX10 FPGA [10M08SAM153](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/packaging/04r00471-00.pdf) and to use it, following are required:

* JAM STAPL player, which is provided as part of the OS Image
```
root@intel-aero:/# jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation
Usage:  jam [options] <filename>
Available options:
    -h          : show help message
    -v          : show verbose messages
    -a<action>  : specify action name (Jam STAPL)
    -d<var=val> : initialize variable to specified value (Jam 1.1)
    -d<proc=1>  : enable optional procedure (Jam STAPL)
    -d<proc=0>  : disable recommended procedure (Jam STAPL)
    -s<port>    : serial port name (for BitBlaster)
    -r          : don't reset JTAG TAP after use
```

* Firmware converted to the JAM file format, sample firmware files are located in /etc/fpga/ folder.

[More details on available sample jam files](https://intel-aero.github.io/getting-started/update/#fpga)

For FPGA Fundamentals you can refer to Altera's [online training](https://www.altera.com/support/training/curricula.html) or check out the Documentation section at the end.


## Generating a JAM file:
A [JAM file](http://quartushelp.altera.com/16.0/#reference/glossary/def_jam.htm) is a STAPL file in ASCII format, it is interpreted by the jam player to program an FPGA device.

After sucessfully creating and compiling a design with Quartus Prime, the resulting programmable object file (.pof) can be converted by following the instructions [Create JAM, JBC, SVF, or ISC File Dialog Box](http://quartushelp.altera.com/16.0/#program/pgm/pgm_com_create_jam.htm) from the Quartus Help.

This will produce the desired jam file formate to be copied to the Aero platform.

## Copying the JAM file into the device
Copy the logs to computer board from computer using scp, sftp or mounting the filesystem with sshfs


## Flashing the MAX10
A sample JAM file is provided in /etc/fpga/aero-compute-board.jam. The preferred flashing method for the MAX10 device on Intel Aero Board is through the OS command line using a port of the [JAM Standard Test and Programming Language (STAPL) player](http://www.altera.com/support/support-resources/download/legacy/jam/dnl-player.html) (jam).

JAM firmware file will provide the supported actions that can be specified by '-a'. A quick command to check available actions is:
```
root@intel-aero:~# grep ACTION /etc/fpga/aero-compute-board.jam
ACTION PROGRAM = L0, DO_BLANK_CHECK OPTIONAL, DO_VERIFY RECOMMENDED,
ACTION BLANKCHECK = L17,
ACTION VERIFY = L18,
ACTION ERASE = L24, DO_BLANK_CHECK OPTIONAL,
ACTION READ_USERCODE = L25, L27;
ACTION CHECK_IDCODE = L966, L27;
```

The expected output from the actions specified through '-a' is as follows (the intended behavior for each action depends on how the user codes the design and generates the jam file):

* **PROGRAM**: This will program and verify for correctness the JAM file specified.

```
root@intel-aero:/etc/fpga# jam -aprogram aero-compute-board.jam
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

* **BLANKCHECK**: Once successfully programmed or erased, this action will return whether the device is blank or not.

    Programmed Device:

```
root@intel-aero:/etc/fpga# jam -ablankcheck aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
blank checking Max 10 FPGA CFM0 block at sector 4 ...
Device is not blank
Exit code = 9... Device is not blank
```

    Blank Device:

```
root@intel-aero:/etc/fpga# jam -ablankcheck aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
blank checking Max 10 FPGA CFM0 block at sector 4 ...
blank checking Max 10 FPGA CFM0 block at sector 5 ...
blank checking Max 10 FPGA UFM block at sector 1 ...
blank checking Max 10 FPGA UFM block at sector 2 ...
blank checking Max 10 FPGA UFM block at sector 3 ...
DONE
Exit code = 0... Success
```

* **VERIFY**: This will ensure that the contents as interpreted by the JAM player where successfully flashed into the FPGA.

```
root@intel-aero:/etc/fpga# jam -averify aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
verifying Max 10 FPGA CFM0 block at sector 4 ...
verifying Max 10 FPGA CFM0 block at sector 5 ...
verifying Max 10 FPGA UFM block at sector 1 ...
verifying Max 10 FPGA UFM block at sector 2 ...
verifying Max 10 FPGA UFM block at sector 3 ...
DONE
Exit code = 0... Success
```

* **ERASE**:

```
root@intel-aero:/etc/fpga# jam -aerase aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
full-chip erasing Max 10 FPGA device(s) ...
DONE
Exit code = 0... Success
```

* **READ_USERCODE**: When enabled in the jam file , it programs a user defined code that can be used for tracking purposes or version control, if not used the application will return 'FFFFFFFF'.

```
root@intel-aero:/etc/fpga# jam -aread_usercode aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 USERCODE code is FFFFFFFF
DONE
Exit code = 0... Success
```

* **CHECK_IDCODE**: returns the 32-bit ID code register from the FPGA.

```
root@intel-aero:/etc/fpga# jam -acheck_idcode aero-compute-board.jam
Jam STAPL Player Version 2.5 (20040526)
Copyright (C) 1997-2004 Altera Corporation

Device #1 IDCODE is 031820DD
Device #1 IDCODE is 031820DD
DONE
Exit code = 0... Success
```

## FPGA JTAG Interface:

In Aero Board, the ported JAM STAPL implementation makes use of SOC GPIOs to bit-bang JTAG protocol information and communicate with the MAX10 device.
The GPIOs used are:

Signal | GPIO 
--- | ---
TMS | East 16
TDI | East 22
TCK | East 25
TDO | East 24

Alternatively, the platform exposes a 6-pin connector to be used with a [USB Blaster Cable](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_usb_blstr.pdf) (if available). The pin out is:

Pin # | Signal
--- | ---
6 | GND
5 | TDO
4 | TCK
3 | TDI
2 | TMS
1 | VCCIO

## Documentation/References:

* [MAX 10 Support](https://www.altera.com/products/fpga/max-series/max-10/support.html): Getting Started, Documentation, How-To Videos, Online Tutorials.
* [MAX 10 FPGA Device Architecture](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/hb/max-10/m10_handbook.pdf)
* [MAX 10 FPGA Device Overview](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/hb/max-10/m10_overview.pdf)
* [MAX 10 FPGA Datasheet](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/hb/max-10/m10_datasheet.pdf)
* [Design Examples](https://cloud.altera.com/devstore/platform/?acds_version=16.0&family=max-10)




# FPGA Sample Configuration

[Sample FPGA configurations](https://github.com/intel-aero/intel-aero-fpga/tree/master/aero_sample) is available for reference.  [Altera Quartus Lite](http://dl.altera.com/?edition=lite&platform=windows&download_manager=direct) is used to compile the project. 

The project contains implementations of several standard electrical interfaces. These include PWM, ADC, I2C, and UART.  All are accessible via the Intel® Atom™ processor using its SPI bus.

FPGA block sits on SPI bus 1 with Chip Select 1 and is accessible using the `spidev` interface. Below are some examples on modifying some of the IP blocks in the FPGA.

## SPI Address / Command Byte

| D7 | D6 | D5 | D4 | D3 | D2 | D1 | D0 |
|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| RW | A6 | A5 | A4 | A3 | A2 | A1 | A0 |

Bit[7] – Command Bit (1 - Read operation, 0 – Write Operation)

Bit[6:0] -  Register Address of the SPI Internal registers.





## PWM

There are 2-byte frequency registers to configure each PWM output. Register value = 25MHz/Desired PWM frequency,

To set PWM0, for instance, to a frequency of 500Hz (2 ms) and 50% Duty Cycle (1 ms), the frequency register should be set to a value of, 25,000,000/500 = 50,000 which is 0xC350.

The sample application can be used to configure this.
```
    spi_xfer -b 1 -c 1 -d 5097 -w 2 
    spi_xfer -b 1 -c 1 -d C398 -w 2
```

## UART

The Baud rate for the UART transmission is calculated in a similar way. For a baud rate of 115200 (default), Baud Rate Value = 25,000,000/115200 = 217 which is 0x00D9. Below is the sequence to Write and Read from UART.

Set baud rate
```
    spi_xfer -b 1 -c 1 -d D98D -w 2 
    spi_xfer -b 1 -c 1 -d 008E -w 2
```
Write the value to transmit (0x55)
```
    spi_xfer -b 1 -c 1 -d 558F -w 2
```
Wait for operation to complete by reading the status register to make sure BUSY is low before moving on
```
    spi_xfer -b 1 -c 1 -d 0C -w 2 (bit 1 is BUSY bit)
```
Read the value that is received. Before reading, make sure RX_DAT_RDY is high.
```
    spi_xfer -b 1 -c 1 -d 0C -w 2 (bit 0 is RX_DAT_RDY bit) 
    spi_xfer -b 1 -c 1 -d 10 -w 2
```

## I2C

I2C operations involve more steps. To set I2C clock frequency to 400kHz, the same formula is used. 2,500,000/400,000 = 62 which is 0x3E.
```
    spi_xfer -b 1 -c 1 -d 3E91 -w 2
    spi_xfer -b 1 -c 1 -d 0092 -w 2 
```
Trigger an I2C START operation
```
    spi_xfer -b 1 -c 1 -d 408C -w 2
```
Check if start operation is complete
```
    spi_xfer -b 1 -c 1 -d 0C -w 2
```
Once the I2C busy bit is cleared, send the Write operation (e.g. value of 0x55)
```
    spi_xfer -b 1 -c 1 -d 5593 -w 2
```
Once the busy bit is cleared, send the I2C STOP
```
    spi_xfer -b 1 -c 1 -d 208C -w 2
```


## Register Map

|   Addr  (Hex)   |   Addr  (Dec)   |   Regsiter Name   |   Reg. Type   |   Bit7   |   Bit6   |   Bit5   |   Bit4   |   Bit3   |   Bit2   |   Bit1   |   Bit0|
|--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |--- |
|00|00|FPGA_REV_L|R|TBD|||||||
|01|01|FPGA_REV_H|R|TBD|||||||
|02|02|ADC0_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|03|03|ADC0_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|04|04|ADC1_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|05|06|ADC1_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|04|04|ADC1_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|05|06|ADC1_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|06|06|ADC2_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|07|07|ADC2_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|08|08|ADC3_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|09|09|ADC3_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|0A|10|ADC4_REG_L|R|D7|D6|D5|D4|D3|D2|D1|D0|
|0B|11|ADC4_REG_H|R|0|0|0|0|D11|D10|D9|D8|
|0C|12|STS_REG|R/W|ADC ON|I2C START|I2C STOP|I2C READ|I2C BUSY|I2C ACK|UART BUSY|UART RX_DAT RDY|
|0D|13|UART_BAUD_L|R/W||||||||
|0E|14|UART_BAUD_H|R/W||||||||
|0F|15|UART_TX_REG|W|D7|D6|D5|D4|D3|D2|D1|D0|
|10|16|UART_RX_REG|R|D7|D6|D5|D4|D3|D2|D1|D0|
|11|17|I2C_CLOCK _REG_L|R/W|||||||||
|12|18|I2C_CLOCK _REG_H|R/W|||||||||
|13|19|I2C_TX_REG|R/W|D7|D6|D5|D4|D3|D2|D1|D0|
|14|20|I2C_RX_REG|W|D7|D6|D5|D4|D3|D2|D1|D0|
|15|21|PWM_CTRL_L|RW|PWM7 ON|PWM6 ON|PWM5 ON|PWM4 ON|PWM3 ON|PWM2 ON|PWM1 ON|PWM0 ON|
|16|22|PWM_CTRL_H|RW|GLOBAL PWM ON|0|0|0|PWM11 ON|PWM10 ON|PWM9 ON|PWM8 ON|
|17|23|PWM0_FREQ_L|RW|R/W|||||||
|18|24|PWM0_FREQ_H|RW|R/W|||||||
|19|25|PWM1_FREQ_L|RW|R/W|||||||
|1A|26|PWM1_FREQ_H|RW|R/W|||||||
|1B|27|PWM2_FREQ_L|RW|R/W|||||||
|1C|28|PWM2_FREQ_H|RW|R/W|||||||
|1D|29|PWM3_FREQ_L|RW|R/W|||||||
|1E|30|PWM3_FREQ_H|RW|R/W|||||||
|1F|31|PWM4_FREQ_L|RW|R/W|||||||
|20|32|PWM4_FREQ_H|RW|R/W|||||||
|21|33|PWM5_FREQ_L|RW|R/W|||||||
|22|34|PWM5_FREQ_H|RW|R/W|||||||
|23|35|PWM6_FREQ_L|RW|R/W|||||||
|24|36|PWM6_FREQ_H|RW|R/W|||||||
|25|37|PWM7_FREQ_L|RW|R/W|||||||
|26|38|PWM7_FREQ_H|RW|R/W|||||||
|27|39|PWM8_FREQ_L|RW|R/W|||||||
|28|40|PWM8_FREQ_H|RW|R/W|||||||
|29|41|PWM9_FREQ_L|RW|R/W|||||||
|2A|42|PWM9_FREQ_H|RW|R/W|||||||
|2B|43|PWM10_FREQ_L|RW|R/W|||||||
|2C|44|PWM10_FREQ_H|RW|R/W|||||||
|2D|45|PWM11_FREQ_L|RW|R/W|||||||
|2E|46|PWM11_FREQ_H|RW|R/W|||||||
|2F|47|PWM12_FREQ_L|RW|R/W|||||||
|30|48|PWM12_FREQ_H|RW|R/W|||||||
|31|49|PWM0_DUTY_L|RW|R/W|||||||
|32|50|PWM0_DUTY_H|RW|R/W|||||||
|33|51|PWM1_DUTY_L|RW|R/W|||||||
|34|52|PWM1_DUTY_H|RW|R/W|||||||
|35|53|PWM2_DUTY_L|RW|R/W|||||||
|36|54|PWM2_DUTY_H|RW|R/W|||||||
|37|55|PWM3_DUTY_L|RW|R/W|||||||
|38|56|PWM3_DUTY_H|RW|R/W|||||||
|39|57|PWM4_DUTY_L|RW|R/W|||||||
|3A|58|PWM4_DUTY_H|RW|R/W|||||||
|3B|59|PWM5_DUTY_L|RW|R/W|||||||
|3C|60|PWM5_DUTY_H|RW|R/W|||||||
|3D|61|PWM6_DUTY_L|RW|R/W|||||||
|3E|62|PWM6_DUTY_H|RW|R/W|||||||
|3F|63|PWM7_DUTY_L|RW|R/W|||||||
|40|64|PWM7_DUTY_H|RW|R/W|||||||
|41|65|PWM8_DUTY_L|RW|R/W|||||||
|42|66|PWM8_DUTY_H|RW|R/W|||||||
|43|67|PWM9_DUTY_L|RW|R/W|||||||
|44|68|PWM9_DUTY_H|RW|R/W|||||||
|45|69|PWM10_DUTY_L|RW|R/W|||||||
|46|70|PWM10_DUTY_H|RW|R/W|||||||
|47|71|PWM11_DUTY_L|RW|R/W|||||||
|48|72|PWM11_DUTY_H|RW|R/W|||||||
|49|73|GPIO_REG|R/W|i/p|i/p|i/p|i/p|o/p|o/p|o/p|o/p|




