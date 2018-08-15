--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
local LOADING = class("LOADING")
function LOADING:ctor()
    self.view = nil;
end

function LOADING:create(view, param)
    local logic = LOADING:new();
    logic.view = view; 
    --生成一个矩形
    -- local fileName = "loading_jintuditu_" .. StringUtil:split(PACKAGE_PF,"pf_")[2] .. ".png";
    -- --动态修改loading
    -- if GameGlobal:checkPngExistInPlist(fileName) == true then
    -- 	view:getChildByName("Image_1"):loadTexture(fileName, ccui.TextureResType.plistType);
    -- end
    --第二个参数：table：填充色 fillColor, 边线色 borderColor 及边线宽度 borderWidth   
--    local rect = UIManager:createRect({
--        container = logic.view, 
--        rect = cc.rect(-2*UIManager.ActualDesignSize.width,-2*UIManager.ActualDesignSize.height,UIManager.ActualDesignSize.width*5, UIManager.ActualDesignSize.height*4),
--        param = {fillColor=cc.c4f(0,0,0,100), borderColor=cc.c4f(0,0,0,0),borderWidth=1},
--        });
    logic:layout(); 
    return logic;
end
function LOADING:layout()
end

function LOADING:dispose()
    self.view = nil;    
end
return LOADING