'''
Created on Nov 21, 2009

@author: kbruneel
'''
import os;
import sys;
import commands;

if __name__ == '__main__':
    inPath = sys.argv[1]
    ext = '.blif'
    for fname in os.listdir(sys.argv[1]):
        if fname[-len(ext):] == ext :
            basename = fname[:-len(ext)];
            fullFile = inPath + '/' + fname
            commands.getoutput('abc -c \'strash; write '+basename+'.aig\' ' + fullFile)
            commands.getoutput('aigtoaig '+basename+'.aig '+basename+'.aag')
            commands.getoutput('java6 -cp ~/recomp/tools/javaMapping/trunk/bin be.ugent.elis.recomp.mapping.simple.AagToBlif '+basename+'.aag '+basename+'-out.blif')
            size = os.stat(basename + ".aag").st_size
            print fname + "\t" + str(size) + "\t" +commands.getoutput('abc -c \'miter '+fullFile+' '+basename+'-out.blif; sat\'')