local table_insert = table.insert

---不会死循环的dump
local function l_dump(tab, _tostring)
    _tostring = _tostring and _tostring or tostring
    local function getkey(k, ktype)
        if ktype == 'number' then
            return '[' .. k .. ']'
        elseif ktype == 'string' then
            return '["' .. k .. '"]'
        else
            return '[' .. _tostring(k) .. ']'  --key可能是table
        end
    end

    local mmax = math.max
    local function dump_obj(obj, key, sp, lv, st)
        local sp = '\t'
        if type(obj) ~= 'table' then
            return sp .. (key or '') .. ' = ' .. tostring(obj) .. '\n'
        end
        local ks, vs, s= { mxl = 0 }, {}
        lv, st =  lv or 1, st or {}
        st[obj] = key or '.' --table对象列表
        key = key or ''
        for k, v in pairs(obj) do
            local ktype, vtype = type(k), type(v)
            if k ~= 'class' and k ~= '__index' and vtype ~= 'function'then
                if vtype == 'table' then
                    if st[v] then --相互引用的table，直接输出
                        vs[#vs + 1] = '[' .. st[v] .. ']'
                        s = sp:rep(lv) .. getkey(k, ktype)
                        table_insert(ks, s)
                        ks.mxl = mmax(#s, ks.mxl)
                    else
                        st[v] = key .. '.' .. _tostring(k) --保存dump过的table，key可能也是table
                        vs[#vs + 1] = dump_obj(v, st[v], sp, lv + 1, st)
                        s = sp:rep(lv) .. getkey(k, ktype)
                        table_insert(ks, s)
                        ks.mxl = mmax(#s, ks.mxl)
                    end
                else
                    if vtype == 'string' then
                        vs[#vs + 1] = (('%q'):format(v):gsub('\\\10','\\n'):gsub('\\r\\n', '\\n'))
                    else
                        vs[#vs + 1] = tostring(v)
                    end
                    s = sp:rep(lv) .. getkey(k, ktype)
                    table_insert(ks, s)
                    ks.mxl = mmax(#s, ks.mxl);
                end
            end
        end
        s = ks.mxl
        for i, v in ipairs(ks) do
            vs[i] = v .. (' '):rep(s - #v) .. ' = ' .. vs[i] .. '\n'
        end
        return '{\n' .. table.concat(vs) .. sp:rep(lv-1) .. '}'
    end
    return dump_obj(tab)
end

sys_tostring = tostring
local _tostring = tostring
tostring = function(v)
    if type(v) == 'table' then
        return l_dump(v, _tostring)
    else
        return _tostring(v)
    end
end