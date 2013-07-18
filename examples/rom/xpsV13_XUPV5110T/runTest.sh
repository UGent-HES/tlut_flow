#!/usr/bin/env bash
set -e

#building
cd workspace/rom_test_V5110T_bsp_0/
make clean
make all
cd -
cd workspace/rom_test_V5110T_0/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/xpsV13_XUPV5110T_hw_platform/system.xml -mode bootload -mem BRAM -pe microblaze_0 workspace/rom_test_V5110T_0/Debug/rom_test_V5110T_0.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/rom_test_V5110T_0/Debug/rom_test_V5110T_0.elf tag microblaze_0 -o b implementation/download.bit

impact -batch etc/download.cmd
