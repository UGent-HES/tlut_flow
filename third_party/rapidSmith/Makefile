all : src/edu hessian-4.0.7.jar
	mkdir -p bin
	javac -d bin -classpath src:hessian-4.0.7.jar src/ugent/elis/csl/hes/tFlow/util/ExtractInfo.java
	jar cMf ExtractInfo.jar -C bin . META-INF/

hessian-4.0.7.jar :
	curl -O http://caucho.com/download/hessian-4.0.7.jar

rapidSmith-0.5.1-linux64 :
	curl -O http://ignum.dl.sourceforge.net/project/rapidsmith/rapidSmith-0.5.1-linux64.tar.gz
	tar xvzf rapidSmith-0.5.1-linux64.tar.gz

src/edu : rapidSmith-0.5.1-linux64
	cp -r rapidSmith-0.5.1-linux64/edu src/edu
