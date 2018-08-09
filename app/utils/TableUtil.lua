--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
 cc.exports.TableUtil =  cc.exports.TableUtil or {}
--在table中遍历查找，如果其中有值等于str，就返回true
function TableUtil:checkStringTableHasString(tab, str)
    local len = table.maxn(tab);
    for i = 1,len,1 do
        if tab[i] == str then
            return true
        end
    end
    return false;
end
--删除重复项目，只支持子对象为string
function TableUtil:removeDuplicateItems(tab)
    local len = table.nums(tab)
    local ret = {}; 
    local has = false;
    for i = 1, len do
        local len2 = table.nums(ret);
        has = false;
        for j = 1, len2 do
            if tab[i] == ret[j] then
                --有了
                has = true;
                break;
            end
        end
        if has == false then
             table.insert(ret, table.maxn(ret) + 1, tab[i]);
        end        
    end
    tab = ret;
    return tab
end 
--在tab1中遍历查找tab2中相同的点
function TableUtil:getPointTableWhenBeInclued(tab, tab2)
    local len = table.maxn(tab);
    local len2 = table.maxn(tab2);
    local ret = {};
    for i = 1,len,1 do
        for j = 1, len2, 1 do
            if tab[i].x == tab2[j].x and  tab[i].y == tab2[j].y then
                table.insert(ret,1,tab2[j]);
            end
        end
    end
    return ret;
end
--尝试将tab转成string，分隔符
function TableUtil:toString(tab, split)
    if split == nil then split = "," end;
    local len = table.maxn(tab);
    local str = "";
    for i = 1,len,1 do
       str = str .. tab[i];
       if i ~= len then str = str .. split end
    end
    return str;
end
--将tab2的内容合并到tab1内，并返回tab1(此方法不保证顺序）
function TableUtil:combineTable(tab1, tab2)
    if tab1 == nil then tab1 = {}; end
    for i,v in pairs(tab2) do
        table.insert(tab1,v)
    end
    return tab1;
end
--浅复制（如果table内存的是复杂对象，则只是传递引用）
function TableUtil:clone(ori_tab, isDeepCopyTable)
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            --如果深拷贝table
            if isDeepCopyTable then
                new_tab[i] = TableUtil:clone(v, true)
            else
                new_tab[i] = v;                            
            end
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end


--深复制
function TableUtil:deepClone(ori_tab)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, getmetatable(object))
    end  -- function _copy
    return _copy(ori_tab)
end

--捣乱table的下标顺序，随机次数
function TableUtil:randomSort(tab, times)
    if tab == nil then return end;
    if times == nil then times = 1 end;
    local len = table.nums(tab);
    if len == 0 then return end;
    for j = 1, times do
        for i = 1, len do
            local index = math.random(1,len);
            local tmp = tab[i]; 
            tab[i] = tab[index];
            tab[index] = tmp
        end
    end
    return tab;
end
--找出相同的point，且删除
function TableUtil:removeDuplicatePoints(arr)
    local len = #arr;
    local cur;
    local index = 1;
    for i = 1, len do
        cur = arr[index];
        for j = index + 1, len do
            --相同的点
            if cur.x == arr[j].x and cur.y == arr[j].y then
                table.remove(arr, index); 
                index = index - 1; 
                len = len - 1;
                break;
            end 
        end
        index = index + 1;
    end 
end
--判断table是否含有指定的key（key,value类型的table）
function TableUtil:containKey(tab,key)
   for k,v in pairs(tab) do
        if k==key then
            return true;
        end
   end
   return false;
end