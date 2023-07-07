local index = 1
local ip = 1
print("Enter Brainfuck code: ")
local input = io.read()
local inputLength = #input

local loopTable = {}
local loopStack = {}

local output = ""

for i = 1, inputLength do
    local inByte = input:byte(i)
    if inByte == string.byte('[') then
        table.insert(loopStack, i)
    elseif inByte == string.byte(']') then
        local loopStartIndex = table.remove(loopStack)
        loopTable[loopStartIndex] = i
        loopTable[i] = loopStartIndex
    end
end

local array = {}
for i = 1, inputLength do array[i] = 0 end

local commands = {
    ["+"] = function() array[index] = (array[index] + 1) % 256 end,
    ["-"] = function() array[index] = (array[index] - 1) % 256 end,
    [">"] = function() index = index + 1 end,
    ["<"] = function() index = index - 1 end,
    ["."] = function() output = output .. string.char(array[index]) end,
    [","] = function() array[index] = string.byte(io.read(1) or '\0') end,
    ["["] = function() if array[index] == 0 then ip = loopTable[ip] end end,
    ["]"] = function() if array[index] ~= 0 then ip = loopTable[ip] end end,
}

while ip <= inputLength do commands[string.sub(input, ip, ip)]() ip = ip + 1 end

print(output)
