#!/usr/bin/env bash
set -e

elfcheck -hw workspace/xor_design/system.xml -mode bootload -mem BRAM -pe ppc440_0 workspace/xorTest_0/Debug/xorTest_0.elf

data2mem -bm workspace/xor_design/system_bd.bmm -bt workspace/xor_design/system.bit -bd workspace/xorTest_0/Debug/xorTest_0.elf tag ppc440_0 -o b implementation/download.bit

impact -batch etc/download.cmd
