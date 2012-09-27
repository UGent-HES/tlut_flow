#!/usr/bin/env python

import sys;
import re;
import string;

#todo: system exit(1) if there are significant errors

global genericsMapping
genericsMapping = {}

def index(string, list):	#return indices of strings that match expression
	expr = re.compile(string)
	return [nmbr for nmbr in range(len(list)) if expr.match(list[nmbr])]

def extractGenericFromVHDL(generic, list):	#lookup the value of a generic in VHDL
	expr = re.compile('([^-]*\W)?'+generic+'\W.*:=\W*(\d+)')	#find the name of the generic (surrounded by non-word characters [^a-zA-Z0-9]) and followed by ":= <number>", and extract the value of <number>
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

def evaluateExpression(expr,lines):	#evaluate an expression (by looking up all generics)
	global genericsMapping
	unknownGenericsFlag = True
	while unknownGenericsFlag: #repeat until expression is completely defined
		try:
			value = eval(expr, genericsMapping)
			unknownGenericsFlag = False
		except NameError,e:	#catch if a generic is used that hasn't been defined yet
			generic = str(e).split('\'')[1] #find name of generic from error
			genericsMapping[generic] = extractGenericFromVHDL(generic, lines)	#lookup value of generic in VHDL
	return value

def extractGenericsFromFile():
	#get list of generics and values from external file, usefull in larger designs
	global genericsMapping
	try:
		genericFile= open('../../generics.txt', 'rU')
		genericLines = genericFile.readlines()
		for genericLine in genericLines:
			if(len(genericLine)>1):
				elems = genericLine.split('#')[0].split('\t')	#ignore comments (#) and split on tab
				generic = elems[0]
				genericValue = eval(elems[1],genericsMapping)
				genericsMapping[generic] = genericValue
	except IOError,e:
		print >> sys.stderr, "Warning: No such file '../../generics.txt'"

def main():
	extractGenericsFromFile()
	fname = sys.argv[1]
	file = open(fname, 'rU')
	
	lines = file.readlines()
	
	nmbrs = index(".*--PARAM", lines)
	if len(nmbrs)==0:
		print >> sys.stderr, "No parameters (--PARAM) found in design"
		exit()
	elif len(nmbrs)==1:
		print >> sys.stderr, "Error: Invalid parameters section: Only one '--PARAM' statement found"
		exit(2)
# 	elif len(nmbrs)>2:
# 		print >> sys.stderr, "Error: Invalid parameters section: More than two '--PARAM' statements found"
# 		exit(3)
	else:
		paramDefs = [elem.strip() for elem in lines[nmbrs[0]+1:nmbrs[1]]]
	
	for paramDef in paramDefs:
		words = re.findall('[^\t ,():;]+',paramDef)
		words_case = [str.lower(word) for word in words]
		if 'in' in words_case:
			parameterName = words[0]
			if 'std_logic' in words_case:
				print parameterName
			elif 'std_logic_vector' in words_case:
				lower = evaluateExpression(words[-3],lines)	#evaluate "lowerbound" expression
				upper = evaluateExpression(words[-1],lines)	#evaluate "upperbound" expression
	
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
					index1 = evaluateExpression(words[-1],lines)
					for i in range(index1):
						print parameterName + '[' + str(i) + ']'
				elif ( nmbOfIndeces == 2):
					index1 = evaluateExpression(words[-2],lines)
					index2 = evaluateExpression(words[-1],lines)
					for i in range(index1):
						for j in range(index2):
							print parameterName + '[' + str(i) + ']' + '[' + str(j) + ']'
		elif 'out' in words_case or 'inout' in words_case:
			print >> sys.stderr, "Warning: 'out' and 'inout' ports are not supported"
	
main()