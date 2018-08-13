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
        local paramsss = param
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

        local scene = cc.Director:getInstance():getRunningScene() --获取到当前的Scene
 
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