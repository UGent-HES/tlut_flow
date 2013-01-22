#!/usr/bin/env bash
set -e

#building
cd workspace/treeMult4bTest_bsp_0/
make clean
make all
cd -
cd workspace/treeMult4bTest_0/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/xpsV13_hw_platform/system.xml -mode bootload -mem BRAM -pe ppc440_0 workspace/treeMult4bTest_0/Debug/treeMult4bTest_0.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/treeMult4bTest_0/Debug/treeMult4bTest_0.elf tag ppc440_0 -o b implementation/download.bit

impact -batch etc/download.cmd
