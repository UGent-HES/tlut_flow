'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

classPath = '~/workspace/javaMapping/bin/'

dataWidth = 8
coefWidth = 8
nmbrTaps  = 16
K = 4

parameterFileName = 'fir.par'
fout = open(parameterFileName, "w")
for c in range(0, nmbrTaps):
    for bit in range(0, coefWidth):
        fout.write('coef['+str(c)+']['+str(bit)+']\n')
fout.close()

cmd = 'gcc -x c -E -P -D _DATA_W='+str(dataWidth)+' -D _COEF_W='+str(coefWidth)+' -D _NR_TAPS='+str(nmbrTaps)+' pkg-preprocessor.vhd -o pkg.vhd'
output = commands.getoutput(cmd)

blifFileName = synthesize('fir.vhd', ['pkg.vhd']);

#Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)

# Mapping
numLuts, depth, check = simpleTMapper(classPath, '.', aagFileName, 'fir.par', K , True)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 

abcNumLuts, abcDepth, abcCheck = simpleMapper(classPath, '.', aagFileName, K)
output += '\t' + str(abcNumLuts) + '\t' + str(abcDepth) + '\t' + abcCheck

print  output
