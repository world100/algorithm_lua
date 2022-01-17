--[[
    栈
    先进后出
--]]

local table_insert = table.insert
local table_remove = table.remove

local Stack = {}

function Stack.new(...)
    local instance = setmetatable({}, {__index=Stack})
    instance:ctor(...)
    return instance
end

function Stack:ctor()
    self.index = 0 --标记
    self.data = {} --用于存放数据
end


function Stack:push(value)
    local index = self.index + 1
    self.data[index] = value
    self.index = index
end

function Stack:pop()
    if self.index <= 0 then
        return
    end
    local value = self.data[self.index]
    self.data[self.index] = nil
    self.index = self.index - 1
    return value
end


function Stack:getData()
    return self.data
end

function Stack:print()
    for i = 1, self.index do
        print(i, self.data[i])
    end
end

function Stack:size()
    return self.index
end

function Stack:empty()
    if self.index > 0 then
        return false
    end
    return true
end
------------------------------------------------------------------
--测试
------------------------------------------------------------------
if arg and arg[0] == "stack.lua" then
    local stack = Stack.new()
    stack:push(1)
    stack:push(2)
    stack:push(3)
    stack:push(4)
    stack:push(5)

    stack:print()
    print("_______")

    stack:pop()
    stack:pop()

    stack:print()
    print("_______", stack:empty())
end

return Stack