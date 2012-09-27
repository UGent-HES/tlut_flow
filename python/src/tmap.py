'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

classPath = '~/workspace/javaMapping/bin/'

numLuts, depth, check = simpleTMapper(classPath, '.', sys.argv[1], sys.argv[2], int(sys.argv[3]), True)
print str(numLuts) + '\t' + str(depth) + '\t' + check 
