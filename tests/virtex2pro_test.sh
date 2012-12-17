#!/usr/bin/env bash
set -e

function testCase {
    cd ../examples/$1/pcores/$2/design/
    generateTMAPMake.py >/dev/null
    cd - >/dev/null
    cd ../examples/$1
    make -f custom.make clean >/dev/null
    rm -f received.txt
    cat > received.txt < /dev/ttyS0&
    stty 580:5:cbd:8a3b:3:1c:7f:15:4:0:1:0:11:13:1a:0:12:f:17:16:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0 -F /dev/ttyS0 #stty -g /dev/ttyS0
    make -f custom.make download >/dev/null
    PID=$!
    sleep 10
    kill $PID
    #wait $PID 2>/dev/null
    if diff received.txt received_expected.txt >/dev/null ; then
      echo $1 succeeded
    else
      echo $1 failed
      exit 1
    fi
    cd - >/dev/null
}

testCase "xorExample/xps" "opb_xor_v1_00_a"
testCase "xorExample/xps_mi" "opb_xor_v1_00_a"
testCase "treeMult4b/xps" "opb_mult4b_v1_00_a"
