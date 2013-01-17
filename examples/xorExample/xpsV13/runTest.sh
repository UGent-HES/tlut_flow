#!/usr/bin/env bash
set -e

#building
cd workspace/xorTest_bsp_0/
make clean
make all
cd -
cd workspace/xorTest_0/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/xor_design/system.xml -mode bootload -mem BRAM -pe ppc440_0 workspace/xorTest_0/Debug/xorTest_0.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/xorTest_0/Debug/xorTest_0.elf tag ppc440_0 -o b implementation/download.bit

impact -batch etc/download.cmd
