'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    


# widths = [2]

resultFileName = 'result.csv'
fres = open(resultFileName, "w")


fres.write('VarW\tParW\tLuts\tdepth\tcheck\n')

CFileName = 'myCfunction.c' 
    
parameterFileName = 'treeMult4b.par'
fout = open(parameterFileName, "w")
for i in range(0,8):
    fout.write('b['+str(i)+']\n')
fout.close()



# Synthesis
blifFileName = synthesize('treeMult4b-preprocessor.vhd', [])

print blifFileName

treeMultBlif = blifFileName 


#Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)
print aagFileName

numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper('.', aagFileName, parameterFileName, 4 , True)
output = str(numLuts) + '\t' + str(numTLUTs) + '\t' + str(depth) + '\t' + check
print 'Luts\tTLUTs\tdepth\tcheck'
print output

numLuts, depth, check = simpleMapper('.', aagFileName, 4, True)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 
print 'Luts\tdepth\tcheck'
print output

        
#print  output
#fres.write(output + '\n')
#         + '\t' + behaviourCheck

