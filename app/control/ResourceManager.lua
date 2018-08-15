--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.ResourceManager = cc.exports.ResourceManager or {}
ResourceManager.curTextureCacheList = {}
ResourceManager.curFrameCacheList = {}
ResourceManager.curAnimationCacheList = {}
ResourceManager.curScene = nil
ResourceManager.delConstInMamory = false
ResourceManager.spineCache = {}
ResourceManager.animationFrameCache = {}
ResourceManager.resourceType = {
    TYPE_TEXTURECACHE = 1,
    TYPE_FRAMECACHE = 2, 
    TYPE_ANIMATIONCACHE = 3
}
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
    if not ResourceManager.curTextureCacheList[sceneName] then 
        ResourceManager.curTextureCacheList[sceneName] = {}
    end 
    ResourceManager.curTextureCacheList[sceneName][texName] = texName
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
    local sceneNameData = ResourceManager.curFrameCacheList[sceneName]
    local s = ResourceManager.curTextureCacheList[sceneName]
    if sceneNameData then 
        if texplist and texplist ~= "" then 
--            local ishas = self:isfindCurSceneFoundForTex(texplist,1)
            
            --如果当前有需要删除的，如果有，并且也在当前的场景，就把他删除掉。
          
            local ishas = ResourceManager:isfindCurSceneFoundForTex(texplist,ResourceManager.resourceType.TYPE_FRAMECACHE)
            if ishas and sceneName ~= ResourceManager.curScene then 
                ResourceManager.curFrameCacheList[ResourceManager.curScene][texplist] = texplist
            else 
                if ResourceManager:isConstInMemory(texplist) then 
                    return 
                end 
                cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(texplist)
            end 
            ResourceManager.curFrameCacheList[sceneName][texplist] = nil 
        else 
            for k,v in pairs(sceneNameData) do 
                local ishas = ResourceManager:isfindCurSceneFoundForTex(v,ResourceManager.resourceType.TYPE_FRAMECACHE)
                if ishas then 
                    ResourceManager.curFrameCacheList[ResourceManager.curScene][v] = v
                    ResourceManager.curFrameCacheList[sceneName] = nil 
                end 
                if ishas == false and v and not ResourceManager:isConstInMemory(v) then 
                    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(v)
                    ResourceManager.curFrameCacheList[sceneName][v] = nil 
                end 
            end 
        end 
    end  
end


function ResourceManager:removeTexFromTextureCacheList(sceneName,texName)
     local sceneNameData = ResourceManager.curTextureCacheList[sceneName]
     if sceneNameData then 
        if texName and string.len(texName) > 0 then 
            local ishas = ResourceManager:isfindCurSceneFoundForTex(texName,ResourceManager.resourceType.TYPE_TEXTURECACHE)
            if ishas and sceneName ~= ResourceManager.curScene then 
                ResourceManager.curTextureCacheList[ResourceManager.curScene][texName]  = texName
            else 
                if ResourceManager:isConstInMemory(texName) then 
                    return 
                end     
                local txN,pvrPath = ResourceManager:getSuffixByPlatform(texName)
                cc.Director:getInstance():getTextureCache():removeTextureForKey(texName)
                cc.Director:getInstance():getTextureCache():removeTextureForKey(pvrPath)
            end
            ResourceManager.curTextureCacheList[sceneName][texName] = nil 
        else 
         for k,v in pairs(sceneNameData) do 
             local  ishas = ResourceManager:isfindCurSceneFoundForTex(v,ResourceManager.resourceType.TYPE_TEXTURECACHE)
 
             if ishas then ---有 
                        
                 ResourceManager.curTextureCacheList[ResourceManager.curScene][v] = v
                 ResourceManager.curTextureCacheList[sceneName][v] = nil
             end

             if   ishas == false and v and not ResourceManager:isConstInMemory( v ) then--and cc.Director:getInstance )
                  local txN,pvrPath = ResourceManager:getSuffixByPlatform( v )
                  cc.Director:getInstance():getTextureCache():removeTextureForKey(v ); 
                  cc.Director:getInstance():getTextureCache():removeTextureForKey(pvrPath ); 
                  ResourceManager.curTextureCacheList[sceneName][v] = nil
             end
          end
         end         
     end 
end

function ResourceManager:getSuffixByPlatform(texName)
    if not texName then 
        return 
    end 
    local path = nil 
    local tmp = StringUtil:split(texName)

    if device.platform == cc.PLATFORM_OS_ANDROID then
        path = tmp[1] ..".pkm"
    elseif device.platform == cc.PLATFORM_OS_IPAD or device.platform == cc.PLATFORM_OS_IPHONE then 
        path = tmp[1] .. ".pvr.czz"
    else 
        path = texName
    end 
    return texName,path
end

function ResourceManager:purgeCacheDataUseEngine(cacheinfo,sceneName)   
    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end


function ResourceManager:isfindCurSceneFoundForTex(texName,type)
    local tp = nil 
    if type == ResourceManager.resourceType.TYPE_TEXTURECACHE then

        tp = ResourceManager.curTextureCacheList[ResourceManager.curScene]

    elseif type == ResourceManager.resourceType.TYPE_TEXTURECACHE then 

        tp = ResourceManager.curFrameCacheList[ResourceManager.curScene]

    elseif type == ResourceManager.resourceType.TYPE_ANIMATIONCACHE then 

        tp = ResourceManager.curAnimationCacheList[ResourceManager.curScene]

    else 
        Logger:out("resourceManager")
    end 

    if tp and tp[texName] then 
        return true
    end 
    return false
end
return cc.exports.ResourceManager