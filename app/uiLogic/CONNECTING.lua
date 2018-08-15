--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local CONNECTING = class("CONNECTING")
function CONNECTING:ctor()
    self.view = nil;
    self.ani = nil;
    self.scheduleId = nil;
    self.rect = nil;
end

function CONNECTING:create(view, param)
    local logic = CONNECTING:new();
    logic.view = view;     
    
    --生成一个矩形
    --第二个参数：table：填充色 fillColor, 边线色 borderColor 及边线宽度 borderWidth
    local function cb()
        Logger:out("点到了connectingUI的rect！！！");    
    end
--    logic.rect = UIManager:createRect(logic.view, cc.rect(-2*UIManager.ActualDesignSize.width,-2*UIManager.ActualDesignSize.height,UIManager.ActualDesignSize.width*5, UIManager.ActualDesignSize.height*4),{fillColor=cc.c4f(0,0,0,220), borderColor=cc.c4f(0,0,0,0),borderWidth=1},cb);
--    Logger:out("创建了connectingUI！！zorder=".. view:getLocalZOrder() .. "rect zorder=" .. logic.rect:getLocalZOrder());    

    logic.ani = require("app.sprite.BaseSprite"):create(100024);
    logic.ani:init(nil, true);
    logic.ani:setName("Ani")
    view:addChild(logic.ani);
    local txt = view:getChildByName("Txt");
    local txtX,txtY = txt:getPosition();
    logic.ani:setPosition(txtX, txtY + 90);
    logic:layout(); 
    
    require("app.utils.DisplayObjectUtil");    
    DisplayObjectUtil:callAllChildrenFun(view, "setOpacity", 0); 
    logic.ani:setVisible(false);
    local function show()
        if logic.scheduleId then scheduler.unscheduleGlobal(logic.scheduleId) end
        if GameGlobal:checkObjIsNull(view) then
            Logger:out("connecting show return 1")
            return
        end                      
        if GameGlobal:checkObjIsNull(logic.rect) then
            Logger:out("connecting show return 2")
            return
        end
        DisplayObjectUtil:callAllChildrenFun(view, "setOpacity", 255);
        logic.rect:setOpacity(100);       
        logic.ani:setVisible(true); 
    end
    
    cc.Director:getInstance():getScheduler():scheduleScriptFunc(show,0.8,false)

    --监听新UI的添加，再次创建ConnectingUI(否则后添加的UI里的点击事件会穿透上面所创建的rect)
    -- local function uiAdded(objectg, param)                                                      
    --     if param.name ~= Config_UI.CONNECTING.name then
    --         Logger:out("uiAdded event listened by connectingUI. name = " .. param.name .. ", readd connectingUI again!")
    --         UIManager:addUI(logic.view:getParent(), Config_UI.CONNECTING.name);
    --     end
    -- end
    -- EventManager:addEvent(logic, UIManager, require("app.event.UIManagerEvent").ADD, uiAdded)
    return logic;
end
function CONNECTING:layout()
end

function CONNECTING:dispose()
    if self.scheduleId then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId)
        self.scheduleId = nil 
    end
    --EventManager:removeEvents(self)
end
return CONNECTING