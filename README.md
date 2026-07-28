
#
STM32 BLackpill clean environment

Designed to be a clean bare metal no bloat template for a blackpill STM32F411CEU6 without an usbTTL or ST-LINK.

Written using only C, uses only the most necessary CMSIS headers. 

Makefile is dynamic and uses wildcards, so you dont have to add sources or includes manually. 
Just type in "make" to compile or "make flash" to compile and flash the board.

##
Important note

To flash the board using "make flash" you have to enter DFU mode on the board by unplugging it, pressing and holding "BOOT" button on it. Then you have to plug it in and release the button.

Tools used:
- arm-none-eabi-gcc
- dfu-util
- makefile


