--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.globalLoadingManagerQueue = cc.exports.globalLoadingManagerQueue or {}
local LoadingManager = class("LoadingManager")
function LoadingManager:ctor()
    self.list = {}
    self.loading = false 
    self.realLoad = false
    self.allCompletedCallBack = nil 
    self.progressCallBack = nil 
    self.maxItemWhenStartLoad = 1 
    self.loadingTicker = nil 
    self.curLoadingItem = nil 
    self.maxTryTimes = 2 
end

function LoadingManager:startLoad(pcb,acb)
    self.progressCallBack = pcb
    self.allCompletedCallBack = acb
    if self.loading then 
        return 
    end 

    if self:checkGlobalQueueLoading() then 
        return 
    end
    self.maxItemWhenStartLoad = table.maxn(self.list) 
    self.realLoad = false 
    self:loadNext()
     
end

function LoadingManager:checkGlobalQueueLoading()
    if #globalLoadingManagerQueue > 0 then 
        if globalLoadingManagerQueue[1] == self then 
            return false
        end 
        return true
    end 
    return false
end

function LoadingManager:loadNext(delayLoad)
    if self.loadingTicker then  --如果已经有了定时器，则先干掉它
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTicker)
        self.loadingTicker =nil
    end
    if delayLoad == nil  then
        delayLoad = true 
    end  
    if delayLoad then 
        if self.list[1] then 
            local boo = self:checkInCache(self.list[1])
            if boo then 
                delayLoad = false
            end 
        end 
    end 
    if delayLoad then 
        local function delayCom()
            self:loadNext(false)
        end
        
        self.loadingTicker = cc.Director:getInstance():getScheduler():scheduleScriptFunc(delayCom,0.01,false)
        --self.loadingTicker =performWithDelay(self,delaycom,0.01)
        return 
    end 

    if self.list[1] == nil then 
        local tmp = self.allCompletedCallBack;
        local tmp2 = self.realLoad
        self:reset()
        if tmp then 
            tmp(tmp2)
        end 
        table.remove(globalLoadingManagerQueue,1)
        self:globalQueueNext()
        return 
    end 
    self.loading = true
    if self.progressCallBack then 
        self.progressCallBack(self:getProgress())
    end 

    local loadingItem = self.list[1]
    table.remove(self.list,1)
    self.curLoadingItem = loadingItem
    self.tryTime = 0 
    local p = loadingItem:getPath()
    local path,pLPath = GameGlobal:getResourceManager():getTypeByPath(p)
    local function tryLoad()
        cc.Director:getInstance():getTextureCache():unbindImageAsync(path);
        self.tryTime = self.tryTime + 1 
        if self.tryTime > self.maxTryTimes then 
            if self.loadingTicker then 
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.loadingTicker)
                self.loadingTicker = nil 
            end 
            self:loadNext()
            return 
        end 
        if loadingItem.type == Const_LoadingItemType.SPR then
            self:loadSprite()
        elseif loadingItem.type == Const_LoadingItemType.MP3 then 
            self:loadMp3()
        elseif loadingItem.type == Const_LoadingItemType.PNG or loadingItem.type == Const_LoadingItemType.JPG then 
            self:loadPng()
        elseif loadingItem.type == Const_LoadingItemType.PNL then 
            self:loadPnl()
        end 
    end

    self.loadingTicker = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tryLoad,4,false)
    tryLoad()
end


function LoadingManager:loadPnl()
    local path = self.curLoadingItem.path
    local bFlag = false
    if path == "ui/common/common.pnl"then 
        bFlag = true
    end 
    if device.platform == cc.PLATFORM_OS_ANDROID then 
        if bFlag == true then 
            self:loadPnlForWindows()
        else
            self:loadPnlForWondiws()
        end 
    elseif device.platform == cc.PLATFORM_OS_IPHONE or device.platform == cc.PLATFORM_OS_IPAD then 
        if bFlag == true then 
            self:loadPnlForWindows()
        else
            self:loadPnlForAndroid()
        end 
    else
        self:loadPnlForWindows()
    end 
end


function LoadingManager:loadPnlForWindows()
    local path = self.curLoadingItem.path 
    local completedCallBack = self.curLoadingItem.completedCallBack
    local arg = self.curLoadingItem.arg
    local tmp  = StringUtil:split(path,".")
    local pngPath = tmp[1] .. ".png"
    local plistPath = tmp[1] .. ".plist"
    local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(pngPath)
    GameGlobal:getResourceManager():addTextureCacheList(GameGlobal:getResourceManager():getCurScene(),pngPath)
    GameGlobal:getResourceManager():addTextureCacheList(GameGlobal:getResourceManager():getCurScene(),plistPath)
    local function dispatchCompletedAndLoadNext(delay)
        if delay == nil  then 
            delay = true
        end 
        if completedCallBack ~= nil then 
            completedCallBack(arg)
        end 
        self:loadNext(delay)
    end;

    if texture then 
        dispatchCompletedAndLoadNext(false)
        return 
    end 
    self.realLoad = true
    cc.Director:getInstance():getTextureCache():addImageAsync(pngPath,function (texture)
        local plistPath = tmp[1] .. ".plist"
        if not GameGlobal:checkFileExist(plistPath) then 
            self:loadNext(false)
            return 
        end 
        cc.SpriteFrameCache:getInstance():addSpriteFrames(plistPath,texture)
    end)

end


function LoadingManager:getProgress()
    if self.maxItemWhenStartLoad == 0 then return 100 end 
    local per = 1 - (table.maxn(self.list) / self.maxItemWhenStartLoad)
    if per < 0 then per = 0 end 
    if per > 100 then per = 100 end 
    return string.format("%.2f",per)
end

function LoadingManager:reset(resetGlobalLoadingToo)
    self.list = {}
    self.allCompletedCallBack = nil
    self.progressCallBack = nil 
    self.loading = false
    self.realLoad = false
    if resetGlobalLoadingToo then 
        globalLoadingManagerQueue = {}
    end 
end

function LoadingManager:globalQueueNext()
    local foundOne = globalLoadingManagerQueue[1];
    if foundOne then
  
        foundOne:startLoad(foundOne.progressCallBack, foundOne.allCompletedCallBack);           
        return;
    end
    --已经没有在全局加载的东西了
    self:reset(true);
end

function LoadingManager:checkInCache(loadingItem)
    local p = loadingItem:getPath() -- 获取path
    local path,pLPath = GameGlobal:getResourceManager():getTypeByPath(p)
    if loadingItem.type == Const_LoadingItemType.SPR then 
        local id = loadingItem.id
        local data = Config_SpriteData[tonumber(id)]
        if not data then  --如果是nil 则设置为默认的
            data = Config_SpriteData:getDefaultAction(id)
        end 
        local modelName = data.modelName
        local path = "spriteTexture/" .. modelName .. ".png"
        if cc.AnimationCache:getInstance():getAnimation(modelName .. "_" .. Const_Action.IDLE .. "_" ..Const_Dir.DOWNRIGHT) then 
            return true
        end 
        return false
    elseif loadingItem.type == Const_LoadingItemType.MP3 then 
        return false
    elseif loadingItem.type == Const_LoadingItemType.PNG or loadingItem.type == Const_LoadingItemType.JPG then 
        local path = self.curLoadingItem.path 
        local tmp = StringUtil:split(path,".")
        local pngPath = tmp[1] .. ".png"
        if cc.Director:getInstance():getTextureCache():getTextureForKey(path) then 
            return true
        end 
    elseif loadingItem.type == Const_LoadingItemType.PNL then 
        local path = loadingItem.path
        local tmp = StringUtil:split(path,".")
        local pngPath = tmp[1] .. ".png"
        local rst = cc.Director:getInstance():getTextureCache():getTextureForKey(pngPath)
        if cc.Director:getInstance():getTextureCache():getTextureForKey(pngPath) then 
            return true
        end     
    end 
    return false
end

function LoadingManager:addPnl(pngPath,completedCallBack,...)
    local args = {...}
    local loadingItem = require("app.control.LoadingItem"):create(Const_LoadingItemType.PNL,pngPath,completedCallBack,args)
    table.insert(self.list,table.maxn(self.list)+1 ,loadingItem)
end

return LoadingManager