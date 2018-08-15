--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.UIManager = cc.exports.UIManager or  {}
--[[
    从目前的状态来看这个是清除/重置ui
]]
--局部变量
local private = {}
UIManager.connectingCache = nil 
UIManager.connectingCacheLogic = nil 
function UIManager:reset()
     private.list = {}--列表
     private.logicList = {}--logic列表
     private.scaleResList = {}
     private.needToRemoveUINames ={}
     private.queue = {}
     private.inUserRes = {}
     private.loading = false
     if UIManager.connectingCache then 
        UIManager.connectingCache = nil 
     end 
     UIManager.connectingCacheLogic = nil 
     if UIManager.nodeCache ~= nil  then 
        for k, v in pairs(UIManager.nodeCache) do
            v:release()
        end
     end 
     UIManager.nodeCache = nil 
end

function private:loadNext()
    if table.maxn(private.queue) == 0 then
        if GameGlobal:checkObjectIsNull(UIManager.loadingNode) then 
            UIManager.loadingNode:removeFromParent()
        end  
        UIManager.loadingNode = nil 
        return 
    end 

    local curItem = private.queue[1]
    table.remove(private.queue,1)
    UIManager:addUI(curItem)
end

function UIManager:addUI(param,...)
    if type(param) ~= "table" then 
        local layer = param 
        local args = {...}
        param = {
            layer = layer, 
            uiName = args[1],
            res = args[2],
            params = args[3] , 
            callBack = args[4], 
            showLoadingUI = args[5], 
            zorder = args[6], 
            needReload = args[7], 
            trigger = args[8]
        }
        local params = param
    end 
    local layer = param.layer
    local uiName = param.uiName
    local res = param.res
    local logicParam = nil 
    if param.params then 
        logicParam = param.params
    elseif param.logicParam then 
        logicParam = param.params
    end 
    local backFun = param.callBack
    local showLoadingUI = param.showLoadingUI 
    local zorder = param.zorder
    local needReload = param.needReload
    local settleNode = param.settleNode   -- 这个目前还不知道是做什么用的
    local trigger = param.trigger
    if not uiName then 
        Logger:throwError("uiName 为空，请查看堆栈")
    end 

  
    if uiName == Config_UI.CONNECTING.name then 
        --如果connectingCache 不为空， 则把connectingCache做处理
        if not GameGlobal:checkObjectIsNull(UIManager.connectingCache) then 
            Logger:out("就要移除："..uiName)
            UIManager.connectingCache:removeFromParent()
            UIManager.connectingCache = nil 
        end 
        if UIManager.connectingCacheLogic then 
            UIManager.connectingCacheLogic:dispose() -- 如果已经存在了logic则删除掉
            UIManager.connectingCacheLogic = nil 
        end 

        UIManager.connectingCache = UIManager:getNodeFromLua(Config_UI.CONNECTING.view)
        UIManager.connectingCache:setName(Config_UI.CONNECTING.name)
        
        local scene = cc.Director:getInstance():getRunningScene()
        scene:addChild(UIManager.connectingCache)
        local logic = require("app.uiLogic."..Config_UI.CONNECTING.name)
        UIManager.connectingCache:setPosition(UIManager.rightShiftPx,UIManager.upperShiftPy)
        UIManager.connectingCacheLogic = logic:create(UIManager.connectingCache,nil)

        return     
    end 

    local function cb()

    end
     
    --如果正在切换场景，则先放到cache 然后再加载
    if GameGlobal.repalcingScene then 
        if not  UIManager.switchingSceneAddUIQueue then 
            UIManager.switchingSceneAddUIQueue = {}
        end 
        table.insert(UIManager.switchingSceneAddUIQueue,{layer = layer,uiName = uiName,res = res,logicParam = logicParam,backFun = backFun,showLoadingUI=showLoadingUI,zorder = zorder,needReload = needReload})
        --等到switchingSceneAddUIQueue没有，再去
        local function continueLoad(args)
            EventManager:removeEvent(UIManager,GameGlobal,require("app.event.GameGlobalEvent").SWITCHSCENECOMPLETED)
            if not UIManager.switchingSceneAddUIQueue or #UIManager.switchingSceneAddUIQueue then return end 
            for i = 1, #UIManager.switchingSceneAddUIQueue do
                local tmp = UIManager.switchingSceneAddUIQueue[i]
                UIManager:addUI(tmp)
            end
            UIManager.switchingSceneAddUIQueue = nil 
        end

        EventManager:addEvent(UIManager,GameGlobal,require("app.event.GameGlobalEvent"),continueLoad)
        return 
    end 
    if GameGlobal.ActivityProxy.showingNewIcon then 
        table.insert(GameGlobal.ActivityProxy.addNewUI,param)
        return 
    end 

    if Config_UI[uiName] and Config_UI[uiName].showLoading then 
        showLoadingUI = Config_UI[uiName].showLoading
    end 

    if private.loading then 
        local temp = param
        table.insert(private.queue,temp)    
        return 
    end 
    
--    if not showLoadingUI then showLoadingUI = false end 
--    if not layer or Config_UI.LOADING.name then 
--        private.loading = false
--        private:loadNext()
--        return 
--    end

    if not private.logicList[layer] then 
        private.logicList[layer] = {}
    end
    private.needToRemoveUINames[uiName] = nil 
    if private.loadingManager then
        private.loadingManager:dispose()
        private.loadingManager = nil  
    end        
    private.loadingManager = require("app.control.LoadingManager"):create()
    local uiConfig = Config_UI[uiName]
    if private.list[layer] and private.list[layer][uiName] then 
        if needReload == 1 then 
            UIManager:removeUI(layer,uiName,nil,true)
        end 
    end  

    local function doCreate()
        
    end;

    local function progressCallBack()

    end;
    local function allCompletedCallBack()

    end;

    private.loading = true 
    private.loadingManager:startLoad(progressCallBack,allCompletedCallBack )

end


function UIManager:removeUI(layer,uiName,DoNotRemoveChild,noAction)
    if not  private.list then return end 
    if not layer then 
        for k,v in  pairs(private.list) do 
            for o,p in pairs(v) do 
                if o == uiName then 
                   layer = k 
                   break 
                end 
            end 
            if layer then break end 
        end 
        if not layer then 
            Logger:out("找不到"..uiName.."的layer")
        end 
    end 
end



--[[
    从lua中获取node
]]
function UIManager:getNodeFromLua(path)
    if not GameGlobal:checkFileExist(path) then 
        return nil   -- 当前没有这个文件
    end 
    local node  = require(path):create()
    MultiVersionUIHelper:checkLuaView(path,node)
    return node
end

return UIManager