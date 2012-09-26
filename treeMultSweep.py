#!/usr/bin/env python
'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

classPath = '../trunk/bin/'

#dataWidth = 32
#addrWidth = 8
dataWidth = 8
addrWidth = 4
K = 4

parameterFileName = 'tcam2.par'
fout = open(parameterFileName, "w")
for entry in range(0, 2**addrWidth):
    fout.write('entry['+str(entry)+'].used\n')
    for bit in range(0, dataWidth):
        fout.write('entry['+str(entry)+'].data['+str(bit)+']\n')
        fout.write('entry['+str(entry)+'].mask['+str(bit)+']\n')
fout.close()

cmd = 'gcc -x c -E -P -D _DATA_W='+str(dataWidth)+' -D _ADDR_W='+str(addrWidth)+' pkg2-preprocessor.vhd -o pkg2.vhd'
output = commands.getoutput(cmd)

blifFileName = synthesize('tcam2.vhd', ['pkg2.vhd']);

#Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)

# Mapping
numLuts, numTLuts, depth, avDup, origAnds, paramAnds, check = simpleTMapper(classPath, '.', aagFileName, 'tcam2.par', K , True)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 

abcNumLuts, abcDepth, abcCheck = simpleMapper(classPath, '.', aagFileName, K)
output += '\t' + str(abcNumLuts) + '\t' + str(abcDepth) + '\t' + abcCheck

print  output
