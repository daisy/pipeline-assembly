all : eval_java.class classes/lib/util.class eval-java.exe eval-java

eval_java.class : %.class : %.java
	javac -source 1.8 -target 1.8 -bootclasspath rt8.jar -extdirs '' $<

# Java >= 8 is required to compile lib.util
classes/lib/util.class : classes/lib/%.class : java/lib/%.java
	javac -source 1.8 -target 1.8 -bootclasspath rt8.jar -extdirs '' -d classes $<

eval-java.exe : eval-java.c
	i686-w64-mingw32-gcc $< -o $@

clean :
	rm -f eval_java.class classes/lib/util.class classes/lib/util\$$OS.class eval-java.exe eval-java
