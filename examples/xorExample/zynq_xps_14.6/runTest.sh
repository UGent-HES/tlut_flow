#!/usr/bin/env bash
set -e

#building
cd workspace/xor_test_zynq_bsp/
make clean
make all
cd -
cd workspace/xor_test_zynq/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/zynq_xps_14.6_hw_platform/system.xml -mode bootload -mem BRAM -pe ps7_cortexa9_0 workspace/xor_test_zynq/Debug/xor_test_zynq.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/xor_test_zynq/Debug/xor_test_zynq.elf tag ps7_cortexa9_0 -o b implementation/download.bit

impact -batch etc/download.cmd
