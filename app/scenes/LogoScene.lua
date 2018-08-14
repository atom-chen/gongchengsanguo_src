--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local LogoScene = class("LogoScene",function ()
    return  display.newScene("LogoScene")
end)
function LogoScene:ctor(...)
    self.uiLayer = nil 
    self.sceneName = "LogoScene"
end

function LogoScene:create()
    local logoScene  = logoScene:new()
    self:showUI()
    return logoScene
end

function logoScene:showUI()
    
end


function logoScene:onEnter()

end

function logoScene:onExist()
    GameGlobal:getResourceManager():purgeCacheData("ui/logo/logo.pnl")
end


return LogoScene