'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

classPath = '~/workspace/javaMapping/bin/'
K = 4

output = ''

# Mapping
numLuts, numTLuts, depth, avDup, origAnds, paramAnds, check = simpleTMapper(classPath, '.', 'k_AES.aag', 'k_AES.par', K , False)
output += str(numLuts) + '\t' + str(numTLuts) + '\t' + str(depth) + '\t' + str(origAnds)  + '\t' + str(paramAnds) + '\t' + check 

abcNumLuts, abcDepth, abcCheck = simpleMapper(classPath, '.', 'k_AES.aag', K, False)
output += '\t' + str(abcNumLuts) + '\t' + str(abcDepth) + '\t' + abcCheck

print  output
