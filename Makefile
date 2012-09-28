
javaClasses = src/be/ugent/elis/recomp/mapping/tmapSimple/TMapSimple.java src/be/ugent/elis/recomp/aig/MergeAag.java src/be/ugent/elis/recomp/mapping/simple/SimpleMapper.java

.PHONY : java third_party
.SUFFIXES: .java .class

java : $(javaClasses:.java=.class)
	
.java.class :
	javac -d bin -classpath src $<

third_party : third_party/bin/aigtoaig

third_party/bin/aigtoaig : third_party/aiger-1.9.4/aigtoaig
	mkdir -p third_party/bin
	ln -s third_party/aiger-1.9.4/aigtoaig third_party/bin/aigtoaig

third_party/aiger-1.9.4/aigtoaig : third_party/aiger-1.9.4 third_party/aiger-1.9.4/aigtoaig.c
	cd third_party/aiger-1.9.4 && ./configure
	cd third_party/aiger-1.9.4 && make aigtoaig

third_party/aiger-1.9.4 : third_party/aiger-1.9.4.tar.gz
	tar -xzf third_party/aiger-1.9.4.tar.gz -C third_party/ 

third_party/aiger-1.9.4.tar.gz :
	@echo "AIGER downloaded from http://fmv.jku.at/aiger/"
	mkdir -p third_party/
	wget -P third_party/ http://fmv.jku.at/aiger/aiger-1.9.4.tar.gz
