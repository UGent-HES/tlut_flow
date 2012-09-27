'''
Created on Nov 21, 2009

@author: kbruneel





'''
import os;
import sys;
import commands;
from mapping import *; 


if __name__ == '__main__':
    classPath = sys.argv[1]
    inPath = sys.argv[2]
    for fname in os.listdir(inPath):
        if fname.split('.')[-1] == "blif" :
            
          
            fullFile = inPath + '/' + fname
            
            ext = fname.split('.')[1]
            basename = fname.split('.')[0]
    
            blifFile = basename + ".blif"
            aigFile  = basename + ".aig"
            aagFile  = basename + ".aag"
            
            
            commands.getoutput('abc -c \'strash; write '+aigFile+'\' ' + fullFile)
            commands.getoutput('aigtoaig '+ aigFile +' '+ aagFile)

            output = fname
          
          
            simpleOutput = simpleMapper(classPath, ".", aagFile)
            output = output + "\t" + str(simpleOutput[0]) +"\t"+ str(simpleOutput[1]) +"\t"+ str(simpleOutput[2])
                        
#            imapOutput   = imapMapper (classPath, inPath, fname)
#            output = output + "\t" + str(imapOutput[0]) +"\t"+ str(imapOutput[1]) +"\t"+ str(imapOutput[2])

            fpgaOutput   = fpgaMapper(".", aigFile)
            output = output + "\t" + str(fpgaOutput[0]) +"\t"+ str(fpgaOutput[1]) +"\t"+ str(fpgaOutput[2])

            print output
#            cmd = 'abc -c \'fpga; write '+basename+'-fpga.blif\' ' + fullFile
#            commands.getoutput(cmd);
#            cmd = 'grep \'.names\' '+basename+'-fpga.blif| wc -l'
#            numLutsFpga = commands.getoutput(cmd);
#            
#            sat = check(basename, fullFile, cmd)
#            print fname + "\t" + numLuts + "\t" + numLutsFpga + "\t" + depth + "\t" + sat