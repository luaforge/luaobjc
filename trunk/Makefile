do: objc.so

LUA=../lua-5.1.1

# Required flags
LD=MACOSX_DEPLOYMENT_TARGET=10.3 gcc
LDFLAGS=-bundle -Wl,-bind_at_load -undefined dynamic_lookup -framework Cocoa
CFLAGS+=-I$(LUA)

# Optional flags
CFLAGS+=-fno-common
CFLAGS+=-Wall -Werror
#CFLAGS+=-O2
CFLAGS+=-g
LDFLAGS+=-g

objc.so: objc.o LuaObjCBridge.o
	$(LD) $(LDFLAGS) -o $@ $^

install: objc.so
	sudo mkdir -p /usr/local/lib/lua/5.1/
	sudo cp -v $< /usr/local/lib/lua/5.1/

run: objc.so
	lua ab.lua

defs.txt: LuaObjCBridge.m Makefile
	gcc -E -dM $(CFLAGS) -o _$@ $< && sort -u < _$@ | grep LUA_OBJC > $@ && rm -f _$@

pkg:
	cd ..; tar -czvf local-objc-1.4.2.tgz objc-1.4.2/ab.lua objc-1.4.2/*.[hm] objc-1.4.2/Makefile
