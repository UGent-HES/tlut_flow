'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

#classPath = '~/workspace/javaMapping/bin/'
classPath = '/home/fmostafa/private/recomp/tools/javaMapping/trunk/bin/'


nmbrParam  = 144
K = 4

parameterFileName = 'subst_row_mem.par'
fout = open(parameterFileName, "w")
for c in range(0, nmbrParam):

        #fout.write('coef['+str(c)+']['+str(bit)+']\n')
        fout.write('subst_row'+'['+str(c)+']\n')
fout.close()

#cmd = 'gcc -x c -E -P -D _DATA_WIDTH='+str(dataWidth)+' pkg-preprocessor.vhd -o pkg.vhd'
#output = commands.getoutput(cmd)

blifFileName = synthesize('subst_row_mem-preprocessor.vhd', []);

#Convert BLIF to aig
aagFileName = bliftoaag(blifFileName)

# Mapping
numLuts, depth, check = simpleTMapper(classPath, '.', aagFileName, 'subst_row_mem.par', K, True )
output = str(numLuts) + '\t' + str(depth) + '\t' + check 

#abcNumLuts, abcDepth, abcCheck = simpleMapper(classPath, '.', aagFileName, K, True)
#output += '\t' + str(abcNumLuts) + '\t' + str(abcDepth) + '\t' + abcCheck

#print  output
