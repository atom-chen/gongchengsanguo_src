--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local LOGO = class("LOGO")
function LOGO:ctor()
    self.view = nil;
end

function LOGO:create(view, param)
    local logic = LOGO:new();
    logic.view = view;
    logic:layout();
    local img = view:getChildByName("Image_1");
    local x,y = img:getPosition();
    --img:setOpacity(0);
    --create带的参数是秒数
    local action_callback = function()      
       logic:preload();
    end
    local function cb1()
        local effect58 = require("app.sprite.BaseSprite"):create(100058, false, true);
        effect58:init(action_callback,false);
        logic.view:addChild(effect58);
        --logic.view:getChildByName("Image_119"):addChild(effect13);
        --local x,y = cell._node_list["Image_261"]:getPosition();
        effect58:setPosition(x,y);
    end
    --第二次初始化了，或者调试模式下，不需要显示logo动画    
    if OPEN_APP_AGAIN == true or Config_Sys.showPrint > 0 then
        view:getChildByName("node1"):setVisible(false);
        logic:preload();
        return logic;
    end
    OPEN_APP_AGAIN = true;
    local text = view:getChildByName("node1"):getChildByName("Text_1");
    local text2 = view:getChildByName("node1"):getChildByName("Text_1_Copy");
    text2:setVisible(false);
    text:setCascadeOpacityEnabled(true)
    text2:setCascadeOpacityEnabled(true)
    local action1 = cc.FadeOut:create(0.6)
    local action3 = cc.DelayTime:create(1)
    local action4 = cc.FadeOut:create(0.6);
    local action5 = cc.DelayTime:create(1);
    local action6 = cc.CallFunc:create(function() cb1()  end);
    local function cb2()
        text:setVisible(false);
        text2:setVisible(true);
        text:setOpacity(255);

    end
    local action8 = cc.CallFunc:create(function() logic:preload() end);
    local action2 = cc.CallFunc:create(function() cb2()  end);
    local action7 = cc.DelayTime:create(1.8)

    if   SdkManager:showLogo() then
        if SdkManager:showHealthTip() then
            text:runAction(cc.Sequence:create(action3,action1))
            
        else
	    text:setOpacity(0)
	    action7 = cc.DelayTime:create(0.1)
	end
        text2:runAction(cc.Sequence:create(action7,action2,action5,action4,action6))
    else
        if SdkManager:showHealthTip() then
            text:runAction(cc.Sequence:create(action3,action1,action8))
        else     
            text:setOpacity(0)   
            text:runAction(cc.Sequence:create(action8))
        end
    end
  --  local action = cc.Sequence:create(cc.FadeIn:create(1),cc.CallFunc:create(action_callback))
  --  img:runAction(action); 
    return logic;
end
function LOGO:preload()
    self.view:removeAllChildren();
    local function loadComplete()
        local scene = require("app.scenes.LoginScene"):create();
        GameGlobal.sceneContext = scene;
        UIManager:removeUI(nil, Config_UI.LOGO.name);
        if cc.Director:getInstance():getRunningScene() then
            cc.Director:getInstance():replaceScene(scene)
        else
            cc.Director:getInstance():runWithScene(scene)
        end  
    end
    --进入游戏前，把资源都加载上来
    local res = require("data.manual.Config_UI").LOGINUI.res;   
    local resArr = res;--需要预加载的场景、地图物件数据
    local curScene = cc.Director:getInstance():getRunningScene();
    local param = {
        layer = curScene,
        uiName = require("data.manual.Config_UI").LOADING.name,
        res = resArr,
        callBack = loadComplete,
        showLoadingUI = true,
    };
    UIManager:addUI(param);--显示Loading界面去加载界面素材。
end
function LOGO:layout()
end
function LOGO:dispose()
    self.view = nil;
end
return LOGO