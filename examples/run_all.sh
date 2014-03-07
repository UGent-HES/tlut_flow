#!/usr/bin/env bash

echo DNA
cd DNA
rm -rf work
./dna.py | tail -n 9
rm -rf work
echo
echo DNA+resynthesis
./dna_resynthesis.py | tail -n 8
cd ..

echo
echo FIRtree
cd FIRTree32Tap8Bit
rm -rf work
./FIRfilter.py | tail -n 8
cd ..

echo
echo mult_verilog
cd multiplier_verilog
rm -rf work
./mult.py | tail -n 8
cd ..

echo
echo treeMult
cd treeMult
rm -rf work
./mult16bit.py | tail -n 8
cd ..

echo
echo treeMult4b
cd treeMult4b
rm -rf work
./treeMult4b.py | tail -n 8
echo
echo treeMult4b+par
rm -rf work
./treeMult4b_par.py | tail -n 8
echo
echo treeMult4b+qsf
rm -rf work
./treeMult4b_qsf.py | tail -n 8
cd ..

echo
echo tripleDES
cd tripleDES
rm -rf work
./tripleDES.py | tail -n 8
cd ..

echo
echo tcam
cd tcam
rm -rf work
./tcam.py | tail -n 8
cd ..

echo
echo rom
cd rom
rm -rf work
./rom.py | tail -n 8
cd ..
