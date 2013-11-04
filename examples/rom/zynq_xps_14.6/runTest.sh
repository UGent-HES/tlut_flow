#!/usr/bin/env bash
set -e

#building
cd workspace/rom_test_zynq_bsp/
make clean
make all
cd -
cd workspace/rom_test_zynq/Debug
make clean
make all
cd -

#downloading
elfcheck -hw workspace/zynq_xps_14.6_hw_platform/system.xml -mode bootload -mem BRAM -pe microblaze_0 workspace/rom_test_zynq/Debug/rom_test_zynq.elf

data2mem -bm implementation/system_bd.bmm -bt implementation/system.bit -bd workspace/rom_test_zynq/Debug/rom_test_zynq.elf tag microblaze_0 -o b implementation/download.bit

set +e
impact -batch etc/download.cmd 2>&1
RET=$?
set -e
if [ $RET -ne 0 ]
then
	echo "Error: Downloading bitstream failed" >&2
fi
exit $RET
