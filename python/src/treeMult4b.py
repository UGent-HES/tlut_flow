'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os
import shutil
import sys
import commands
from mapping import *   


baseNameIn = "treeMult4b"

try:
    os.system('mkdir -p work')
    shutil.copy(baseNameIn+'-preprocessor.vhd', 'work')
    shutil.copy('abc.rc','work')
except IOError as e:
    print e
    exit(3)

os.chdir('work')
check_setup('.')

# Generate parameter file from VHDL
parameterFileName = baseNameIn+'.par'
try:
    assert not os.system('genParameters.py '+baseNameIn+'-preprocessor.vhd > '+baseNameIn+'.par')
except AssertionError:
    exit(3)

# Synthesis
blifFileName = synthesize(baseNameIn+'-preprocessor.vhd', [])

# Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)

# Unleash TMAP
numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(aagFileName, parameterFileName, 4, True)
output = str(numLuts) + '\t' + str(numTLUTs) + '\t' + str(depth) + '\t' + check
print 'Luts\tTLUTs\tdepth\tcheck'
print output

# Run regular MAP
numLuts, depth, check = simpleMapper(aagFileName, 4, True)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 
print 'Luts\tdepth\tcheck'
print output

