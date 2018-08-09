--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

cc.exports.StringUtil = cc.exports.StringUtil or {}
cc.exports.StringBuffer = cc.exports.StringBuffer or {}
-- 添加
function StringBuffer:append(str)
    if type(str) == "number" then
        str = tostring(str)
    end
    if type(str) == "string" then
        table.insert(self._sArray, str)
        self._sLen = self._sLen + string.len(str)
    elseif type(str) == "table" then
        if self ~= str then
            if str._sArray and type(str._sArray) == "table" then str = str._sArray end
            for _,v in ipairs(str) do
                self:append(v)
            end
        end
    end
    return self
end
function StringBuffer:appends(...)
    local arr = {...}
    local len = table.maxn(arr)
    for i = 1,math.max(1,len) do
        if arr[i] then
            self:append(arr[i])
        end
    end
    return self
end
-- 插入
function StringBuffer:insert(str,pos)
    if not pos then pos = 1 end
    local o = StringBuffer:new(str)
    if o:isEmpty() then return self end
    local num = #self._sArray
    local addnum = #o._sArray
    for i = num,pos,-1 do
        self._sArray[i + addnum] = self._sArray[i]
    end
    for i = pos,pos + addnum - 1 do
        self._sArray[i] = o._sArray[i - pos + 1]
        self._sLen = self._sLen + string.len(o._sArray[i - pos + 1])
    end
    return self
end
-- 弹出
function StringBuffer:pop(pos)
    if not pos then pos = #self._sArray end
    if pos <= 0 then return end
    if pos > #self._sArray then return end
    local str = self._sArray[pos]
    table.remove(self._sArray,pos)
    self._sLen = self._sLen - string.len(str)
    return str
end
-- 获得字符串
function StringBuffer:toStr(sep)
    return table.concat(self._sArray,sep)
end
-- 获得字符长度
function StringBuffer:getLen()
    return self._sLen
end
function StringBuffer:isEmpty()
    return 0 == #self._sArray
end
-- 获得迭代器
function StringBuffer:getStrBufferIter()
    local index = 0
    local function iter_add()
        index = index + 1
        return self._sArray[index]
    end
    return iter_add
end
-- 清空
function StringBuffer:cleanUp()
    self._sArray = {}
    self._sLen = 0
end
function StringBuffer:__add(o)
    if type(self) ~= "table" or not self.append then return o:insert(self) end
    return self:append(o)
end
function StringBuffer:__tostring()
    return self:toStr()
end
function StringBuffer:dump()
    print("______begin______")
    for k,v in pairs(self._sArray) do
        print(""..k.." "..v)
    end
    print("_______end_______")
end
-- new
function StringBuffer:new(s)
    local o = {
        _sArray = {},
        _sLen = 0,
    }
    setmetatable(o, StringBuffer)
    StringBuffer.__index = StringBuffer
    o:append(s)
    return o
end

-- 创建字符串缓冲集
function StringUtil:getStringBuffer(s)
    return StringBuffer:new(s)
end

function StringUtil:split(str, split_char, transStrToNum)
    if str == nil then
        --Logger:out("Lua Error:StringUtil:欲拆分的string为nil！");
        Logger:throwError("StringUtil:欲拆分的string为nil！");
        return {};
    end
    if type(str) == "table" then
        --Logger:out("Lua Error:StringUtil:欲拆分的string为table！");
        Logger:dump(str);
        Logger:throwError("StringUtil:欲拆分的string为table！");
        return {};
    end
    local split_charLen = string.len(split_char)  
    local tab = {}
    for uchar in string.gmatch(split_char, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local len = table.nums(tab);
    local findSpec = false;
    for i = 1, len do
        local index = tab[i]:find("[%(%)%.%%%+%-%*%?%[%^%$%]]")
        if index and index > 0 then
            tab[i] = "%"..tab[i]
            findSpec = true
        end
    end
    local splitRealChar = split_char
    if findSpec then
        splitRealChar = ""
        for i = 1,len do
            splitRealChar = splitRealChar..tab[i];
        end 
    end
    local sub_str_tab = {};
    -- if split_char == "." then 
    --     split_char = "%."
    -- else 
    --     --把拆分的关键字转义
    --     split_char = string.gsub(split_char,"%%","%%%%");
    --     split_char = string.gsub(split_char,"%.","%%.");
    -- end;  
    local isFind = false;
    while (true) do
        local pos = string.find(str, splitRealChar);
        if pos then
            isFind = true;
        end
        if (not pos) then
            if transStrToNum and tonumber(str) ~= nil then
                sub_str_tab[#sub_str_tab + 1] = tonumber(str);
            else
                sub_str_tab[#sub_str_tab + 1] = str;
            end
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        if transStrToNum and tonumber(sub_str) ~= nil then
            sub_str_tab[#sub_str_tab + 1] = tonumber(sub_str);
        else
            sub_str_tab[#sub_str_tab + 1] = sub_str;
        end        
        str = string.sub(str, pos + split_charLen, #str);
    end
    return sub_str_tab;
end
function StringUtil:setUnitsForMyriad(num)
    num = tonumber(num);
--    if num > 9999 and num < 100000 then
--        if num/10000 > math.floor(num/10000) then
--            return (string.format("%.2f", (num/10000)) ..unit)
--        else
--            return ((num/10000) ..unit)
--        end
--         
--    elseif num >= 100000 and num < 1000000 then
--        if num/10000 > math.floor(num/10000) then
--            return (string.format("%.1f", (num/10000)) ..unit)
--        else 
--            return ((num/10000) ..unit)
--        end
    if num >= 100000000 then
        local yin = num/100000000;
        local yi = math.floor(yin);
        local tmp =string.format("%.6f",(yin - yi) * 100) 
        local xiaoshu = math.floor(tmp) / 100;
        return  (yi + xiaoshu) .. Config_Language.yi1 
    elseif num >= 100000 then
        return    math.floor((num/10000))..require("data.manual.Config_Language")["wan"]; 
    end
    return num
end
--将秒数转变为00:00:00:00  toDays 超过24小时是否转为天 默认不转
--如果超过一天 则时间变成X天X小时，否则为时：分:秒
function StringUtil:formatTime(n,toDays) 
    if toDays== nil then
        toDays = false;
    end
    n = math.floor(n);    
    local symbols = ":";
    local day = math.floor(n / 86400);
    local m = n % 86400;
    local hour = math.floor(m / 3600);
    local minute = math.floor(m % 3600 / 60);
    local second = math.floor(m % 60);
    if toDays == false then
        hour = hour + day * 24;
        day = 0;
    end
    if day <= 9 then
        day =  day;
    end 
    if hour <= 9 then
        hour = "0" .. hour;
    end
    if minute <= 9 then
        minute = "0" .. minute;
    end
    if second <= 9 then
        second = "0" .. second;
    end
    
    if tonumber(day) == 0  then                          
        return hour .. symbols .. minute .. symbols .. second                       
    else               
        --return day .. symbols .. hour .. symbols .. minute ..symbols .. second
        return day .. Config_Language.day..hour..Config_Language.TIMEHOUR
    end
end

--精简地显示剩余时间。
--如超过1天，则显示x天x时；
--若超过1小时，则显示x时x分；
--若小于1小时，则显示分:秒
function StringUtil:formatTimeSimple(n) 
    n = math.floor(n);    
    local symbols = ":";
    local day = math.floor(n / 86400);
    local m = n % 86400;
    local hour = math.floor(m / 3600);
    local minute = math.floor(m % 3600 / 60);
    local second = math.floor(m % 60);
    if day <= 9 then
        day =  day;
    end    
    if minute <= 9 then
        minute = "0" .. minute;
    end
    if second <= 9 then
        second = "0" .. second;
    end
    
    if tonumber(day) == 0  then
        if tonumber(hour) == 0 then
            --不到1小时，显示xx:xx
            return minute .. symbols .. second;                      
        else
            --超过1小时，显示x小时
            if tonumber(minute) == 0 then
                return hour .. Config_Language.TIMEHOUR2;
            else
                return hour .. Config_Language.TIMEHOUR2 .. minute .. Config_Language.TIMEMUNITE;                       
            end
        end
    else
        --超过1天，显示x天        
        if tonumber(hour) == 0 then
            return day .. Config_Language.day;
        else
            return day .. Config_Language.day .. hour .. Config_Language.TIMEHOUR2;
        end
    end
end
-- x小时x分x秒
function StringUtil:formatTimeText( sec )
    

    local nhour = math.floor(tonumber(sec)/3600)
    local nsec = math.floor(tonumber(sec)%3600/60)
    local ns = math.floor(tonumber(sec)%3600%60)
    Logger:out("nhour---------",nhour,nsec,ns)

    local strTime = ""
    local strTime_h = ""..nhour
    if  nhour <10 then 

        strTime_h = "0"..nhour

    end 

    local strTime_sec = ""..nsec
    if  nsec <10 then 

        strTime_sec = "0"..nsec

    end 

    local strTime_ss = ""..ns
    if  ns <10 then 

        strTime_ss = "0"..ns

    end 
    local symbol = ":"
    strTime =  strTime_h..Config_Language.TIMEHOUR..strTime_sec..Config_Language.TIMEMUNITE..strTime_ss..Config_Language.TIMESEC
    if MultiVersionUIHelper:needColonSymbolTime() then
        strTime =  strTime_h..symbol..strTime_sec..symbol..strTime_ss
    end
    return strTime
end
-- x小时x分x秒（没有的不显示）
function StringUtil:formatTimeTextSim( sec )
    

    local nhour = math.floor(tonumber(sec)/3600)
    local nsec = math.floor(tonumber(sec)%3600/60)
    local ns = math.floor(tonumber(sec)%3600%60)
    Logger:out("nhour---------",nhour,nsec,ns)

    local strTime = ""
    local strTime_h = ""..nhour
    if  nhour <10 then 

        strTime_h = "0"..nhour

    end 

    local strTime_sec = ""..nsec
    if  nsec <10 then 

        strTime_sec = "0"..nsec

    end 

    local strTime_ss = ""..ns
    if  ns <10 then 

        strTime_ss = "0"..ns

    end 
    local symbol = ":"
	if nhour > 0 then strTime = strTime..strTime_h..Config_Language.TIMEHOUR end
	if nsec > 0 then strTime = strTime..strTime_sec..Config_Language.TIMEMUNITE end
	strTime = strTime..strTime_ss..Config_Language.TIMESEC
    if MultiVersionUIHelper:needColonSymbolTime() then
        strTime =  strTime_h..symbol..strTime_sec..symbol..strTime_ss
    end
    return strTime
end
-- 将时间转化为日期
function StringUtil:formatTimeStr(time,isneedwhole)
	local timedata = time
	if type(time) == "number" then
		timedata = os.date("*t",time)
	end
	if MultiVersionUIHelper:needColonSymbolTime() then
		if isneedwhole then
			return timedata.year .. "-" .. timedata.month .. "-" .. timedata.day .. " " .. string.format("%02d",timedata.hour) .. ":" .. string.format("%02d",timedata.min) .. ":" .. string.format("%02d",timedata.sec)
		else
			return timedata.year .. "-" .. timedata.month .. "-" .. timedata.day
		end
	else
		if isneedwhole then
			local str = timedata.year .. Config_Language.YEAR .. timedata.month .. Config_Language.MONTH .. timedata.day .. Config_Language.DAY .. timedata.hour .. Config_Language.TIMEHOUR2
			if timedata.min > 0 then
				str = str .. string.format("%02d",timedata.min) .. Config_Language.TIMEMUNITE
			end
			if timedata.sec > 0 then
				str = str .. string.format("%02d",timedata.sec) .. Config_Language.TIMESEC
			end
			return str
		else
			return timedata.year .. Config_Language.YEAR .. timedata.month .. Config_Language.MONTH .. timedata.day .. Config_Language.DAY
		end	
	end
end
--按照utf8编码字符串长度来拆分
function StringUtil:subByteLen(str, isUtf8,startIndex,endIndex)
    local tab = {};
    isUtf8 = false;
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local length = table.nums(tab);
    local totalBytes = 0;
    local resultStr = ""
    for i = 1, length do
        local len = string.len(tab[i]);
        if len > 1 then
            if isUtf8 == true then

            else
                totalBytes = totalBytes + 2;
                if startIndex <= totalBytes  and totalBytes < endIndex    then 
                    resultStr = resultStr .. tab[i];
                end
                if totalBytes  == endIndex then
                    resultStr = resultStr .. tab[i];
                    return resultStr
                elseif totalBytes > endIndex then
                    return resultStr
                end
            end            
        else
            totalBytes = totalBytes + 1; 
            if startIndex <= totalBytes  and totalBytes  < endIndex  then
                resultStr = resultStr .. tab[i];
            end
            if totalBytes   == endIndex  then
                resultStr = resultStr .. tab[i];
                return resultStr
            elseif totalBytes > endIndex then
                    return resultStr
            end
        end
    end
    return resultStr
end

--- 获取utf8编码字符串长度(如果第二个参数不填，则用gbk方式来计算。默认不填)
function StringUtil:getByteLen(str, isUtf8)
    local tab = {};
    isUtf8 = false;
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local len = table.nums(tab);
    local totalBytes = 0;
    for i = 1, len do
        local len = string.len(tab[i]);
        if len > 1 then
            if isUtf8 == true then
                totalBytes = totalBytes + len;
            else
                totalBytes = totalBytes + 2;
            end            
        else
            totalBytes = totalBytes + 1; 
        end
    end
    return totalBytes
end
--- 获取字符数量
function StringUtil:getWordNum(str)
    local tab = {};
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local len = table.nums(tab);
    return len
end
--trim
--把大string按字节拆
function StringUtil:splitToString(str, s, e)
    str=str:gsub('([\001-\127])','\000%1')
    str=str:sub(s*2+1,e*2)
    str=str:gsub('\000','')
    return str
end

--切割字符串，长于len后，用“...”替换尾部
function StringUtil:getShort(str, maxLen)
    local tab = {};
    local totalBytes = 0;
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end    
    local len = table.nums(tab);
    local newStr = ""; 
    for i=1,len do
        if len > 1 then          
            totalBytes = totalBytes + 2;            
        else
            totalBytes = totalBytes + 1; 
        end
        if totalBytes > maxLen then
            newStr = newStr .. "...";
            break;
        end    
        newStr = newStr .. tab[i];
    end 
    return newStr;
end

--按照字符长度加回车符，返回处理好的字符串  (letterLen为了显示英文或数字的时候看起来更合适，可以传2)
function StringUtil:changeLineByLen(str, maxLen, letterLen)
    letterLen = letterLen or 1
    local tab = {};
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local len = table.nums(tab);
    local totalBytes = 0;
    local resultStr = "";
    for i = 1, len do
        local len = string.len(tab[i]);
        if len > 1 then
            totalBytes = totalBytes + len;     
        else
            totalBytes = totalBytes + letterLen; 
        end
        resultStr = resultStr .. tab[i];
        if totalBytes >= maxLen then
            resultStr = resultStr .. "\n";
            totalBytes = 0;
        end
    end
    return resultStr
end

-- 按中文的一个字符拆字
function StringUtil:SubUTF8String(str, s, n)    
    local tab = {};
    if type(str) == "string" then
        for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    else
        tab = str
    end
    --dump(tab)
    local len = table.nums(tab);
    --Logger:out("str.len-==>",len)
    if n >= len then
        n = len
    end
    if s < 1 then
        s = 1
    end
    
    local totalBytes = 0;
    local resultStr = "";
    for i = s, n do
        resultStr = resultStr .. tab[i]
    end
    return resultStr
end 
--获得t1、t2之间的时间差。t1需要小于t2。单位都是秒。
--返回x天x时x分x秒
function StringUtil:getTimeGap(t1, t2)
    local day = math.floor(( t1 - t2 )/3600/24 )
    local hour = math.floor(( t1 - t2)/3600 )
    local minute = math.floor(( t1 - t2)/60)
    if hour < 1 then 
        return minute  .. require("data.manual.Config_Language").fenzhongqian
    elseif day < 1 then
        return hour .. require("data.manual.Config_Language").xiaoshiqian
    elseif day >= 1 then
        return day ..require("data.manual.Config_Language").tianqian
    end
end
-- 获得星期
function StringUtil:getTimeWeedDays(t,noChinese)
    if type(t) == "number" then
        t = os.date("*t",t)
    end
    if MultiVersionUIHelper:needColonSymbolTime() or noChinese then
        if t.wday == 2 then
            return "Mon"
        elseif t.wday == 3 then
            return "Tue"
        elseif t.wday == 4 then
            return "Wed"
        elseif t.wday == 5 then
            return "Thu"
        elseif t.wday == 6 then
            return "Fri"
        elseif t.wday == 7 then
            return "Sat"
        elseif t.wday == 1 then
            return "Sun"
        end
    else
        if t.wday == 1 then
            return Config_Language.WEEK .. Config_Language.DAY
        else
            return Config_Language.WEEK .. Config_Language["chin"..(t.wday - 1)]
        end
    end    
end

--获取字符串位长度，双字节字符算2位
function StringUtil:getStringLenForByte(str)    
    local tab = {}
    if str and str ~= "" and type(str) == "string" then
        for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    else
        return 0
    end
    local len = 0
    for i = 1,#tab do
        if string.byte(tab[i],1) > 127 then 
            len =len  + 2
        else
            len = len + 1
        end
    end
    return len
 end
 --获取字符串位宽度，根据字体来算汉字长度
function StringUtil:getStringWidth(str)    
    local tab = {}
    if str and str ~= "" and type(str) == "string" then
        for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    else
        return 0
    end
    local len = 0
    for i = 1,#tab do
        if string.byte(tab[i],1) > 127 then 
            len =len  + 1.5
        else
            len = len + 1
        end
    end
    return math.ceil(len)
 end
 -- 检测前三个字节是否是 EF BB BF 也就是BOM标记；如果是就去掉，只保留后面的字节。
function StringUtil:TryRemoveUtf8BOM(ret)
    if string.byte(ret,1)==239 and string.byte(ret,2)==187 and string.byte(ret,3)==191 then 
        ret=string.char( string.byte(ret,4,string.len(ret)) )
    elseif string.byte(ret,1) == 255 and string.byte(ret,2) == 254 then
        FloatMessage:addMessage("error utf-16 with bom")
    end
    return ret;
end
function StringUtil:getUTF8StringLen(str)    
    local tab = {};
    if str and str ~= "" and type(str) == "string" then
        for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    else
       return 0
    end
    local len = table.nums(tab);
    return len
end
--删除table里每一个字符串最后一个字符 
function StringUtil:delLastSymble(arr)
    for i = 1, #arr do
        arr[i] = string.sub(arr[1], 1, string.len(arr[i]) - 1);
    end
end

--不足len长度，后面补空格(len按字节算，即中文算2字节)
function StringUtil:addSpaceByLen(str, len)
    local cur = StringUtil:getUTF8StringLen(str);
    for i = cur, len do
        str = str .. " ";
    end
    return str;
end
--把后台log变回arr
function StringUtil:parseServerLogToArr(str)
    local arr = StringUtil:split(str, " ");
    local re = {};
    for i = 1, #arr do
        local tmp1 = string.sub(arr[i], 0, 1);
        local tmp2 = string.sub(arr[i], 2, #arr[i]);        
        if tmp1 == "i" then
            table.insert(re, tonumber(tmp2));
        elseif tmp1 == "s" then
            table.insert(re, tmp2);
        elseif tmp1 == "f" then
            table.insert(re, tonumber(tmp2));
        end
    end
    return re;
end
function StringUtil:replace(content, src, dst)  
    content, count = string.gsub(content, src, dst);  
    return content
end  
--把服务器的以下格式的关键字，改为对应模块号、命令的格式
--modoul:[1] cmd:[24]
--modoul:1, cmd:24     
function StringUtil:replaceServerLog(path)
        local file = assert(io.open(path,"r"))
    local str = file:read();
    local arr = {};
    arr[1] = str;
    local index = 1;
    while str do
        table.insert(arr, str);
        str = file:read();
    end
    file:close();
    local moduleTab = {};
    --找出所有模块号
    for k, v in pairs (Const_MsgType) do
        local newStr, num = string.gsub(k,"_"," ");        
        if num == 1 then
            if moduleTab[v] == nil then
                moduleTab[v] = {};
            end            
            moduleTab[v].name = k;            
        end
    end
    --找出所有命令
    for k, v in pairs (Const_MsgType) do
        local newStr, num = string.gsub(k,"_"," ");
        --找出所有模块号
        if num > 1 then
            local ttt = StringUtil:split(k, "_");
            local name = ttt[1] .. "_" .. ttt[2];
            for i,j in pairs(moduleTab) do
                if moduleTab[i].name == name then
                    moduleTab[i][v] = k;
                end
            end
        end
    end
    for k = 1,#arr do
        --后台有两种格式
        --modoul:[1] cmd:[24]
        --modoul:1, cmd:24       
        --找模块号        
        local pos = string.find(arr[k], "modoul:%[")
        local modoulNum;
        local need = true;
        if pos then
            local tmpStrArr = StringUtil:split(arr[k], "modoul:[");
            moduleNum = tonumber(StringUtil:split(tmpStrArr[2], "]")[1]);
            local name = moduleTab[moduleNum].name;
            arr[k] = string.gsub(arr[k],"modoul:%[","modoul:%[" .. name);
            need = false;
        end
        --找模块号        
        local pos = string.find(arr[k], "modoul:")
        if pos and need then
            local tmpStrArr = StringUtil:split(arr[k], "modoul:");
            moduleNum = tonumber(StringUtil:split(tmpStrArr[2], ",")[1]);
            local name = moduleTab[moduleNum].name;
            arr[k] = string.gsub(arr[k],"modoul:","modoul:" .. name);
        end
        --找命令号
        local pos = string.find(arr[k], "cmd:%[")
        need = true;
        if pos then
            local tmpStrArr = StringUtil:split(arr[k], "cmd:[");
            local cmdNum = tonumber(StringUtil:split(tmpStrArr[2], "]")[1]);
            local name = moduleTab[moduleNum][cmdNum];
            arr[k] = string.gsub(arr[k],"cmd:%[","cmd:%[" .. name);
            need = false;
        end
        --找命令号        
        local pos = string.find(arr[k], "cmd:")
        if pos and need then
            local tmpStrArr = StringUtil:split(arr[k], "cmd:");
            local cmdNum = tonumber(StringUtil:split(tmpStrArr[2], " ")[1]);
            local name = moduleTab[moduleNum][cmdNum];
            arr[k] = string.gsub(arr[k],"cmd:","cmd:" .. name);
        end
    end
    local allStr = "";
    file = assert(io.open(path ..".new","a+"));
    for i = 1, #arr do
        file:write(arr[i] .. "\n");
    end    
    file:close();
end
--只打印一层，内部属性是table也不会递归
function StringUtil:tableToString(_t)   
    local szRet = "{"  
    local function doT2S(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet =  szRet .. '"' .. "table" .. '"' .. ","   
            elseif "userdata" == type(_v) then
                szRet = szRet .. '"' .. "userdata" .. '"' .. ","  
            elseif "function" == type(_v) then
                szRet = szRet .. '"' .. "(function)" .. '"' .. ","  
            elseif "nil" == type(_v) then
                szRet = szRet .. '"' .. "nil" .. '"' .. ","  
            else  
                szRet = szRet .. "unknownType,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. '"' .. "userdata" .. '"' .. "," 
            elseif "userdata" == type(_v) then
                szRet = szRet .. '"' .. "userdata" .. '"' .. ","  
            elseif "function" == type(_v) then
                szRet = szRet .. '"' .. "(function)" .. '"' .. ","  
            elseif "nil" == type(_v) then
                szRet = szRet .. '"' .. "nil" .. '"' .. ","  
            else  
                szRet = szRet .. "unknownType,"   
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end  
function StringUtil:checkHasChinese(s)  
    local ss = {}  
    local k = 1  
    local foundChin = false;
    while true do  
        if k > #s then break end  
        local c = string.byte(s,k)  
        if not c then break end  
        if c<192 then  
            k = k + 1  
        elseif c<224 then  
            k = k + 2  
        elseif c<240 then  
            if c>=228 and c<=233 then  
                local c1 = string.byte(s,k+1)  
                local c2 = string.byte(s,k+2)  
                if c1 and c2 then  
                    local a1,a2,a3,a4 = 128,191,128,191  
                    if c == 228 then a1 = 184  
                    elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                    end  
                    if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                        foundChin = true;
                        break;
                    end  
                end  
            end  
            k = k + 3  
        elseif c<248 then  
            k = k + 4  
        elseif c<252 then  
            k = k + 5  
        elseif c<254 then  
            k = k + 6  
        end  
    end  
    return foundChin 
end  
--size:   MB
--fileNum  int
function StringUtil:createRubbishCode(size, fileNum)    
    StringUtil:removeRubbishCode();
    --开始生成    
    local randomPath = {"src/app", "src/app/control", "src/app/proxy", "src/app/script", "src/app/uiLogic", "src/app/utils"};
    local randomContentHead = {"local %s='", "local function %s()", "print ('"}
    local randomContentTail = {"'\n", "end\n", "')\n"};
    local rTxtPath = "E:\\work\\dpProject\\clientCode\\trunk\\dp01\\r.txt"
    local eachFileSize = size * 1024 * 1024 / fileNum;  
    local curSize = 0;
    local sbuffer = StringUtil:getStringBuffer() 
    local function getFileName()
        local len = #Config_usualWords;    
        local b1 = Config_usualWords[math.random(1,len)];
        local b2 = Config_usualWords[math.random(1,len)];
        b2 = string.ucfirst(b2);
        local fileName = b1 .. b2;
        return fileName
    end
    local function getContentHead()
        local len = #Config_usualWords;  
        local str = "";
        local len2 = #randomContentHead;
        local index = math.random(1, len2);
        str = randomContentHead[index];
        if index == 1 then
            str = str:format(Config_usualWords[math.random(1,len)]);
        end
        if index == 2 then
            str = str:format(Config_usualWords[math.random(1,len)]);
        end
        if index == 3 then

        end
        return str, index
    end
    local function getContentBody(index)
        local buffer = StringUtil:getStringBuffer()
        local len = #Config_usualWords;  
        if index == 1 then
            local j = math.random(1,3);
            if j == 1 then                
                buffer:append(string.upper(string.char(math.random(69,90))))
            elseif j == 2 then
                buffer:append(string.lower(string.char(math.random(69,90))))
            elseif j == 3 then
                buffer:append(string.char(math.random(48,57)))
            end
        end
        if index == 2 then
            buffer:append("\n")           
            for p = 1,math.random(10) do
                buffer:append("local ")
                buffer:append(Config_usualWords[math.random(1,len)])
                buffer:append(" = '")
                for i = 1, math.random(1,50) do
                    local j = math.random(1,3);
                    local tt = "";
                    if j == 1 then                
                        tt = string.upper(string.char(math.random(69,90)));
                    elseif j == 2 then
                        tt = string.lower(string.char(math.random(69,90)));
                    elseif j == 3 then
                        tt = string.char(math.random(48,57));
                    end
                    buffer:append(tt)
                end
                buffer:append("';\n")
            end
        end
        if index == 3 then
            for i = 1, math.random(2,100) do
                local j = math.random(1,3);
                local tt = "";
                if j == 1 then                
                    tt = string.upper(string.char(math.random(69,90)));
                elseif j == 2 then
                    tt = string.lower(string.char(math.random(69,90)));
                elseif j == 3 then
                    tt = string.char(math.random(48,57));
                end
                if i == 1 then
                    buffer:append(tt)
                else
                    buffer:append(",")
                    buffer:append(tt)
                end
            end
        end
        return buffer
    end
    local function getContentTail(index)
        return randomContentTail[index], index
    end
    local filePath = "";
    local fileConTotal = "";
    local allFilesList = "local data = {}\n";
    for i = 1,fileNum do
        filePath = randomPath[math.random(1,#randomPath)] .. "/" .. getFileName() .. ".lua";  
        filePath = "E:/work/dpProject/clientCode/trunk/dp01/" .. filePath;
        filePath = string.gsub(filePath,"/","\\");  
        needContinue = true;
        sbuffer:cleanUp()
        while(needContinue) do
            local con, index = getContentHead();
            sbuffer:append(con)
            local ran = math.floor(10 / math.random(1,100));
            if ran < 1 then ran = 1; end
            local full = false;
            for k = 1, ran do
                local sbody = getContentBody(index)
                sbuffer:append(sbody)
                if sbuffer:getLen() > eachFileSize then                                    
                    break;
                end
            end
            local stail = getContentTail(index)
            sbuffer:append(stail)
            if sbuffer:getLen() > eachFileSize then            
                needContinue = false;
                local file4 = assert(io.open(filePath, "a+"));
                local iter = sbuffer:getStrBufferIter()
                for tstr in iter do
                    file4:write(tstr)
                end
                file4:close();
                filePath = string.gsub(filePath,"\\","\\\\");  
                allFilesList = allFilesList .. "data[" .. i .."]='" .. filePath .. "';\n";
            end
        end        
    end
    allFilesList = allFilesList .. "return data"
    local file4 = assert(io.open(rTxtPath, "a+"));
    file4:write(allFilesList);
    file4:close();
end
function StringUtil:removeRubbishCode()
    local rTxtPath = "E:\\work\\dpProject\\clientCode\\trunk\\dp01\\r.txt"
    local path = rTxtPath;
    if not io.exists(rTxtPath) then
        return;
    end
    local file3 = assert(io.open(path, "r"));
    local data = file3:read("*a");
    file3:close();
    local luaFun = loadstring(data);
    local ret = luaFun();
    for i = 1,#ret do
        cc.FileUtils:getInstance():removeFile(cc.FileUtils:getInstance():fullPathForFilename(ret[i]));
    end        
    cc.FileUtils:getInstance():removeFile(path);
end
function StringUtil:boolToInt(boo)
    if boo then
        return 1;    
    end
    return 0;
end
--把table序列化变成string
function StringUtil:serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
    for k, v in pairs(obj) do
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        Logger:throwError("can not serialize a " .. t .. " type.")
    end
    return lua
end
--把string反序列化变成table
function StringUtil:unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        Logger:throwError("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end