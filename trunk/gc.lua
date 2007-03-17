--[[
Example of garbage collection, showing it doesn't work. :-(
]]

require'objc'

pool = objc.autoreleasepool()

function p(t, n)
  if n then print('--'..n..":") end
  for k,v in pairs(t) do print(k,v) end
  t = getmetatable(t)
  if t then
     print('mt->')
     for k,v in pairs(t) do print(k,v) end
  end
end

p(objc, 'obc')

nsstring = objc.class'NSString'

p(nsstring, 'nsstring class')

objc_metatable = getmetatable(nsstring)

objc_metatable.__tostring = function (obj)
  return obj:description()
end

print("nsstring => ", tostring(nsstring))

while true do
  local s = nsstring:stringWithCString'a string'
  p(s, 'nsstring object')
  collectgarbage()
end

