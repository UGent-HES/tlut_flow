#!/usr/bin/env bash
set -e

if [ ! -f ./zynq.sh ]
then
    echo "Test failed: You are not in the 'tests' directory"
    exit 1
fi
if [ ! -d ../examples ]
then
    echo "Test failed: Did you move the 'tests' or 'examples' directories from their original location?"
    exit 1
fi
if [ ! -f ../source ]
then
    echo "Test failed: Did you forget to run make?"
    exit 1
fi

trap ctrl_c INT
function ctrl_c() {
        echo "Test aborted"
        #kill $PID
        exit 1
}

function testCase {
    echo Testing $1
    echo Testing $1 >> work/zynq_output.log
    oldPWD=$PWD
    cd ../examples/$1/pcores/$2/design/
    generateTMAPMake.py zynq >> $oldPWD/work/zynq_output.log
    cd - >/dev/null
    cd ../examples/$1
    make -f custom.make clean >/dev/null
    rm -f received.txt
#    cat > received.txt < /dev/ttyACM0&
#    PID=$!
#    stty 580:5:cbd:8a3b:3:1c:7f:15:4:0:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0 -F /dev/ttyACM0 #stty -g /dev/ttyS0
    set +e
    make -f custom.make exporttosdk >> $oldPWD/work/zynq_output.log
#    ./runTest.sh >> $oldPWD/work/zynq_output.log
    if [ $? -ne 0 ]
    then
      echo "$1 compilation failed"
      echo "Log file: work/zynq_output.log"
      #kill $PID
      exit 1
    fi
    set -e
    sleep 10
#    kill $PID
    #wait $PID 2>/dev/null
#    if diff -bB received.txt received_expected.txt >/dev/null ; then
#      echo "$1 succeeded"
#    else
#      echo "$1 failed (output mismatch)"
#      echo "Output file: ../examples/$1/received.txt"
#      exit 1
#    fi
    cd - >/dev/null
}

mkdir -p work
rm -f work/zynq_output.log

echo "Automatic testing doesn't work for zynq. This script will compile all test projects but will not run them."

testCase "xorExample/zynq_xps_14.6" "axi_xor_v1_00_a"
testCase "rom/zynq_xps_14.6" "axi_rom_v1_00_a"


