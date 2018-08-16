UIManager = {}
require("app.utils.StringUtil");
require("app.utils.TableUtil");
require("app.control.CsbObjectPool");
if Config_Sys.isClientKeyBack then
	CLIENT_VIEW_ARRAY = {}
end
--这是创建私有方法的办法。将方法放在私有表中，外部就访问不了了
local private = {};
UIManager.designSize = {width=1366, height=768};
UIManager.ActualDesignSize = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize();
--采用fixHeight策略时，x方向右方必定有空白，所有元素统一右移，使得整个画面居中
UIManager.rightShiftPx = (cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width - UIManager.designSize.width)/2;
--采用width策略时，Y方向上方必定有空白，所有元素统一上移，使得整个画面居中
UIManager.upperShiftPy = (cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height - UIManager.designSize.height)/2;
--设计分辨率的屏幕重心点坐标
UIManager.CenterX = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width/2;
UIManager.CenterY = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height/2;

UIManager.frameSize = cc.Director:getInstance():getOpenGLView():getFrameSize();
--在设计分辨率上的放缩
UIManager.scaleX = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width / UIManager.designSize.width;
UIManager.scaleY = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height / UIManager.designSize.height;
if cc.Director:getInstance():getOpenGLView():getResolutionPolicy() == cc.ResolutionPolicy.FIXED_HEIGHT then 
    UIManager.scale = UIManager.ActualDesignSize.height / UIManager.designSize.height;
else 
    UIManager.scale = UIManager.ActualDesignSize.width / UIManager.designSize.width;
end
UIManager.nodeCache = nil;
UIManager.connectingCache = nil;
UIManager.connectingCacheLogic = nil;
UIManager.loadingTicker = nil; 
UIManager.newBieMask = nil;
UIManager.loadingNode = nil;
UIManager.currentRemoveView = nil;
UIManager.openedUI = {};
--判断一个点击点是否击中节点
function UIManager:__isContainsTouchPos(node,touch ,touch_size, touch_AnchorPoint)
    touch_size = touch_size or cc.size(node:getContentSize().width,node:getContentSize().height)

    local location = touch:getLocation()
    local locationInNode = node:convertToNodeSpace(location)
    local nodeSize = node:getContentSize();    
    local node_rect = cc.rect(nodeSize.width * touch_AnchorPoint.x -touch_size.width * touch_AnchorPoint.x, nodeSize.height *touch_AnchorPoint.y - touch_size.height*touch_AnchorPoint.y,touch_size.width,touch_size.height)
    return cc.rectContainsPoint(node_rect, locationInNode)
end

function UIManager:removeWidgetTouchExtent(widget)
    --是widget，删除点击事件
   if widget.setLayoutParameter then 
      widget:setTouchEnabled(false);
      widget.widgetTouchExtentInfo = nil;
	  if NEWBIEWIDGET and NEWBIEWIDGET.widget == widget then NEWBIEWIDGET = nil end
   end   
end

function UIManager:jointDamageValue(param)
    local node = cc.Node:create()
    node:setCascadeOpacityEnabled(true)
    local imgValue
    local imgText = ccui.ImageView:create()
    local imgSymbol = ccui.ImageView:create()
    -- 0 一般认为是伤害
    if param.value <= 0 then
        if param.isSkill == true then -- 技能
            imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigYellow, Config_GameData.artFonts.bigInterval)
            if param.isCri == true then -- 暴击
                imgText:loadTexture(Config_UIPath.battle.skillCri, ccui.TextureResType.plistType)
            end
            imgSymbol:loadTexture(Config_UIPath.battle.skillSub, ccui.TextureResType.plistType)
        else -- 普攻
            imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigRed, Config_GameData.artFonts.bigInterval)
            if param.isCri == true then
                imgText:loadTexture(Config_UIPath.battle.normalCri, ccui.TextureResType.plistType)
            end
            imgSymbol:loadTexture(Config_UIPath.battle.normalSub, ccui.TextureResType.plistType)
        end
    else -- 治疗
        imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigGreen, Config_GameData.artFonts.bigInterval)
        if param.isCri == true then
            imgText:loadTexture(Config_UIPath.battle.healCri, ccui.TextureResType.plistType)
        end
        imgSymbol:loadTexture(Config_UIPath.battle.healAdd, ccui.TextureResType.plistType)
    end
    local len = string.len(math.abs(param.value))
    imgValue:setContentSize(len*Config_GameData.artFonts.bigInterval, 0)
    node:addChild(imgValue)
    if param.isCri == true then
        node:addChild(imgText)
    end
    node:addChild(imgSymbol)
    local totalWidth = 0
    for k, v in pairs(node:getChildren()) do
        totalWidth = v:getContentSize().width + totalWidth
    end
    if param.isCri == true then
        imgText:setPositionX(-totalWidth/2 + imgText:getContentSize().width/2)
        imgSymbol:setPositionX(-totalWidth/2 + imgText:getContentSize().width + imgSymbol:getContentSize().width / 2)
    else
        imgSymbol:setPositionX(-totalWidth/2 + imgSymbol:getContentSize().width / 2)
    end
    local offset = 13
    imgValue:setPositionX(imgSymbol:getPositionX() + imgSymbol:getContentSize().width / 2 + offset + imgValue:getContentSize().width/2)
    -- imgText:setPosition(0,0)
    -- imgSymbol:setPosition(0,0)
    -- imgValue:setPosition(0,0)
    return node
end
function UIManager:getNodeFromLua(path)
    if not GameGlobal:checkFileExist(path) then
        return nil;
    end
    local node = require(path):create();
	MultiVersionUIHelper:checkLuaView(path,node)
    return node;
end
function UIManager:getResFromLua(path)   
    --自带的res
    local res = require(path):getRes();    
    local arr = {};
    local str = "";
    for i = 1,#res do
        str = "ui/" .. res[i] .. "/" .. res[i] .. ".pnl";
        table.insert(arr, str);
    end
    --额外node的res
    local nodes = require(path):getExtraNodes(); 
    for i = 1,#nodes do
        local tmp = self:getResFromLua(nodes[i]);
        TableUtil:combineTable(arr, tmp);
    end
    return arr; 
end
-- 参数格式及说明：
-- params = {
--     container, 创建的rect放在哪个view上
--     rect, cc.rect(x,y,width,height)
--     param, 包含fillColor,name参数，例param = {fillColor=cc.c4f(0,0,0,175),name="test"}
--     onTouchEndedCallBack, 点击结束的回调。格式可以是function，也可以是这样的table：{callBack=cb, param={}}
--     onTouchBeganCallBack, 点击开始的回调
--     onTouchMoveCallBack, 点住滑动时的回调
--     zorder, z值
--     name，此矩形的名称
--     swallowTouches 默认true
-- }
function UIManager:createRect(params,...)
    if type(params) ~= "table" then
       local container = params;
       local args = {...}
       params = {
            container = container,
            rect = args[1],
            param = args[2],
            onTouchEndedCallBack = args[3],
            onTouchBeganCallBack = args[4],
            onTouchMoveCallBack = args[5],
            zorder = args[6],
            name = args[7],
            swallowTouches = args[8]
       }
    end
    local container = params.container;
    local rect = params.rect;
    local param = params.param;
    local onTouchEndedCallBack = params.onTouchEndedCallBack;
    local onTouchBeganCallBack = params.onTouchBeganCallBack;
    local onTouchMoveCallBack = params.onTouchMoveCallBack;
    local zorder = params.zorder;
    local name = params.name;
    local swallowTouches = params.swallowTouches
    if type(onTouchEndedCallBack) == "function" then
        onTouchEndedCallBack = {callBack = onTouchEndedCallBack}
    end
    if type(onTouchBeganCallBack) == "function" then
        onTouchBeganCallBack = {callBack = onTouchBeganCallBack}
    end
    if type(onTouchMoveCallBack) == "function" then
        onTouchMoveCallBack = {callBack = onTouchMoveCallBack}
    end
    if zorder == nil then zorder = -9999; end 
    if name == nil then
        name = "BlockingRect"
    end
    local ret_layer = ccui.ImageView:create("singlePic/other/other_black.png", ccui.TextureResType.localType);  
	ret_layer:setScale9Enabled(true)
    ret_layer:setContentSize(cc.size(rect.width,rect.height))
    ret_layer:setPosition(rect.x, rect.y)
    ret_layer:setAnchorPoint(cc.p(0,0))
    ret_layer:setName(name)

    if param.fillColor ~= nil then
        ret_layer:setOpacity(param.fillColor.a)
    end
    ret_layer:setOpacity(param.fillColor.a)
    ret_layer:setColor(cc.c3b(param.fillColor.r, param.fillColor.g, param.fillColor.b))
    UIManager:resetPosition(ret_layer)

    ret_layer:setLocalZOrder(zorder);
    if container then
        container:addChild(ret_layer)
    end
    ret_layer:setSwallowTouches(swallowTouches);
    UIManager:widgetTouchExtent(ret_layer, onTouchEndedCallBack, {callBack = function()
            Logger:out("点到矩形层之内！Began " .. name )
            if onTouchBeganCallBack ~= nil then
                onTouchBeganCallBack.callBack()
            end
            return true
        end}, onTouchMoveCallBack);
    
        
    local function onLoadingNodeEvent(event)
        --退出的event有：exitTransitionStart（即将退出）、exit（退出完成）、cleanup（清理）
        if "exitTransitionStart" == event then                                               
            Logger:out("矩形被移除！name=" .. name)
        end
    end        
    ret_layer:registerScriptHandler(onLoadingNodeEvent)
    return ret_layer
end


function UIManager:moveFontAni(container, attrStr, fontSize, color, positionX, positionY, addX, addY, time, delay, frontIcon, iconGap,zorder)
    if delay == nil then delay = 0 end;
    ----属性字增加，往上飘动画
    local text = ccui.Text:create();
    text:setString(attrStr);
    text:setFontSize(fontSize);
    text:setLocalZOrder(100);
    text:setColor(color);
    text:setFontName("simhei.ttf")
    text:setPositionX(positionX);
    text:setPositionY(positionY);   
    if zorder then
        text:setLocalZOrder(zorder)  
    end  
    UIManager:fontStoke(text); 
    local tweenObj = text;
    if frontIcon ~= nil then
        text:setPositionX(0);
        text:setPositionY(0);
        text:setAnchorPoint(0, 0.5);
        local img = ccui.ImageView:create();
        container:addChild(img);
        img:addChild(text);
        text:setPositionX(iconGap * frontIcon:getScaleX());
        text:setPositionY(0);
        img:addChild(frontIcon);
        img:setPositionX(positionX);
        img:setPositionY(positionY);            
        frontIcon:setCascadeOpacityEnabled(true);
        img:setCascadeOpacityEnabled(true);
        if zorder then
            img:setLocalZOrder(zorder)
        end
        frontIcon:setPosition(0,0);
        tweenObj = img;
    else
        container:addChild(tweenObj);
    end    
    if delay > 0 then
        --有延迟
        tweenObj:setVisible(false);
    end
    local time1 = time * 0.7;
    local time2 = time - time1;
    local addX1 = addX * 0.7;
    local addX2 = addX - addX1;
    
    local addY1 = addY * 0.7;
    local addY2 = addY - addY1;
    tweenObj:setName("movefont");
    if delay == 0 then
        local action = cc.Spawn:create(cc.MoveBy:create(time1,{x=addX1,y=addY1}));
        local action2 = cc.Spawn:create(cc.MoveBy:create(time2,{x=addX2,y=addY2}), cc.FadeOut:create(time2));
        local actions = cc.Sequence:create(action,action2,cc.CallFunc:create(function() container:removeChild(tweenObj); end));
        tweenObj:runAction(actions);
    else
        local function cb()
            tweenObj:setVisible(true);
        end 
        local dAction = cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(cb));
        local action = cc.Spawn:create(cc.MoveBy:create(time1,{x=addX1,y=addY1}));
        local action2 = cc.Spawn:create(cc.MoveBy:create(time2,{x=addX2,y=addY2}), cc.FadeOut:create(time2));
        local actions = cc.Sequence:create(dAction,action,action2,cc.CallFunc:create(function() container:removeChild(tweenObj); end));
        tweenObj:runAction(actions);
    end
end
function private:loadNext()    
    if table.maxn(private.queue) == 0 then
         Logger:out("UIManager load next queue empty. retuened..")
        if not GameGlobal:checkObjIsNull(UIManager.loadingNode) then
            UIManager.loadingNode:removeFromParent();            
        end      
        UIManager.loadingNode = nil;
        return 
    end;
    local curItem = private.queue[1];
    table.remove(private.queue,1);
    Logger:out("UIManager load next:" .. curItem.uiName)
    UIManager:addUI(curItem)  
end
--如果不传layer，就会自动在所有layer里面寻找和name符合的ui，多个的话会返回数组，单个的话返回实际的view
function UIManager:getUIByName(layer, name)
    if name == require("data.manual.Config_UI").CONNECTING.name then
        local tmp = UIManager.connectingCache;
        if GameGlobal:checkObjIsNull(tmp) then
            return nil;
        end
        return  tmp
    end    
    if layer == nil then
        if private.list == nil then return end;
        local tab = {};
        for k,v in pairs(private.list) do
            for o,p in pairs(v) do 
                if o == name then
                    layer = k;
                    table.insert(tab,{layer = k, view = p});
                end
            end
        end  
        if table.maxn(tab) == 0 then return nil end;
        if table.maxn(tab) == 1 then return tab[1].view, tab[1].layer end;
        return tab; 
    else
        if private.list[layer] == nil then
            return nil;
        end    
    end
    return private.list[layer][name], layer;
end
--如果不传layer，就会自动在所有layer里面寻找和name符合的logic，多个的话会返回数组，单个的话返回实际的logic
function UIManager:getUILogicByName(layer, name)
    if name == require("data.manual.Config_UI").CONNECTING.name then
        local tmp = UIManager.connectingCache;
        if GameGlobal:checkObjIsNull(tmp) then
            return nil;
        end
        return  UIManager.connectingCacheLogic
    end    
    if private.logicList == nil then return end;
    if layer == nil then
        if private.logicList == nil then return end;
        local tab = {};
        for k,v in pairs(private.logicList) do
            for o,p in pairs(v) do 
                if o == name then
                    layer = k;
                    table.insert(tab,{layer = k, logic = p});
                end
            end
        end  
        if table.maxn(tab) == 0 then return nil end;
        if table.maxn(tab) == 1 then return tab[1].logic, tab[1].layer end;
        return tab; 
    else
        if private.logicList[layer] == nil then
            return nil;
        end          
    end    
    return private.logicList[layer][name], layer; 
end
function UIManager:reset()
    --清掉所有状态
    private.list = {}
    private.logicList = {};
    private.scaleResetList = {};
    private.needToRemoveUINames = {};
    private.queue = {};
    private.inUseRes = {};--key是UIName，value是资源数组
    private.loading = false;    
    if UIManager.connectingCache then
        --UIManager.connectingCache:release();
        UIManager.connectingCache = nil;
    end
    UIManager.connectingCacheLogic = nil;
    if UIManager.nodeCache ~= nil then
        for k,v in pairs(UIManager.nodeCache) do
            v:release();
        end
    end
    UIManager.nodeCache = {}; 
end

--参数格式及说明：
-- param = {
--     layer           想把该ui放在哪个layer里
--     uiName          data.manual.Config_UI中的UI的名称
--     res             除了data.manual.Config_UI中配置的res，还额外需要加载的资源。必须是数组。如：{11.png,22.mp3}
--     params          传给对应Logic的参数，如果没有logic，也可以填nil
--     callBack        加载完成后的回调。回调会回传此界面的logic。
--     showLoadingUI   是否显示loading
--     zorder          设置层深
--     needReload      如果界面已存在，如何处理。为1则先删除老的,重新加载；否则不处理，直接return
--     settleNode      已经加载好的node
--     trigger         需要从点击的按钮那个位置开始展开到中间 就设置trigger为点击的按钮
-- }


function UIManager:addUI(param,...)
    if type(param) ~= "table" then
        local layer = param;
        local args = {...}
        param = {
                layer = layer,
                uiName = args[1],
                res = args[2],
                params = args[3],
                callBack = args[4],
                showLoadingUI = args[5],
                zorder = args[6],
                needReload = args[7],
                trigger = args[8]
        }
    end
    local layer = param.layer;
    local uiName = param.uiName;
    local res = param.res;
    local logicParam = nil;
    if param.params then
        logicParam = param.params;
    elseif param.logicParam then
        logicParam = param.logicParam;
    end
    local backFun = param.callBack;
    local showLoadingUI = param.showLoadingUI;
    local zorder = param.zorder;
    local needReload = param.needReload;
    local settleNode = param.settleNode;
    local trigger = param.trigger;
    if uiName == nil then
        Logger:throwError("uiName为nil！请观察堆栈！")
        return
    end
    --如果是connectingUI，则直接处理
    if uiName == Config_UI.CONNECTING.name then
        --删掉老的
        --UIManager:removeUI(nil, require("data.manual.Config_UI").CONNECTING.name);  
        if not GameGlobal:checkObjIsNull(UIManager.connectingCache) then
            Logger:out("即将移除：" .. uiName);
            UIManager.connectingCache:removeFromParent();
            UIManager.connectingCache = nil;
        end
        if UIManager.connectingCacheLogic then UIManager.connectingCacheLogic:dispose() UIManager.connectingCacheLogic = nil end;
        UIManager.connectingCache = UIManager:getNodeFromLua(require("data.manual.Config_UI").CONNECTING.view);
        UIManager.connectingCache:setName(require("data.manual.Config_UI").CONNECTING.name)

        local scene = cc.Director:getInstance():getRunningScene();

        Logger:out ("显示UI:" .. uiName);
        scene:addChild(UIManager.connectingCache);     
        UIManager.connectingCache:setLocalZOrder(Config_GameData.lZorder.connecting);
        local logic = require("app.uiLogic." .. require("data.manual.Config_UI").CONNECTING.name);
        UIManager.connectingCache:setPosition(UIManager.rightShiftPx,UIManager.upperShiftPy);        
        UIManager.connectingCacheLogic = logic:create(UIManager.connectingCache, nil);
        Logger:out ("创建了ConnectingUI的logic:" .. uiName);
        
		-- local worldMap = UIManager:getUIByName(nil, Config_UI.WORLDMAPVIEW.name);
  --       local connectingUI = UIManager:getUIByName(nil, Config_UI.CONNECTING.name);
  --       if worldMap then
  --           Logger:out("WORLDMAP和CONNECTINGUI的Zorder:" .. worldMap:getLocalZOrder(), connectingUI:getLocalZOrder());
  --       end
  --       local children = cc.Director:getInstance():getRunningScene():getChildren();
  --       local s1 = "";
  --       local s2 = "";
  --       for i = 1, #children do
  --           if worldMap and children[i] == worldMap then
  --               s1 = i;
  --           end
  --           if children[i] == connectingUI then
  --               s2 = i;
  --           end
  --       end
  --       Logger:out("WORLDMAP和CONNECTINGUI的addChild顺序:" .. s1, s2);
        
		CLIENT_VIEW_ARRAY = CLIENT_VIEW_ARRAY or {}
		table.insert(CLIENT_VIEW_ARRAY,{uiName = uiName,logic = UIManager.connectingCacheLogic,view = UIManager.connectingCache,panel = scene})
        return;
    end

    if GameGlobal.repalcingScene then
        --正在切场景
        Logger:out("正在切场景，先把该UI放入队列，等场景切换完成后再继续：" .. uiName);
        if UIManager.switchingSceneAddUIQueue == nil then UIManager.switchingSceneAddUIQueue = {}; end;
        table.insert( UIManager.switchingSceneAddUIQueue, {layer = layer, uiName = uiName, res = res, logicParam = logicParam,
            backFun =  backFun,showLoadingUI =  showLoadingUI, zorder = zorder,needReload = needReload} )
        local function continueLoad()
            Logger:out("UIManger 监听到场景切换完成，开始添加场景切换时无法添加的UI：")
            EventManager:removeEvent(UIManager, GameGlobal, require("app.event.GameGlobalEvent").SWITCHSCENECOMPLETED);
            if UIManager.switchingSceneAddUIQueue == nil or #UIManager.switchingSceneAddUIQueue == 0 then return end;            
            for i = 1,#UIManager.switchingSceneAddUIQueue do
                local tmp = UIManager.switchingSceneAddUIQueue[i];
                UIManager:addUI(tmp);
            end
            UIManager.switchingSceneAddUIQueue = nil;
        end
        EventManager:addEvent(UIManager, GameGlobal, require("app.event.GameGlobalEvent").SWITCHSCENECOMPLETED, continueLoad);
        return
    end
    if GameGlobal.ActivityProxy.showingNewIcons == true then
        table.insert( GameGlobal.ActivityProxy.addNewUI, param)
        return;
    end    
    --如果配置表指定了showLoading的值，则根据此值来做决断
    if Config_UI[uiName] and Config_UI[uiName].showLoading ~= nil then
        showLoadingUI = require("data.manual.Config_UI")[uiName].showLoading;
    end 
    --UIManager正忙加载，放队列里
    if private.loading then
        Logger:out ("UIManager正在加载中，先放入加载队列:" .. uiName);
        local tmpObj = param
        table.insert(private.queue, tmpObj);
        return;
    end
    if showLoadingUI == nil then showLoadingUI = false; end;   
    --父图层不存在了，不加载这个UI了，直接加载下一个
    if layer == nil or GameGlobal:checkObjIsNull(layer) and uiName ~= require("data.manual.Config_UI").LOADING.name then
        Logger:out ("父图层不存在了，忽略此UI的加载，直接加载下一个:" .. uiName);
        private.loading = false;
        private:loadNext();
        return; 
    end  
    
    if private.logicList[layer] == nil then
        private.logicList[layer] = {};
    end    

    private.needToRemoveUINames[uiName] = nil;--之前没加载完被调用了remove，然而现在又要add了。所以又要从待删列表里面干掉它
    Logger:out ("准备加载并显示UI:" .. uiName);

    if private.LoadingManager then
        private.LoadingManager:dispose();
        private.LoadingManager = nil;
    end
    private.LoadingManager = require("app.control.LoadingManager"):create();
    local uiConfig = Config_UI[uiName];
    if private.list[layer] ~= nil and private.list[layer][uiName] ~= nil then
        Logger:out("已有同名UI，先remove:" .. uiName);
        if needReload == 1 then
            --有同名的ui了，先删除 
            UIManager:removeUI(layer, uiName, nil, true);--先删掉同名的
        else
            --有同名的ui了，返回，只受理之前的第一个            
            return 
        end
    end
    res = res or {};
    --根据lua文件，取出资源
    local luaRes = {};
    if uiConfig.view ~= "" then
        luaRes = UIManager:getResFromLua(uiConfig.view);
    end
    res = TableUtil:combineTable(res, luaRes);
    if uiConfig.res ~= nil and uiConfig.res ~= "" then        
        local resArr;
        if type(uiConfig.res) == "string" then
            resArr = StringUtil:split(uiConfig.res, ",");
        elseif type(uiConfig.res) == "table" then
            resArr = uiConfig.res;
        end
        --合并两个数组：
        if resArr then
            for i,v in pairs(resArr) do
                table.insert(res,v)
            end
        end
    end    
    --去重复项
    res = TableUtil:removeDuplicateItems(res);    
    private.inUseRes[uiName] = res;    
    local allFromCache = private.LoadingManager:addByArray(res);
    --缓存里全有，则强制把showLoadingUI 置为false
    if allFromCache then
        showLoadingUI = false;
    end
    local node;    
    if GameGlobal:checkObjIsNull(UIManager.loadingNode) then
        UIManager.loadingNode = nil;
    end          
    if UIManager.loadingNode == nil then
        --检查loading是否在内存里了，如果没有，就不显示了
        UIManager.loadingNode = UIManager:getNodeFromLua(Config_UI.LOADING.view);
        UIManager.loadingNode.logic = nil;
    end           
     
    if not showLoadingUI then
        UIManager.loadingNode:setCascadeOpacityEnabled(true);
        UIManager.loadingNode:setOpacity(0);
    end
    UIManager.loadingNode:getChildByName("LoadingBar_1"):setPercent(0);   
    local function trySetVisible()
        --当loading界面出现的时候，connectingUI出来，就隐藏        
        if not GameGlobal:checkObjIsNull(UIManager.connectingCache) then
            UIManager.connectingCache:setVisible(false);
        else
            UIManager.connectingCache = nil; 
        end      
    end
    --避免UIManager.connectingCache已经因且场景而不存在了  
    trySetVisible();    
    --if ret == false then UIManager.connectingCache = nil end; --出错了，置空
    
    local function onLoadingNodeEvent(event)
        --退出的event有：exitTransitionStart（即将退出）、exit（退出完成）、cleanup（清理）
        if "exitTransitionStart" == event then                                               
            local function trySetVisibleTrue()
                if not GameGlobal:checkObjIsNull(UIManager.connectingCache) then
                    UIManager.connectingCache:setVisible(true);
                else
                    UIManager.connectingCache = nil;
                end
           end            
            trySetVisibleTrue() 
            UIManager.loadingNode = nil;
        end
    end        
    UIManager.loadingNode:registerScriptHandler(onLoadingNodeEvent)
    if private.list[layer] == nil then
        private.list[layer] = {};
    end        
    local function tryAddChild()
        if not GameGlobal:checkObjIsNull(cc.Director:getInstance():getRunningScene()) and UIManager.loadingNode:getParent() == nil then
            cc.Director:getInstance():getRunningScene():addChild(UIManager.loadingNode);
            return true
        else
            return false;  
        end
    end
    --因为父节点被移除了，无法添加这个node，则跳过      
    local ret = tryAddChild();
    if ret == false then
        UIManager.loadingNode:unregisterScriptHandler()
        --private.list[layer] = nil;
        Logger:out("无法添加" .. Config_UI.LOADING.name .. "因为父节点已经被删除！")
    else
        --逻辑
        local logic = nil 
        if UIManager.loadingNode.logic == nil then
            logic = require("app.uiLogic." .. Config_UI.LOADING.name);
            UIManager.loadingNode:setPosition(UIManager.rightShiftPx, UIManager.upperShiftPy);--适应不同分辨率  
            local loadinglogic = logic:create(UIManager.loadingNode, nil);
            UIManager.loadingNode.logic = logic; 
			CLIENT_VIEW_ARRAY = CLIENT_VIEW_ARRAY or {}
			table.insert(CLIENT_VIEW_ARRAY,{uiName = Config_UI.LOADING.name,logic = loadinglogic,view = UIManager.loadingNode,panel = cc.Director:getInstance():getRunningScene()})
        end      
    end                                
   
    local function progressCallBack(value)
        if UIManager.loadingNode ~= nil then
            --用动画来表现
            local function cb()     
                if UIManager.loadingNode == nil or GameGlobal:checkObjIsNull(UIManager.loadingNode) then
                    if UIManager.loadingTicker then
                        
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(UIManager.loadingTicker)
                        UIManager.loadingTicker = nil;
                    end
                    return 
                end                    
                local cur = UIManager.loadingNode:getChildByName("LoadingBar_1"):getPercent();                
                --1秒后到达此目标      
                if UIManager.loadingNode.newValue == nil then UIManager.loadingNode.newValue = 0 end;
                UIManager.loadingNode.speed = (UIManager.loadingNode.newValue - cur) * 0.1;--此值是每秒速度
                UIManager.loadingNode.speed = UIManager.loadingNode.speed * 5;--此值是0.5秒的速度      
                if UIManager.loadingNode.speed < 2 then UIManager.loadingNode.speed = 2; end;   
                local show = (cur + UIManager.loadingNode.speed);
                if show > 100 then show = 100 end;
                if show < 0 then show = 0 end;
                if UIManager.loadingNode.newValue >= 100 then 
                    show = 100;
                end
                UIManager.loadingNode:getChildByName("LoadingBar_1"):setPercent(show);
                Logger:out("UIManager loadingNode进度显示为：" .. show);
                if show == 100 then
                    scheduler.unscheduleGlobal(UIManager.loadingTicker);
                    UIManager.loadingTicker = nil;
                end
                local function trySetVisibleFalse()
                    if not GameGlobal:checkObjIsNull(UIManager.connectingCache) then
                        UIManager.connectingCache:setVisible(false);
                    else
                        UIManager.connectingCache = nil;
                    end      
                end
                --避免UIManager.connectingCache已经因且场景而不存在了  
                trySetVisibleFalse();    
            end            
            if UIManager.loadingNode.newValue == nil then
                UIManager.loadingNode.newValue = value * 100;
                cb();
            end
            UIManager.loadingNode.newValue = value * 100;
            if UIManager.loadingTicker == nil then                
                UIManager.loadingTicker = cc.Director:getInstance():getScheduler():scheduleScriptFunc(cb,0.1,false)
                
            end            
        end
    end
    local function doCreate()    
        local function tryGetNodeFromLua()
            if uiConfig.view == nil or uiConfig.view == "" then
                node = ccui.Widget:create();
            elseif not settleNode then
                node = UIManager:getNodeFromLua(uiConfig.view);
            elseif settleNode then
                node = settleNode;
            end
        end   
        local ret,errMessage=pcall(tryGetNodeFromLua);
        --如果这一步出错了（可能因为没有正确预加载，或者打包缺图），则生出失败
        if ret == false then
            Logger:throwError("没有正确预加载所需的PNL，或者打包缺图。\nuiName：" .. uiConfig.name .. "\n" .. errMessage);    
            private.loading = false;
            private:loadNext();      
            return  
        end
        local function onNodeEvent(event)
            --退出的event有：exitTransitionStart（即将退出）、exit（退出完成）、cleanup（清理）
            if "exitTransitionStart" == event then
                --node退出时
                local view,layer = UIManager:getUIByName(nil, uiConfig.name);
                if layer ~= nil then private.list[layer][uiConfig.name] = nil end;
                --node退出时，若有logic，删logic
                local logic = UIManager:getUILogicByName(nil, uiConfig.name);
                if logic then
                    EventManager:removeEvents(logic)
                end
                if logic ~= nil and logic.dispose and (not logic.disposed) then                    
                    logic:dispose();
                    logic.disposed = true;
                end
                self:clearUIResCache(uiConfig.name);--此界面关闭，需要清掉跟此界面相关的纹理
            end
        end
        node:registerScriptHandler(onNodeEvent)     
        if private.list[layer] == nil then
            private.list[layer] = {};
        end
        private.list[layer][uiName] = node;
        node:setName(uiConfig.name);    
          
        local function tryAddChild()
            if not GameGlobal:checkObjIsNull(layer) and not GameGlobal:checkObjIsNull(node) then
                layer:addChild(node); 
            else
                return false;                
            end
            if not GameGlobal:checkObjIsNull(UIManager.loadingNode) then             
                UIManager.loadingNode:setLocalZOrder(9999);           
            end
            return true;
        end
        --因为父节点被移除了，无法添加这个node，则跳过      
        local ret = tryAddChild();
        if ret == false then
            node:unregisterScriptHandler()
            Logger:out("无法添加" .. uiConfig.name .. "因为父节点已经被删除！加载队列里下一个！")
            private.loading = false;
            private.list[layer] = nil;
            private:loadNext();
            return;
        end                     
       
        if zorder ~= nil then
            node:setLocalZOrder(zorder);		
        end     
        UIManager:layoutAllObjectsInUI(layer, uiName);
        local logicName = "";
        if type(uiConfig.hasLogic) == "boolean" then
            --布尔类型
            if uiConfig.hasLogic == true then
                logicName = uiName;
            end
        else
            if uiConfig.hasLogic ~= nil then                
                logicName = uiConfig.hasLogic
            end
        end
        if logicName ~= "" then
            local function fun()
                local logic = require("app.uiLogic." .. logicName);                      
                private.logicList[layer][uiName] = logic:create(node, logicParam);
                if UIManager.currentRemoveView == node then
                    --刚添加又被删了
                    if private.logicList[layer][uiName].dispose then
                        private.logicList[layer][uiName]:dispose();
                        private.logicList[layer][uiName] = nil;
                    end
                    return
                end
				CLIENT_VIEW_ARRAY = CLIENT_VIEW_ARRAY or {}
				table.insert(CLIENT_VIEW_ARRAY,{uiName = uiName,logic = private.logicList[layer][uiName],view = node,panel = layer})
                if not node:isVisible() then
                    Logger:out("ERROR......view is invisible now")
                end
            end
            local ret = nil;
            local errMessage = "";
            ret,errMessage=pcall(fun);
            if ret == false then
                --logic报错了              
                private.loading = false;
                private:loadNext();
                Logger:throwError(errMessage);                
            end                                      
            if private.list[layer][uiName] == nil then
                UIManager:removeUI(layer, uiName);    
                private.loading = false;
                private:loadNext();            
                return
            end
            if private.logicList[layer][uiName] == nil then
                Logger:out("LUA ERROR:" .." 没有正常的return logic") 
                Logger:out("Error: " .. uiName .. "的logic的create方法没返回，请检查！") 
            else
                Logger:out(uiName .. "的逻辑创建成功！"); 
            end  
        end;                
        Logger:out(uiName .. "添加成功！")    
        UIManager.openedUI[uiName] = uiName;           
        if require("data.manual.Config_UI")[uiName].needAction == true then
            local tmpMaskNode = UIManager:createRect(cc.Director:getInstance():getRunningScene(), cc.rect(-2*UIManager.ActualDesignSize.width,-2*UIManager.ActualDesignSize.height,UIManager.ActualDesignSize.width*5, UIManager.ActualDesignSize.height*4),{fillColor=cc.c4f(0,0,0,0), borderColor=cc.c4f(0,0,0,0),borderWidth=1},nil,nil,nil,99999999);
            local needCallComAction = true;            
            local function comAction()  
                if not needCallComAction then
                    return
                end
                needCallComAction = false;--这么做保证comAction只会被调用一次          
                if not GameGlobal:checkObjIsNull(tmpMaskNode) then
                    tmpMaskNode:removeFromParent();
                end
                Logger:out(uiName .. "缓动完成！")   
                EventManager:sendEvent(UIManager, require("app.event.UIManagerEvent").ADD, {name=uiName, view = node}) 
                private.loading = false;
                private:loadNext();               
                if backFun then 
                    backFun(private.logicList[layer][uiName]);--回传logic出去
                end;       
            end             
            node:setScale(0.35)
            node:setCascadeOpacityEnabled(true)
            node:setOpacity(0)
            local srcPosX, srcPosY = node:getPosition();
            
            local starPos;
            if trigger then
              starPos = trigger:getParent():convertToWorldSpace(cc.p(trigger:getPosition()))
            else
              starPos = {x = UIManager.ActualDesignSize.width*0.3,y=UIManager.ActualDesignSize.height*0.3} 
            end
            node.xxxxxxpos = starPos;
            node:setPosition(starPos) 
            local action1 = cc.EaseBackOut:create(cc.ScaleTo:create(0.2,1))    
            local action2 = cc.FadeIn:create(0.1);
            local action3 = cc.EaseBackOut:create(cc.MoveTo:create(0.2,cc.p(srcPosX, srcPosY)));            
            local sp = cc.Sequence:create(cc.Spawn:create(action1,action2,action3), cc.CallFunc:create(comAction));                                
            node:runAction(sp);
            --SoundManager:playEffect("sound/open.mp3");  
            --若1秒后缓动仍未完成，证明该UI在动画展示时，被切换场景或者别的原因被干掉了，所以直接调用comAction
            
            performWithDelay(comAction,1)
        else
            if not GameGlobal:checkObjIsNull(UIManager.loadingNode) then 
                --删掉loading界面
                UIManager.loadingNode:removeFromParent();                                
            end   
            Logger:out(uiName .. "无须缓动！")
            EventManager:sendEvent(UIManager, require("app.event.UIManagerEvent").ADD, {name=uiName, view = node})
            private.loading = false;
            private:loadNext(); 
            if backFun then 
               backFun(private.logicList[layer][uiName]);--回传logic出去
            end;       
        end 
        --如果这个ui将被删除，则不要后续处理了。删除吧：
        if private.needToRemoveUINames[uiName] == 1 then
            --在加载过程中就应该被删掉的。那么现在删掉吧
            Logger:out("加载过程中被移除：" .. uiName);  
            UIManager:removeUI(layer, uiName);
            private.loading = false;
            private:loadNext();
            return
        end
        --派发者，事件类型，参数
        if not require("data.manual.Config_UI")[uiName].needAction then
            EventManager:sendEvent(UIManager, require("app.event.UIManagerEvent").ADD, {name=uiName, view = node})
        end        
    end
    local function allCompletedCallBack(needDelay)      
        Logger:out("UIManager allCompletedCallBack()")
        --如果是预加载用的loading界面，那么就结束了，不要再处理后续的
        if UIManager.loadingNode ~= nil and not GameGlobal:checkObjIsNull(UIManager.loadingNode) then
            UIManager.loadingNode:getChildByName("LoadingBar_1"):setPercent(100);
            if UIManager.loadingTicker then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(UIManager.loadingTicker)
                UIManager.loadingTicker = nil;
            end
        end
        if uiName == Config_UI.LOADING.name then
            Logger:out("UIManager needDelay=".. tostring(needDelay))
            Logger:out("UIManager loadingNode=".. tostring(UIManager.loadingNode))
            if needDelay == nil then needDelay = true end;
            local function com() 
                Logger:out("UIManager backFun() Called.")                
                if backFun then 
                    backFun();            
                end     
                private.loading = false;
                private:loadNext();
            end
            if needDelay and UIManager.loadingNode then
                
                performWithDelay(UIManager.loadingNode,com,0.1)
            else
                com();
            end         
            return
        end       
        Logger:out ("about to create node:" .. uiConfig.view);
        --加载完成后，让渲染喘一口气，再生成这个node
        if needDelay == nil then needDelay = true end;
        if needDelay and UIManager.loadingNode then
           
            performWithDelay(doCreate,0.1)
        else
            doCreate();
        end
    end
    private.loading = true; 
    private.LoadingManager:startLoad(progressCallBack,allCompletedCallBack)
end

function UIManager:clearUIResCache(uiName)
    local arr = {};
    --如果这个界面有预加载纹理
    if private.inUseRes[uiName] ~= nil and #private.inUseRes[uiName] > 0 then
        --先找出当前画面显示着的UI里，哪些资源在使用中，把计数记下来
        for k, v in pairs(private.inUseRes) do
            for j = 1, #v do                        
                if arr[v[j]] == nil then
                    arr[v[j]] = 1;
                else
                    arr[v[j]] = arr[v[j]] + 1;
                end
            end
        end
        --待移除的界面资源使用计数只有1（即只有待移除的界面所用的），移除掉
        for i = 1,#private.inUseRes[uiName] do
            if arr[private.inUseRes[uiName][i]] == 1 then
                if GameGlobal:getResourceManager() then
                    if GameGlobal:getResourceManager().purageCaheDataForUIM then
                        GameGlobal:getResourceManager():purageCaheDataForUIM(private.inUseRes[uiName][i]);
                    end
                end
            end 
        end
    end

    private.inUseRes[uiName] = nil;
end
--从private.list里删除UI，排除extTab里提到的uiName
--extTab的格式是：
--tab[Config_UI.WORLDMAPVIEW.name] = 1;
--tab[Config_UI.WORLDMAPUI.name] = 1;
function UIManager:removeAllUIFromList(extTab)
    --寻找layer、uiName    
    local layer;
    local uiName;
    if extTab == nil then
        extTab = {};
    end
    for k,v in pairs(private.list) do 
        for o,p in pairs(v) do 
            if extTab[o] == nil then
                layer = k;
                uiName = o;
                UIManager:removeUI(layer, uiName, nil, true);
            end
        end       
    end   
end
--在layer里删除名字为uiName的ui，是否不执行removeChild
function UIManager:removeUI(layer, uiName, DoNotRemoveChild, noAction)
    Logger:out("即将移除：" .. uiName);

    if uiName == require("data.manual.Config_UI").CONNECTING.name then
        if UIManager.connectingCacheLogic ~= nil then
            UIManager.connectingCacheLogic:dispose();
            UIManager.connectingCacheLogic = nil;    
        end
        if UIManager.connectingCache then 
            if GameGlobal:checkObjIsNull(UIManager.connectingCache) == false and GameGlobal:checkObjIsNull(UIManager.connectingCache:getParent()) == false then
                if CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] and CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY].view == UIManager.connectingCache then
					CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] = nil
				end
				UIManager.connectingCache:removeFromParent()
            end
            UIManager.connectingCache = nil
        end 
        return 
    end
    if private.list == nil then return end;     
    --Logger:dump(private)
    --Logger:out("=================")
    --Logger:dump(private.list)  
    if layer == nil then
        --寻找layer
        for k,v in pairs(private.list) do 
            for o,p in pairs(v) do 
                if o == uiName then                   
                    layer = k;
                    break;
                end
            end
            if layer ~= nil then break; end;
        end
        if layer == nil then
            Logger:out("Error:找不到包含" ..uiName .. "的layer！")
        end
    end 
    if private.list[layer] == nil then
        --Logger:out("Error: list里没有这个layer。可能切换场景的时候已经删掉了！uiName:" .. uiName)
		if CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] and CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY].uiName == uiName then
			CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] = nil
		end
        return;
    end
    if private.list[layer][uiName] == nil then
        Logger:out("UIManager里没有这个uiName的UI，无须删除:" .. uiName)
        --为避免正在加载中时被删，先标记下来
        private.needToRemoveUINames[uiName] = 1;
		if CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] and CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY].uiName == uiName then
			CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] = nil
		end
        return;   
    end              
    --先删逻辑
    --Logger:out("=========list========")
    --Logger:dump(private.logicList)
    --Logger:out("=================")
    --Logger:dump(private.logicList[layer])

    if private.logicList[layer]~= nil and private.logicList[layer][uiName] ~= nil then
        if private.logicList[layer][uiName]["dispose"] == nil then
            Logger:out("app.uiLogic没有dispose函数，注意检查！")
        end;
        --避免EventManager的侦听忘了删，代logic删一下
        EventManager:removeEvents(private.logicList[layer][uiName]);
        if not private.logicList[layer][uiName].disposed then

            if private.logicList[layer][uiName]["dispose"] ~= nil then    
                --先注销node的监听，否则之前注册的node的监听，会监听到exit导致重复调用dispose
                if not GameGlobal:checkObjIsNull(private.logicList[layer][uiName].view) then 
                    private.logicList[layer][uiName].view:unregisterScriptHandler();                
                end;
                local uiLogicToDis = private.logicList[layer][uiName];            
                uiLogicToDis:dispose();
                if uiLogicToDis then
                   uiLogicToDis.disposed = true;
                end
            end
        end
		if CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] and CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY].uiName == uiName then
			CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] = nil
		end
        if private.logicList[layer] and private.logicList[layer][uiName] then
            private.logicList[layer][uiName] = nil;
        end
    end;
    --再删child
    if private.list[layer] == nil then
        --父节点不存在了 
        Logger:out(uiName .. "移除后，其父节点list中已不存在了")
        return 
    end;
    if private.list[layer][uiName] == nil then
        --不存在了 
        Logger:out(uiName .. "移除后，在list中已不存在了")
        return 
    end;
    local node = private.list[layer][uiName];

    if not DoNotRemoveChild then
        --递归调用layer:removeAllNodeEventListeners();
        local function removeChildNodeEventListeners(child)
            --child在c++那边已经被移除
            if GameGlobal:checkObjIsNull(child) then return end;
            --child:removeAllNodeEventListeners();
            local arr = child:getChildren();
            local len = table.nums(arr);
            if len > 0 then
                for i = 1, len do
                    removeChildNodeEventListeners(arr[i]);
                end
            end            
        end
        removeChildNodeEventListeners(node);
        UIManager.currentRemoveView = node;
        if require("data.manual.Config_UI")[uiName].needAction == true and (not GameGlobal:checkObjIsNull(node)) and not noAction then                
            UIManager:createRect(node, cc.rect(-2*UIManager.ActualDesignSize.width,-2*UIManager.ActualDesignSize.height,UIManager.ActualDesignSize.width*5, UIManager.ActualDesignSize.height*4),{fillColor=cc.c4f(0,0,0,0), borderColor=cc.c4f(0,0,0,0),borderWidth=1},nil,nil,nil,99999999);             
            local action1 =cc.EaseBackIn:create(cc.ScaleTo:create(0.3,0.35))    
            local action2 = cc.FadeOut:create(0.3);
            local enPos = node.xxxxxxpos
            if not enPos then
                enPos = {x = UIManager.ActualDesignSize.width*0.3,y = UIManager.ActualDesignSize.height*0.3}
            end
            local action3 = cc.EaseBackIn:create(cc.MoveTo:create(0.3,cc.p(enPos.x,enPos.y)));
            local sp = cc.Spawn:create(action1,action2,action3)
            node:runAction(cc.Sequence:create(sp,cc.CallFunc:create(function()   
                layer:removeChild(node);       
            end)));
            --SoundManager:playEffect("sound/close.mp3");
        else
            if not GameGlobal:checkObjIsNull(node) then
                layer:removeChild(node);       
            end
        end
    end  


    private.list[layer][uiName] = nil;
    if private.logicList[layer] ~= nil then
        private.logicList[layer][uiName] = nil;
    end
    if  private.scaleResetList[layer] ~= nil then
        Logger:out ("private.scaleResetList:" .. tostring(layer) .. ", " .. uiName .. " ," .. tostring(private.scaleResetList[layer][uiName]))
        private.scaleResetList[layer][uiName] = nil;
    end
    private.needToRemoveUINames[uiName] = nil;
    Logger:out("移除了： " .. uiName);
    UIManager.openedUI[uiName] = nil;
    --清理list
    for k,v in pairs(private.list) do
        if GameGlobal:checkObjIsNull(k) then
            private.list[k] = nil;
        else
            if next(v) == nil then
                private.list[k] = nil;
            end
        end
    end
    for k,v in pairs(private.logicList) do
        if GameGlobal:checkObjIsNull(k) then
            private.logicList[k] = nil;
        else
            if next(v) == nil then
                private.logicList[k] = nil;
            end
        end
    end
    --派发者，事件类型，参数
    EventManager:sendEvent(UIManager, require("app.event.UIManagerEvent").REMOVE, {name=uiName})
end
--offsetX、offsetY是在对齐后，再偏移多少像素
function UIManager:toScreenCenter(target, offsetX, offsetY)    
    UIManager:toScreenCenterX(target, offsetX);
    UIManager:toScreenCenterY(target, offsetX, offsetY);
end
--offsetX是在对齐后，再偏移多少像素
function UIManager:toScreenCenterX(target, offsetX)
    offsetX = offsetX or 0; 
    local contentSize = target:getContentSize();
    target:setPositionX(UIManager.CenterX-(0.5-target:getAnchorPoint().x)*contentSize.width+offsetX);
end

function UIManager:toScreenCenterY(target, offsetY)
    offsetY = offsetY or 0;
    local contentSize = target:getContentSize();
    target:setPositionY(UIManager.CenterY-(0.5-target:getAnchorPoint().y)*contentSize.height+offsetY);  
end
--左对齐  ...为多个需要左对齐的targetName
function UIManager:alignLeft(parent,...)


    --Logger:out("UIManager:alignLeft(parent,...)=========")
    local arg = {...}
    --Logger:dump(arg)
    local n = #arg; 


    if n ==0 then return end;
    for i=1,n do
        local node = parent:getChildByName(arg[i]);
        if node ~=nil then
            node:setPositionX(node:getPositionX()-UIManager.rightShiftPx);
        else
            Logger:out("Error：node named "..arg[i].."can't be found!!!!");
        end
    end
end
--左对齐 除了指定元素外左对齐 ...为多个需要排除targetName
function UIManager:alignLeftExcept(parent,...)

    --Logger:out("UIManager:alignLeftExcept(parent,...)=========")
    local arg = {...}
    --Logger:dump(arg)
    local n = #arg; 

    local function containTarget(nodeName)
        if n==0 then return false end;
        for i=1,n do
            if arg[i] == nodeName then return true end;
        end
        return false;
    end
    local children = parent:getchildren();
    for i=1,#children do
        local node = children[i];
        if containTarget(node:getName())== false then
            node:setPositionX(node:getPositionX()-UIManager.rightShiftPx);
        end
    end
end
--右对齐  ...为多个需要左对齐的targetName
function UIManager:alignRight(parent,...)


    --Logger:out("UIManager:alignLeftExcept(parent,...)=========")
    local arg = {...}
    --Logger:dump(arg)
    local n = #arg; 

    if n ==0 then return end;
    for i=1,n do
        local node = parent:getChildByName(arg[i]);
        if node ~=nil then
            node:setPositionX(node:getPositionX()+UIManager.rightShiftPx);
        else
            Logger:out("error：node named "..arg[i].."can't be found!!!!");
        end
    end
end
--右对齐 除了指定元素外右对齐 ...为多个需要排除targetName
function UIManager:alignRightExcept(parent,...)

    --Logger:out("UIManager:alignLeftExcept(parent,...)=========")
    local arg = {...}
    --Logger:dump(arg)
    local n = #arg; 

    local function containTarget(nodeName)
        if n==0 then return false end;
        for i=1,n do
            if arg[i] == nodeName then return true end;
        end
        return false;
    end
    local children = parent:getChildren();
    for i=1,#children do
        local node = children[i];
        if containTarget(node:getName())== false then
            node:setPositionX(node:getPositionX()+UIManager.rightShiftPx);
        end
    end
end
--九宫格对象X方向扩展到全屏
function UIManager:scaleX2FullScreen4Scale9Sprite(target)
    local originalSize = target:getContentSize();
    target:setContentSize(UIManager.ActualDesignSize.width,originalSize.height);
end
--某目标对象伸缩到全屏
function UIManager:scaleToFullScreen(target)
    target:setScaleX(UIManager.scaleX*target:getScaleX());
    target:setScaleY(UIManager.scaleY*target:getScaleY());
end
--某名字的目标对象伸缩到全屏
function UIManager:scaleToFullScreenByName(parent, targetName)
    local target = parent:getChildByName(targetName);
    if target == nil then return end;
    UIManager:scaleToFullScreen(target);
end
--某目标对象x方向伸缩到全屏,keepYScale
function UIManager:scaleXToFullScreen(target, keepYScale)
    -- UIManager:toScreenCenter(target)
    if target == nil then return end
    local oriScale = target:getScaleX()
    local p = target:getAnchorPoint()
    local width = target:getContentSize().width*target:getScaleX();
    if width >= cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width then
        target:setPositionX(target:getPositionX() - UIManager.rightShiftPx * 2* (0.5 - p.x)  )
        return;
    end
    local scaleExtra = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width/width;
    local scale = oriScale * scaleExtra
    target:setScaleX(scale);
    target:setPositionX(target:getPositionX() - UIManager.rightShiftPx * 2* (0.5 - p.x)  )
    --y比例也跟着缩放
    if keepYScale then
        target:setScaleY(target:getScaleY() * scaleExtra);
    end
end
--某目标对象y方向伸缩到全屏,keepXScale
function UIManager:scaleYToFullScreen(target, keepXScale)
    -- UIManager:toScreenCenter(target)
    if target == nil then return end
    local oriScale = target:getScaleY()
    local p = target:getAnchorPoint()
    local height = target:getContentSize().height*target:getScaleY();
    if height >= cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height then
        target:setPositionY(target:getPositionY() - UIManager.upperShiftPy * 2* (0.5 - p.y)  )
        return;
    end
    local scaleExtra = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().height/height;
    local scale = oriScale * scaleExtra
    target:setScaleY(scale);
    target:setPositionY(target:getPositionY() - UIManager.upperShiftPy * 2* (0.5 - p.y)  )
    --y比例也跟着缩放
    if keepXScale then
        target:setScaleX(target:getScaleX() * scaleExtra);
    end
end
--某名字的目标对象在Y方向上伸缩到全屏
function UIManager:scaleYToFullScreenByName(parent, targetName, keepXScale)
    local target = parent:getChildByName(targetName);
    if target == nil then return end;
    UIManager:scaleYToFullScreen(target,keepXScale);
end

--某名字的目标对象在X方向上伸缩到全屏
function UIManager:scaleXToFullScreenByName(parent, targetName, keepYScale)
    local target = parent:getChildByName(targetName);
    if target == nil then return end;
    UIManager:scaleXToFullScreen(target,keepYScale);
end
--恢复目标的原始坐标
function UIManager:resetPosition(target)
    local formerPositonX,formerPositonY = target:getPosition();

    if cc.Director:getInstance():getOpenGLView():getResolutionPolicy() ==  cc.ResolutionPolicy.FIXED_HEIGHT then
        target:setPosition(formerPositonX-UIManager.rightShiftPx,formerPositonY-UIManager.upperShiftPy)
    else
        target:setPosition(formerPositonX,formerPositonY-UIManager.upperShiftPy);
    end
end
--layoutAllObjectsInUI方法会随着view加载完毕后自动调用，遍历所有的孩子对坐标进行修正，以适应不同分辨率
function UIManager:layoutAllObjectsInUI(layer, name)  
    if layer == nil then
        Logger:out("Error: layoutAllObjectsInUI：layer为nil！")
        return; 
    end    
    local viewUI = UIManager:getUIByName(layer, name);
    if viewUI == nil then
        return;
    end
    local formerPositonX,formerPositonY = viewUI:getPosition();
    viewUI:setPosition(formerPositonX+UIManager.rightShiftPx,formerPositonY+UIManager.upperShiftPy)
end
--移动坐标，使得target适应屏幕
function UIManager:fixToScreen(target)
    local formerPositonX,formerPositonY = target:getPosition();
    target:setPosition(formerPositonX+UIManager.rightShiftPx,formerPositonY+UIManager.upperShiftPy)
end
function UIManager:undoLayoutAllObjectsInUI(layer, name)     
end
--该图层下所有ui删掉
function UIManager:clear(layer)
    if layer == nil then
        --清除所有图层
        if private.list ~= nil then
            for i ,v in pairs(private.list) do
                UIManager:clear(i);
            end
        end
        return;
    end    
    if private.list[layer] ~= nil then
        for i,v in pairs(private.list[layer]) do
            UIManager:removeUI(layer, i, true);
        end
    end
    private.list[layer] = nil;
    private.scaleResetList[layer] = nil;   
    private.logicList[layer] = {};
    private.removeBeforeLoadCompleteUI = {};
    private.needToRemoveUINames = {};
end

--此方法用以快速加touch侦听。
-- 参数格式及说明：
-- param = {
    -- target               设置侦听的对象
    -- endedCallBack        是table。设置end事件的回调函数；格式是：{callBack=回调函数, param={参数, 参数...}}，不需要填nil。
    -- beganCallBack        是table。可以设置began事件的回调函数；格式是：{callBack=回调函数, param={参数, 参数...}}，不需要填nil。
    -- movedCallBack        是table。可以设置move事件的回调函数；格式是：{callBack=回调函数, param={参数, 参数...}}，不需要填nil。
    -- scale                按钮对象放缩比例。不需要填nil。
    -- needPressScale       按下时对象的放缩比例；不需要填0。默认1.1（松开后恢复到上面设置的scale值）
    -- pixNumIgnoreEnded    用户按下目标后，move多远像素后触发moveOutCallBack事件。若不设置此值，默认为50
    -- moveOutCallBack      移出pixNumIgnoreEnded像素后或是抬手时抬手点不在目标范围内，会触发此事件。
    -- removeLastListener   当同样的node被多次侦听，是否先删除上一个监听。默认true。若设为false，重复侦听会返回（只受理第一次监听）；若设为true，则会先移除上一个监听，再添加本次监听
    -- root                 需要整个node放缩时，传入target的根node，如果没有 先创建ccui.Widget
    -- swallowTouch         默认true
-- }
--每一个callBack的写法应该是：{callBack= callBack, param={"end", 1, 2}}
--如果为target赋予sound属性，则会播放此对象的点击音效。如果赋值""，则点击按钮无声音。如：target.sound="sound/big.mp3"，或者target.sound="";(点击按钮不发出任何声音)
function UIManager:widgetTouchExtent(param,...)
    if type(param) ~= "table" then
       local target = param;
       local args = {...}
       param = {
            target = target,
            endedCallBack = args[1],
            beganCallBack = args[2],
            movedCallBack = args[3],
            scale = args[4],
            needPressScale = args[5],
            pixNumIgnoreEnded = args[6],
            moveOutCallBack = args[7],
            removeLastListener = args[8],
            root = args[9],
            swallowTouch = args[10]
       }    
        
    end
    local target = param.target;
    local endedCallBack = param.endedCallBack;
    local beganCallBack = param.beganCallBack;
    local movedCallBack = param.movedCallBack;
    local scale = param.scale;
    local needPressScale = param.needPressScale;
    local pixNumIgnoreEnded = param.pixNumIgnoreEnded;
    local moveOutCallBack = param.moveOutCallBack;
    local removeLastListener = param.removeLastListener;
    local root = param.root;
    local swallowTouch = param.swallowTouch;
    if swallowTouch == nil then swallowTouch = true end;
    if target == nil then 
        --Logger:throwError("侦听对象为空！");
        Logger:out("Error:侦听对象为空！") 
        return 
    end;
    if endedCallBack ~= nil and (type(endedCallBack)~= "table" or endedCallBack.callBack == nil) then
        --格式不对，警告
        Logger:throwError("endedCallBack的格式不对，应该是{callBack=cb, param='123'}这样的格式！"); return;
    end
    if beganCallBack ~= nil and (type(beganCallBack)~= "table" or beganCallBack.callBack == nil) then
        --格式不对，警告
        Logger:throwError("endedCallBack的格式不对，应该是{callBack=cb, param='123'}这样的格式！"); return;
    end
    if movedCallBack ~= nil and (type(movedCallBack)~= "table" or movedCallBack.callBack == nil) then
        --格式不对，警告
        Logger:throwError("endedCallBack的格式不对，应该是{callBack=cb, param='123'}这样的格式！"); return;
    end
    if moveOutCallBack ~= nil and (type(moveOutCallBack)~= "table" or moveOutCallBack.callBack == nil) then
        --格式不对，警告
        Logger:throwError("endedCallBack的格式不对，应该是{callBack=cb, param='123'}这样的格式！"); return;
    end

    if removeLastListener == nil then
        removeLastListener = true;
    end    
    local srcPixNumIgnoreEnded = pixNumIgnoreEnded;
    if pixNumIgnoreEnded == nil then pixNumIgnoreEnded = 50; end;
    --删除之前的侦听
    if removeLastListener == true then        
        UIManager:removeWidgetTouchExtent(target);
    else
        if target.addedTouchEventListener then
            return  target ;
        end
    end
    if target.widgetTouchExtentInfo == nil then
        target.widgetTouchExtentInfo = {};
    end
    
    target.widgetTouchExtentInfo.endedCallBack = endedCallBack;
    target.widgetTouchExtentInfo.beganCallBack = beganCallBack; 
    target.widgetTouchExtentInfo.movedCallBack = movedCallBack;
    target.widgetTouchExtentInfo.scale = scale;
    target.widgetTouchExtentInfo.pixNumIgnoreEnded =  pixNumIgnoreEnded;
    target.widgetTouchExtentInfo.needPressScale = needPressScale;
    --是按钮的话才有默认放缩
    if target.widgetTouchExtentInfo.needPressScale == nil and target.setTitleText then
        target.widgetTouchExtentInfo.needPressScale = 1.1
    end
    if target.widgetTouchExtentInfo.needPressScale == 0 then
        target.widgetTouchExtentInfo.needPressScale = nil;
    end    
    target.widgetTouchExtentInfo.moveOutCallBack = moveOutCallBack;
    
    if target.addedTouchEventListener then
        target:setTouchEnabled(true); 
        return target
    end
    
    if target.widgetTouchExtentInfo.scale then 
        target:setScale(target.widgetTouchExtentInfo.scale);  
    end
    local srcScaleX = target:getScaleX(); 
    local srcScaleY = target:getScaleY();


    local callBack;
    local param;
    local function handleCallBack(event)
        if param == nil then
            param = {};           
        end
        --如果当前在链接中，所有按钮事件不响应
        if UIManager:getUIByName(nil, Config_UI.CONNECTING.name) and event:getParent():getName() ~= "MESSAGEBOX" then
           Logger:out("CONNECTING. forbidden touches!!");
           return
        end
        --最后的参数加上这个原始的event，以便外部逻辑能够使用
        local newParam = TableUtil:clone(param);
        newParam[table.maxn(newParam) + 1] =  event;
        if callBack ~= nil then            
            local len = table.maxn(newParam); 
            if len == 0 then callBack(newParam); end
            if len == 1 then callBack(newParam[1],newParam[2]); end
            if len == 2 then callBack(newParam[1],newParam[2]); end
            if len == 3 then callBack(newParam[1],newParam[2],newParam[3]); end
            if len == 4 then callBack(newParam[1],newParam[2],newParam[3],newParam[4]); end
            if len == 5 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5]); end
            if len == 6 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5],newParam[6]); end
            if len == 7 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5],newParam[6],newParam[7]); end
            if len == 8 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[6],newParam[6],newParam[7],newParam[8]); end
        end
    end
    local needHandleEnded = true;
    local needHandleMoveOut = true;
    local needHandleMove = true;
    local beginPoint = nil;    
    local function touchCallBack(target, type)
        --已不需要该回调
        if target.widgetTouchExtentInfo == nil then return end;     
        --若没设置pixNumIgnoreEnded的值，才会响应moveOutCallBack
        if type == ccui.TouchEventType.canceled then
            if target.widgetTouchExtentInfo.needPressScale then      
                if root  then
                    root:setScaleX(srcScaleX);
                    root:setScaleY(srcScaleY);
                else              
                    target:setScaleX(srcScaleX);
                    target:setScaleY(srcScaleY);
                end
            end
            needHandleEnded = false;
            Logger:out("widgetTouchExtent: canceled")
            if target.widgetTouchExtentInfo.moveOutCallBack ~= nil and needHandleMoveOut then
                callBack = target.widgetTouchExtentInfo.moveOutCallBack.callBack;
                param = target.widgetTouchExtentInfo.moveOutCallBack.param;
                handleCallBack(target);                
            end
            --都取消了
            needHandleEnded = false;
            needHandleMoveOut = false;
            needHandleMove = false;
        end    
        if type == ccui.TouchEventType.began then
            beginPoint = target:getTouchBeganPosition();
            --再次点击，就需要把这几个变量重置
            needHandleEnded = true;
            needHandleMoveOut = true;
            needHandleMove = true;
            if target.widgetTouchExtentInfo.needPressScale then
                if root then
                    root:setScaleX(srcScaleX * target.widgetTouchExtentInfo.needPressScale);
                    root:setScaleY(srcScaleY * target.widgetTouchExtentInfo.needPressScale); 
                else
                    target:setScaleX(srcScaleX * target.widgetTouchExtentInfo.needPressScale);
                    target:setScaleY(srcScaleY * target.widgetTouchExtentInfo.needPressScale);
                end
            end
            if target.widgetTouchExtentInfo.beganCallBack ~= nil then
                Logger:out("widgetTouchExtent: began. name=" .. tostring(target:getName()))
                callBack = target.widgetTouchExtentInfo.beganCallBack.callBack;
                param = target.widgetTouchExtentInfo.beganCallBack.param;
                handleCallBack(target);
            end         
        end
        if type == ccui.TouchEventType.moved then
            if target.widgetTouchExtentInfo.movedCallBack ~= nil and needHandleMove then
                Logger:out("widgetTouchExtent: moved".. tostring(target:getName()))
                callBack = target.widgetTouchExtentInfo.movedCallBack.callBack;
                param = target.widgetTouchExtentInfo.movedCallBack.param;
                handleCallBack(target);
            end
            local movePoint = target:getTouchMovePosition();
            local dis = cc.pGetDistance(beginPoint, movePoint);
            if dis > target.widgetTouchExtentInfo.pixNumIgnoreEnded  then
                if target.widgetTouchExtentInfo.needPressScale then 
                    if root then
                        root:setScaleX(srcScaleX);
                        root:setScaleY(srcScaleY);  
                    else
                        target:setScaleX(srcScaleX);
                        target:setScaleY(srcScaleY);
                     end
                end
                needHandleEnded = false;
                if target.widgetTouchExtentInfo.moveOutCallBack ~= nil and needHandleMoveOut then
                    Logger:out("widgetTouchExtent: moved out".. tostring(target:getName()))
                    callBack = target.widgetTouchExtentInfo.moveOutCallBack.callBack;
                    param = target.widgetTouchExtentInfo.moveOutCallBack.param;
                    handleCallBack(target);
                    needHandleMoveOut = false; 
                end
                needHandleMove = false;
            end
        end
        if type == ccui.TouchEventType.ended then
            if target.widgetTouchExtentInfo.needPressScale then
                if root then
                    root:setScaleX(srcScaleX); 
                    root:setScaleY(srcScaleY);
                else
                    target:setScaleX(srcScaleX);
                    target:setScaleY(srcScaleY);
                end
            end
            if needHandleEnded == false then
                needHandleEnded = true;
                return;
            end
            if target.widgetTouchExtentInfo.endedCallBack ~= nil then
                --放音效 
                if target.sound ~= nil then
                    if target.sound ~= "" then
                        --SoundManager:playEffect(target.sound);
                    end
                else
                    --SoundManager:playEffect("sound/button.mp3");
                end                
                Logger:out("widgetTouchExtent ended." .. tostring(target:getName()));
                callBack = target.widgetTouchExtentInfo.endedCallBack.callBack;
                param = target.widgetTouchExtentInfo.endedCallBack.param;
                handleCallBack(target);
            end
        end 
    end    
    target:setTouchEnabled(true);
    target.addedTouchEventListener = true;
    target:addTouchEventListener(touchCallBack);
    target:setSwallowTouches(swallowTouch);--是否吞
    return target;
end

local function createImage(path)
    local img = ccui.ImageView:create(); 
    --print(path)       
    --Logger:out("加载" .. "artText_" .. prefix .. word .. ".png");
    img._objectPath = path
    img:loadTexture(path, ccui.TextureResType.plistType)
    return img
end

--str：待生成图片的完整数值
--prefix：对应artText包里的前缀。如：uiNum3
--eachCharWidth：每个数字对应的间隔。默认15
--align：对齐方式。"left"或"center"。默认"left"
--oriSpr:生成这些数字的容器，不填写则会自动生成个sprite作为容器，最后返回
function UIManager:createImageString(str, prefix, eachCharWidth,align,oriSpr)
    if align == nil then align = "left" end;
    if eachCharWidth == nil then eachCharWidth = 15 end;
    --从artText获取
    local spr = cc.Sprite:create();
    --Logger:out(tostring(str));
    --Logger:out("即将将此str显示为美术数字:" .. str)
    local len = string.len(str);
    local curX = 0;    
    local totalWidth = len * eachCharWidth;
    if align == "center" then
        curX = -totalWidth * 0.5;
    end
    if oriSpr then
        spr = oriSpr;
    end
    
    for i=1,len,1 do
        local word = string.sub(str,i,i)
        local path = "artText_" .. prefix .. word .. ".png"
        local img = self:getNodeFromCache(path,createImage)
        spr:addChild(img);
        img:setName("artText_" .. prefix .. word);  
        img.isNum = true;
        img:setPosition(cc.p(curX + eachCharWidth/2, 0));
        curX = curX + eachCharWidth;   
        totalWidth = totalWidth + eachCharWidth;   
    end
    --spr:setName("damageNumber")
    spr:setCascadeOpacityEnabled(true)
    spr.prefix = prefix;
    spr.len = len;
    spr.str = str;
    spr.eachCharWidth = eachCharWidth;
    spr.align = align;
    return spr;
end

function UIManager:jointDamageValue(param)
    local node = cc.Node:create()
    node:setCascadeOpacityEnabled(true)
    local imgValue
    local imgText = ccui.ImageView:create()
    local imgSymbol = ccui.ImageView:create()
    -- 0 一般认为是伤害
    if param.value <= 0 then
        if param.isSkill == true then -- 技能
            imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigYellow, Config_GameData.artFonts.bigInterval)
            if param.isCri == true then -- 暴击
                imgText:loadTexture(Config_UIPath.battle.skillCri, ccui.TextureResType.plistType)
            end
            imgSymbol:loadTexture(Config_UIPath.battle.skillSub, ccui.TextureResType.plistType)
        else -- 普攻
            imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigRed, Config_GameData.artFonts.bigInterval)
            if param.isCri == true then
                imgText:loadTexture(Config_UIPath.battle.normalCri, ccui.TextureResType.plistType)
            end
            imgSymbol:loadTexture(Config_UIPath.battle.normalSub, ccui.TextureResType.plistType)
        end
    else -- 治疗
        imgValue = UIManager:createImageString(math.abs(param.value), Config_GameData.artFonts.bigGreen, Config_GameData.artFonts.bigInterval)
        if param.isCri == true then
            imgText:loadTexture(Config_UIPath.battle.healCri, ccui.TextureResType.plistType)
        end
        imgSymbol:loadTexture(Config_UIPath.battle.healAdd, ccui.TextureResType.plistType)
    end
    local len = string.len(math.abs(param.value))
    imgValue:setContentSize(len*Config_GameData.artFonts.bigInterval, 0)
    node:addChild(imgValue)
    if param.isCri == true then
        node:addChild(imgText)
    end
    node:addChild(imgSymbol)
    local totalWidth = 0
    for k, v in pairs(node:getChildren()) do
        totalWidth = v:getContentSize().width + totalWidth
    end
    if param.isCri == true then
        imgText:setPositionX(-totalWidth/2 + imgText:getContentSize().width/2)
        imgSymbol:setPositionX(-totalWidth/2 + imgText:getContentSize().width + imgSymbol:getContentSize().width / 2)
    else
        imgSymbol:setPositionX(-totalWidth/2 + imgSymbol:getContentSize().width / 2)
    end
    local offset = 13
    imgValue:setPositionX(imgSymbol:getPositionX() + imgSymbol:getContentSize().width / 2 + offset + imgValue:getContentSize().width/2)
    -- imgText:setPosition(0,0)
    -- imgSymbol:setPosition(0,0)
    -- imgValue:setPosition(0,0)
    return node
end

--tab,tab,tab...支持多个高亮区域多个回调。
--tab的结构：x、y、size(width与height的table)，anchorPoint，callBack{callBack=cb, param="123", showTime=11},dir(箭头指示方向，1~4表示上下左右)、是否显示箭头，touchMoveDis（拖拽距离，即抬手时距离按下时的距离像素，格式cc.p(x,y)。默认nil）
--注意，当showTime不为nil时，在目标处闪烁，不需要用户点击，而是延时到指定时间后执行callBack
function UIManager:showNewBieHelp(...)
    --Logger:out("UIManager:alignLeftExcept(parent,...)=========")
    
    --关掉一切MessageBox
    UIManager:removeUI(nil, Config_UI.MESSAGEBOX.name);
    local arg = {...}
    --Logger:dump(arg)
    local view = arg[1];
    if view == nil then
        view = GameGlobal.sceneContext;
        if view == nil then
            view = cc.Director:getInstance():getRunningScene();
        end
        arg[1] = view;
    end
    table.remove(arg,1);

    
    local n = #arg; 
    if n == 0 then return end;

    local highLightArea; 
    local rect = {};
    --加个黑遮罩，以便挡住下面的层，不可点击
    local viewPosX, viewPosY = view:getPosition(); 
    local touchNodes = {};
    local tipNodes = {};
    local data;
    local function handleCallBack()
            SoundManager:playEffect("sound/button.mp3");
            Logger:out("UIManager showNewBieHelp handleCallBack()");
            Logger:dump(data.callBack);
            if data.callBack ~= nil then     
                local callBack = data.callBack.callBack;
                local newParam = data.callBack.param;
                local len = 0;
                if newParam ~= nil then
                    len = table.maxn(newParam);
                end 
                Logger:out("UIManager showNewBieHelp handleCallBack() len=" .. len);
                if len == 0 then callBack(newParam); end
                if len == 1 then callBack(newParam[1],newParam[2]); end
                if len == 2 then callBack(newParam[1],newParam[2]); end
                if len == 3 then callBack(newParam[1],newParam[2],newParam[3]); end
                if len == 4 then callBack(newParam[1],newParam[2],newParam[3],newParam[4]); end
                if len == 5 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5]); end
                if len == 6 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5],newParam[6]); end
                if len == 7 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[5],newParam[6],newParam[7]); end
                if len == 8 then callBack(newParam[1],newParam[2],newParam[3],newParam[4],newParam[6],newParam[6],newParam[7],newParam[8]); end            
            end           
        end
    local function clearNewBieHelp(clearMaskTo)        
        view:removeChild(highLightArea);    
        view:removeChild(UIManager.newBieMask);
        UIManager.newBieMask = nil;
        for i = 1, #touchNodes do
            view:removeChild(touchNodes[i]);
            view:removeChild(tipNodes[i]);
        end
        if UIManager.newBieHelpHighLightAreaAniScheduleId ~= nil then
             
            cc.Director:getInstance():unscheduleScriptEntry(UIManager.newBieHelpHighLightAreaAniScheduleId)
            UIManager.newBieHelpHighLightAreaAniScheduleId = nil;
        end
    end
    local function wrongTouch() 
        if arg[1][5].showTime ~= nil then
            --有时间的
            if UIManager.newBieHelpHighLightAreaAniScheduleId then
                cc.Director:getInstance():unscheduleScriptEntry(UIManager.newBieHelpHighLightAreaAniScheduleId)

            end
            UIManager.newBieHelpHighLightAreaAniScheduleId = nil; 
            clearNewBieHelp();
            handleCallBack();
            return
        end
        local scale = 5; 
        local opacity = 0.6; 
        local index = 0.3;     
        local function draw()
            if scale <= 1 then
                index = index + index;
                opacity = opacity - 0.01 * index;
                scale = scale + 0.2;
            end
            scale = scale - 0.6;
            if opacity < 0 then opacity = 0; end
            if scale < 1 then scale = 1; end;
            highLightArea:initBlend({contentSize = {width=UIManager.ActualDesignSize.width, height = UIManager.ActualDesignSize.height}, position=cc.p(UIManager.CenterX, UIManager.CenterY), bgOpacity=opacity, rectArray=rect, highLightScale = scale});
            if  opacity == 0 and scale == 1 then
                if UIManager.newBieHelpHighLightAreaAniScheduleId then
                     cc.Director:getInstance():unscheduleScriptEntry(UIManager.newBieHelpHighLightAreaAniScheduleId)
                end
                UIManager.newBieHelpHighLightAreaAniScheduleId = nil;
            end
        end
        if UIManager.newBieHelpHighLightAreaAniScheduleId == nil then

            --UIManager.newBieHelpHighLightAreaAniScheduleId = scheduler.scheduleGlobal(draw,0.05)
        end              
    end
    local mask =  UIManager:createRect(view, cc.rect(-2*UIManager.frameSize.width,-2*UIManager.frameSize.height,UIManager.frameSize.width*4, UIManager.frameSize.height*4),{fillColor=cc.c4f(0,0,0,0), borderColor=cc.c4f(0,0,0,0),borderWidth=1},wrongTouch,nil,nil,Config_GameData.lZorder.newbieHelper.mask);    
    mask:setSwallowTouches(true)
    UIManager.newBieMask = mask;
    

    local function createTipAndTouchEvent(i, da)
        data = da;
        
        local tmpTouchNode = ccui.ImageView:create();
        tmpTouchNode:loadTexture("common_heiquan.png", ccui.TextureResType.plistType);
        tmpTouchNode:setPosition(data.x + data.width * 0.5, data.y + data.height * 0.5);
        tmpTouchNode:setOpacity(0);
        local touchNodeSize = tmpTouchNode:getContentSize();
        local widthPara = 1.4142 / touchNodeSize.width
        local heightPara = 1.4142 / touchNodeSize.height
        local scaleX = widthPara * data.width
        local scaleY = heightPara * data.height

        tmpTouchNode:setScale(scaleX, scaleY);
        view:addChild(tmpTouchNode);
        local touchBeginPoint = nil;
        local function began(target)
            Logger:out("UIManager showNewBieHelp() began called...")
            touchBeginPoint = target:getTouchBeganPosition();
        end        
        local function ended(target)
            Logger:out("UIManager showNewBieHelp() ended called...")
            Logger:dump(data);
            --判断是否需要移动距离达到多少才算点击
            if data.touchMoveDis ~= nil then
                local newPos = target:getTouchEndPosition();
                local xFit = true; 
                local yFit = true;
                if data.touchMoveDis.x > 0 and (newPos.x - touchBeginPoint.x) < data.touchMoveDis.x then
                    xFit = false
                end 
                if data.touchMoveDis.x < 0 and (newPos.x - touchBeginPoint.x) > data.touchMoveDis.x then
                    xFit = false;
                end
                if data.touchMoveDis.y > 0 and (newPos.y - touchBeginPoint.y) < data.touchMoveDis.y then
                    yFit = false
                end 
                if data.touchMoveDis.y < 0 and (newPos.y - touchBeginPoint.y) > data.touchMoveDis.y then
                    yFit = false;
                end 
                if xFit == false or yFit == false then
                    Logger:out("xFit or yFit false, return!!!!!!!");
                    return
                end 
            end            
            --如果是时间显示的，点击就跳过了
            if data.callBack.showTime ~= nil then
               wrongTouch();
                return
            end
            clearNewBieHelp();
            handleCallBack();           
        end
        tmpTouchNode:setName("newBie touch Widget");

        param = {
            target = tmpTouchNode,
            endedCallBack = {callBack = ended},
            beganCallBack = {callBack = began},
        }                     
        touchNodes[i] = UIManager:widgetTouchExtent(param);
        
        tmpTouchNode:setLocalZOrder(Config_GameData.lZorder.newbieHelper.touch);
        
		local node = ccui.ImageView:create();
        node:loadTexture("common_yindaojiantou.png", ccui.TextureResType.plistType);
        node:setAnchorPoint(0.8,0.5);
        if data.showArrow ~= nil and data.showArrow == false then
            node:setVisible(false);
        else
            node:setVisible(true);
        end        
        tipNodes[i] = node;
        view:addChild(node);
        --上下左右1~4
        local tarX;
        local tarY;
        local action;

        local tarPos;
        local tarRotation;
        
        if data.dir == 1 then
            tarX = data.x + data.width * 0.5;
            tarY = data.y + data.height * 0.5 + 50;
            tarPos = cc.p(tarX, tarY);
            tarRotation = 90;
            --node:setPosition(tarX, tarY);
            --node:setRotation(180);
            action = cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.2,{x=0, y=10}),cc.MoveBy:create(0.2,{x=0, y=-10})));
        elseif data.dir == 3 then
            tarX = data.x;
            tarY = data.y + data.height * 0.5;
            tarPos = cc.p(tarX, tarY);
            tarRotation = 0;
            --node:setPosition(tarX, tarY);
            action = cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.2,{x=-10, y=0}),cc.MoveBy:create(0.2,{x=10, y=0})));
        elseif data.dir == 2 then
            tarX = data.x + data.width * 0.5;
            tarY = data.y;
            tarPos = cc.p(tarX, tarY);
            tarRotation = -90;
            --            node:setPosition(tarX, tarY);
            action = cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.2,{x=0, y=-10}),cc.MoveBy:create(0.2,{x=0, y=10})));
        elseif data.dir == 4 then
            tarX = data.x + data.width;
            tarY = data.y + data.height * 0.5;            
            tarPos = cc.p(tarX, tarY);
            tarRotation = 180;
            --            node:setPosition(tarX, tarY);
            action = cc.RepeatForever:create(cc.Sequence:create(cc.MoveBy:create(0.2,{x=10, y=0}),cc.MoveBy:create(0.2,{x=-10, y=0})));
        end   
        action:retain();     
        node:setPosition(GameGlobal.newBieProxy.newbieArrowPos.x, GameGlobal.newBieProxy.newbieArrowPos.y);
        node:setRotation(GameGlobal.newBieProxy.newbieArrowRotation);        
        node:stopAllActions();
        local function com()
            node:runAction(action);
            action:release();
            GameGlobal.newBieProxy.newbieArrowPos.x = node:getPositionX();
            GameGlobal.newBieProxy.newbieArrowPos.y = node:getPositionY();
            GameGlobal.newbieArrowRotation = node:getRotation();
			NEWBIEWIDGET = {callback = function()
			if GameGlobal:checkObjIsNull(tmpTouchNode) then return end
				began(tmpTouchNode)
				ended(tmpTouchNode)
			end,widget = tmpTouchNode}
        end
        local duration = 0.1;
        --求两点之间距离，duration最大为0.5
        duration = cc.pGetDistance(cc.p(node:getPosition()),cc.p(tarPos.x, tarPos.y)) / 100 * duration
        if duration < 0.1 then duration = 0.1; end
        if duration > 0.3 then duration = 0.3; end
        local moveAction  = cc.Sequence:create(
            cc.Spawn:create(cc.EaseOut:create(cc.MoveTo:create(duration,{x=tarPos.x, y=tarPos.y}), 0.9), cc.RotateTo:create(0.2,tarRotation)),
            cc.CallFunc:create(com)
        )
        node:runAction(moveAction);
		
        data.hasFilter = false;         
        local function blink()
            data.callBack.showTime = data.callBack.showTime - 0.5;
            if data.callBack.showTime <= 0 then
                if UIManager.newBieHelpHighLightAreaAniScheduleId then
                    cc.Director:getInstance():unscheduleScriptEntry(UIManager.newBieHelpHighLightAreaAniScheduleId)
               end
               UIManager.newBieHelpHighLightAreaAniScheduleId = nil; 
               clearNewBieHelp();
               handleCallBack();
               return
            end 
            if data.hasFilter then
                highLightArea:setVisible(true);
                data.hasFilter = false;
            else            
                highLightArea:setVisible(false);
                data.hasFilter = true;
            end
        end
        if data.callBack ~= nil and data.callBack.showTime ~= nil then
            --UIManager.newBieHelpHighLightAreaAniScheduleId = scheduler.scheduleGlobal(blink, 0.5) 
        end
    end
    for i=1,n do
        local tmp = {};
        if arg[i][3].width < 10 then arg[i][3].width = 100 end;
        if arg[i][3].height < 10 then arg[i][3].height = 100 end;
        tmp.x = arg[i][1] - arg[i][3].width * arg[i][4].x;
        tmp.y = arg[i][2] - arg[i][3].height * arg[i][4].y;
        tmp.width = arg[i][3].width;
        tmp.height = arg[i][3].height;
        tmp.callBack = arg[i][5];       
        tmp.dir = arg[i][6];
        if tmp.dir == nil then tmp.dir = 4; end;
        tmp.showArrow = arg[i][7];
        tmp.touchMoveDis = arg[i][8];
        table.insert(rect, i, tmp);
    end
    if rect[1].callBack.showTime == nil then
        --不是特定时间内闪烁的
        highLightArea = require ("app.utils.HighLightArea"):createBlend({contentSize = {width=UIManager.ActualDesignSize.width, height = UIManager.ActualDesignSize.height}, position=cc.p(UIManager.CenterX, UIManager.CenterY), bgOpacity=0, rectArray=rect});
        view:addChild(highLightArea);
    else
        --特定时间内闪烁的，创建这货：
        highLightArea = ccui.ImageView:create();
        highLightArea:loadTexture("common_xuanzekuang.png", ccui.TextureResType.plistType)
        view:addChild(highLightArea);
        highLightArea:setScale9Enabled(true); 
        highLightArea:setCapInsets(cc.rect(10,10,10,10) );
        highLightArea:setContentSize( rect[1].width,  rect[1].height);
        highLightArea:setPosition(rect[1].x + rect[1].width * 0.5, rect[1].y + rect[1].height * 0.5);
        --从大到小动一下，以免看不清他在哪闪烁
        highLightArea:setScale(5);
        local action = cc.ScaleTo:create(0.2,1);
        highLightArea:runAction(action);
    end   
    for i=1,n do
        createTipAndTouchEvent(i, rect[i]); 
    end
end

-- 用label来承载editbox的内容，主要是为了支持换行！
-- 退出的时候要调用unregisterScriptEditBoxHandler()
-- label 承载editbox的label控件
-- size  宽高
-- fontSize 字体大小
-- len 输入内容的长度
function UIManager:createEditBoxWithLabel(label, size, fontSize, len, returnCb,widget,beganCb,changeCb) 
    -- local editBox = ccui.EditBox:create(size, ccui.Scale9Sprite:create("common_dikuang.png"))
    local editBox = ccui.EditBox:create(size, "common_dikuang.png")
    editBox:setFontSize(fontSize)
    if len then
        editBox:setMaxLength(len)
    end
    editBox:setCascadeOpacityEnabled(true)
    editBox:setOpacity(0);

    if  GameGlobal:getCurPlatForm() == cc.PLATFORM_OS_ANDROID  then
        editBox:setFont("Helvetica",2);
    elseif GameGlobal:getCurPlatForm() == cc.PLATFORM_OS_IPAD or  GameGlobal:getCurPlatForm() == cc.PLATFORM_OS_IPHONE then
        editBox:setFont("Helvetica",0);
    end

    local function textHandler( event )
        if event == "began" then
            Logger:out("..text handler began ..")
            editBox:setText(label:getString())
            if beganCb then
                beganCb.callBack(beganCb.params)
            end
        end
        if event == "changed" then
            Logger:out("..text handler changed ..")
            local str = editBox:getText()
            local subStr = StringUtil:SubUTF8String(str,1,len) 
            label:setString(subStr)
            if changeCb then
                changeCb.callBack(changeCb.params)
            end
        end
        if event == "return" then
            Logger:out("..text handler return ..")
            local str = editBox:getText()
            local subStr = StringUtil:SubUTF8String(str,1,len) 
            label:setString(subStr)
            editBox:setText("")
            if returnCb ~= nil then
                returnCb.callBack(returnCb.params)
            end

        end
    end
    editBox:registerScriptEditBoxHandler(textHandler)
    return editBox
            
end
--说明：让tableView像pageView那样，每次滚动一页。使用此方法，tableview的默认touch事件将会被屏蔽。tableview:setTouchEnabled(false)
--tableview:传入tableView对象
--pos:tableview当前的x、y坐标。需要用cc.p(x,y)格式的table。如果不传此参数，则使用传入的tableview的position
--size:这个tableView单个cell的大小。需要cc.size(width,height)格式的table，如果不传此参数，则使用传入的tableview的position
--cellNum:总共有多少个cell
--pageScrollPercent:希望划过百分比多少时，发生滚动（默认0.3）
--curCellChangedCallBack:当前Cell发生了改变的回调，同时回传cell对象
function UIManager:createTableViewScrollAsPageView(tableview, size, pos, cellNum, pageScrollPercent, curCellChangedCallBack)
    local container = tableview:getParent();
    tableview:setTouchEnabled(false);
    if pageScrollPercent == nil then pageScrollPercent = 0.3; end;
    if pos == nil then pos = cc.p(tableview:getPosition()); end
    if size == nil then size = tableview:getContentSize(); end
    local touchRectLastMovePoint = nil;
    local tableViewTouchCurOffset = nil;
    local disPos = nil; 
    local function updateCurrentCell(pos)
        local twidth = size.width;
        local w = math.abs(math.floor((tableview:getContentOffset().x)/ twidth)); 
        if w < 0 then w = 0 end;
        if w > cellNum - 1 then w = cellNum - 1;end;   
        local current_cell = tableview:cellAtIndex(w);
        Logger:out("updateCurrentCell:" .. w);
        if curCellChangedCallBack ~= nil then curCellChangedCallBack(current_cell,pos) end;          
    end
    local function forceTableViewScroll(inc, needAni)
        if inc == nil then inc = 0; end;
        if needAni == nil then needAni = true; end;
        local twidth = size.width
        --找到最近的滚动点
        local w = math.abs(math.floor((tableview:getContentOffset().x )/ twidth)) + inc;
        if w < 0 then w = 0 end;
        if w > cellNum - 1 then w = cellNum - 1;end;   
        tableview:setContentOffset(cc.p(-w * twidth,0), needAni); 
    end
    local function rectTouchEnded(touch,event)
        if touchRectLastMovePoint == nil then return end;    --不复原
        --复原
        tableview:setContentOffset(cc.p(tableViewTouchCurOffset,0),true);   
        touchRectLastMovePoint = nil;
        updateCurrentCell(disPos); 
    end
    local function rectTouchBegan(touch, event)    
        --找到最近的滚动点
        forceTableViewScroll(nil, false);
        touchRectLastMovePoint = touch:getLocation();
        tableViewTouchCurOffset = tableview:getContentOffset().x;
    end
    local function rectTouchMoved(touch, event)
        if touchRectLastMovePoint == nil then return end
        local curPoint = touch:getLocation();
        local offsetX = touchRectLastMovePoint.x - curPoint.x;
        touchRectLastMovePoint = curPoint;
        local resultX = tableview:getContentOffset().x - offsetX;
        local twidth =  size.width;
        --左滑
        if resultX - tableViewTouchCurOffset < 0 and  resultX - tableViewTouchCurOffset < -twidth * pageScrollPercent then
            forceTableViewScroll();
            touchRectLastMovePoint = nil;
            disPos = tableViewTouchCurOffset/twidth
        elseif resultX - tableViewTouchCurOffset < 0 and resultX - tableViewTouchCurOffset < -twidth * pageScrollPercent then
            forceTableViewScroll();
            touchRectLastMovePoint = nil;
            disPos = tableViewTouchCurOffset/twidth + 1;
        end
        --右滑 
        if resultX - tableViewTouchCurOffset > 0 and  resultX - tableViewTouchCurOffset >  twidth *  pageScrollPercent then            
            forceTableViewScroll(-1);
            touchRectLastMovePoint = nil;
            disPos = tableViewTouchCurOffset/twidth
        end
        tableview:setContentOffset(cc.p(resultX,0));
    end

    local rect = UIManager:createRect(container, cc.rect(pos.x + UIManager.rightShiftPx, pos.y, size.width, size.height),{fillColor=cc.c4f(255,255,255,50), borderColor=cc.c4f(0,0,0,0),borderWidth=1}, rectTouchEnded, rectTouchBegan, rectTouchMoved);
    return rect;
end
function UIManager:removeTableViewScrollAsPageView(rect, tableview)
    if rect ~= nil then 
        rect:removeFromParent();
        rect = nil
    end
    tableview:setTouchEnabled(true);
end

-- 实现对话的打字机效果 如果对话中有空格，用全角的空格，否则换行时会出错
-- lable 文本框   str 文本  len按长度换行 为nil时维持原格式
function UIManager:typewriterEffect( label, str, len, dt, cb )
    self.typewriterTick = 1
    local resultStr = str
    if len ~= nil then
        resultStr = StringUtil:changeLineByLen(str, len)
    end
    local tab = {}
    for uchar in string.gmatch(resultStr, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
    local function tick( dt )
        if self.typewriterTick > #tab then
            scheduler.unscheduleGlobal(self.schedulerTypewiter)
            self.schedulerTypewiter = nil
            if cb ~= nil then
                cb()
            end
            return
        end
        -- local tmpStr = string.sub(resultStr, 1, self.typewriterTick)
        local tmpStr = StringUtil:SubUTF8String(tab, 1, self.typewriterTick)
        label:setString(tmpStr)
        self.typewriterTick = self.typewriterTick + 1
    end
    if self.schedulerTypewiter == nil then
        self.schedulerTypewiter = scheduler.scheduleGlobal(tick, dt)
    end
    local function onNodeEvent(event)
        if "exit" == event then
            UIManager:stopTypewriter()
        end
    end
    label:registerScriptHandler(onNodeEvent)
end
-- 停止对话的打字机效果
function UIManager:stopTypewriter(label, str, len)
    if label ~= nil then
        local resultStr = str
        if len ~= nil then
            resultStr = StringUtil:changeLineByLen(str, len)
        end
        label:setString(resultStr)
    end
    if self.schedulerTypewiter ~= nil then
        scheduler.unscheduleGlobal(self.schedulerTypewiter)
        self.schedulerTypewiter = nil
    end
end

--node clone
function UIManager:NodeCLone(node)

    local NewNode = cc.Node:create()
    NewNode:setAnchorPoint(cc.p(node:getAnchorPoint()));
    NewNode:setName(node:getName());
    NewNode:setPosition(node:getPosition());
    NewNode:setContentSize(node:getContentSize());
    NewNode:setScaleX(node:getScaleX());
    NewNode:setScaleY(node:getScaleY());
    NewNode:setRotation(node:getRotationSkewX());

    --将Node的孩子挂到widget上
    local children = node:getChildren();
    local len = table.getn(children)
    local name ={"logo_diwen","Image_1"}

    print("len:",len)
    for i = 1, len, 1 do
        --print("children[i]:",children[i],type(children[i]),children[i]:getName())
        --dump(children[i])
        local child1  = node:getChildByName(name[i])
        local child =  (tolua.cast(child1,"ccui.ImageView"))
        local wChild = child.clone()      
        NewNode:addChild(wChild,children[i]:getLocalZOrder(),children[i]:getTag());
       
    end

    return NewNode;

end 

function UIManager:replaceNodeWithWidget(node)
    local widget = ccui.Widget:create();
    widget:setAnchorPoint(cc.p(node:getAnchorPoint()));
    widget:setName(node:getName());
    widget:setPosition(node:getPosition());
    widget:setContentSize(node:getContentSize());
    widget:setScaleX(node:getScaleX());
    widget:setScaleY(node:getScaleY());
    widget:setRotation(node:getRotationSkewX());

    --将Node的孩子挂到widget上
    local children = node:getChildren();
    local len = table.getn(children)
    for i = 0, len-1, 1 do
        local child = children[i + 1];      
        child:retain();
        node:removeChild(child);
        widget:addChild(child);
        child:release();
    end

    --从父节点摘除
    local parent = node:getParent();
    local zOrder = node:getLocalZOrder();
    if parent ~= nil then
        parent:addChild(widget, zOrder);
        parent:removeChild(node);
    end

    --目标widget里的孩子若有node，继续转
    local wChildren =  widget:getChildren();
    for i = 1, #wChildren do
        local child = wChildren[i];
        if not child.setLayoutParameter then
            UIManager:replaceNodeWithWidget(child);
        end
    end

    return widget;
end 


--字体描边
--ccuitext：  需要text或button
--c4b：  描边的颜色，需要cc.c4b。默认是略透的黑色：cc.c4b(0,0,0,200);
--ttfPath： 嵌入的字体路径（如：simhei.ttf）。若不填，默认就是simhei.ttf
--outLineThick: 描边粗细，默认1
function UIManager:fontStoke(ccuitext,c4b, ttfPath, outLineThick)  
    if c4b == nil then c4b = cc.c4b(0,0,0,200) end;
    if ttfPath == nil then ttfPath = "simhei.ttf" end
    if outLineThick == nil then outLineThick = 1 end;
    local render = nil;
    local size = nil;
    local needKerning = MultiVersionUIHelper:getAdditionalKerning( )
    if ccuitext.getString  then
        if ccuitext.setFontName then
            ccuitext:setFontName("simhei.ttf");
        end
        ccuitext:enableOutline(c4b,outLineThick);
        local labelRender = nil
        if needKerning then
            if ccuitext.getVirtualRenderer then
                labelRender = ccuitext:getVirtualRenderer()
            else
                labelRender = ccuitext
            end

            if labelRender.setAdditionalKerning then
                local fontSize = labelRender:getTTFConfig().fontSize
                local interval = -math.ceil(fontSize * 0.1)
                labelRender:setAdditionalKerning(interval)
            end

        else
            if ccuitext.getVirtualRenderer then
                ccuitext:getVirtualRenderer():setAdditionalKerning(-1.5) -- 默认为-1的描边字间距
            end
        end
        return;
    elseif ccuitext.getTitleText then --按钮上的文字需要转换render为label然后再调用ttfconfig
        render = ccuitext:getTitleRenderer()
        size = ccuitext:getTitleFontSize();
    end
    render = tolua.cast(render,"cc.Label")
    --描边
    local ttfConfig = render:getTTFConfig()
    ttfConfig.fontSize = size 
    ttfConfig.outlineSize = 0
    ----    ttfConfig.customGlyphs = nil
    --    ttfConfig.glyphs   = cc.GLYPHCOLLECTION_DYNAMIC
    ttfConfig.fontFilePath = ttfPath;
    render:setTTFConfig(ttfConfig)
    --  render:enableGlow(cc.c4b(0, 0, 0, 165))
    render:enableOutline(c4b, outLineThick)
    if needKerning then     
        render:setAdditionalKerning(-math.ceil(size * 0.1))
    else
        render:setAdditionalKerning(-1.5) -- 默认为-1的描边
    end
end
-- 如果要在该界面加入返回键功能，调用此方法
function UIManager:addBackKey( view )
	if Config_Sys.isClientKeyBack then
		self:addBackViewKey(view)
		return true
	end
    local klistener = cc.EventListenerKeyboard:create()
    local function releaseKey( keyCode, target)       
        --正在切场景，点击返回键没反应
        if GameGlobal.repalcingScene then return end;
        --新手引导中，点返回键没有效
        if (not GameGlobal:checkObjIsNull(UIManager.newBieMask)) then return end;         
        if keyCode == cc.KeyCode.KEY_BACK then
            if UIManager.keyBackTouched == true then 
                return
            end
            if view.setBattlePause ~= nil then
                view:setBattlePause(true)
            end
            UIManager.keyBackTouched = true
            local function finish(  )
                UIManager.keyBackTouched = false
                cc.Director:getInstance():endToLua()
            end
            local function closeCb(  )
                UIManager.keyBackTouched = false
                if view.setBattlePause ~= nil then 
                    view:setBattlePause(false)
                end
            end
            local function retry(  )
                UIManager.keyBackTouched = false
                GameGlobal.gameSocket:returnToLogin()
            end
            --没有sdk点返回键需求的，显示游戏自己的
           if not GameGlobal.sdkManager:checkNeedSdkExit() then 
                local param = {
                    layer = cc.Director:getInstance():getRunningScene(),
                    uiName = require("data.manual.Config_UI").MESSAGEBOX.name,
                    logicParam = {id="EXIT", fun1=retry, fun2=finish, closeCb = closeCb},
                };
                UIManager:addUI(param);

            else 
                --显示sdk需要的退出界面
                    --if  then 
                                 UIManager.keyBackTouched = false
                                local ok ,strPay = GameGlobal.sdkManager:sdkExit(view)
                                --print("ok ,strPay -----------------",ok ,strPay )
                    --end 
                  
            end 

        end
    end
    klistener:registerScriptHandler(releaseKey, cc.Handler.EVENT_KEYBOARD_RELEASED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(klistener, view)
end

function UIManager:addMouseEvent(view)
    -- cc.Handler.EVENT_MOUSE_DOWN       = 48
    -- cc.Handler.EVENT_MOUSE_UP         = 49
    -- cc.Handler.EVENT_MOUSE_MOVE       = 50
    -- cc.Handler.EVENT_MOUSE_SCROLL     = 51
  local dispatcher  =  view:getEventDispatcher();
  local listener = cc.EventListenerMouse:create();
    listener:registerScriptHandler(function ( touch, event )
        print("mouseDown!")
    end,cc.Handler.EVENT_MOUSE_DOWN )
    listener:registerScriptHandler(function ( touch, event )
        print("mouseUp!")
    end, cc.Handler.EVENT_MOUSE_UP)    
    listener:registerScriptHandler(function ( touch, event )
        print("mouseMove!")
    end, cc.Handler.EVENT_MOUSE_MOVE)    
    listener:registerScriptHandler(function ( touch, event )
        print("mouseScroll!")
    end, cc.Handler.EVENT_MOUSE_SCROLL)    
    dispatcher:addEventListenerWithSceneGraphPriority(listener, view);    
    view.mouseDispatcher = dispatcher;
end
function UIManager:removeMouseEvent(view)
    if view.mouseDispatcher then
        view.mouseDispatcher:removeEventListener();
    end
end

-- 直接在代码中用路径加载单个图片的方法封装
--例子：  UIManager:addLocalPic(self.view:getChildByName("body"), "heroBodyBig/heroBodyBig_1001", ccui.TextureResType.localType, "png")
function UIManager:addLocalPic( sprite,filePath,type,picType)
    if type == nil then type = ccui.TextureResType.localType; end
    if picType == nil then picType = "png"; end

    if sprite == nil then 
        Logger:out("sprite is null")
        return
    end

    if filePath == nil or filePath == "" then
        Logger:out("filePath is null")
    end

    local localpath = nil
    -- local platForm = GameGlobal:getCurPlatForm()

    -- --cc.PLATFORM_OS_WINDOWS 5 cc.PLATFORM_OS_LINUX 6 cc.PLATFORM_OS_MAC
    -- if platForm == cc.PLATFORM_OS_ANDROID   then
    --     --localpath = filePath .. ".pkm"
    --        if picType == "png" then  
    --         localpath = filePath .. ".png"
    --     elseif picType == "jpg" then  
    --         localpath = filePath .. ".jpg"
    --     end 

    -- elseif platForm == cc.PLATFORM_OS_IPHONE or platForm == cc.PLATFORM_OS_IPAD then
    --     localpath = filePath .. ".pvr.czz"
    -- else
    --     if picType == "png" then  
    --         localpath = filePath .. ".png"
    --     elseif picType == "jpg" then  
    --         localpath = filePath .. ".jpg"
    --     end 
    -- end

    if picType == "png" then  

        localpath = filePath .. ".png"

    elseif picType == "jpg" then  
        
        localpath = filePath .. ".jpg"
    end     
    sprite:loadTexture(localpath, type);
end


--local gray = display.newGraySprite("#worldWar_classBatImage"..id..".png");
--display.newGraySprite("heroBody/heroBody_"..insInfo.instanceMapId..".png");
function UIManager:getLocalGraySpritePath( filePath,picType)
    if filePath == nil or filePath == "" then
        Logger:out("filePath is null")
    end

    local localpath = nil
    --local platForm = GameGlobal:getCurPlatForm()

    --cc.PLATFORM_OS_WINDOWS 5 cc.PLATFORM_OS_LINUX 6 cc.PLATFORM_OS_MAC
    -- if platForm == cc.PLATFORM_OS_ANDROID   then
    --     --localpath = filePath .. ".pkm"
    --       if picType == "png" then  
    --         localpath = filePath .. ".png"
    --     elseif picType == "jpg" then  
    --         localpath = filePath .. ".jpg"
    --     end 
        
    -- elseif platForm == cc.PLATFORM_OS_IPHONE or platForm == cc.PLATFORM_OS_IPAD then
    --     localpath = filePath .. ".pvr.czz"
    -- else
    --     if picType == "png" then  
    --         localpath = filePath .. ".png"
    --     elseif picType == "jpg" then  
    --         localpath = filePath .. ".jpg"
    --     end 
    -- end

    if picType == "png" then  
            
        localpath = filePath .. ".png"

    elseif picType == "jpg" then  
        
        localpath = filePath .. ".jpg"

    end 


    return (localpath);
end
--找到某node里所有的字体，进行描边。param参数和UIManager:fontStoke方法同
function UIManager:allFontStoke(node, param)
   --ccuitext,c4b, ttfPath, outLineThick
   if param == nil then param = {}; end
   local children = node:getChildren();
   for i = 1, #children do  
        if children[i].getString or children[i].getTitleText then
            self:fontStoke(children[i], param[1]);
        end
        if children[i].getChildren ~= nil and #children[i]:getChildren() > 0 then
            self:allFontStoke(children[i]);
        end
   end
   if #children == 0 then
        self:fontStoke(node, param[1]);
   end
end
--使某node一直做上下浮动（或左右浮动）的action。返回了该action，以便按需停止
--例子：UIManager:flowAction(talkBubble, 0.4, cc.p(0,15));
function UIManager:flowAction(node, timeInterval, point)
    local action1 = cc.MoveBy:create(timeInterval, point)
    local action2 = cc.RepeatForever:create(
        cc.Sequence:create(
            action1,
            action1:reverse()
        )
    )
    node:runAction(action2);
    return action2;
end

--把一堆node在某段距离内横向居中（或横向匀齐）
--参数：
--nodesArr:nodes数组
--beginX:开始坐标X
--endX：结束坐标X
--eachWidth：指定每个node的宽度
--eachGap：每个node之间的间隔（若不填此参数，就会用完beginX和endX之间的距离，即匀齐）
--例子：UIManager:mulNodesHAlign({icon1, icon2, icon3}, 100, 50)
function UIManager:mulNodesHAlign(nodesArr, beginX, endX, eachWidth, eachGap)    
    local dis = endX - beginX; 
    local gap = eachGap;
    local firstX = beginX;
    if gap == nil then
        if #nodesArr <= 1 then
            gap = 0;
        else
            --匀齐间隔
            gap = math.floor(dis / (#nodesArr - 1));
        end  
    else
        if #nodesArr > 1 then
            firstX = beginX + (dis - ((#nodesArr - 1) * gap +  eachWidth * #nodesArr)) * 0.5;
            gap = gap + eachWidth;      
        end       
    end          
    for i = 1, #nodesArr do
        nodesArr[i]:setPositionX(firstX);
        firstX = firstX + gap;
    end
end
--把一堆node在某段距离内纵向居中（或纵向匀齐）
--参数：
--nodesArr:nodes数组
--beginY:开始坐标Y
--endY：结束坐标Y
--eachHeight：指定每个node的高度
--eachGap：每个node之间的间隔（若不填此参数，就会用完beginY和endY之间的距离，即匀齐）
--例子：UIManager:mulNodesVAlign({icon1, icon2, icon3}, 100, 50)
function UIManager:mulNodesVAlign(nodesArr, beginY, endY, eachHeight, eachGap)    
    local dis = endY - beginY;
    local gap = eachGap;
    local firstY = beginY;
    if gap == nil then
        if #nodesArr <= 1 then
            gap = 0;
        else
            --匀齐间隔
            gap = math.floor(dis / (#nodesArr - 1));
        end  
    else
        if #nodesArr > 1 then
            firstY = beginY + (dis - ((#nodesArr - 1) * gap +  eachHeight * #nodesArr)) * 0.5;
            gap = gap + eachHeight;      
        end       
    end          
    for i = 1, #nodesArr do
        nodesArr[i]:setPositionY(firstY);
        firstY = firstY + gap;
    end
end

--根据key，从缓存里拿出node来
function UIManager:getNodeFromCache(path,func)
    require("app.control.CsbObjectPool");
    local tar = CsbObjectPool:getFromPool(path);
    --先从对象池里取，看看有没有 。若有，取对象池内的对象
    if tar ~= nil then
        tar:removeFromParent();
        return tar;
    end     
    --没有，就从当前的缓存里取克隆对象
    tar = UIManager.nodeCache[path];
    if tar == nil then
        --需要重新生成
        if func and type(func) == "function" then
            tar = func(path)
        end
        if not tar then
            Logger:out("UIManager:getNodeFromCache()需要重新生成Node.路径:" .. path);
            tar = UIManager:getNodeFromLua(path);
        end
        --tar = UIManager:replaceNodeWithWidget(tar);
        tar:retain();
        UIManager.nodeCache[path] = tar;
    end
    --Logger:out("UIManager:getNodeFromCache()执行Node的克隆.路径:" .. path);
    --local temp = CUtil:getSystemTime();
    local cc = tar:clone();
    --Logger:out("克隆完成：" .. path);
    --Logger:out("getNodeFromCache cost:" .. (CUtil:getSystemTime() - temp))
    return cc;
end

--需要从缓存区里删掉node则调用此函数。如果path=nil，则清掉所有
function UIManager:removeNodeFromCache(path)
    if path == nil then
        for k, v in pairs(UIManager.nodeCache) do
            Logger:out("UIManager:removeNodeFromCache()删掉了Node的缓存.路径:" .. k);
            v:release();
        end
        UIManager.nodeCache = {};
        return
    end
    local tar = UIManager.nodeCache[path];
    if tar ~= nil then
        tar:release();
        tar = nil;
    end
    UIManager.nodeCache[path] = nil;
end
function UIManager:createBlackRectOnTopBottomByScreenSize(view)
   local function createRect(rect, param, position)    
        local con = display.newLayer();
        con:setContentSize(rect.width,rect.height);
        con:setPosition(position);
        local tmp = display.newRect(rect,param);
        con:addChild(tmp);
        con:getAnchorPoint();
        view:addChild(con);
        return con;
    end
    if cc.Director:getInstance():getOpenGLView():getResolutionPolicy() == cc.ResolutionPolicy.FIXED_WIDTH then --上下生成遮挡黑块
        local bottomRect = createRect(cc.rect(0,0,UIManager.ActualDesignSize.width, UIManager.upperShiftPy),{fillColor=cc.c4f(0,0,0,1), borderColor=cc.c4f(0,0,0,0),borderWidth=1},cc.p(0,0));
        local topRect = createRect(cc.rect(0,0,UIManager.ActualDesignSize.width, UIManager.upperShiftPy),{fillColor=cc.c4f(0,0,0,1), borderColor=cc.c4f(0,0,0,0),borderWidth=1},cc.p(0,UIManager.ActualDesignSize.height-UIManager.upperShiftPy));
    end   
end
--返回值有两个，一个是这个富文本控件，另外一个是内部元素的实际高度和实际宽度
--areasize设置大小，如果超过这个设置大小的内容则不会显示出来， 需要所有内容显示就设置巨大一点
--tableinfo 是控件配置表，按显示顺序加入,line表示是否立即换行显示
--文本{"text",text = "",fontSize = 20,color = cc.c3b(),line = true,outlineSize = 0 singleCb = cb}    如果输入"sdfweg\nffwegwg\n"则会按\n换行
--图片{"image",filePath = "",type = 0 ,line = true,scale = 1.1,callBack = cb,callBackParam = {},singleCb = cb(图片生成后调用的回调，参数为图片对象),touchScale = "点击反馈的大小"}
--按钮{"button",fontColor = c3b,line = true,NormalImage = ,HighlightedButtonImage= ,DissbledButtonImage = ,callBack = ,callBackParam = {} singleCb = cb}
--node {"node",node = ,size =cc.size() ,pos =cc.p() ,line = ,scale =  singleCb = cb}
--vertical为垂直分布方式，top为默认，其余的输入"center" 或者 "bottom"  这个居中方式是按 设置areaSize的大小居中的，不是按实际有内容部分的大小
--horizon为水平分布方式,left为默认，其余的输入"center" 或者 "right" 这个居中方式是按 设置areaSize的大小居中的，不是按实际有内容部分的大小
--anchorPoint:实际有内容部分的宽高,锚点位置
--line = true :如果是最后一个元素 就不要写line=true 否则会向上偏移一点
function UIManager:richText(areaSize,tableInfo,vertical,horizon,anchorPoint)
    local  area = TextArea:create();
    area:setSize(areaSize.width,areaSize.height); 
    local contentHeight = 0;
    local contentWidth = 0;
    for i = 1,#tableInfo  do
        if tableInfo[i][1] == "text" then
            --按\n换行
            local tmp = StringUtil:split(tableInfo[i].text,"\\n");
            for j = 1,#tmp do
                local mm = clone(tableInfo[i]);
                mm.text = tmp[j];
                if j < #tmp then
                    mm.line = true;
                end
                local text = TextAreaElement:create(mm)
                area:insertElement(text);
                if tableInfo[i].singleCb then
                    tableInfo[i].singleCb(text);
                end
            end
        elseif tableInfo[i][1] == "button" then
            local button = TextAreaBtnElement:create(tableInfo[i])
            area:insertElement(button);
            if tableInfo[i].singleCb then
                tableInfo[i].singleCb(button);
            end
        elseif tableInfo[i][1] == "image" then
            local image = TextAreaImgElement:create(tableInfo[i].filePath,tableInfo[i].type,tableInfo[i].line,nil,tableInfo[i].scale,tableInfo[i].callBack,nil,tableInfo[i].touchScale)
            area:insertElement(image);
            if tableInfo[i].singleCb then
                tableInfo[i].singleCb(image);
            end
        else
            local node = TextAreaCustomerElement:create(tableInfo[i].node,tableInfo[i].size,tableInfo[i].pos,tableInfo[i].line,tableInfo[i].scale)
            area:insertElement(node);
            if tableInfo[i].singleCb then
                tableInfo[i].singleCb(node);
            end
        end
    end
    contentHeight,contentWidth= TextArea:align(area,vertical,horizon)  
    if anchorPoint then
        TextArea:setRealAnchorPoint(area,contentWidth,contentHeight,anchorPoint)
    end
    return area,contentHeight,contentWidth;
end
-- node为改变的位置node
--scaleChange是否有变大缩小的效果
--如果使用的是美术字减少或者增加 就填写true
function UIManager:valueChangeAction(node, str, color, size,scaleChange,artWordId)
    if size == nil then
        size = 20;
    end
    if scaleChange == nil then scaleChange = true end;
    if not artWordId then
        local _Text_1 = ccui.Text:create()
        _Text_1:setFontName("simhei.ttf")
        _Text_1:setFontSize(size)
        _Text_1:setString(str)
        _Text_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)        
        _Text_1:setPosition(0,20)
        _Text_1:setAnchorPoint(0,0.5)
        _Text_1:setColor(color);
        UIManager:fontStoke(_Text_1);
        --runAction，然后消失
        local function com()
            _Text_1:removeFromParent();
        end
        local action = cc.Sequence:create(
            cc.MoveBy:create(0.5, cc.p(0, 10)), 
            cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0,10)),cc.FadeOut:create(0.5)),
            cc.CallFunc:create(com)
        );
        _Text_1:runAction(action);
        node:addChild(_Text_1);
    else

        local img1 = ccui.ImageView:create();
        if tonumber(str) >= 0 then
            str = tonumber(str)
        else
            str = tonumber(str)*-1
            img1 = ccui.ImageView:create("artText_uiNum2jian.png",1)
        end
        img1:setPosition(20,30)
        local img2 = self:createImageString(str,"uiNum2",13,"left")
        node:addChild(img1)
        node:addChild(img2);
        img2:setPosition(35,30)
        img2:setScale(0.6)
        local function com()
            img1:removeFromParent();
        end
        local function com1()
            img2:removeFromParent();
        end
        local action = cc.Sequence:create(
            cc.MoveBy:create(0.5, cc.p(0, 20)), 
            cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0,10)),cc.FadeOut:create(0.5)),
            cc.CallFunc:create(com)
        );
        local action1 = cc.Sequence:create(
            cc.MoveBy:create(0.5, cc.p(0, 20)), 
            cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0,10)),cc.FadeOut:create(0.5)),
            cc.CallFunc:create(com1)
        );
        img1:runAction(action);
        img2:runAction(action1)


    end
    --node放大缩小一下
    local action = cc.Sequence:create(
        cc.ScaleTo:create(0.3, 1.2),
        cc.ScaleTo:create(0.3, 1)
    )
    if scaleChange then
        node:runAction(action);        
    end
end

function UIManager:scaleLayerToFull(view,node)
    local size = nil --DisplayObjectUtil:getLayerActulSize(view);
    if node then size = DisplayObjectUtil:getLayerActulSize(node); else  size = DisplayObjectUtil:getLayerActulSize(view); end;
    local scaleX = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width/size.width;
    if scaleX > 1 then
        view:setScale(scaleX);
        return scaleX;
    end
    return 1;
end
--startPer 起始百分比,
--endPer 终止百分比,升N级则传N*100 + 最终百分比
--time 一帧对应的百分比，默认3%耗时0.033秒,如果写2就是2%耗时0.033秒
--sprite loadingbar顶端的特效名字
--offset 特效左右偏移的%
--关闭界面调用 UIManager:disPosLoadingBar()
--cb 达到endper的时候回调
function UIManager:loadingBarScroll(node,startPer,endPer,sprite,offset,cb1,time)
    local width = node:getContentSize().width
    local height = node:getContentSize().height
    if not time then
        time = 3;
    end
    if not offset then
        offset = 0
    end
    if not self.loadingBarSche then
        self.endPer = endPer;
        self.curPer = startPer;
        local function cb()
            if self.curPer > self.endPer then
                if self.loadingBarSche then
                    scheduler.unscheduleGlobal(self.loadingBarSche)
                    if sprite then
                        -- 炼魂特效加遮罩，特殊处理一下
                        if node:getName() == "refineSoulBar" then
                            -- local clipingNode = node:getChildByName("clipingNode")
                            node:removeChildByName("clipingNode")
                            node:setPercent(self.endPer%100)
                        else
                            node:removeChildByName(sprite)
                        end
                    end
                    self.loadingBarSche = nil;
                end
                if cb1 then
                    cb1();
                end
                return; 
            else
                local per = self.curPer%100 
                if per == 0 then
                    if self.curPer ~= 0 then
                        per = 100
                    end
                end
                node:setPercent(per);
                if self.curPer ~= self.endPer then
                    self.curPer = self.curPer + time;
                    if self.curPer > self.endPer  then
                        self.curPer = self.endPer;
                    end
                else
                    self.curPer = self.endPer + time;
                end
                if sprite then
                    local effect = nil
                    if node:getName() == "refineSoulBar" then
                        local clipingNode = node:getChildByName("clipingNode")
                        effect = clipingNode:getChildByName("effect1")
                    else
                        effect = node:getChildByName(sprite)
                    end
                    
                    if effect and offset then
                        effect:setVisible(true);
                        effect:setPosition(  width*(per - offset)/100  ,height/2)
                    end
                end
            end
        end
        self.loadingBarSche = scheduler.scheduleGlobal(cb, 0.033)
        cb();
    else
        self.endPer = endPer;
    end
end
function UIManager:disPosLoadingBar()
    if  self.loadingBarSche then
        scheduler.unscheduleGlobal(self.loadingBarSche)
    end
    self.loadingBarSche = nil;
end
--制造一个闪退
function UIManager:makeCrash(view)
    local function tableCellAtIndex(table_view,idx )
        --local _cell = table_view:dequeueCell()
		return true
    end
  
    local _tableview =  cc.TableView:create(cc.size(500 , 300))
    _tableview:setDelegate()
    view:addChild(_tableview)
    _tableview:registerScriptHandler(function( table_view)
        return  10
    end,cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    _tableview:registerScriptHandler(function ( table_view,idx  )
        return tableCellAtIndex(table_view,idx  )
    end,cc.TABLECELL_SIZE_AT_INDEX)
    --每一行的宽高度
    _tableview:registerScriptHandler(function ( table_view,idx )
        return 140,768 
    end,cc.TABLECELL_SIZE_FOR_INDEX)
    _tableview:reloadData()
end


-- 如果要在该界面加入返回键功能，调用此方法
function UIManager:addBackViewKey(view)
	_testCloseView = view
	if _backKeyListener then
		CLIENT_VIEW_ARRAY = {}
		return
	end
    local klistener = cc.EventListenerKeyboard:create()
    local function releaseKey( keyCode, target)       
        --正在切场景，点击返回键没反应
        if GameGlobal.repalcingScene then return end
        --新手引导中，点返回键没有效
        if (not GameGlobal:checkObjIsNull(self.newBieMask)) then FloatMessage:addMessage(require("data.manual.Config_Language").canNotBreakStudy) return end
		if not GameGlobal:checkObjIsNull(GameGlobal.newBieProxy.mask) then FloatMessage:addMessage(require("data.manual.Config_Language").canNotBreakStudy) return end
		local worldMapLogic = UIManager:getUILogicByName(nil, Config_UI.WORLDMAPVIEW.name);
		if worldMapLogic ~= nil and (not GameGlobal:checkObjIsNull(worldMapLogic.masker)) then return end;
		if private.loading then return end
        if keyCode ~= cc.KeyCode.KEY_BACK then return end
        if self.keyBackTouched then return end
		self.keyBackTouched = true
		local data
		while #CLIENT_VIEW_ARRAY ~= 0 do
			data = CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY]
			if data and data.logic and data.view and not GameGlobal:checkObjIsNull(data.view) then
				local isback,delaytime
				local conf = require("data.manual.Config_UI")[data.uiName]
				if conf then
					isback,delaytime = conf.keyBackClosed,conf.keyBackDelayTime 
				end
				if data.logic.canClosed then
					local tisback,tdelaytime = data.logic:canClosed()
					isback = tisback
					if tdelaytime then delaytime = tdelaytime end
					if not isback then break end
				end
				if isback then
					delaytime = delaytime or 0.5
					if not GameGlobal:checkObjIsNull(data.view) then
						if data.logic.closeIt then
							data.logic:closeIt()
						else
							self:removeUI(data.panel,data.uiName)
						end
					end
					self._backhander = scheduler.scheduleGlobal(function()
						if not self then return end
						if self._backhander then
							scheduler.unscheduleGlobal(self._backhander)
							self._backhander = nil
						end
						self.keyBackTouched = false
					end, delaytime)
				else
					if string.find(data.uiName,"HOMESTYLE") then
						self:closeViewTips()
					else
						self.keyBackTouched = false
					end
				end
				return
			else
				CLIENT_VIEW_ARRAY[#CLIENT_VIEW_ARRAY] = nil
			end
		end
		if #CLIENT_VIEW_ARRAY == 0 then
			self:closeViewTips()
		end
        self.keyBackTouched = false
    end
    klistener:registerScriptHandler(releaseKey, cc.Handler.EVENT_KEYBOARD_RELEASED)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(klistener, -128)
	_backKeyListener = klistener
end

function UIManager:closeViewTips()
	if not _testCloseView then
		self.keyBackTouched = false
		return
	end
	if _testCloseView.setBattlePause ~= nil then
		_testCloseView:setBattlePause(true)
	end
	local function finish()
		self.keyBackTouched = false
		cc.Director:getInstance():endToLua()
	end
	local function closeCb()
		self.keyBackTouched = false
		if _testCloseView and _testCloseView.setBattlePause then 
			_testCloseView:setBattlePause(false)
		end
	end
	local function retry()
		self.keyBackTouched = false
		GameGlobal.gameSocket:returnToLogin()
	end
	--没有sdk点返回键需求的，显示游戏自己的
	if not GameGlobal.sdkManager:checkNeedSdkExit() then 
        local param = {
            layer = cc.Director:getInstance():getRunningScene(),
            uiName = require("data.manual.Config_UI").MESSAGEBOX.name,
            logicParam = {id="EXIT", fun1=retry, fun2=finish, closeCb = closeCb},
        };
		UIManager:addUI(param)
	else
		self.keyBackTouched = false
		local ok ,strPay = GameGlobal.sdkManager:sdkExit(_testCloseView)
	end
end

function UIManager:scaleLayerToFull(view,node, extScale)
    if extScale == nil then extScale = 1 end;    
    local size = nil --DisplayObjectUtil:getLayerActulSize(view);
    if node then size = DisplayObjectUtil:getLayerActulSize(node); else  size = DisplayObjectUtil:getLayerActulSize(view); end;
    local scaleX = cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width/size.width * extScale;
    if scaleX > 1 then
        view:setScale(scaleX);
        return scaleX;
    end
    view:setScale(extScale);
    return extScale;
end

function UIManager:pushNewBieStep()
	if NEWBIEWIDGET then
		if GameGlobal:checkObjIsNull(NEWBIEWIDGET.widget) then
			FloatMessage:addMessage(require("data.manual.Config_Language").canNotBreakStudy)
		else
			NEWBIEWIDGET.callback()
		end
	else
		FloatMessage:addMessage(require("data.manual.Config_Language").canNotBreakStudy)
	end
end
function UIManager:addPicIcon(pic,iconPath) 
   if not GameGlobal:checkFileExist(iconPath) then
      iconPath = "singlePic/icons/icons_-1.png"; 
   end
   pic:loadTexture(iconPath,ccui.TextureResType.localType);
end
--文本设置成竖向排列
function UIManager:setTextVertical(text) 
   local str = text:getString();
   local tab = {};
   for uchar in string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*") do tab[#tab+1] = uchar end
   text:setString(table.concat(tab,"\n"))
end
function UIManager:setButtonEnabled(button, value)
    button:setEnabled(value);
    button:setBright(value);
end
--5颗星星的排列公共算法
--stars  所有的星星显示对象数组。可以多于5个。格式：{star1_img, star2_img, star3_img, star4_img, star5_img}
--showStarNum  显示几个星
--useDisPer  使用距离百分比，默认true。如：总共5星，但显示3个星，则使用总距离*(3/5)的距离。 若为false，则使用全部距离
--alignType  0横排（默认）   1竖排
function UIManager:alignStar(stars, showStarNum, useDisPer, alignType)
    if useDisPer == nil then useDisPer = true end;
    if alignType == nil then alignType = 0 end;
    local beginPos = cc.p(stars[1]:getPosition());
    local endPos = cc.p(stars[#stars]:getPosition());
    local dis = cc.pGetDistance(beginPos, endPos);
    if useDisPer == true then
        local oldDis = dis;
        dis = dis * (showStarNum / #stars);
        if alignType == 0 then
            --重新计算结束坐标        
            endPos.x = beginPos.x + (beginPos.x + (oldDis - dis) / 2) + dis;
            --重新计算起始坐标
            beginPos.x = beginPos.x + (oldDis - dis) / 2;        
        else
            --重新计算结束坐标        
            endPos.y = beginPos.y + (beginPos.y + (oldDis - dis) / 2) + dis;
            --重新计算起始坐标
            beginPos.y = beginPos.y + (oldDis - dis) / 2;        
        end
    end
    local gap
    if showStarNum then 
        gap = 0;
        beginPos.x = beginPos.x  + dis / 2;
    else
        gap = dis / (showStarNum - 1)--间隔
    end
    
    for i = 1,#stars do
        if i <= showStarNum  then
            stars[i]:setVisible(true);
            if alignType == 0 then
                stars[i]:setPositionX(beginPos.x + (i - 1) * gap);
            else
                stars[i]:setPositionY(beginPos.y + (i - 1) * gap);
            end
        else
            stars[i]:setVisible(false);
        end        
    end
end
function UIManager:InWind(nodes,angleEnd) --摆动角度 ，1秒内的摆动角度 ,要求 传入的nodes 需要把锚点设置在0.5，1
    local curNode;
    local lastNode;
    local switch = 1;
    local index = 0
    for i = 1,#nodes do --做辅助点 以便于连接上
        local pos = ccui.ImageView:create();
        nodes[i]:addChild(pos);
        pos:setName("_bottom_pos_");
        pos:setPosition(nodes[i]:getContentSize().width/2,2)
    end
    local function update()
        if math.abs(index) % 30 == 1 and index*index ~= 1 then
            switch = switch * -1
        end            
        index = index + 1*switch;      
        for i = #nodes,1 ,-1 do
            local curNode = nodes[i];
            local lastNode = nodes[i - 1];
            if i == 1  then --起始点
                if index > 0 then
                    curNode:setRotation(angleEnd - angleEnd * (  1 - index/30) * (1 - index/30));
                else
                    curNode:setRotation(-angleEnd + angleEnd * (  1 + index/30) * ( 1 + index/30));
                end
            else
               curNode:setRotation(lastNode:getRotation());
               curNode:setPosition(lastNode:convertToWorldSpace(cc.p(lastNode:getChildByName("_bottom_pos_"):getPositionX(),lastNode:getChildByName("_bottom_pos_"):getPositionY())))
            end
            
        end
    end
    nodes[1].curSche = scheduler.scheduleGlobal(update,0.033);
    local function onNodeEvent(event)
        --退出的event有：exitTransitionStart（即将退出）、exit（退出完成）、cleanup（清理）
        if "exitTransitionStart" == event then
            scheduler.unscheduleGlobal(nodes[1].curSche)
        end
    end
    nodes[1]:registerScriptHandler(onNodeEvent)      
    return nodes[1].curSche;
end
function UIManager:createFlyText(node, str, color, size) --资源变化飞字
    if size == nil then
        size = 20;
    end
    local _Text_1 = ccui.Text:create()
    _Text_1:setFontName("simhei.ttf")
    _Text_1:setFontSize(size)
    _Text_1:setString(str)
    _Text_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)        
    _Text_1:setPosition(0,20)        
    _Text_1:setAnchorPoint(0,0.5)
    _Text_1:setColor(color);
    UIManager:fontStoke(_Text_1);
    --runAction，然后消失
    local function com()
        _Text_1:removeFromParent();
    end
    local action = cc.Sequence:create(
        cc.MoveBy:create(0.5, cc.p(0, 10)), 
        cc.Spawn:create(cc.MoveBy:create(0.5, cc.p(0,10)),cc.FadeOut:create(0.5)),
        cc.CallFunc:create(com)
    );
    _Text_1:runAction(action);
    node:addChild(_Text_1);
    --node放大缩小一下
    local action = cc.Sequence:create(
        cc.ScaleTo:create(0.3, 1.2),
        cc.ScaleTo:create(0.3, 1)
    )
    node:runAction(action);        
end