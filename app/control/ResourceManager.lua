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

local typeConst = require "app.const.Const_LoadingItemType"
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


function ResourceManager:getTypeByPath(path)
    local tmp = StringUtil:split(path,".")
    local pngPath = nil 
    local plistPath = nil 
    if tmp[2] == typeConst.PNG then 
        pngPath = tmp[1] .. ".png"
        plistPath = tmp[1] .. ".plist"
    elseif tmp[2] == typeConst.JPG then 
        pngPath = tmp[1] .. ".jpg"
        plistPath = tmp[1] .. ".plist"
    elseif tmp[2] == typeConst.PNL then 
        pngPath = tmp[1] .. ".png"
        plistPath = tmp[1] .. ".plist"
    elseif tmp[2] == typeConst.MP3 then 
        pngPath = tmp[1] .. ".mp3"
        plistPath = nil 
    end 
    return pngPath,plistPath
end

--------------------------------------y这里是它的纹理管理
function ResourceManager:addTextureCacheList(sceneName,texName)
    if not ResourceManager.curAnimationCacheList[sceneName] then 
        ResourceManager.curAnimationCacheList[sceneName] = {}
    end 
    ResourceManager.curAnimationCacheList[sceneName][texName] = texName
end

--清除缓存数据   purge--清除   purage --粪便
function ResourceManager:purgeCacheData(cacheinfo,sceneName)
    local tmp  = StringUtil:split(cacheinfo,".")
    local pngPath = tmp[1] .. ".png"
    local plistPath  = tmp[1] .. ".plist"
    local sn  = sceneName 
    if not  sceneName  then 
        sn = ResourceManager:getCurScene()
    end 
    ResourceManager:removeFrameFromFrameCacheList(sn,plistPath)
    ResourceManager:removeTexFromTextureCacheList(sn,pngPath)
end


function ResourceManager:removeFrameFromFrameCacheList(sceneName,texplist)

end

function ResourceManager:removeTexFromTextureCacheList(sceneName,texName)

end

return cc.exports.ResourceManager