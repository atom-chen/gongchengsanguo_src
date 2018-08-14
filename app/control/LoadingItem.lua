--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregionl
local LoadingItem = class("LoadingItem")
function LoadingItem:ctor()
    self.type = nil 
    self.path = nil 
    self.completedCallBack = nil 
    self.args = nil 
end

function LoadingItem:create(type,path,completedCallBack,arg)
    local loadingItem  = LoadingItem:new()
    loadingItem.type = type
    loadingItem.path = path
    loadingItem.completedCallBack = completedCallBack
    loadingItem.args = arg
    return loadingItem
end

function LoadingItem:getPath()
    return self.path
end

function LoadingItem:cleanup()
    self.type = nil 
    self.path = nil 
    self.completedCallBack = nil 
    self.args = nil 
end
return LoadingItem