
all:
	javac -d bin -classpath src src/be/ugent/elis/recomp/mapping/tmapSimple/TMapSimple.java
	javac -d bin -classpath src src/be/ugent/elis/recomp/aig/MergeAag.java 
	javac -d bin -classpath src src/be/ugent/elis/recomp/mapping/simple/SimpleMapper.java
	javac -d bin -classpath src src/be/ugent/elis/recomp/aig/MakeCEvaluator.java

