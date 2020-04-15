AIGER_VERSION = 1.9.4
RAPIDSMITH_VERSION = 0.5.2-linux64
HESSIAN_VERSION = 4.0.6
JOPT_SIMPLE_VERSION = 4.5

javaClasses = java/src/be/ugent/elis/recomp/mapping/tmapSimple/TMapSimple.java java/src/be/ugent/elis/recomp/aig/MergeAag.java java/src/be/ugent/elis/recomp/mapping/simple/SimpleMapper.java java/src/be/ugent/elis/recomp/aig/MakeCEvaluator.java java/src/be/ugent/elis/recomp/aig/MakeCEvaluator.java java/src/be/ugent/elis/recomp/util/ExtractInfo.java 


.PHONY : java third_party all aigtoaig abc jopt_simple source
.SUFFIXES: .java .class

all : java source third_party 



java : $(javaClasses:.java=.class)
$(javaClasses:.java=.class) : rapidSmith jopt_simple
.java.class :
	mkdir -p java/bin
	javac -d java/bin -classpath java/src:third_party/rapidSmith:third_party/rapidSmith/jars/hessian-${HESSIAN_VERSION}.jar:third_party/jopt-simple-${JOPT_SIMPLE_VERSION}.jar $<


source :
	echo "export PATH=${PWD}/python/src:${PWD}/third_party/bin:"'$${PATH}' > source
	echo "export CLASSPATH=${PWD}/java/bin:${PWD}/third_party/rapidSmith/jars/hessian-${HESSIAN_VERSION}.jar:"'$${CLASSPATH:-}' >> source
	echo "export CLASSPATH=${PWD}/third_party/jopt-simple-${JOPT_SIMPLE_VERSION}.jar:"'$${CLASSPATH:-}' >> source
	echo "export PYTHONPATH=${PWD}/python/src:"'$${PYTHONPATH:-}' >> source
	echo "export RAPIDSMITH_PATH=${PWD}/third_party/rapidSmith" >> source
	echo "export TLUTFLOW_PATH=${PWD}" >> source



third_party : aigtoaig abc rapidSmith jopt_simple
aigtoaig : third_party/aiger-${AIGER_VERSION}/aigtoaig third_party/bin/aigtoaig
abc : third_party/abc third_party/bin/abc third_party/etc/abc.rc
rapidSmith : third_party/rapidSmith
jopt_simple : third_party/jopt-simple-${JOPT_SIMPLE_VERSION}.jar

third_party/bin/aigtoaig :
	mkdir -p third_party/bin
	ln -sf ../aiger-${AIGER_VERSION}/aigtoaig third_party/bin/aigtoaig

third_party/aiger-${AIGER_VERSION}/aigtoaig : third_party/aiger-${AIGER_VERSION} third_party/aiger-${AIGER_VERSION}/aigtoaig.c
	cd third_party/aiger-${AIGER_VERSION} && ./configure
	cd third_party/aiger-${AIGER_VERSION} && make aigtoaig

third_party/aiger-${AIGER_VERSION} : third_party/aiger-${AIGER_VERSION}.tar.gz
	tar -xzf third_party/aiger-${AIGER_VERSION}.tar.gz -C third_party/ 
	touch third_party/aiger-${AIGER_VERSION}

third_party/aiger-${AIGER_VERSION}.tar.gz :
	@echo "AIGER downloaded from http://fmv.jku.at/aiger/"
	mkdir -p third_party
	cd third_party && curl -O http://fmv.jku.at/aiger/aiger-${AIGER_VERSION}.tar.gz



third_party/bin/abc :
	mkdir -p third_party/bin
	ln -s ../abc/abc third_party/bin/abc

third_party/etc/abc.rc :
	mkdir -p third_party/etc
	ln -s ../abc/abc.rc third_party/etc/abc.rc

third_party/abc : third_party/abc_git
	cd third_party/abc && make

third_party/abc_git:
	cd third_party && git clone https://github.com/berkeley-abc/abc.git

third_party/rapidSmith : third_party/rapidSmith-${RAPIDSMITH_VERSION}.tar.gz
	tar -xzf third_party/rapidSmith-${RAPIDSMITH_VERSION}.tar.gz -C third_party/
	touch third_party/rapidSmith
	
third_party/rapidSmith-${RAPIDSMITH_VERSION}.tar.gz :
	cd third_party && curl -L -O http://downloads.sourceforge.net/project/rapidsmith/rapidSmith-${RAPIDSMITH_VERSION}.tar.gz

third_party/jopt-simple-${JOPT_SIMPLE_VERSION}.jar : 
	cd third_party && curl -O https://repo1.maven.org/maven2/net/sf/jopt-simple/jopt-simple/4.5/jopt-simple-4.5.jar
