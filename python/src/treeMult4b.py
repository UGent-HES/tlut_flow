'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os
import sys
import commands
from mapping import *   


baseNameIn = "treeMult4b"

os.system('mkdir -p work')
assert not os.system('cp '+baseNameIn+'-preprocessor.vhd work/')
assert not os.system('cp abc.rc work/')

os.chdir('work')
check_setup('.')

parameterFileName = baseNameIn+'.par'
assert not os.system('genParameters.py '+baseNameIn+'-preprocessor.vhd > '+baseNameIn+'.par')

# Synthesis
blifFileName = synthesize(baseNameIn+'-preprocessor.vhd', [])

treeMultBlif = blifFileName 


#Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)

numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper('.', aagFileName, parameterFileName, 4, True)
output = str(numLuts) + '\t' + str(numTLUTs) + '\t' + str(depth) + '\t' + check
print 'Luts\tTLUTs\tdepth\tcheck'
print output

numLuts, depth, check = simpleMapper('.', aagFileName, 4, True)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 
print 'Luts\tdepth\tcheck'
print output

