cc.exports.Const_genItemType = cc.exports.Const_genItemType or  {}
--item表物品类型有三种；
 
Const_genItemType.EQUIPMENT = 1;--装备
Const_genItemType.SOUL = 2;--将魂
Const_genItemType.ITEM = 3;--消耗品
----------------------------------------------------------
--若是Const_genItemType.ITEM类型（3类型），则type2对应的是：
Const_genItemType.TYPE2_ITEM = 1;--普通道具
Const_genItemType.TYPE2_EXP = 2;--经验水
Const_genItemType.TYPE2_GIFT = 3;--普通道具
Const_genItemType.TYPE2_EQUFRAG = 4;--装备碎片
-- /** 军令 */
Const_genItemType.TYPE2_AP = 5;--获得后立刻加上的
-- /** 玩家经验 */
Const_genItemType.TYPE2_PLAYEREXP = 6;--获得后立刻加上的
-- /** 粮草 */
Const_genItemType.TYPE2_FOOD = 7;--获得后立刻加上的
-- /** 天赋点 */
Const_genItemType.TYPE2_TALENT_POINT = 8;--获得后立刻加上的
-- /** 精炼石 */
Const_genItemType.TYPE2_REFINE_STONE = 9;
-- /** 功勋 */
Const_genItemType.TYPE2_FACTION_EXPLOIT = 10;--获得后立刻加上的
-- /** 挖金铲 */
Const_genItemType.TYPE2_WAJINCHAN = 11;
-- /** 训练材料 */
Const_genItemType.TYPE2_XUNLIAN = 12;
-- /** 军资*/
Const_genItemType.TYPE2_FACTION_FUND = 13;--获得后立刻加上的
Const_genItemType.TYPE2_VIP = 19;--获得后立刻加上的

Const_genItemType.TYPE2_VIPEXP = 24;--vip经验道具，使用后获得所配置的VIP经验
Const_genItemType.TYPE2_ZHANGONG = 26;--战功，获得后立刻加上

Const_genItemType.TYPE2_ZUOQI = 32;--坐骑，获得后激活
Const_genItemType.TYPE2_GEMS = 46;--宝石
Const_genItemType.TYPE2_POWER_PELLET = 53;--体力丹

--下面是常用的道具的常量ID，其id就是道具表的Id
Const_genItemType.PLAYEREXP = 30013;--player经验
Const_genItemType.EXPLOIT = 30020;--功勋
Const_genItemType.BRAVE = 30026;--煞币
Const_genItemType.FUND = 30022;--军资
Const_genItemType.AP = 30012; --军令
Const_genItemType.FOOD = 30014; -- 军粮
Const_genItemType.TALENTPOINT = 30015; --天赋点
Const_genItemType.REVIVEITEM = 30007 --虎符（复活道具）
Const_genItemType.WINE = 30000 --米酒
Const_genItemType.INVIATATION_CARD = 60050 --拜帖
Const_genItemType.ARROW = 30043 --令箭 
Const_genItemType.ZHANGONG = 30056 --战功
Const_genItemType.BUBI = 30005 --布币 
Const_genItemType.JINGJIBI = 30006 --竞技币

return Const_genItemType