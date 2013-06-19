#!/usr/bin/env bash
set -e

#building
cd workspace/xor_test_V5110T_bsp_0/
make clean
make all
cd -
cd workspace/xor_test_V5110T_0/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/xpsV13_XUPV5110T_hw_platform/system.xml -mode bootload -mem BRAM -pe microblaze_0 workspace/xor_test_V5110T_0/Debug/xor_test_V5110T_0.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/xor_test_V5110T_0/Debug/xor_test_V5110T_0.elf tag microblaze_0 -o b implementation/download.bit

impact -batch etc/download.cmd
