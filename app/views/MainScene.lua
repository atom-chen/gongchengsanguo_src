require "app.resCheck"
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

 

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("这个是测试", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

end

function MainScene:reloadLuaFiles()
    local already_files = package.loaded
    for k,v in pairs(already_files) do 
        local pos,q = string.find(tostring(k),"app")
        local posD,qD = string.find(tostring(k),"data")
        local posU,qU = string.find(tostring(k),"ui")
        if (pos~=nil and pos==1) or (posD ~=nil and posD ==1) or (posU ~=nil and posU ==1) then
            package.loaded[k] = nil  
        end 
    end 
end

function MainScene:onEnter()
   
    if not cc.exports.NEW_PACKAGE_PF then 
        cc.exports.NEW_PACKAGE_PF=PACKAGE_PF -- 角色平台
        cc.exports.OLD_PACKAGE_PF=PACKAGE_PF
    end  
   cc.exports.GAME_INIT_SUCCESS = false
   local function luaErrCallBack(str1, str2)
        --如果游戏不正常，则返回热更新界面去
        if not cc.exports.GAME_INIT_SUCCESS then            
            print("出屎了，回到热更新界面！！！")
            cc.exports.GAME_INIT_SUCCESS = true;--不要频繁进来
            if Config_Language == nil then
                Config_Language = {};
                Config_Language.strUpdate = {
                    ios = {
                        check = "checking resources...",
                        load = "loading game..",
                        wait = "loading, please wait...",
                        strError = "load error",
                        exit = "loading, wanna quit?"
                    },
                    default = {
                        check = "checking version...",
                        load = "updating...",
                        wait = "updating, please wait...",
                        strError = "load error",
                        exit = "loading, wanna quit?"
                    },
                    retry = "network error, retry?",
                    entry = "latest version. entering game...",
                    consume = "need update %sMB，\ncontinue?",
                    exit = "exit",
                    try = "retry",
                    new = "found new version!",
                    download = "version too old, need to download latest version",
                    cancel = "cancel",
                    confirm = "ok",
                    mobNet = "mobile network state",
                    consumeDefault = "need update 100MB，\ncontinue?",
                    continue = "continue",
                    netError = "network error",
                }
            end
            if Config_Sys and StringUtil then
                local ttttt = Config_Sys.VersionCodePath;
                 --VERSION_CODE_PATH_FOR_UPDATE的格式是：http://res.xh.gcsg.yileweb.com/resource/dwsg/Android_zuoqi/                                            
                VERSION_CODE_PATH_FOR_UPDATE = StringUtil:split(ttttt, "version.manifest")[1];                                            
            end
	        
            local UpdateManager = require("src.app.UpdateManager_new.lua"):create(nil)
            if cc.Director:getInstance():getRunningScene() then
                cc.Director:getInstance():replaceScene(UpdateManager)
            else
                cc.Director:getInstance():runWithScene(UpdateManager)
            end   
            return 
        end

        local tmpLen = string.len(str1)
        local resStr = ""
        for i = 1, math.ceil(tmpLen / 60) do
            resStr = resStr .. "\n" .. string.sub(str1,(i-1)*60 + 1 ,i*60)
        end
        local str = resStr .. "\n" .. str2;
        if Config_Sys.showLuaErrorMsg == 1 then
            --把错误信息打印出来。若showPrint=2，则会写到文件里
            if Logger and Logger.out then
                Logger:out("Lua Error:" .. str1);
            end
            --UIManager未初始化，无法报错
            if not UIManager then return end;
            local logic = UIManager:getUILogicByName(cc.Director:getInstance():getRunningScene(),require("data.manual.Config_UI").SIGNINTRO.name)
            if logic ~= nil then
                local last = logic:getText();
                str = last .. str;
                logic:init({str=str, width = 900, height = 2000,showClose = true});
            else
			UIManager:addUI({layer = cc.Director:getInstance():getRunningScene(),uiName = require("data.manual.Config_UI").SIGNINTRO.name,zorder = 99999999,params = {str=str, width = 900, height = 2000,showClose = true, needShort = true}})
            end
        end
    end
    cc.exports.LUA_ERROR_CALLBACK = luaErrCallBack;
    self:reloadLuaFiles()
    --在window平台下， 可以随意的调整尺寸
    if device.platform == "windows"then 
        cc.Director:getInstance():getOpenGLView():setFrameSize(960,640)
    end 
    cc.Director:getInstance():setAnimationInterval(1.0/30)
    local frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    -- 开发时，美术采用的基准分辨率分辨率。最后那个参数,请查阅ResolutionPolicy：  
    --    1:ResolutionPolicy::EXACT_FIT    ：拉伸变形，使铺满屏幕。
    --    2:ResolutionPolicy::NO_BORDER    ：按比例放缩，全屏展示不留黑边。
    --                                      （宽高属性，小的铺满屏幕，大的超出屏幕）
    --    3:ResolutionPolicy::SHOW_ALL     ：按比例放缩，全部展示不裁剪。
    --                                      （宽高属性，大的铺满屏幕，小的留有黑边）
    --    4:ResolutionPolicy::FIXED_WIDTH  ：按比例放缩，宽度铺满屏幕。
    --    5:ResolutionPolicy::FIXED_HEIGHT ：按比例放缩，高度铺满屏幕。    
    if frameSize.width / frameSize.height > 1.5 then 
        --cc.Director:getInstance():getOpenGLView():setFrameSize(1366,768)
    else
        --cc.Director:getInstance():getOpenGLView():setFrameSize(1366,768)
    end 
    cc.Director:getInstance():setDisplayStats(false)
    
    --系统的math 精度是保3个小位。 
    if not cc.exports.mathFloor then 
        cc.exports.mathFloor = math.floor
        mathFloor = function(str)
            local tmp  = string.format("%.6f",str)
            return mathFloor(tmp)
        end 
    end 

    if not cc.exports.mathCeil then 
        cc.exports.mathCeil = math.ceil
        math.ceil = function(str)
            local tmp  = string.format("%.6f",str)
            return mathCeil(tmp)
        end 
    end 

    require "app.utils.MathUtil"
    require "app.utils.CUtil"
    require "app.control.Logger"
    require "app.control.GameGlobal" -- 写到了这里
    require "app.control.MultiVersionUIHelper"


   
    GameGlobal:init()

   
   
end

return MainScene
