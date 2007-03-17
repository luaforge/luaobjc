/*
objc.m - allow objective-c bindings to be loaded as a module

Author: Sam Roberts
Contact: sroberts@uniserve.com
Copyright: see file COPYRIGHT

*/

#include "LuaObjCBridge.h"

#include <string.h>

// lua tries to unload a dynamically loaded library when its done with it, this
// will cause a fatal exception if the library contained obj-c code.
//
// To prevent this, we search the registry for the key that matches the .so that
// we were loaded from. Unfortunately, the only thing we know about the key is that
// it starts with "LOADLIB: " and ends with <modulename>, and maps to a userdata.
//
// If we find the userdata, we clear its metatable, since the only purpose of
// the metatable is to attach a __gc function, and we don't want that.
static void kill_dlclose(lua_State* L, const char* modulename){
	int top = lua_gettop(L);

	lua_pushnil(L);

	while (lua_next(L, LUA_REGISTRYINDEX) != 0) {
		lua_pop(L, 1);

		if(lua_type(L, -1) != LUA_TSTRING)
			continue;

		const char* k = lua_tostring(L, -1);

		// Looking for a key that starts with "LOADLIB: " and ends with <modulename>.
		 if(k != strstr(k, "LOADLIB: "))
			 continue;

		 const char* s = strstr(k, modulename);

		 while(s) {
			 if(0 == strcmp(s, modulename))
				 break;
			 s = strstr(s+1, modulename);
		 }

		 if(!s)
			 continue;

		 lua_gettable(L, LUA_REGISTRYINDEX);
		 lua_pushnil(L);
		 lua_setmetatable(L, -2);
		 break;
	}

	lua_settop(L, top);

	return;
}

int luaopen_objc(lua_State* state) {
	kill_dlclose(state, "/objc.so");
	lua_objc_open(state);
	return 1;
}

// vim:ts=2:sw=2:
