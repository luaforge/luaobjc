require'objc'

----[[
function p(t, n)
  if n then print('--'..n..":") end
  for k,v in pairs(t) do print(k,v) end
  t = getmetatable(t)
  if t then
    print('mt->')
    for k,v in pairs(t) do print(k,v) end
  end
end

pool = objc.autoreleasepool()

NSBundle = assert(objc.class'NSBundle')

b = assert(NSBundle:bundleWithPath("/System/Library/Frameworks/AddressBook.framework"))

assert(b:load())

cab = assert(objc.class'ABAddressBook')

ab = cab:sharedAddressBook()

print(ab:description())
print(ab:groups())
print(ab:groups():objectAtIndex(1):description())

--]]
