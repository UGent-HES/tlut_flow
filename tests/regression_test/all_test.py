#!/usr/bin/env python

import unittest
import vhdl_test
import mappedblif_test
import aagtoaag_test

def main():
    vhdl_suite = unittest.TestLoader().loadTestsFromTestCase(vhdl_test.VhdlGenerationTest)
    mappedblif_suite = unittest.TestLoader().loadTestsFromTestCase(mappedblif_test.MappedBlifTest)
    aagtoaag_suite = unittest.TestLoader().loadTestsFromTestCase(aagtoaag_test.AagToAagTest)
    unittest.TextTestRunner().run(unittest.TestSuite([vhdl_suite, mappedblif_suite, aagtoaag_suite]))
    
if __name__=="__main__":
    main()

