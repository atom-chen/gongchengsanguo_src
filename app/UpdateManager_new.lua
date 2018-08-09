--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

--[[
        @项目更新模块
]]--

local updateLanguage = {}
local UpdateManager_new = class("UpdateManager_new",function()
    return  display.newScene("UpdateManager_new") --cc.Scene:create() 
end)

require("data.manual.Config_Language")

local winSize = cc.Director:getInstance():getWinSize()
local write_path = cc.FileUtils:getInstance():getWritablePath()



function  UpdateManager_new:ctor(  )
    if scheduler then
        scheduler.unscheduleAll();
    end
    print("@@UpdateManager_new:ctor")

    self.uiLayer = nil
    self.nTryTime = 0
    self._errorFileNum = 0
    self.failedFileName = ""
    self.wifiNode = nil   -- 提示处于移动网络

    if device.platform == "ios" then
        updateLanguage = Config_Language.strUpdate.ios
    else
        updateLanguage = Config_Language.strUpdate.default
    end
end

function UpdateManager_new:create(parent)
    print("@@UpdateManager_new:create")
   
     

    local UpdateManager_new = UpdateManager_new:new()
    UpdateManager_new.uiLayer = cc.Layer:create()
    UpdateManager_new._nCurPer = 0
    UpdateManager_new._bNoForceClose = nil
    UpdateManager_new._bForceCloseThisLoad = false
    
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()       
    if cc.PLATFORM_OS_WINDOWS == targetPlatform then
        -- 电脑调试，才随意设置分辨率
        -- cc.Director:getInstance():getOpenGLView():setFrameSize(1536,864)
         -- cc.Director:getInstance():getOpenGLView():setFrameSize(1280,800) 
        -- cc.Director:getInstance():getOpenGLView():setFrameSize(1160,640) 
    end
    --设置帧频
    cc.Director:getInstance():setAnimationInterval(1/30)
    local frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
    --小米手机在home键后，当app进程被干掉，再从任务列表里回到应用，会导致应用的宽高颠倒；此处作判断是当这种情况发生时，会退出应用；让用户只能点击应用app图标进入
     if frameSize.height>frameSize.width then
        cc.Director:getInstance():endToLua()
        return
    end
    -- 开发时，美术采用的基准分辨率分辨率。最后那个参数,请查阅ResolutionPolicy：  
    --    1:ResolutionPolicy::EXACT_FIT    ：拉伸变形，使铺满屏幕。
    --    2:ResolutionPolicy::NO_BORDER    ：按比例放缩，全屏展示不留黑边。
    --                                      （宽高属性，小的铺满屏幕，大的超出屏幕）
    --    3:ResolutionPolicy::SHOW_ALL     ：按比例放缩，全部展示不裁剪。
    --                                      （宽高属性，大的铺满屏幕，小的留有黑边）
    --    4:ResolutionPolicy::FIXED_WIDTH  ：按比例放缩，宽度铺满屏幕。
    --    5:ResolutionPolicy::FIXED_HEIGHT ：按比例放缩，高度铺满屏幕。    
    -- 保证设计分辨率不小于960*640
    if frameSize.width/frameSize.height>1.5 then 
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(960,640,cc.ResolutionPolicy.FIXED_HEIGHT)
    else 
        cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(960,640,cc.ResolutionPolicy.FIXED_WIDTH)
    end

    cc.Director:getInstance():setDisplayStats(false)



    return UpdateManager_new
end


function UpdateManager_new:onEnter(  )
    print("@@UpdateManager_new:onEnter")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ui/update/update.plist")
    local view = require("ui/update/updateLayerWithPerson.lua"):create()
    self.updateLayer = require("src.app.UpdateManagerLayer"):create(view)

    local designSize = cc.size(960, 640)
    --采用fixHeight策略时，x方向右方必定有空白，所有元素统一右移，使得整个画面居中
    rightShiftPx = (cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width - designSize.width)/2
    --采用width策略时，Y方向上方必定有空白，所有元素统一上移，使得整个画面居中
    upperShiftPy = (cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height - designSize.height)/2
    local formerPositonX,formerPositonY = view:getPosition()
    view:setPosition(formerPositonX+rightShiftPx,formerPositonY+upperShiftPy)

    self:addChild(view)
    self.updateLayer:start()
end

function UpdateManager_new:onExit(  ) 
    print("@@UpdateManager_new:OnExit")
    -- self.UpdateManager_new:onExit()
end

return UpdateManager_new
