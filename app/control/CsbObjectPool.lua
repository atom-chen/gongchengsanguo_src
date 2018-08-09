--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion




if cc.exports.CsbObjectPool then
    --不重新生成
else
   cc.exports.CsbObjectPool = cc.exports.CsbObjectPool or {}
    CsbObjectPool.pool = {}; 
    CsbObjectPool.nums = {};--存着某路径的对象数
    CsbObjectPool.inited = false;
end


function CsbObjectPool:init()
    --避免重新进登录界面，会重新init();------------------
    if CsbObjectPool.tempParentNotNil ~= nil then
        --全部扔回对象池        
        for k,v in pairs(CsbObjectPool.tempParentNotNil) do
            CsbObjectPool:addToPool(k.addToPoolPath, k, true);            
        end
    end
    CsbObjectPool.tempParentNotNil = {};--key是对象。想放入对象池，但是parent不为nil，临时存起来，下一帧再来检查。
    if CsbObjectPool.ticker ~= nil then
        scheduler.unscheduleGlobal(CsbObjectPool.ticker);
        CsbObjectPool.ticker = nil;
    end
    if CsbObjectPool.inited then return end; 
    ---------------------------------------------
    local nodeCache = {};
    local function generate(path, name, nodeType)
        local tar = nodeCache[path];
        if tar == nil then          
            tar = UIManager:getNodeFromLua(path);
            --tar = UIManager:replaceNodeWithWidget(tar);
            tar:retain();
            nodeCache[path] = tar;
        end
        local cc = tar:clone();
        cc:setName(name);
        cc:retain();             
        cc.fromPool = true;
        cc._NODETYPE = nodeType
        CsbObjectPool:addToPool(path, cc, true);
        return cc;
    end     
    --想要把何种csb放入对象池，则在此处放入
    for i = 1, 100 do
        generate("ui/common/Icon.lua", "ObjPoolIcon_" .. i, "ICON");        
    end
	
    --for i = 1, 50 do
    --     generate("ui/common/CharHeadNode2.lua", "ObjPoolCharHeadNode2_" .. i, "CHARNODE")
    --end
	
	--local texture = cc.Director:getInstance():getTextureCache():addImage("ui/artText/artText.png")
    --cc.SpriteFrameCache:getInstance():addSpriteFrames("ui/artText/artText.plist", texture)
		--
	for i = 0,29 do
		local path = "artText_uiNum"..i..".png"
		if cc.SpriteFrameCache:getInstance():getSpriteFrame(path) then
			for j = 1,30 do
				local img = ccui.ImageView:create()
				img:loadTexture(path, ccui.TextureResType.plistType)
				img:retain()
				img.fromPool = true
				img._NODETYPE = path
				img:registerScriptHandler(function(event)
					if "cleanup" == event then
						CsbObjectPool:addToPool(path, img,true)
					end
					if "enter" == event then
						CsbObjectPool:getFromPool(path, img);
					end
				end)
				CsbObjectPool:addToPool(path, img, true)
			end
		end
	end
	--]]
--    for i = 1, 30 do
--        generate("ui/battle/HeadInfo.lua", "HeadInfo_" .. i)    
--    end 
    --删除临时的
    for k, v in pairs(nodeCache) do
       v:release();       
    end
    nodeCache = nil;
    CsbObjectPool.inited = true;
end
function CsbObjectPool:nextFramCheck()
    local function cb()
        local arr = {};
        local left = 0;
        local count = 0;
        if CsbObjectPool.tempParentNotNil ~= nil then
            for k,v in pairs(CsbObjectPool.tempParentNotNil) do
                left = left + 1;
                count =  k:getReferenceCount();
                if k:getParent() == nil then
                    if count > 1 then
                        Logger:out("parent为nil了，但计数还是大于1，为:" .. count .. "，证明被retain过，不回收")
                        left = left - 1; 
                    else
                        table.insert(arr, k)--这下可以回收了
                    end
                else                  
                    --if count > 3 then                        
                    --    Logger:out("parent不为空，计数大于3，为:" .. count .. "，证明被retain过，不回收")
                    --    left = left - 1; 
                    --else                        
                    --end;
                    --下一帧了，parent还在，则证明还在显示中，不处理
                    left = left - 1;
                end 
            end
            Logger:out("CsbObjectPool nextFramCheck arr length:" .. #arr)
            for i = 1,#arr do
                CsbObjectPool:addToPool(arr[i].addToPoolPath, arr[i], true);
                CsbObjectPool.tempParentNotNil[arr[i]] = nil;
            end
        end
        --无临时的了，删计时器
        if left == 0 then
            if CsbObjectPool.ticker ~= nil then
                scheduler.unscheduleGlobal(CsbObjectPool.ticker);
                CsbObjectPool.ticker = nil;
            end
        end
    end    
    if CsbObjectPool.ticker == nil then
        CsbObjectPool.ticker = scheduler.scheduleGlobal(cb, 0.1);
    end
end
--参数：路径、对象
function CsbObjectPool:addToPool(path, tar, atOnce)       
    --检查一下是否是从库里出来的，如果不是，就不要回收；如果引用次数不为2也不要回收（因为有别的逻辑retain了，不能回收）
    if tar.fromPool ~= true then return end;        
    --父节点不为空，下一帧再检查
--    if tar:getParent() ~= nil then                
--        tar.addToPoolPath = path;
--        if CsbObjectPool.tempParentNotNil == nil then CsbObjectPool.tempParentNotNil = {}; end
--        CsbObjectPool.tempParentNotNil[tar] = 1;
--        CsbObjectPool:nextFramCheck();
--        return
--    else      
--        local count = tar:getReferenceCount();
--        if count > 1 then
--            Logger:out("parent为空，且引用计数大于1，为" .. count .. "，证明被retain过，不回收此对象！".. tar:getName());
--            return 
--        end
--    end
    --下一帧再处理
    if not atOnce then
        tar.addToPoolPath = path;
        if CsbObjectPool.tempParentNotNil == nil then CsbObjectPool.tempParentNotNil = {}; end
        CsbObjectPool.tempParentNotNil[tar] = 1;
        CsbObjectPool:nextFramCheck();
        return
    end
    --如果这个对象的getParent()不为空，则下一帧再回收
    if CsbObjectPool.pool[path] == nil then
        CsbObjectPool.pool[path] = {};
    end    
    --把其属性还原
    tar:stopAllActions();
    tar:setScale(1);
    tar:setRotation(0); 
    tar:setOpacity(255);
    tar:setOpacity(255);
    tar:setColor(cc.c4f(255,255,255,255));
    tar:setVisible(true);
    tar:setPosition(0,0);
	if tar.setGLProgramState then
		tar:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
	end
	Logger:out("存入对象池：" .. tar:getName())
    if tar._NODETYPE == nil then
        Logger:throwError("回收的CsbObjectPool的type是空")
    else
        if tar._NODETYPE == "ICON" then
            if tar:getChildByName("selected") == nil then
                Logger:throwError("回收的CsbObjectPool的ICON异常")
            end
        end
    end
    --table.insert(CsbObjectPool.pool[path], tar);
    CsbObjectPool.pool[path][tar] = 1;
    if CsbObjectPool.nums[path]  == nil then
        CsbObjectPool.nums[path] = 1;
    else
        CsbObjectPool.nums[path] = CsbObjectPool.nums[path] + 1;
    end
    Logger:out("存放后，当前池子中:" .. path .. " 对象数为：" .. CsbObjectPool.nums[path])
end
function CsbObjectPool:getFromPool(path, tar)
    if  CsbObjectPool.tempParentNotNil ~= nil and CsbObjectPool.tempParentNotNil[tar] == 1 then
        Logger:out("对象池的tempParentNotNil有此对象，直接返回此对象：" ..  path);
        CsbObjectPool.tempParentNotNil[tar] = nil;
        return tar; 
    end      
    if CsbObjectPool.pool[path] == nil then      
        Logger:out("对象池里没有此路径：" ..  path);
        return nil;
    end
    local tmp;
    if tar ~= nil then
        tmp = tar;
    else
        for k,v in pairs(CsbObjectPool.pool[path]) do
            tmp = k;
            if CsbObjectPool.nums[path]  ~= nil then
                CsbObjectPool.nums[path] = CsbObjectPool.nums[path] - 1;
                Logger:out("取出后，当前池子中:" .. path .. " 对象数为：" .. CsbObjectPool.nums[path])
            end 
            break;
        end
    end    
    if tmp ~= nil then
        if tar ~= nil then
            Logger:out("指定从对象池里取出：" .. tmp:getName())
        else
            Logger:out("从对象池里取出：" .. tmp:getName())
        end    
        CsbObjectPool.pool[path][tmp] = nil;        
    else
        Logger:out("此路径池子里空了！没得取：" .. path )        
    end         
    return tmp;
end
function CsbObjectPool:cleanPool(path)
    local map = CsbObjectPool.pool[path]
    CsbObjectPool.pool[path] = nil
    for k,v in pairs(map) do
        assert(1 == k:getReferenceCount())
        if k:getParent() then
            k:removeFromParent()
        else
            k:release()
        end
    end
end
function CsbObjectPool:cleanArtTextPool()
    for k,v in pairs(CsbObjectPool.pool) do
        if string.find(k,"artText_") then
            CsbObjectPool:cleanPool(k)
        end
    end
end
return CsbObjectPool;
