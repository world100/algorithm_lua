--[[
    链表：
    单向链表
    头结点.next->尾结点.next->null

--]]

local table_insert = table.insert
local table_remove = table.remove



local SLink = {}

function SLink.new(...)
    local instance = setmetatable({}, {__index=SLink})
    instance:ctor(...)
    return instance
end

--[[
    1:单向 
--]]
function SLink:ctor()
    self.head = nil
    self.tail = nil
    self.count = 0 --节点个数
end

function SLink:add(node)
    if not self.head then
        self.head = node
        self.tail = node
        self.count = self.count + 1
        return
    end

    self.tail.next = node
    self.tail = node
    self.count = self.count + 1
    return

end

function SLink:delete(node)
    if not self.head or not self.tail then
        return
    end
    local pre_node = nil
    local cur_node = self.head
    local finded = nil
    while cur_node do
        if cur_node.id == node.id then
            if not pre_node then
                --删除的是头节点
                self.head = cur_node.next
                finded = true
                break
            end
            pre_node.next = cur_node.next
            finded = true
            break
        end
        pre_node = cur_node
        cur_node = cur_node.next
    end
    if finded then
        self.count = self.count - 1
    end
    return finded
end

--排序,head小->tail大
function SLink:sort()
    local node = self.head
    if not node then
        return
    end
    local tb = {}
    local tb_data = {}
    for k=1, self.count do
        table_insert(tb, node.id)
        tb_data[node.id] = node.data
        node = node.next
        if not node then
            break
        end
    end
    table.sort(tb) --从小到大
    node = self.head
    for k=1, self.count do
        --交换数据
        local id = tb[k]
        local data = tb_data[id]
        node.data = data
        node.id = id
        node = node.next
        if not node then
            break
        end
    end
end

function SLink:empty()
    if self.count > 0 then
        return false
    end
    return true
end

function SLink:print()
    local node = self.head
    while node do
        if  node.data and  node.data[1] then
            print(node.id, node.data[1])
        else
            print(node.id)
        end
        node = node.next
    end
    return
end

function SLink:size()
    return self.count
end


------------------------------------------------------------------
--测试
------------------------------------------------------------------
if arg and arg[0] == "slink.lua" then
    --单向
    print("_____1111111__")
    local list = SLink.new()
    list:add({id=1, data={"1"}})
    list:add({id=5, data={"5"}})
    list:add({id=8, data={"8"}})
    list:add({id=4, data={"4"}})
    list:add({id=2, data={"2"}})
    list:print()
    print("_______")
    local a = list:delete({id=8})
    local a = list:delete({id=1})
    list:add({id=15,data={"15555"}})
    list:add({id=3,data={"3"}})
    print("delete:", a)
    list:print()
    print("_______")
    list:sort()
    print("_______",list:size())
    list:print()



end

return SLink