#!/usr/bin/env bash
set -e

#building
cd workspace/hello_world_bsp_0/
make clean
make all
cd -
cd workspace/testReconf/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/microblaze/system.xml -mode bootload -mem BRAM -pe microblaze_0 workspace/testReconf/Debug/testReconf_0.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/testReconf/Debug/testReconf_0.elf tag microblaze_0 -o b implementation/download.bit

impact -batch etc/download.cmd
