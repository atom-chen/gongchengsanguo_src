--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local ActivityProxy = class("ActivityProxy")
function ActivityProxy:ctor()
    self.addNewUI = {}
    self.showingNewIcon = false   
end
return ActivityProxy