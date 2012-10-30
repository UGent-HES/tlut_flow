#!/usr/bin/env bash

echo DNA
cd DNA
rm -r work
./dna.py | tail -n 8
cd ..

echo
echo FIRtree
cd FIRTree32Tap8Bit
rm -r work
./FIRfilter.py | tail -n 8
cd ..

echo
echo mult_verilog
cd multiplier_verilog
rm -r work
./mult.py | tail -n 8
cd ..

echo
echo treeMult
cd treeMult
rm -r work
./mult16bit.py | tail -n 8
cd ..

echo
echo treeMult4b
cd treeMult4b
rm -r work
./treeMult4b.py | tail -n 8
cd ..

echo
echo tripleDES
cd tripleDES
rm -r work
./tripleDES.py | tail -n 5
cd ..

echo
echo tcam
cd tcam
rm -r work
./tcam.py | tail -n 8
cd ..
