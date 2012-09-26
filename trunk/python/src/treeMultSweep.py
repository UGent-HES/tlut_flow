'''
Created on Dec 15, 2009

@author: kbruneel
'''

import os;
import sys;
import commands;
from mapping import *;    

classPath = '~/recomp/tools/javaMapping/trunk/bin/'
# classPath = '/home/balfaris/private/recomp/tools/javaMapping/trunk/bin/'
<<<<<<< .mine
widths = [8]
=======
widths = [128]
>>>>>>> .r1453

# widths = [2]

resultFileName = 'result.csv'
fres = open(resultFileName, "w")


fres.write('VarW\tParW\tLuts\tdepth\tcheck\n')

for paramWidth in widths:
    
    parameterFileName = 'treeMult.par'
    fout = open(parameterFileName, "w")
    for i in range(0,paramWidth):
        fout.write('b['+str(i)+']\n')
    fout.close()

    
    for variableWidth in [paramWidth]:
        # print 'Multiplier parameter width = ' + str(paramWidth) + ' variable width = ' + str(variableWidth) 

        output = str(variableWidth) + '\t' + str(paramWidth)

                
        # Preprocessor
        cmd = 'gcc -x c -E -P -D _DATA_WIDTH_A='+str(variableWidth)+' -D _DATA_WIDTH_B='+str(paramWidth)+' treeMult-preprocessor.vhd -o treeMult.vhd'
        commands.getoutput(cmd)
        
        # Synthesis
        blifFileName = synthesize('treeMult.vhd', [])
        treeMultBlif = blifFileName 
        
        #Convert BLIF to aig
        aagFileName = bliftoaag(blifFileName)
        
        numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(classPath, '.', aagFileName, parameterFileName, 4 , True)
        output += '\t' + str(numLuts) + '\t' + str(numTLUTs) + '\t' + str(depth) + '\t' + str(avDup) + '\t' + str(origAnds) +'\t' + str(paramAnds) +'\t' + check 
        
        

        numLuts, depth, check = simpleMapper(classPath, '.', aagFileName, 4 )
        output += '\t' + str(numLuts) + '\t' + str(depth) + '\t' + check 


        # Preprocessor
        cmd = 'gcc -x c -E -P -D _DATA_WIDTH_A='+str(variableWidth)+' -D _DATA_WIDTH_B='+str(paramWidth)+' mult-preprocessor.vhd -o mult.vhd'
        commands.getoutput(cmd)
        
        # Synthesis
        blifFileName = synthesize('mult.vhd', [])
        multBlif = blifFileName
        
        #Convert BLIF to aig
        aagFileName = bliftoaag(blifFileName)
        
        numLuts, numTLUTs, depth, avDup, origAnds, paramAnds, check = simpleTMapper(classPath, '.', aagFileName, parameterFileName, 4 , True)
        output += '\t' + str(numLuts) + '\t' + str(numTLUTs) + '\t' + str(depth) + '\t' + str(avDup)  + '\t' + str(origAnds) +'\t' + str(paramAnds) +'\t' + check 


        numLuts, depth, check = simpleMapper(classPath, '.', aagFileName, 4 )
        output += '\t' + str(numLuts) + '\t' + str(depth) + '\t' + check 


#        behaviourCheck = miter(treeMultBlif,multBlif)
#        output += '\t' + behaviourCheck


#        # Preprocessor
#        cmd = 'gcc -x c -E -P -D _DATA_WIDTH_A='+str(variableWidth)+' -D _DATA_WIDTH_B='+str(paramWidth)+' mult2-preprocessor.vhd -o mult2.vhd'
#        output = commands.getoutput(cmd)
#        
#        # Synthesis
#        blifFileName = synthesize('mult2.vhd', [])
#        
#        #Convert BLIF to aig
#        aagFileName = bliftoaag(blifFileName)


      
        # TODO: this seems to take a lot of time for larger input width (> 16)
        # Check behaviour
#        cmd = 'gcc -x c -E -P -D _DATA_WIDTH_A='+str(variableWidth)+' -D _DATA_WIDTH_B='+str(paramWidth)+' mult-preprocessor.vhd -o mult.vhd'
#        output = commands.getoutput(cmd)
#        behaviourFileName = synthesize('mult.vhd', [])
#        behaviourCheck = miter(treeMultBlif,multBlif)
        
#        output = str(variableWidth) + '\t' + str(paramWidth)
#        # Mapping
#        numLuts, depth, check = simpleTMapper(classPath, '.', aagFileName, parameterFileName, 4 , True)
#        output += '\t' + str(numLuts) + '\t' + str(depth) + '\t' + check 
        
        
#        abcNumLuts, abcDepth, abcCheck = simpleMapper(classPath, '.', behaviourFileName, 4)
#        output += '\t' + str(abcNumLuts) + '\t' + str(abcDepth) + '\t' + abcCheck

        
        print  output
        fres.write(output + '\n')
#         + '\t' + behaviourCheck

