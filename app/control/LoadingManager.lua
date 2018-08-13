--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.globalLoadingManagerQueue = cc.exports.globalLoadingManagerQueue or {}
local LoadingManager = class("LoadingManager")
function LoadingManager:ctor()
    self.list = {}
end

return LoadingManager