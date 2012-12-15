#!/usr/bin/env python

import sys
import re

def tryint(s):
    try:
        return int(s)
    except:
        return s
    
def alphanum_key(s):
    """ Turn a string into a list of string and number chunks.
        "z23a" -> ["z", 23, "a"]
    """
    return [ tryint(c) for c in re.split('([0-9]+)', s) ]

def index(string, list):    #return indices of strings that match expression
    expr = re.compile(string)
    return [nmbr for nmbr, line in enumerate(list) if expr.match(line)]

#determine which signals correspond to parameters from blif file
def extract_parameter_signals(parameter_names, fname):
    file = open(fname, 'rU')
    #read inputs section
    line = file.readline().lstrip().rstrip('\r\n')
    while not line.startswith('.inputs '):
        line = file.readline().lstrip().rstrip('\r\n')
        comment_index = line.find('#')  #remove comments
        if comment_index != -1:
            line = line[:comment_index]
    while line.endswith('\\'): #multi-line inputs section
        line = line[:-1]+' '
        new_line= file.readline().rstrip('\r\n').lstrip()
        comment_index = line.find('#')  #remove comments
        if comment_index != -1:
            line = line[:comment_index]
        line += new_line
    file.close()
    #filter signal names that correspond to parameters
    parameter_names = map(str.lower, parameter_names)
    inputs = line.split()[1:]
    def input_in_parameters(input):
        return input.lower().split('[',1)[0].split('.',1)[0] in parameter_names
    return sorted(filter(input_in_parameters, inputs),key=alphanum_key)
    

#extract signal names of parameters defined in PARAM section of VHDL/Verilog file
def extract_parameter_names(fname):
    #determine file type
    ext = fname.split('.')[-1].lower()
    if ext in ('vhd','vhdl'):   #VHDL
        paramDelimiter = '--PARAM'
        extraction_re = re.compile(r'^(?P<name>[a-z]\w*)\s*:\s*(?P<type>in|out|inout)\s*[a-z]\w*(\([\w\s+*/-]*\))?$',
         re.IGNORECASE)
    elif ext in ('v',):         #Verilog
        paramDelimiter = '//PARAM'
        extraction_re = re.compile(r'^(?P<type>input|output)\s*(\[[\w\s+*/-]*:[\w\s+*/-]*\])?\s*(?P<name>[a-z]\w*)$', 
        re.IGNORECASE)
    else:
        print >> sys.stderr, "Error: Unknown input file type"
        exit(2)
    
    #read file
    file = open(fname, 'rU')
    lines = file.readlines()
    file.close()
    
    #extract PARAM section
    nmbrs = index(r"^\s*%s\s*$"%paramDelimiter, lines) #only whitespace allowed before and after --PARAM
    if len(nmbrs)==0:
        print >> sys.stderr, "No parameters ("+paramDelimiter+") found in design"
        exit()
    elif len(nmbrs)==1:
        print >> sys.stderr, "Error: Invalid parameters section: Only one '"+paramDelimiter+"' statement found"
        exit(2)
    else:
        #first PARAM section contains parameter signal declarations
        paramDefs = lines[nmbrs[0]+1:nmbrs[1]]
        paramDefs = ''.join(paramDefs).split(';')
        paramDefs = filter(bool, map(lambda l:l.rstrip('\r\n\t ').lstrip(), paramDefs))
    
    #extract signal names from PARAM section
    parameter_names = []
    for paramDef in paramDefs:
        res = extraction_re.match(paramDef)
        if not res:
            print >> sys.stderr, "Warning: Unrecognised signal declaration: "+paramDefs
        else:
            signal_type = res.group('type')
            signal_name = res.group('name')
            if signal_type in ('input','in'):
                parameter_names.append(signal_name)
            else:
                print >> sys.stderr, "Warning: Unsupported signal type: "+signal_type
    return parameter_names

def main():
    if len(sys.argv)!=3:
        print >> sys.stderr, "Error: Incorrect number of arguments"
        print >> sys.stderr, "Usage: genParameters.py <HDL file name> <corresponding BLIF file name>"
        exit(2)
    hdl_fname = sys.argv[1]
    blif_fname = sys.argv[2]
    parameter_names = extract_parameter_names(hdl_fname)
    parameter_signals = extract_parameter_signals(parameter_names, blif_fname)
    print '\n'.join(parameter_signals)
    
if __name__=="__main__":
    main()
