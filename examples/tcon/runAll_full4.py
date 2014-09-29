#!/usr/bin/env python

import sys
import os
import glob
from fast_tconmap import run, setMaxMemory, setMappingMode


K = 4

#setMaxMemory(5000)
setMaxMemory(1024)
setMappingMode('conventional')

# os.chdir('barrelshift')
# ./barrelshift.py
# os.chdir('..')

os.chdir('crossbar')
module = "cross16-sweep.blif"
print module
run(module, 
    K=K, 
    performCheck=True, 
    verboseFlag=False,
    synthesizedFileName=module, 
    parameterFileName="parameters_cross16.par")
os.chdir('..')

# os.chdir('crossbar')
# module = "switch16x16-sweep-sclean.blif"
# print module
# run(module, 
#     K=K, 
#     performCheck=False, 
#     verboseFlag=False,
#     synthesizedFileName=module, 
#     parameterFileName="parameters_clos16.par", 
#     extraArgs=['--nolutstruct'])
# os.chdir('..')

# os.chdir('mux')
# module = "mux3.blif"
# print 'mux'
# run(module, 
#     K=K, 
#     performCheck=True, 
#     verboseFlag=False,
#     resynthesizeFlag=True,
#     synthesizedFileName=module, 
#     parameterFileName="parameters_mux.par",
#     extraArgs=['--nolutstruct'])
# os.chdir('..')

os.chdir('tlc2')
print 'tlc2'
module = "tlc2-sweep.blif"
run(
    module, 
    K=K, 
    performCheck=True, 
    verboseFlag=False,
    synthesizedFileName=module, 
    parameterFileName="parameters_ps.par")
os.chdir('..')

os.chdir('tlc4')
print 'tlc4'
module = "tlc4-sweep.blif"
run(module, 
    K=K, 
    performCheck=True, 
    verboseFlag=False,
    synthesizedFileName=module, 
    parameterFileName="parameters_ps.par")
os.chdir('..')

# os.chdir('regEx')
# ./combined_blocks.py
# os.chdir('..')

os.chdir('regExPE')
print "regex"
#setMaxMemory(5000)
run("design/grid_tile.vhd", 
    glob.glob("design/*.vhd"), 
    K=K, 
    performCheck=True, 
    verboseFlag=False,
    resynthesizeFlag=True)
os.chdir('..')
