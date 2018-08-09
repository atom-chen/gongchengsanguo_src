cc.exports.Const_YuanInfo = cc.exports.Const_YuanInfo or {}
--物品类型
 
--根据装备Id，取得装备对应所有英雄缘
Const_YuanInfo.equToYuan = nil;
Const_YuanInfo.getYuanByEquId = function(self, equId)
    if Const_YuanInfo.equToYuan ~= nil then return Const_YuanInfo.equToYuan[equId] end;
    Const_YuanInfo.equToYuan = {};
    local data = require("data.Config_EquipmentYuan");
    for k,v in pairs(data) do 
        local equIds = StringUtil:split(v.equipIds, ";", true);
        for i = 1,#equIds do
            if  Const_YuanInfo.equToYuan[equIds[i]] == nil then
                Const_YuanInfo.equToYuan[equIds[i]] = {};
            end
            table.insert( Const_YuanInfo.equToYuan[equIds[i]], v); 
        end
    end
    return Const_YuanInfo.equToYuan[equId];
end
--根据英雄定义id，取得英雄对应所有英雄缘
Const_YuanInfo.heroToHero = {}; 
Const_YuanInfo.getYuanByHeroId = function(self, equId)
    if  Const_YuanInfo.heroToHero ~= nil  and Const_YuanInfo.heroToHero[equId] ~= nil then return Const_YuanInfo.heroToHero[equId] end;  
        Const_YuanInfo.heroToHero[equId] = {};
        local tmp = StringUtil:split(require("data.Config_Hero")[equId].heroYuan,",",true) 
        for _,v in  pairs(tmp) do 
            table.insert( Const_YuanInfo.heroToHero[equId],require("data.Config_HeroYuan.lua")[v]);
        end
        return Const_YuanInfo.heroToHero[equId];
end
return Const_YuanInfo