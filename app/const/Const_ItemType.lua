cc.exports.Const_ItemType = cc.exports.Const_ItemType or {}
--物品类型
  
--1   元宝
--2   铜钱
--3   普通物品(装备也算是物品，都在config_item表)
--5   弟子
--6   军令
--7   粮草
--8   经验
Const_ItemType.GOLD = 1;
Const_ItemType.SILVER = 2;
Const_ItemType.ITEM = 3;
Const_ItemType.HERO = 5;
Const_ItemType.AP = 6;
Const_ItemType.FOOD = 7;


--以下特殊判断用的：
Const_ItemType.MISSION = 9;
Const_ItemType.TALENT = 10 ;
Const_ItemType.SKILL = 100;--技能/状态类型

Const_ItemType.ExpId = 30013
--根据碎片，取得可合成的物品的id
--Const_ItemType.fragItemToItem = nil;
--Const_ItemType.getFragItemToItem = function(self, fragId)
--    if Const_ItemType.fragItemToItem ~= nil then return Const_ItemType.fragItemToItem[fragId] end;
--    Const_ItemType.fragItemToItem = {};
--    local allItems = require("data.Config_Item");
--    --第一步，找出所有碎片类型的物品    
--    for k,v in pairs(allItems) do
--        if v.type2 == require("app.const.Const_genItemType").TYPE2_EQUFRAG then
--            Const_ItemType.fragItemToItem[k] = -1;
--        end
--    end
--    --第二步，找出对应关系
--    local found = false;
--    for k, v in pairs(Const_ItemType.fragItemToItem) do
--        found = false;
--        for k2,v2 in pairs(allItems) do
--            if v2.assembleItem ~= "-1" then
--                --判断是否包含了k
--                local tmp = StringUtil:split(v2.assembleItem,",",false);
--                for i = 1,#tmp do
--                    local id = StringUtil:split(tmp[i],"_", true)[1];
--                    if id == k then
--                        Const_ItemType.fragItemToItem[k] = v2.id;
--                        found = true;
--                        break;
--                    end
--                end
--                if found then break end;
--            end            
--        end
--    end        
--    return Const_ItemType.fragItemToItem[fragId];
--end
return Const_ItemType