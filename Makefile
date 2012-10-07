AIGER_VERSION = 1.9.4
ABC_VERSION = 810ba683c042

javaClasses = java/src/be/ugent/elis/recomp/mapping/tmapSimple/TMapSimple.java java/src/be/ugent/elis/recomp/aig/MergeAag.java java/src/be/ugent/elis/recomp/mapping/simple/SimpleMapper.java

.PHONY : java third_party all aigtoaig abc
.SUFFIXES: .java .class

all : java source third_party 


java : $(javaClasses:.java=.class)
.java.class :
	mkdir -p java/bin
	javac -d java/bin -classpath java/src $<



source :
	echo "export PATH=${PWD}/python/src:${PWD}/third_party/bin:"'$${PATH}' > source
	echo "export CLASSPATH=${PWD}/java/bin:"'$${CLASSPATH:-}' >> source
	echo "export PYTHONPATH=${PWD}/python/src:"'$${PYTHONPATH:-}' >> source



third_party : aigtoaig abc
aigtoaig : third_party/aiger-${AIGER_VERSION}/aigtoaig third_party/bin/aigtoaig
abc : third_party/abc_${ABC_VERSION}/abc third_party/bin/abc


third_party/bin/aigtoaig :
	mkdir -p third_party/bin
	ln -sf ../aiger-${AIGER_VERSION}/aigtoaig third_party/bin/aigtoaig

third_party/aiger-${AIGER_VERSION}/aigtoaig : third_party/aiger-${AIGER_VERSION} third_party/aiger-${AIGER_VERSION}/aigtoaig.c
	cd third_party/aiger-${AIGER_VERSION} && ./configure
	cd third_party/aiger-${AIGER_VERSION} && make aigtoaig

third_party/aiger-${AIGER_VERSION} : third_party/aiger-${AIGER_VERSION}.tar.gz
	tar -xzf third_party/aiger-${AIGER_VERSION}.tar.gz -C third_party/ 

third_party/aiger-${AIGER_VERSION}.tar.gz :
	@echo "AIGER downloaded from http://fmv.jku.at/aiger/"
	mkdir -p third_party
	cd third_party && curl -O http://fmv.jku.at/aiger/aiger-${AIGER_VERSION}.tar.gz



third_party/bin/abc :
	mkdir -p third_party/bin
	ln -s ../abc_${ABC_VERSION}/abc third_party/bin/abc

third_party/abc_${ABC_VERSION}/abc : third_party/abc_${ABC_VERSION}
	cd third_party/abc_${ABC_VERSION} && make

third_party/abc_${ABC_VERSION} : third_party/abc_${ABC_VERSION}.tar.gz
	tar -xzf third_party/abc_${ABC_VERSION}.tar.gz -C third_party/
	cd third_party && mv alanmi-abc-${ABC_VERSION} abc_${ABC_VERSION}
	cd third_party/abc_${ABC_VERSION} && patch < ../abc_makefile.patch

third_party/abc_${ABC_VERSION}.tar.gz :
	cd third_party && curl -O https://bitbucket.org/alanmi/abc/get/${ABC_VERSION}.tar.gz
	cd third_party && mv ${ABC_VERSION}.tar.gz abc_${ABC_VERSION}.tar.gz
