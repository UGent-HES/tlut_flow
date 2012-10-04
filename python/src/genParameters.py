#!/usr/bin/env python

import sys;
import re;
import string;

#todo: system exit(1) if there are significant errors

global genericsMapping
genericsMapping = {}

def index(string, list):    #return indices of strings that match expression
    expr = re.compile(string)
    return [nmbr for nmbr, line in enumerate(list) if expr.match(line)]

def extractGenericFromVHDL(generic, list, HDLtype): #lookup the value of a generic in VHDL
    if HDLtype == 'VHDL':
        expr = re.compile(r'([^-]*\W|^)'+generic+r'\W.*:=\W*(\d+)') #find the name of the generic (surrounded by non-word characters [^a-zA-Z0-9]) and followed by ":= <number>", and extract the value of <number>
    elif HDLtype == 'Verilog':
        expr = re.compile(r'([^-]*\W|^)parameter\s+'+generic+r'\s*=\s*(\d+)')   #find the name of the parameter preceded by parameter and followed by "= <number>", and extract the value of <number>
    
    genericValues = []
    for elem in list:
        r = expr.match(elem) #match at the beginning of a line
        if r:
            genericValues.append(r.group(2))
            
    if len(genericValues)==0:
        print >> sys.stderr, "Error: Cannot find value for generic: "+generic
        exit(3)
    elif len(genericValues)>1:
        print >> sys.stderr, "Error: Cannot extract single value for generic: "+generic
        exit(4)
    else:
        #print generic, genericValues[0]
        return int(genericValues[0]) # assign the value of the generic to the name of the generic

def evaluateExpression(expr,lines,HDLtype): #evaluate an expression (by looking up all generics)
    global genericsMapping
    unknownGenericsFlag = True
    while unknownGenericsFlag: #repeat until expression is completely defined
        try:
            value = eval(expr, genericsMapping)
            unknownGenericsFlag = False
        except NameError,e: #catch if a generic is used that hasn't been defined yet
            generic = str(e).split("'")[1] #find name of generic from error
            genericsMapping[generic] = extractGenericFromVHDL(generic, lines, HDLtype)  #lookup value of generic in VHDL
    return value

def extractGenericsFromFile():
    #get list of generics and values from external file, usefull in larger designs
    global genericsMapping
    try:
        genericFile= open('../../generics.txt', 'rU')
        genericLines = genericFile.readlines()
        for genericLine in genericLines:
            if(len(genericLine)>1):
                elems = genericLine.split('#')[0].split('\t')   #ignore comments (#) and split on tab
                generic = elems[0]
                genericValue = eval(elems[1],genericsMapping)
                genericsMapping[generic] = genericValue
    except IOError,e:
        print >> sys.stderr, "Warning: No such file '../../generics.txt'"

def generateParameters(fname):
    ext = fname.split('.')[-1].lower()
    if ext in ('vhd','vhdl'):
        HDLtype = 'VHDL'
    elif ext in ('v'):
        HDLtype = 'Verilog'
    else:
        print >> sys.stderr, "Error: Unknown input file type"
        exit(2)
    file = open(fname, 'rU')
    lines = file.readlines()
    
    #extractGenericsFromFile()
    
    if HDLtype == 'VHDL':
        paramDelimiter = '--PARAM'
    elif HDLtype == 'Verilog':
        paramDelimiter = '//PARAM'
    
    nmbrs = index(".*"+paramDelimiter, lines)
    if len(nmbrs)==0:
        print >> sys.stderr, "No parameters ("+paramDelimiter+") found in design"
        exit()
    elif len(nmbrs)==1:
        print >> sys.stderr, "Error: Invalid parameters section: Only one '"+paramDelimiter+"' statement found"
        exit(2)
    else:
        paramDefs = [elem.strip() for elem in lines[nmbrs[0]+1:nmbrs[1]]]
    
    if HDLtype == 'VHDL':
        for paramDef in paramDefs:
            words = re.findall(r'[^\t ,():;]+',paramDef)
            words_case = [str.lower(word) for word in words]
            if 'in' in words_case:
                parameterName = words[0]
                if 'std_logic' in words_case:
                    print parameterName
                elif 'std_logic_vector' in words_case:
                    lower = evaluateExpression(words[-3],lines,HDLtype) #evaluate "lowerbound" expression
                    upper = evaluateExpression(words[-1],lines,HDLtype) #evaluate "upperbound" expression
                    if (lower > upper):
                        temp = upper
                        upper = lower
                        lower = temp
                    if lower<0:
                        print >> sys.stderr, 'Error: Negative indices are invalid: '+' '.join(words[-3:])
                        exit(5)
                    for i in range(lower, upper+1):
                        print parameterName + '[' + str(i) + ']'
                elif 'array' in words_case:
                    nmbOfIndeces = len(words)-index('^array$', words)[0]-1
                    if ( nmbOfIndeces == 1):
                        index1 = evaluateExpression(words[-1],linesHDLtype)
                        for i in range(index1):
                            print parameterName + '[' + str(i) + ']'
                    elif ( nmbOfIndeces == 2):
                        index1 = evaluateExpression(words[-2],linesHDLtype)
                        index2 = evaluateExpression(words[-1],linesHDLtype)
                        for i in range(index1):
                            for j in range(index2):
                                print parameterName + '[' + str(i) + ']' + '[' + str(j) + ']'
            elif 'out' in words_case or 'inout' in words_case:
                print >> sys.stderr, "Warning: 'out' and 'inout' ports are not supported"
    elif HDLtype == 'Verilog':
        for paramDef in paramDefs:
            words = re.findall(r'[^\t ,():;\]\[]+',paramDef)
            words_case = [str.lower(word) for word in words]
            if 'input' == words_case[0]:
                if len(words)==2:
                    parameterName = words[1]
                    print parameterName
                elif len(words)==4:
                    parameterName = words[3]
                    lower = evaluateExpression(words[1],lines,HDLtype) #evaluate "lowerbound" expression
                    upper = evaluateExpression(words[2],lines,HDLtype) #evaluate "upperbound" expression
                    if (lower > upper):
                        temp = upper
                        upper = lower
                        lower = temp
                    if lower<0:
                        print >> sys.stderr, 'Error: Negative indices are invalid: '+' '.join(words[-3:])
                        exit(5)
                    for i in range(lower, upper+1):
                        print parameterName + '[' + str(i) + ']'
            elif 'output' == words_case[0] or 'inout' == words_case[0]:
                print >> sys.stderr, "Warning: 'output' and 'inout' ports are not supported"
        

def main():
    fname = sys.argv[1]
    generateParameters(fname)
    
if __name__=="__main__":
    main()
