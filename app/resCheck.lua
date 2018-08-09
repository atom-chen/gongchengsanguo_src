--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--[[

]]


--endregion


-- 检查require lua文件
if device and device.platform == "windows" and not LUALOADERS then
	--local searchPaths = cc.FileUtils:getInstance():getSearchPaths()
	local function split_str(str, separator)
		local separatorlen = string.len(string.gsub(separator,"%%",""))
		local strlen = string.len(str)
		local findstartindex = 1
		local splitindex = 1
		local splitarray = {}
		while true do
			local nFindLastIndex = string.find(str, separator, findstartindex)
			if not nFindLastIndex then
				splitarray[splitindex] = string.sub(str, findstartindex, strlen)
				break
			end
			splitarray[splitindex] = string.sub(str, findstartindex, nFindLastIndex - 1)
			findstartindex = nFindLastIndex + separatorlen
			splitindex = splitindex + 1
		end		
		return splitarray
	end
	local dirMap = {}
	local function makeDirList(rootpath)
		if dirMap[rootpath] then return dirMap[rootpath] end
		local len = string.len(rootpath)
		if "/" == string.sub(rootpath,len,len) then
			rootpath = string.sub(rootpath,0,len-1)
		end
		local pathes = {}
		for entry in lfs.dir(rootpath) do  
			if entry ~= '.' and entry ~= '..' then  
				local path = rootpath .. '/' .. entry
				local attr = lfs.attributes(path)
				if attr.mode == 'file' then
					pathes[path] = true
				end
			end  
		end
		dirMap[rootpath] = pathes
		return pathes
	end
	

	cc.exports.LUALOADERS = package.loaders[2]
	
	package.loaders[2] = function(path)
		local func = cc.exports.LUALOADERS(path)
		local tmp = split_str(path, "%.")
		local filepath = path
		if tmp[#tmp] == "lua" then
			tmp[#tmp] = nil
			filepath = table.concat(tmp,".")
		end
		filepath = string.gsub(filepath,"%.","/")
		filepath = cc.FileUtils:getInstance():fullPathForFilename(filepath..".lua")
		local ls = split_str(filepath, "/")
		local index = 1
		for k = 1,#ls do
			if ls[index] == ".." then
				table.remove(ls,index)
				table.remove(ls,index - 1)
				index = index - 1
			else
				index = index + 1
			end
		end
		filepath = table.concat(ls,"/")
		ls[#ls] = nil
		local tpath = table.concat(ls,"/")
		local m = makeDirList(tpath)
		if m[filepath] then return func end
		if IS_LUAFILE_CHECK then
			return func
		end
		
 	end
end

-- 检查资源
if cc.exports.ISINITUICHECKMAP then return end
cc.exports.ISINITUICHECKMAP = true
local fileUtil = cc.FileUtils:getInstance()
local spriteFrameCache = cc.SpriteFrameCache:getInstance()
local function checkResExist(path)
	local tpath = fileUtil:fullPathForFilename(path)
	return io.exists(tpath)
end

-- 检查函数
-- 参数1 节点 参数2 方法名 参数3 参数数组
-- 返回1 是否是忽略c++操作
local function checkType1(self,methodName,args)
	--if IS_UIEDITOR then return false end
	if ISNOTCHECKIMAGE then return end
	if not args[1] then
		return false
	end
	if args[2] == ccui.TextureResType.localType then
		if not checkResExist(args[1]) then
			 
		end
	elseif args[2] == ccui.TextureResType.plistType then
		if not spriteFrameCache:getSpriteFrame(args[1]) then
            if device and device.platform == "windows"  then
                if args[1]:find("common_") then --如果包含common_ 则先去oldCommon里面找,如果找不到再报错 找到了则提示包含旧的文件
                    FloatMessage:addMessage(args[1].."在新的common中没有找到,用的oldcommon！")
                    args[1] = string.gsub(args[1], "common_", "oldCommon_")
                    args[1] = "common_ziyuan2.png"
                elseif args[1]:find("common2_") then
                    FloatMessage:addMessage(args[1].."在旧的common2中存在！")   
                    args[1] = "common_ziyuan2.png"                    
                else
                    --Logger:throwError(args[1].." plist res not found!")
                    args[1] = "common_ziyuan2.png"
                end
            else
                args[1] = "common_ziyuan2.png"
               --Logger:throwError(args[1].." plist res not found!") 
            end
		end
	else
	end
	return false
end

local function checkType2(self,methodName,args)
	for i = 1,#args - 1 do
		checkType1(self,methodName,{args[i],args[#args]})
	end
end

local function checkType4(self,methodName,args,data)
	if args[2] and args[2] == cc.TABLECELL_SIZE_AT_INDEX then
		if data._handler then
			data._handler(self,function(node,idx)
				local cell = args[1](node,idx)
				if not cell then
					cell = cc.TableViewCell:new()
				end
				return cell
			end,cc.TABLECELL_SIZE_AT_INDEX)
			return true
		end
	end
end

local function checkType5(self,methodName,args)
	if #args == 0 then return end
	checkType1(self,methodName,args)
end

local function checkAddChild(self,methodName,args)
	if args[1]:getParent() then
	end
end

local defInt = "number"
local defString = "string"
local defBool = "boolean"
local defTable = "table"
local defFunc = "function"
local defUsedata = "userdata"

local uiCheckMap = {
	{class = ccui.ImageView,method = "loadTexture",handle = checkType1,isshow = false},
	{class = ccui.LoadingBar,method = "loadTexture",handle = checkType1,isshow = false},
	{class = ccui.Button,method = "loadTextureNormal",handle = checkType1,isshow = false},
	{class = ccui.Button,method = "loadTexturePressed",handle = checkType1,isshow = false},
	{class = ccui.Button,method = "loadTextureDisabled",handle = checkType1,isshow = false},
	{class = ccui.Button,method = "loadTextures",handle = checkType2,isshow = false},
	{class = cc.Node,method = "addChild",handle = checkAddChild,params = {defUsedata},isshow = false},
	{class = cc.TableView,method = "registerScriptHandler",handle = checkType4,isshow = true},
	{class = ccui.ImageView,method = "create",handle = checkType5,isshow = false},
	--{class = cc.Node,method = "getChildByName",params = {defString},isshow = false},
    {class = ccui.Slider,method = "loadBarTexture",handle = checkType1,isshow = false},
    {class = ccui.Slider,method = "loadProgressBarTexture",handle = checkType1,isshow = false},
    {class = ccui.Slider,method = "loadSlidBallTextureNormal",handle = checkType1,isshow = false},
    {class = ccui.Slider,method = "loadSlidBallTexturePressed",handle = checkType1,isshow = false},
    {class = ccui.Slider,method = "loadSlidBallTextureDisabled",handle = checkType1,isshow = false},
}
--竖向排列 文本 注意锚点位置
ccui.Text.setStringWithVertical = function(text,str)
    local tab = {};
    local newTab = {};
    for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local len = table.nums(tab);
    for i = 1,len  do
        newTab[i] = tab[i].."\n";
    end
    local newStr = table.concat(newTab);
    text:setString(newStr);
end


local function resLoadCheck(data,self,...)
	local args = {...}
	if data.params then
		for k,v in pairs(data.params) do
			if type(args[k]) ~= v then
				 
				break
			end
		end
	end
	if data.handle then
		if data.handle(self,data.method,args,data) then return end
	end
	if data._handler then
        if device and device.platform == "windows"  then
            return data._handler(self,unpack(args))
        else
            args = nil
            return data._handler(self,...)
        end
	else
        args = nil
		assert(false,"" .. self:getName() .. " " .. data.method)
	end
end

local function init()
	local isCheckAll = (device and device.platform == "windows")
	local t = {}
	for _,v in ipairs(uiCheckMap) do
		if v.isshow or isCheckAll then
			if not t[v.class] then t[v.class] = {} end
			if not t[v.class][v.method] then
				t[v.class][v.method] = true
				v._handler = v.class[v.method]
				v.class[v.method] = function(...)
					return resLoadCheck(v,...)
				end
			else
				assert(false,v.method)
			end
		end
	end
	t = nil
end

cc.exports.disableResCheck = function ()
    if cc.exports.LUALOADERS == nil then
        return
    end
    package.loaders[2] = cc.exports.LUALOADERS;
    
end
init()
