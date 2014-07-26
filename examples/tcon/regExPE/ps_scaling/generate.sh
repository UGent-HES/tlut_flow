#!/usr/bin/env bash

function gen {
    SZ=$1
    CMD=$2
    abc -t blif  -c "$CMD"';strash;zero' -o top_genericblock_$SZ.aig top_genericblock.blif && aigtoaig top_genericblock_$SZ.a{i,a}g && cat top_genericblock_$SZ.aag | pcregrep -o "(\d_)*(Fb_en|Ff_en|cntr_M\[\d+\]|cntr_N\[\d+\]|counter_en|dummy_en|fastforward_en|loopback_en)" | sort -u > top_genericblock_$SZ.par
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
gen 1024 "double;double;double;double;double;double;double;double;double;double"
