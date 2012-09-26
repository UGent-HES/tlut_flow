#!/usr/bin/env python

import sys
from mapping import *;
#classPath = '/home/balfaris/private/recomp/tools/javaMapping/trunk/bin/'
classPath = '../trunk/bin/'

aagFile = sys.argv[1]
parFile = sys.argv[2]
K = sys.argv[3]
inVhdFile = sys.argv[4]

# Unleash TMAP
numLuts, depth, check = simpleTMapper2(classPath, '.', aagFile, parFile, int(K) , True, inVhdFile)
output = str(numLuts) + '\t' + str(depth) + '\t' + check 
print 'Luts\tdepth\tcheck'
print  output


