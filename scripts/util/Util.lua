local json = require "json"

function printObj(obj, indent)
   local str = ""
   if indent then
      for i = 1, indent do
         str = str.."    "
      end
   end
   for key, value in pairs(obj) do
      print(str..key)
   end
end

function printArray(array)
   for key, value in pairs(array) do
      print(value)
      if type(value) == "table" then
         printObj(value, 1)
      end
   end
end

function printCardArray(array)
   require "scripts.card.Card"
   for k,v in pairs(array) do
      if (v:is_a(Card )) then
         print(classname(v))
      elseif (v.name ~=nil) then
         print(v.name)
      end
   end
end

function copy(obj, seen)
   if type(obj) ~= 'table' then return obj end
   if seen and seen[obj] then return seen[obj] end
   local s = seen or {}
   local res = setmetatable({}, getmetatable(obj))
   s[obj] = res
   for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
   return res
end

function jsonFile(file)
   local filePath = system.pathForFile(file)
   local f,err = io.open(filePath, "r")
   if f==nil then
      return f,err
   else
      local content = f:read("*a")
      f:close()
      return content
   end
end

function isType(obj, type)
   for k,v in pairs(obj.types) do
      if (v == type) then
         return true
      end
   end
   return false
end

math.randomseed( os.time() )

function shuffle( t, shuffleCount )
   local rand = math.random
   local iterations = #t
   local j

   for i = iterations, 2, -1 do
      j = rand(i)
      t[i], t[j] = t[j], t[i]
   end
   shuffleCount = shuffleCount or 0
   if shuffleCount < 3 then
      shuffle(t, shuffleCount + 1)
   end
end

function indexOf(array, obj)
   for k,v in pairs(array) do
      if v == obj then
         return k
      end
   end
   return nil
end

function contains(array, obj)
   return indexOf(array, obj) ~= nil
end

function loadData(dataFile)
   return json.decode(jsonFile("data\\"..dataFile))
end

function combine(first, second, append)
   for k,v in pairs(second) do
      if not append or first[k] == nil then
         first[k] = v
      end
   end
end

function getRequireString(card, paths)
   local basepath = "scripts/card/"
   if not paths then
      paths = {}
   end
   table.insert(paths, "treasure")
   table.insert(paths, "victory")
   for k,v in pairs(paths) do
      local path = basepath .. v .. "/" .. card ..".lua"
      if doesFileExists(path) then
         return path:gsub("/", "."):gsub(".lua","")
      end
   end
end

function doesFileExists(path)
   path = system.pathForFile(path)
   local file = nil
   if path then
      file = io.open(path)
   end
   if file then
      file:close()
      return true
   else
      return false
   end
end

function eval(string)
   return _G[string]
end

function removeFromTable(tbl, obj)
   if not obj then return nil end
   return table.remove(tbl, indexOf(tbl, obj))
end

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end
