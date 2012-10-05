#!/usr/bin/env bash

echo DNA
cd DNA && ./dna.py | tail -n 8
cd ..

echo
echo FIRtree
cd FIRTree32Tap8Bit && ./FIRfilter.py | tail -n 8
cd ..

echo
echo mult_verilog
cd multiplier_verilog && ./mult.py | tail -n 8
cd ..

echo
echo treeMult
cd treeMult && ./mult16bit.py | tail -n 8
cd ..

echo
echo treeMult4b
cd treeMult4b && ./treeMult4b.py | tail -n 8
cd ..

echo
echo tripleDES
cd tripleDES && ./tripleDES.py | tail -n 5
cd ..
