--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
--以下为所有Const
require("app.const.Const_Action");
require("app.const.Const_ChatType");
require("app.const.Const_colorData");
require("app.const.Const_CostType");
require("app.const.Const_genItemType");
require("app.const.Const_IncidentAni");
require("app.const.Const_ItemType");
require("app.const.Const_LoadingItemType");
require("app.const.Const_MsgType");
require("app.const.Const_Skill");
require("app.const.Const_speItemDefId");
require("app.const.Const_ShopType");
require("app.const.Const_Dir");
require("app.const.Const_Form");
require("app.const.Const_Job");
require("app.const.Const_SkillBuff");
require("app.const.Const_BattleAction");
require("app.const.Const_YuanInfo");
---------------------------------------
--require("data.RequireAllConfig");--此句用于导入所有由Excel导出的lua配置文件

---------以下配置文件并不是由excel表导出的，需要手动添加
require("data.manual.Config_SpriteData")
--require("data.manual.Config_Spine");
require("data.manual.Config_UI")
require("data.manual.Config_Sys")
--require("data.manual.Config_GameData")
--require("data.manual.Config_Language")
--require("data.manual.Config_SkillUpgrade")
--require("data.manual.Config_Message")
--require("data.manual.Config_UIPath")
--require("data.manual.Config_LanguageForUI")
--require("data.manual.Config_usualWords")
--require("app.script.NewBieScriptEtc");
--require("app.script.NewbieForLv");
--require("app.script.NewBieScript")
--require("app.control.DamageCalculator")
--require("app.utils.MapUtil")
require("app.control.EventManager");
--require("app.event.StateEvent")
--shader = require("app.sprite.Shaders"):create();