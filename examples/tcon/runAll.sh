#!/usr/bin/env bash

cd barrelshift
./barrelshift.py
cd ..

cd crossbar
./crossbar.py
cd ..

cd crossbar
./clos.py
cd ..

cd mux
./mux.py
cd ..

cd tlc2
./tlc2.py
cd ..

cd tlc4
./tlc4.py
cd ..

cd regEx
./combined_blocks.py
cd ..
