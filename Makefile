
javaClasses = java/src/be/ugent/elis/recomp/mapping/tmapSimple/TMapSimple.java java/src/be/ugent/elis/recomp/aig/MergeAag.java java/src/be/ugent/elis/recomp/mapping/simple/SimpleMapper.java

.PHONY : java third_party all
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



third_party : third_party/bin/aigtoaig third_party/bin/abc


third_party/bin/aigtoaig : third_party/aiger-1.9.4/aigtoaig
	mkdir -p third_party/bin
	ln -sf ../aiger-1.9.4/aigtoaig third_party/bin/aigtoaig

third_party/aiger-1.9.4/aigtoaig : third_party/aiger-1.9.4 third_party/aiger-1.9.4/aigtoaig.c
	cd third_party/aiger-1.9.4 && ./configure
	cd third_party/aiger-1.9.4 && make aigtoaig

third_party/aiger-1.9.4 : third_party/aiger-1.9.4.tar.gz
	tar -xzf third_party/aiger-1.9.4.tar.gz -C third_party/ 

third_party/aiger-1.9.4.tar.gz :
	@echo "AIGER downloaded from http://fmv.jku.at/aiger/"
	mkdir -p third_party
	wget -P third_party/ http://fmv.jku.at/aiger/aiger-1.9.4.tar.gz



third_party/bin/abc : third_party/abc91222p/abc
	mkdir -p third_party/bin
	ln -s ../abc91222p/abc third_party/bin/abc

third_party/abc91222p/abc :
	cd third_party/abc91222p && make
