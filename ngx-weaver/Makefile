.SUFFIXES: .lua .luac
JIT = luajit
JITFLAGS = -O

JITFILES = \
	init-weaver.luac \
	weaver-request.luac weaver-response.luac \
	c.luac
FOUNDFILES = $(JITFILES:%=../lua/%)

.lua.luac:
	$(JIT) $(JITFLAGS) -b $< $@

all: ./lua $(FOUNDFILES)
	mv ../lua/*.luac ./lua

./lua:
	mkdir $@
