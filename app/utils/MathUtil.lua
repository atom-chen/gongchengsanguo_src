--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

cc.exports.MathUtil = cc.exports.MathUtil or {}

function MathUtil:round(num)
    local a,b = math.modf(num)
    if b > 0.5 then 
        return a + 1
    else
        return a
    end 
end

function MathUtil:min(num, num2)
    if num < num2 then return num end;
    return num2;
end
function MathUtil:max(num, num2)
    if num > num2 then return num end;
    return num2;
end

--t：table
--f：sort函数（若不传，则按照key从小到大排序）
local function emptyFunction()
    
end
cc.exports.pairssort = function (t, f)
	local bRet = true
	if next(t) ~= nil then bRet = false end;
	if bRet then return emptyFunction end;
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0                -- iterator variable
	local iter = function ()  -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end
