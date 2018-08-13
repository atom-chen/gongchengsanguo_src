--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

if GameGlobal then
    GameGlobal:reset()
end 
cc.exports.GameGlobal = cc.exports.GameGlobal or {}

GameGlobal.curPlatForm  = nil;   -- 全局使用的变量判断当前的平台是什么
GameGlobal.curBattleInfo = nil;  
GameGlobal.fileIsExist = {}; --文件是否存在
GameGlobal.APP_ENTER_BACKGROUND = false;--APP进入了后台
GameGlobal.dropIdToItems = {};--key是dropId，value是这个掉落id可能掉落的物品数组
GameGlobal.trailToItems = {} --{chapter= , inst = } 掉落id对应的试炼副本信息
GameGlobal.IDFA = "";
GameGlobal.sKey = "DMJGFB734MGNUEW5634MKGHKJASH348I";
GameGlobal.versionCheckPassed = false;
GameGlobal.repalcingScene = false;--正在切换场景
GameGlobal.editState = false;
GameGlobal.listenerEB = nil;
GameGlobal.listenerEF = nil;
GameGlobal.listenerEventDispatcher = nil;
GameGlobal.islowEnd = false;
GameGlobal.isHotFixing = false;

require "app.utils.StringUtil"

function GameGlobal:init()
     require "app.control.RequireAll"
     require "app.control.UIManager"
     require "app.utils.FilterUtil"
    -- local zip = require "zlib"
    
    --local zip = cc.FileUtils:getInstance()
    UIManager:reset()
    GameGlobal.islowEnd = self:checkDeviceIsLowend()

    math.randomseed(os.time());  
    math.randomseed(math.ceil(math.random() * 1000000000));  
    require "app.control.BattleRandom" 
    
    if Config_Sys.showFps == 1 then 
        cc.Director:getInstance():setDisplayStats(true)
    end 
    GameGlobal.ResourceManager = require("app.control.ResourceManager") -- 资源管理模块
    
    --GameGlobal.gameSocket = require("app.control.GameSocket"):create()--socket管理模块
    GameGlobal.loginProxy = require("app.proxy.LoginProxy"):create() --登陆模块
    GameGlobal.ActivityProxy = require("app.proxy.ActivityProxy"):create() -- 活动模块

    UIManager:addUI(cc.Director:getInstance():getRunningScene(),Config_UI.LOGO.name)
    

end

 
 
--[[
    检查是否是低端设备
]]
 
function GameGlobal:checkDeviceIsLowend()
   
    --如果是ios则不去检查，只检测android 
    if device.platform ~= "android" then 
        return false , -1,-1,-1
    end 
    local luaj = require "luaj"
end


function GameGlobal:checkObjectIsNull(obj)
    if not obj then 
        return false 
    end 
    --查看传进来是不是一个c++对象
    if type(obj) ~= "userdata" then 
        return false
    end 
    --这个应该是一个 tolua的绑定
    if tolua.isnull(obj) then 
        return true
    end 
    return false
end


function GameGlobal:checkFileExist(path)
    if GameGlobal.fileIsExist[path] then --如果文件中已经存在了
        return true
    end 

    local lpath = string.find(path,"/")
    --如果不存在 '/‘写的路径
    if not  lpath then 
        path = string.gsub(path,"%.","/")
        local ts = string.reverse(path)
        path = string.gsub(ts,"/","%.",1)
        path = string.reverse(path)
    end 

    local tPath = cc.FileUtils:getInstance():fullPathForFilename(path)
    local exist = io.exists(tPath)

    if exist then 
        return true
    else 
        Logger:out("文件不存在")
        GameGlobal.fileIsExist[path] = false
    end 
    return exist
end

return GameGlobal