#!/usr/bin/env python

from constant_optimisation import runVHDL, generateIntToUnsignedLogicVector

def main():
    par = {'Fb_en':map(generateIntToUnsignedLogicVector(1), (0,1)),
        'Ff_en':map(generateIntToUnsignedLogicVector(1), (0,1)),
        'counter_en':map(generateIntToUnsignedLogicVector(1), (1,)),
        'dummy_en':map(generateIntToUnsignedLogicVector(1), (0,)),
        'fastforward_en':map(generateIntToUnsignedLogicVector(1), (0,1)),
        'loopback_en':map(generateIntToUnsignedLogicVector(1), (0,1))}
    runVHDL('grid_tile.vhd', ['top_genericblock.vhd', 'counter.vhd', 'countDecoder.vhd'], par, K=6)
    
if __name__=="__main__":
    main()
