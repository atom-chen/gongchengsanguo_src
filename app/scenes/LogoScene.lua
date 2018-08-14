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
    local logoScene  = LogoScene:new()
    self:showUI()
    return logoScene
end

function LogoScene:showUI()
    GameGlobal:getResourceManager():setCurScene( GameGlobal:getResourceManager().sceneNametbl.LOGOSCENE)
    local param = {
        layer = self,
        uiName = Config_UI.LOGO.name,
    };
    UIManager:addUI(param);
end


function LogoScene:onEnter()
    GameGlobal:getResourceManager():purgeCacheDataUseEngine()
end

function LogoScene:onExist()
    GameGlobal:getResourceManager():purgeCacheData("ui/logo/logo.pnl")
end


return LogoScene