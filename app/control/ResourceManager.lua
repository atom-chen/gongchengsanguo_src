--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.ResourceManager = cc.exports.ResourceManager or {}
ResourceManager.curTextureCacheList = {}
ResourceManager.curAnimationCacheList = {}
ResourceManager.curScene = nil
ResourceManager.delConstInMamory = false
ResourceManager.spineCache = {}
ResourceManager.animationFrameCache = {}
ResourceManager.sceneNametbl = {
    NONSCENE = "NONSCENE",
    LOGOSCENE = "LOGOSCENE",
    LOGINSCENE = "LOGINSCENE",
    HOMEUISCENE = "HOMEUISCENE",
    MAINSCENE = "MAINSCENE",
    BATTLESCENE = "BATTLESCENE",
    FACTIONWARSCENE = "FACTIONWARSCENE",
    WORLDMAPSCENE = "WORLDMAPSCENE",
    VIDOESCENE = "VIDOESCENE",
    KUFUSCENE = "KUFUSCENE"
}

ResourceManager.ConstResTblMemory = {
    
        "ui/common/common.png",
        "ui/common/common.plist",
        "ui/common2/common2.png",
        "ui/common2/common2.plist",
        "ui/artText/artText.png",
        "ui/artText/artText.plist",
        "ui/home/home.png",
        "ui/home/home.plist",
        "ui/icons/icons.png",
        "ui/icons/icons.plist",
        
        "ui/loading/loading.png",
        "ui/loading/loading.plist",
}
ResourceManager.ConstTextTblInMemory ={
        "ui/common/common.png",
        "ui/common/common2.png",
        "ui/artText/artText.png",
        "ui/home/home.png",
        "ui/loading/loading.png",
        "ui/icons/icons.png",
}

function ResourceManager:setCurScene(sceneName)
    self.curScene = sceneName
end

function ResourceManager:getCurScene()
    return self.curScene
end

function ResourceManager:isConstInMemory(textOrlist)    
    if ResourceManager.delConstInMamory then 
        return false 
    end
    if textOrlist or textOrlist ~= ""  then 
        return true
    end 
    return false
end


return cc.exports.ResourceManager