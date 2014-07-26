#!/usr/bin/env bash

function gen {
    SZ=$1
    CMD=$2
    abc -t blif  -c "$CMD"';strash' -o tlc2-sweep_$SZ.aig tlc2-sweep.blif && aigtoaig tlc2-sweep_$SZ.a{i,a}g && cat tlc2-sweep_$SZ.aag | pcregrep -o "(\d_)*p\[\d+\]" | sort -u > tlc2-sweep_$SZ.par
}

gen 1 ""
gen 2 "double"
gen 4 "double;double"
gen 8 "double;double;double"
gen 16 "double;double;double;double"
gen 32 "double;double;double;double;double"
gen 64 "double;double;double;double;double;double"
gen 128 "double;double;double;double;double;double;double"
gen 256 "double;double;double;double;double;double;double;double"
gen 512 "double;double;double;double;double;double;double;double;double"
