#!/usr/bin/env bash
set -e

if [ ! -f ./virtex5_test.sh ]
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

function testCase {
    echo Testing $1
    echo Testing $1 >> work/virtex5_output.log
    oldPWD=$PWD
    cd ../examples/$1/pcores/$2/design/
    generateTMAPMake.py virtex5 >> $oldPWD/work/virtex5_output.log
    cd - >/dev/null
    cd ../examples/$1
    make -f custom.make clean >/dev/null
    rm -f received.txt
    cat > received.txt < /dev/ttyS0&
    PID=$!
    stty 580:5:cbd:8a3b:3:1c:7f:15:4:0:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0 -F /dev/ttyS0 #stty -g /dev/ttyS0
    set +e
    make -f custom.make exporttosdk >> $oldPWD/work/virtex5_output.log
    ./runTest.sh >> $oldPWD/work/virtex5_output.log
    if [ $? -ne 0 ]
    then
      echo "$1 compilation failed"
      echo "Log file: work/virtex5_output.log"
      kill $PID
      exit 1
    fi
    set -e
    sleep 10
    kill $PID
    #wait $PID 2>/dev/null
    if diff -bB received.txt received_expected.txt >/dev/null ; then
      echo "$1 succeeded"
    else
      echo "$1 failed (output mismatch)"
      echo "Output file: ../examples/$1/received.txt"
      exit 1
    fi
    cd - >/dev/null
}

mkdir -p work
rm -f work/virtex5_output.log

testCase "xorExample/xpsV13" "plb_xor_v1_00_a"
