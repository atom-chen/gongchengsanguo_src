cc.exports.Const_MsgType = cc.exports.Const_MsgType or {}
 
Const_MsgType.MODULE_PLAYER = 1;
Const_MsgType.MODULE_PLAYER_register = 1;
Const_MsgType.MODULE_PLAYER_getPlayerList = 2;
Const_MsgType.MODULE_PLAYER_login = 3;
Const_MsgType.MODULE_PLAYER_tokenMiss = 9999;
Const_MsgType.MODULE_PLAYER_getPlayerBaseInfo = 4;
Const_MsgType.MODULE_PLAYER_modifyPlayerName = 5;
Const_MsgType.MODULE_PLAYER_syncLocalPlayerAttr = 6;
Const_MsgType.MODULE_PLAYER_getLevyInfo = 7;
Const_MsgType.MODULE_PLAYER_levySilverFood = 8;
Const_MsgType.MODULE_PLAYER_getLoginDayRewardInfo = 9;
Const_MsgType.MODULE_PLAYER_extraDayReward = 10;
Const_MsgType.MODULE_PLAYER_loginDayComReward = 11;
Const_MsgType.MODULE_PLAYER_modifyNewbie = 12;
Const_MsgType.MODULE_PLAYER_addNewbieItem = 13;
Const_MsgType.MODULE_PLAYER_modifyNewbieAndCallFun = 14;
Const_MsgType.MODULE_PLAYER_buyAp = 15;
Const_MsgType.MODULE_PLAYER_useItem = 16;
Const_MsgType.MODULE_PLAYER_sellItem = 17;
Const_MsgType.MODULE_PLAYER_getPlayerSomeInfoChange = 18;
Const_MsgType.MODULE_PLAYER_getVipGiftInfo = 19;
Const_MsgType.MODULE_PLAYER_acqVipGift = 20;
Const_MsgType.MODULE_PLAYER_bugVipGift = 21;
Const_MsgType.MODULE_PLAYER_getHeroInfo = 24;
Const_MsgType.MODULE_PLAYER_getItemInfo = 25;
Const_MsgType.MODULE_PLAYER_getEquiptInfo = 26;
Const_MsgType.MODULE_PLAYER_sellRubbishItem = 27;
Const_MsgType.MODULE_PLAYER_getBroadcas = 28;
Const_MsgType.MODULE_PLAYER_pvpErrorLog = 29;
Const_MsgType.MODULE_PLAYER_acqActivateGift = 30;
Const_MsgType.MODULE_PLAYER_acqSevenTestRewards = 31;
Const_MsgType.MODULE_PLAYER_getMaxPowerRankInfo = 32;
Const_MsgType.MODULE_PLAYER_getMaxHeroRankInfo = 33;
Const_MsgType.MODULE_PLAYER_getMaxFactionRankInfo = 34;
Const_MsgType.MODULE_PLAYER_getCityKillRankInfo = 35;
Const_MsgType.MODULE_PLAYER_changePlayerIcon = 36;
Const_MsgType.MODULE_PLAYER_getChaozhiInfo = 37;
Const_MsgType.MODULE_PLAYER_getOtherPlayerInfo = 38;
Const_MsgType.MODULE_PLAYER_pveBattleReturnFood = 40;
Const_MsgType.MODULE_PLAYER_wushengUpgrade = 41;
Const_MsgType.MODULE_PLAYER_upTouristOfficial = 42;
Const_MsgType.MODULE_PLAYER_upgradeZhangu = 43;
Const_MsgType.MODULE_PLAYER_getFundInfo = 44;		--基金
Const_MsgType.MODULE_PLAYER_acqFundRewards = 45;	--基金奖励
Const_MsgType.MODULE_PLAYER_upLvAcqRewards = 46;	--升级领取物品
Const_MsgType.MODULE_PLAYER_getHongBaoInfo = 47;	--开服红包
Const_MsgType.MODULE_PLAYER_modifyWXName = 48;	--微信号填写

Const_MsgType.MODULE_PLAYER_testPlayerLogin = 50;
Const_MsgType.MODULE_PLAYER_cityReset = 51;
Const_MsgType.MODULE_PLAYER_worldBuff = 52; --世界加成
Const_MsgType.MODULE_PLAYER_getMulPlatPlayerInfo = 53;
Const_MsgType.MODULE_PLAYER_wushengDowngrade = 54;
Const_MsgType.MODULE_PLAYER_upgradeChainSoul = 55;
Const_MsgType.MODULE_PLAYER_upgradeSoldierAdvanced = 56;
Const_MsgType.MODULE_PLAYER_setArmyHeroInfo = 57;
Const_MsgType.MODULE_PLAYER_armyLvUp = 58;
Const_MsgType.MODULE_PLAYER_updateArmyHeroInfo = 59;
--------------------------------------------------------------
Const_MsgType.MODULE_HERO = 2;
Const_MsgType.MODULE_HERO_genRecruit = 1;
Const_MsgType.MODULE_HERO_goldOneRecruit = 2;
Const_MsgType.MODULE_HERO_goldTenRecruit = 3;
Const_MsgType.MODULE_HERO_pushEquipment = 4;
Const_MsgType.MODULE_HERO_heroUpRank =5;
Const_MsgType.MODULE_HERO_heroUpdatePosition = 10;
Const_MsgType.MODULE_HERO_upHeroLvUseItem =11;
Const_MsgType.MODULE_HERO_equipAssemble =12;
Const_MsgType.MODULE_HERO_heroUpStar =6;
Const_MsgType.MODULE_HERO_heroUpSkill =7;
Const_MsgType.MODULE_HERO_heroComposite = 8;
Const_MsgType.MODULE_HERO_buySkillPoint = 14;
Const_MsgType.MODULE_HERO_oneKeyPushEquipment = 13 ;
Const_MsgType.MODULE_HERO_getRecruitInfo = 16;
Const_MsgType.MODULE_HERO_wearEquipment = 17;
Const_MsgType.MODULE_HERO_upgradeEquipmentLv = 18;
Const_MsgType.MODULE_HERO_upgradeEquiptRefineLv = 19;
Const_MsgType.MODULE_HERO_upgradeHeroYuanLv = 20;
Const_MsgType.MODULE_HERO_resolveEquipment = 21;
Const_MsgType.MODULE_HERO_unloadEquipment = 22;
Const_MsgType.MODULE_HERO_getInnInfo = 23;
Const_MsgType.MODULE_HERO_refreshInnHero = 24;
Const_MsgType.MODULE_HERO_feteInn = 25;
Const_MsgType.MODULE_HERO_activateTrea = 26;
Const_MsgType.MODULE_HERO_activateHeroTalent = 27;
Const_MsgType.MODULE_HERO_practiceUpgrade = 28;
Const_MsgType.MODULE_HERO_artifactUpgrade = 29;
Const_MsgType.MODULE_HERO_artifactSkillUpgrade = 30;
Const_MsgType.MODULE_HERO_heroUpSkillOneKey = 31;
Const_MsgType.MODULE_HERO_changeMonut = 32;
Const_MsgType.MODULE_HERO_mountUpRank = 33;
Const_MsgType.MODULE_HERO_mountUpSkill = 34;
Const_MsgType.MODULE_HERO_acqMount = 35;
Const_MsgType.MODULE_HERO_activateMount = 36;

Const_MsgType.MODULE_HERO_equipLevelUp = 37;
Const_MsgType.MODULE_HERO_equipRankUp = 38;
Const_MsgType.MODULE_HERO_equipChange = 39;
Const_MsgType.MODULE_HERO_equipDecompose = 40;
Const_MsgType.MODULE_HERO_equipCompose = 41;
Const_MsgType.MODULE_HERO_equipUnload = 42;

Const_MsgType.MODULE_HERO_heroBreak = 43;
Const_MsgType.MODULE_HERO_soldierChoise = 44;
Const_MsgType.MODULE_HERO_soldierLevelUp = 45;
Const_MsgType.MODULE_HERO_soldierSwitch = 46;
Const_MsgType.MODULE_HERO_soldierInherit = 47;
Const_MsgType.MODULE_HERO_inlayStone = 48;
Const_MsgType.MODULE_HERO_unloadStone  = 49;
Const_MsgType.MODULE_HERO_composeStone = 50;
Const_MsgType.MODULE_HERO_changeStone  = 51;
Const_MsgType.MODULE_HERO_upLevelStone = 52;
---------------------------------------------------------------
Const_MsgType.MODULE_INSTANCE = 3;
Const_MsgType.MODULE_INSTANCE_getInstInfo = 1;
Const_MsgType.MODULE_INSTANCE_validInstBattle = 2;
Const_MsgType.MODULE_INSTANCE_instBattle = 3;
Const_MsgType.MODULE_INSTANCE_acqChapterReward = 4;
Const_MsgType.MODULE_INSTANCE_mopupInst = 5;
Const_MsgType.MODULE_INSTANCE_buyMopupTimes = 6;
Const_MsgType.MODULE_INSTANCE_triggerInstSpeItem = 7
Const_MsgType.MODULE_INSTANCE_openInstTreasure = 8
Const_MsgType.MODULE_INSTANCE_getCityVisitInfo = 9
Const_MsgType.MODULE_INSTANCE_visit_fight = 10
Const_MsgType.MODULE_INSTANCE_visit_visit = 11
Const_MsgType.MODULE_INSTANCE_visit_drink = 12 

--翻牌
Const_MsgType.MODULE_INSTANCE_getAwardInfo = 13;
Const_MsgType.MODULE_INSTANCE_getAllAward = 14;
Const_MsgType.MODULE_INSTANCE_pitOneAward = 15;
Const_MsgType.MODULE_INSTANCE_randomAward = 16;
Const_MsgType.MODULE_INSTANCE_buyVisitTimes = 17;
Const_MsgType.MODULE_INSTANCE_getBaifangTimes = 18;

---------------------------------------------------------------
Const_MsgType.MODULE_SHOP = 4;
Const_MsgType.MODULE_SHOP_getShopInfo = 1;
Const_MsgType.MODULE_SHOP_refreshShop = 2;
Const_MsgType.MODULE_SHOP_buyShopItem = 3;
Const_MsgType.MODULE_SHOP_getFixedShopInfo = 4;
Const_MsgType.MODULE_SHOP_buyFixedShopItem = 5;
Const_MsgType.MODULE_SHOP_getTreaShop = 6;
Const_MsgType.MODULE_SHOP_refreshTreaShop = 7;
Const_MsgType.MODULE_SHOP_buyTreaShopItem = 8;
Const_MsgType.MODULE_SHOP_getDiscountShopInfo = 9;
Const_MsgType.MODULE_SHOP_buyDiscountShopItem = 10;
----------------------------------------------------------------
Const_MsgType.MODULE_MISSION = 5;
Const_MsgType.MODULE_MISSION_getMissionInfo = 1;
Const_MsgType.MODULE_MISSION_acqMissionReward = 2;
Const_MsgType.MODULE_MISSION_getAchieveInfo = 3;
Const_MsgType.MODULE_MISSION_acqAchieveReward = 4;
Const_MsgType.MODULE_MISSION_getMeanMissionInfo = 5;
Const_MsgType.MODULE_MISSION_acqMeanMissionReward = 6;
Const_MsgType.MODULE_MISSION_getActiveReward = 7;
--------------------------------------------------------------------
Const_MsgType.MODULE_FACTION = 6;
Const_MsgType.MODULE_FACTION_getTotalFactions = 1;
Const_MsgType.MODULE_FACTION_createFaction = 2;
Const_MsgType.MODULE_FACTION_applyJoinFaction = 3;
Const_MsgType.MODULE_FACTION_getApplys = 4;
Const_MsgType.MODULE_FACTION_validApply = 5;
Const_MsgType.MODULE_FACTION_getFactionInfo = 6;
Const_MsgType.MODULE_FACTION_getMembersInfo = 7;
Const_MsgType.MODULE_FACTION_changeFactionDesc = 8;
Const_MsgType.MODULE_FACTION_leaveFaction = 9;
Const_MsgType.MODULE_FACTION_kickFactionMember = 10;
Const_MsgType.MODULE_FACTION_getAllCityStatus = 11;
Const_MsgType.MODULE_FACTION_getOneCityInfo = 12;
Const_MsgType.MODULE_FACTION_declareWar = 13;
Const_MsgType.MODULE_FACTION_getCityBattleGroup = 14;
Const_MsgType.MODULE_FACTION_getArmyCampInfo = 15;
Const_MsgType.MODULE_FACTION_assembleArmy = 16;
Const_MsgType.MODULE_FACTION_withdrawnArmy = 17;
Const_MsgType.MODULE_FACTION_withdrawnArmyByCity = 18;
Const_MsgType.MODULE_FACTION_getAdjustArmyInfo = 19;
Const_MsgType.MODULE_FACTION_adjustArmy = 20;
Const_MsgType.MODULE_FACTION_getCanDispatchHero= 21;
Const_MsgType.MODULE_FACTION_dispatchHero = 22;
Const_MsgType.MODULE_FACTION_getCityLeftArmy = 24;
Const_MsgType.MODULE_FACTION_getCityBattleInfo = 25;
Const_MsgType.MODULE_FACTION_getPlayerDispatchHero = 26;
--Const_MsgType.MODULE_FACTION_withdrawnSomeArmy = 27;
Const_MsgType.MODULE_FACTION_unableFight = 28;
Const_MsgType.MODULE_FACTION_changeJobTitle = 29;
Const_MsgType.MODULE_FACTION_cancelApplyJoin = 30;
Const_MsgType.MODULE_FACTION_modifyFactionEnsign = 31;
Const_MsgType.MODULE_FACTION_modifyFactionName= 32;
Const_MsgType.MODULE_FACTION_resetCallRollHero = 33;
Const_MsgType.MODULE_FACTION_opeCallRoll = 34;
Const_MsgType.MODULE_FACTION_masterSendMail = 35;
Const_MsgType.MODULE_FACTION_upgradeFactionLv = 36;
Const_MsgType.MODULE_FACTION_getFactionShop = 37;
Const_MsgType.MODULE_FACTION_refreshFactionShop = 38;
Const_MsgType.MODULE_FACTION_buyFactionShopItem = 39;
Const_MsgType.MODULE_FACTION_getFactionManorInfo = 40;
Const_MsgType.MODULE_FACTION_acqFactionManorReward = 41;
Const_MsgType.MODULE_FACTION_getFactionTech = 42;
Const_MsgType.MODULE_FACTION_upFactionLvTech = 43;
Const_MsgType.MODULE_FACTION_getFactionDeclareCity = 44;
Const_MsgType.MODULE_FACTION_getStarMission = 45;
Const_MsgType.MODULE_FACTION_getStarMissionRank = 46;
Const_MsgType.MODULE_FACTION_acqStarMissionReward = 47;
Const_MsgType.MODULE_FACTION_getCityBattleLine = 48;--获取城战所有线信息
Const_MsgType.MODULE_FACTION_acqFactionManorMoney = 49;
Const_MsgType.MODULE_FACTION_getAllCityManorReward = 50;
Const_MsgType.MODULE_FACTION_getFactionNews = 51;
Const_MsgType.MODULE_FACTION_getFactionCityJobTitleInfo = 52;--查看本帮派的城池的官位信息
Const_MsgType.MODULE_FACTION_getFactionCityJobTitleList = 53;--查看本帮派的城池的官位申请列表
Const_MsgType.MODULE_FACTION_offerCityJobTitle = 54;--颁封或撤销封官
Const_MsgType.MODULE_FACTION_getCityJobTitleSalary = 55;--领取俸禄
Const_MsgType.MODULE_FACTION_applyForCityJobTitle = 56;--申请城池官位
Const_MsgType.MODULE_FACTION_cancelApplyForCityJobTitle = 57;--取消申请
Const_MsgType.MODULE_FACTION_getAllCityKillArmyInfo = 58;--获取所有城战杀敌信息
Const_MsgType.MODULE_FACTION_getCityWarRank = 59;--获取城战杀敌榜
Const_MsgType.MODULE_FACTION_acqCityWarKillReward = 60;--领取累积杀敌奖励
Const_MsgType.MODULE_FACTION_quitCityJob = 61;--辞去官位
Const_MsgType.MODULE_FACTION_getFactionCityJobInfo = 62;--获取帮派激活的官职体系
Const_MsgType.MODULE_FACTION_offerCityJob = 63;--任命官职
Const_MsgType.MODULE_FACTION_cancelCityJob = 64;--撤销官职
Const_MsgType.MODULE_FACTION_oneKeyAcqFactionManorMoney = 65;--一键领取所有城池的奖励
Const_MsgType.MODULE_FACTION_impeachMaster = 66;--弹劾军团长
Const_MsgType.MODULE_FACTION_getFactionTreasureInfo = 67;--军团宝库
Const_MsgType.MODULE_FACTION_operFactionTrea = 68;--多去军团宝物
Const_MsgType.MODULE_FACTION_giveUpCity = 69;--放弃城池
Const_MsgType.MODULE_FACTION_dissolveFaction = 70;--解散军团
Const_MsgType.MODULE_FACTION_fireOnCity = 71;--集火城池
Const_MsgType.MODULE_FACTION_cityLoginVerify = 72;--是否能进入城战
----------------------------------------------------------------
Const_MsgType.MODULE_CAMPAIGN = 7;
Const_MsgType.MODULE_CAMPAIGN_getCampaignInfo = 1;
Const_MsgType.MODULE_CAMPAIGN_upClassicPosition = 2;
Const_MsgType.MODULE_CAMPAIGN_validClassicBattle = 3;
Const_MsgType.MODULE_CAMPAIGN_classicBattle = 4;
Const_MsgType.MODULE_CAMPAIGN_getHeroTrialsInfo = 5;
Const_MsgType.MODULE_CAMPAIGN_upHeroTrialsPosition = 6;
Const_MsgType.MODULE_CAMPAIGN_validTrialsBattle = 7;
Const_MsgType.MODULE_CAMPAIGN_heroTrialsBattle = 8;
Const_MsgType.MODULE_CAMPAIGN_acqHeroTrialsReward = 9;
Const_MsgType.MODULE_CAMPAIGN_getFourSidesWarInfo = 10;
Const_MsgType.MODULE_CAMPAIGN_validFourSidesWar = 11;
Const_MsgType.MODULE_CAMPAIGN_fourSidesWarBattle = 12;

Const_MsgType.MODULE_CAMPAIGN_upFourSidesWarPosition = 14;
Const_MsgType.MODULE_CAMPAIGN_openFourSidesWarBox = 15;
Const_MsgType.MODULE_CAMPAIGN_getFourSidesWarEnemy = 16;
Const_MsgType.MODULE_CAMPAIGN_getFourSidesWarShop = 17;
Const_MsgType.MODULE_CAMPAIGN_refreshFourSidesWarShop = 18;
Const_MsgType.MODULE_CAMPAIGN_buyFourSidesWarShopItem = 19;
Const_MsgType.MODULE_CAMPAIGN_getArenaInfo = 20;



Const_MsgType.MODULE_CAMPAIGN_modifyArenaAtkSetup = 22;
Const_MsgType.MODULE_CAMPAIGN_modifyArenaDefSetup = 23;
Const_MsgType.MODULE_CAMPAIGN_arenaBattle = 24;

Const_MsgType.MODULE_CAMPAIGN_refreshArenaPlayer = 25;
Const_MsgType.MODULE_CAMPAIGN_buyArenaTimes = 26;

Const_MsgType.MODULE_CAMPAIGN_getArenaRank = 27;
Const_MsgType.MODULE_CAMPAIGN_getArenaShop = 28;
Const_MsgType.MODULE_CAMPAIGN_refreshArenaShop = 29;
Const_MsgType.MODULE_CAMPAIGN_buyArenaShopItem = 30;
Const_MsgType.MODULE_CAMPAIGN_resetArenaCoolTime = 31;
Const_MsgType.MODULE_CAMPAIGN_getArenaReportInfo = 32;
Const_MsgType.MODULE_CAMPAIGN_playerBackReport = 33;
Const_MsgType.MODULE_CAMPAIGN_resetFourSides = 34;
Const_MsgType.MODULE_CAMPAIGN_trialsMopup = 35;
Const_MsgType.MODULE_CAMPAIGN_acqHeroTrialsFirstReward = 36;
Const_MsgType.MODULE_CAMPAIGN_buyTrialsTimes = 37;
Const_MsgType.MODULE_CAMPAIGN_buyClassicTimes = 38;
Const_MsgType.MODULE_CAMPAIGN_getDuelInfo = 39;
Const_MsgType.MODULE_CAMPAIGN_getDuelInst = 40;
Const_MsgType.MODULE_CAMPAIGN_validDuelBattle = 41;
Const_MsgType.MODULE_CAMPAIGN_duelBattle = 42;
Const_MsgType.MODULE_CAMPAIGN_duelMopup = 44;
Const_MsgType.MODULE_CAMPAIGN_refreshDuel = 45;
Const_MsgType.MODULE_CAMPAIGN_fourSidesMopup = 46;
Const_MsgType.MODULE_CAMPAIGN_classicMopup = 47;

----------------------------------------------------------------------
Const_MsgType.MODULE_MAIL = 8
Const_MsgType.MODULE_MAIL_getAllPlayerMail = 1
Const_MsgType.MODULE_MAIL_getOneMailDetailInfo = 2
Const_MsgType.MODULE_MAIL_recMailReward = 3
Const_MsgType.MODULE_MAIL_getNoReadNum = 4
Const_MsgType.MODULE_MAIL_writeMail = 5
Const_MsgType.MODULE_MAIL_getFactionMemberName = 6
Const_MsgType.MODULE_MAIL_removePlayerMail = 7
Const_MsgType.MODULE_MAIL_onekeyAcqMailReward = 8
----------------------------------------------------------------
Const_MsgType.MODULE_RECHARGE = 9
Const_MsgType.MODULE_RECHARGE_queryRecharge = 1
Const_MsgType.MODULE_RECHARGE_getOrderRequest = 2
Const_MsgType.MODULE_RECHARGE_testCharge = 3
Const_MsgType.MODULE_RECHARGE_getRechargeNeedInfo = 4
Const_MsgType.MODULE_RECHARGE_iosRecharge = 5
Const_MsgType.MODULE_RECHARGE_recordIosFailRecharge = 6
Const_MsgType.MODULE_RECHARGE_getYybOrderInfo = 7 --应用宝特有
Const_MsgType.MODULE_RECHARGE_aibeiOrder = 8 --请求h5版爱贝支付参数
Const_MsgType.MODULE_RECHARGE_getUCOrderInfo = 9 --UC特有
Const_MsgType.MODULE_RECHARGE_getOtherRechargeNeedInfo = 10;--其它第三方
--------------------------------------------------------------------------
Const_MsgType.MODULE_TALENT = 10;
Const_MsgType.MODULE_TALENT_getTalentInfo = 1;
Const_MsgType.MODULE_TALENT_modifyTalentPoint = 2;
Const_MsgType.MODULE_TALENT_acqTalentPoint = 3;
Const_MsgType.MODULE_TALENT_upTalentLv = 4;
Const_MsgType.MODULE_TALENT_resetTalent = 5;
Const_MsgType.MODULE_TALENT_openTalentPage = 6;
Const_MsgType.MODULE_TALENT_changeTalentPage = 7;

------------------------------------------------------------------------
Const_MsgType.MODULE_FarmProxy = 11;
Const_MsgType.MODULE_FarmProxy_getLandInfo = 1;
Const_MsgType.MODULE_FarmProxy_openNewLand = 2;
Const_MsgType.MODULE_FarmProxy_acqLandFood = 3;
Const_MsgType.MODULE_FarmProxy_perCulLand = 4;
Const_MsgType.MODULE_FarmProxy_forciblyLand = 5;
Const_MsgType.MODULE_FarmProxy_oneKeyPerCulLand = 6;
-----------------------------------------------------------------------------
Const_MsgType.MODULE_TOMBDIG = 12;
Const_MsgType.MODULE_TOMBDIG_getTreasureInfo = 1;
Const_MsgType.MODULE_TOMBDIG_digTreasure = 2;
Const_MsgType.MODULE_TOMBDIG_openTreasureBox = 3;
Const_MsgType.MODULE_TOMBDIG_getAcqTreasure = 4;
Const_MsgType.MODULE_TOMBDIG_getTreasureRecords = 5;
Const_MsgType.MODULE_TOMBDIG_resetTreasureLine = 6;
--------------------------------------------------------------------------
Const_MsgType.MODULE_ActivityProxy = 13;
Const_MsgType.MODULE_ActivityProxy_getGodsTreasureInfo = 1;
Const_MsgType.MODULE_ActivityProxy_acqGodsTreasureReward = 2;
Const_MsgType.MODULE_ActivityProxy_getActivityInfo = 3;
Const_MsgType.MODULE_ActivityProxy_getHeavenGoldInfo = 4;
Const_MsgType.MODULE_ActivityProxy_acqHeavenGoldReward = 5;
Const_MsgType.MODULE_ActivityProxy_getEatWorldInfo = 6;
Const_MsgType.MODULE_ActivityProxy_acqEatWorldReward = 7;
Const_MsgType.MODULE_ActivityProxy_firstRechargeInfo = 8;
Const_MsgType.MODULE_ActivityProxy_acqFirstRechargeReward = 9;
Const_MsgType.MODULE_ActivityProxy_luxurySignInfo = 10;
Const_MsgType.MODULE_ActivityProxy_extraLuxurySignReward = 11;
Const_MsgType.MODULE_ActivityProxy_luxurySignReward = 12;
Const_MsgType.MODULE_ActivityProxy_getGenActivityInfo = 13;
Const_MsgType.MODULE_ActivityProxy_acqGenActivityReward = 14; 
Const_MsgType.MODULE_ActivityProxy_getMingMenInfo = 15; 
Const_MsgType.MODULE_ActivityProxy_buyMingMenjia = 16; 
Const_MsgType.MODULE_ActivityProxy_getSevenLoginInfo = 17; 
Const_MsgType.MODULE_ActivityProxy_acqSevenLoginReward = 18; 
Const_MsgType.MODULE_ActivityProxy_getThreeMissionInfo = 19; 
Const_MsgType.MODULE_ActivityProxy_getThreeMissReward = 20; 
Const_MsgType.MODULE_ActivityProxy_getRankInfo = 21; 
Const_MsgType.MODULE_ActivityProxy_getBattleOfLevelInfo = 22;
Const_MsgType.MODULE_ActivityProxy_enterBattleOfLevel = 23;
Const_MsgType.MODULE_ActivityProxy_getBattleOfLevelReward = 24;
Const_MsgType.MODULE_ActivityProxy_resultOfBattleOfLevel = 25;
Const_MsgType.MODULE_ActivityProxy_getFunctionActivityInfo = 26;
Const_MsgType.MODULE_ActivityProxy_getEventActivityInfo = 27;
Const_MsgType.MODULE_ActivityProxy_acqFunctionActivityReward = 28;
Const_MsgType.MODULE_ActivityProxy_getMingjiangInfo = 29;
Const_MsgType.MODULE_ActivityProxy_buyMingjiangItem = 30;
Const_MsgType.MODULE_ActivityProxy_getLevelShopInfo = 31;
Const_MsgType.MODULE_ActivityProxy_buyLevelShopInfo = 32;
Const_MsgType.MODULE_ActivityProxy_getXunyouShopInfo = 33;
Const_MsgType.MODULE_ActivityProxy_buyXunyouShop = 34;
Const_MsgType.MODULE_ActivityProxy_getShenjiangInfo = 35;
Const_MsgType.MODULE_ActivityProxy_acqShenjiangLogin = 36;
Const_MsgType.MODULE_ActivityProxy_acqShenjiangMission = 37;
Const_MsgType.MODULE_ActivityProxy_acqShenjiangChallenge = 38;
Const_MsgType.MODULE_ActivityProxy_exShenjiangSoul = 39;
Const_MsgType.MODULE_ActivityProxy_enterShenjiangChallenge = 40;
Const_MsgType.MODULE_ActivityProxy_resultOfShenjiangChallenge = 41;
Const_MsgType.MODULE_ActivityProxy_getHeroPowerMission = 42;
Const_MsgType.MODULE_ActivityProxy_acqHeroPowerReward = 43;
Const_MsgType.MODULE_ActivityProxy_getLimitHeroInfo = 44;
Const_MsgType.MODULE_ActivityProxy_limitHeroOneTime = 45;
Const_MsgType.MODULE_ActivityProxy_limitHeroTenTime = 46;
Const_MsgType.MODULE_ActivityProxy_limitHeroBuyShopItem = 47;
Const_MsgType.MODULE_ActivityProxy_limitHeroAcqReward = 48;
Const_MsgType.MODULE_ActivityProxy_getAncTreaInfo = 49;
Const_MsgType.MODULE_ActivityProxy_getAncTreaRecords = 50;
Const_MsgType.MODULE_ActivityProxy_ancTreaExplore = 51;
Const_MsgType.MODULE_ActivityProxy_acqAncTreaProgress = 52;

Const_MsgType.MODULE_ActivityProxy_getQijinInfo = 53;
Const_MsgType.MODULE_ActivityProxy_qijinDraw = 54;
Const_MsgType.MODULE_ActivityProxy_qijinRefreshDraw = 55;
Const_MsgType.MODULE_ActivityProxy_qijinBuyTimes = 56;

Const_MsgType.MODULE_ActivityProxy_resultOfQijinChallenge = 58;
Const_MsgType.MODULE_ActivityProxy_enterQijinChallenge = 57;

Const_MsgType.MODULE_ActivityProxy_getRechargeShopInfo = 59;
Const_MsgType.MODULE_ActivityProxy_buyRechargeShop = 60 ;
Const_MsgType.MODULE_ActivityProxy_acqMountRechargeReward = 61 ;

Const_MsgType.MODULE_ActivityProxy_getHefuArenaRankInfo = 62 ;
Const_MsgType.MODULE_ActivityProxy_getHefuKillRankInfo = 63 ;
Const_MsgType.MODULE_ActivityProxy_getHefuHeroRankInfo = 65 ;
Const_MsgType.MODULE_ActivityProxy_getHefuMaxPowerRankInfo = 66 ;
Const_MsgType.MODULE_ActivityProxy_getHefuRechargeRankInfo = 67 ;
Const_MsgType.MODULE_ActivityProxy_getHefuShopInfo = 68 ;
Const_MsgType.MODULE_ActivityProxy_buyHefuShop = 69 ;

Const_MsgType.MODULE_ActivityProxy_getFestivalLogin = 70 ;
Const_MsgType.MODULE_ActivityProxy_acqFestivalLogin = 71 ;

Const_MsgType.MODULE_ActivityProxy_zajindanLottery = 72 ;
Const_MsgType.MODULE_ActivityProxy_zajindanInfo = 73 ;
Const_MsgType.MODULE_ActivityProxy_zajindanRefresh = 74 ;
Const_MsgType.MODULE_ActivityProxy_zajindanReward = 75 ;
Const_MsgType.MODULE_ActivityProxy_closeSmashEggPop = 76;
Const_MsgType.MODULE_ActivityProxy_getTimeFood = 77;
Const_MsgType.MODULE_ActivityProxy_removeRefreshCD = 78;
Const_MsgType.MODULE_ActivityProxy_getDailyRechargeInfo = 79;
Const_MsgType.MODULE_ActivityProxy_getDailyRechargeReward = 80;
Const_MsgType.MODULE_ActivityProxy_getOnlineRewardInfo = 81;
Const_MsgType.MODULE_ActivityProxy_getOnlineReward = 82;
Const_MsgType.MODULE_ActivityProxy_acqBreakRechargeReward = 83;
Const_MsgType.MODULE_ActivityProxy_acqAdvanceRechargeReward = 84;
Const_MsgType.MODULE_ActivityProxy_acqBaoshi = 85;

Const_MsgType.MODULE_ActivityProxy_acqNationDayInfo = 86;
Const_MsgType.MODULE_ActivityProxy_exchangeNationDayGift = 87;
Const_MsgType.MODULE_ActivityProxy_acqActRechargeReward = 89;
Const_MsgType.MODULE_ActivityProxy_getTreasureInfo = 90;
Const_MsgType.MODULE_ActivityProxy_getTreasureRecords = 91;
Const_MsgType.MODULE_ActivityProxy_ancTreasure = 92;
Const_MsgType.MODULE_ActivityProxy_getCostGoldInfo = 93;
Const_MsgType.MODULE_ActivityProxy_rewardCostGold = 94;
Const_MsgType.MODULE_ActivityProxy_getCaptureTerritoryInfo = 95;
Const_MsgType.MODULE_ActivityProxy_rewardCaptureTerritory = 96;
Const_MsgType.MODULE_ActivityProxy_getHeroSacrifice = 97;
Const_MsgType.MODULE_ActivityProxy_sacrificeHero = 98;


----------------------------------------------------------------------
Const_MsgType.MODULE_MANOR = 14 -- 领地
Const_MsgType.MODULE_MANOR_getManorInfo = 1 -- 获取领地信息
Const_MsgType.MODULE_MANOR_openNewManor = 2 -- 开垦新的领地
Const_MsgType.MODULE_MANOR_upgradeBuild = 3 -- 建筑升级
Const_MsgType.MODULE_MANOR_cancelUpgrade = 4 -- 取消建筑升级
Const_MsgType.MODULE_MANOR_speedUpgrade = 5 -- 加速建筑升级
Const_MsgType.MODULE_MANOR_removeBuild = 6 -- 拆除建筑
Const_MsgType.MODULE_MANOR_acqSilverFood = 7 -- 收获铜钱或者粮草
Const_MsgType.MODULE_MANOR_drillGroundStart = 8 -- 开始校场训练
Const_MsgType.MODULE_MANOR_speedUpDrillGround = 9 -- 加速校场训练
Const_MsgType.MODULE_MANOR_acqDrillGroundExp = 10 -- 领取校场经验
Const_MsgType.MODULE_MANOR_refreshArtisanItem = 11 -- 刷新工匠坊材料
Const_MsgType.MODULE_MANOR_artisanStart = 12 -- 工匠坊开始生产
Const_MsgType.MODULE_MANOR_acqArtisanItem = 13 -- 工匠坊领取材料
Const_MsgType.MODULE_MANOR_oneKeyAcqResource = 14 -- 一键领取
Const_MsgType.MODULE_MANOR_getOneBuildInfo = 15 -- 获取单个建筑信息

Const_MsgType.MODULE_MANOR_moveOneBuild = 16 -- 移动建筑
Const_MsgType.MODULE_MANOR_buyUpgradeLine = 17 -- 购买升级队列
Const_MsgType.MODULE_MANOR_speedUpArtisan = 18 -- 加速工匠坊
Const_MsgType.MODULE_MANOR_oneKeyUpgradeBuild = 19 -- 一键加速
Const_MsgType.MODULE_MANOR_upBuildOneKey = 20 -- 建筑一键升级

--------------------------------------------------------------------------------------------
Const_MsgType.MODULE_JUNFU = 15;
Const_MsgType.MODULE_JUNFU_getInfo = 1;
Const_MsgType.MODULE_JUNFU_saveTeam = 2;
Const_MsgType.MODULE_JUNFU_saveInfo = 3;
Const_MsgType.MODULE_JUNFU_dispatchGroupForCity = 4;
Const_MsgType.MODULE_JUNFU_getCityAndHeroState = 5;

--------------------------------------------------------------------

-- 无双争霸
Const_MsgType.MODULE_COMPETITION = 16
Const_MsgType.MODULE_COMPETITION_getCompetInfo = 1
Const_MsgType.MODULE_COMPETITION_getCompetPlayerInfo = 2
Const_MsgType.MODULE_COMPETITION_modifyCompetAtkSetup = 3
Const_MsgType.MODULE_COMPETITION_modifyCompetDefSetup = 4
Const_MsgType.MODULE_COMPETITION_refreshCompetPlayer = 5
Const_MsgType.MODULE_COMPETITION_buyCompetTimes = 6
Const_MsgType.MODULE_COMPETITION_getCompetRank = 7
Const_MsgType.MODULE_COMPETITION_getCompetThreeRank = 8
Const_MsgType.MODULE_COMPETITION_acqCompetScoreReward = 9
Const_MsgType.MODULE_COMPETITION_competMoubai = 10
Const_MsgType.MODULE_COMPETITION_modifyCompetDecl = 11
Const_MsgType.MODULE_COMPETITION_getCompetReportInfo = 12
Const_MsgType.MODULE_COMPETITION_competBackReport = 13
Const_MsgType.MODULE_COMPETITION_competBattle = 14
Const_MsgType.MODULE_COMPETITION_competUpRankBattle = 15
Const_MsgType.MODULE_COMPETITION_oneKeyScoreRewards = 16
Const_MsgType.MODULE_COMPETITION_resetCompetCoolTime = 17
Const_MsgType.MODULE_COMPETITION_skipCompetition = 18

--皇宫
Const_MsgType.MODULE_PALACEFUN = 17
Const_MsgType.MODULE_PALACEFUN_getPalaceFunInfo = 1
Const_MsgType.MODULE_PALACEFUN_getEmperorInfo = 2
Const_MsgType.MODULE_PALACEFUN_getYufuShopInfo = 6
Const_MsgType.MODULE_PALACEFUN_refreshYufuShop = 7
Const_MsgType.MODULE_PALACEFUN_buyYufuShopItem = 8
Const_MsgType.MODULE_PALACEFUN_visitEmperorReward = 3
Const_MsgType.MODULE_PALACEFUN_getBaiguanReward = 4
Const_MsgType.MODULE_PALACEFUN_acqBaiguanReward = 5
Const_MsgType.MODULE_PALACEFUN_getYusaiRankInfo = 9
Const_MsgType.MODULE_PALACEFUN_getSacrificeInfo = 10
Const_MsgType.MODULE_PALACEFUN_setSacrificeCities = 11
Const_MsgType.MODULE_PALACEFUN_getPointEnemyInfo = 12
Const_MsgType.MODULE_PALACEFUN_pointEnemy = 13
--爬塔 --消息还是写到campaignProxy里的
Const_MsgType.MODULE_DIM = 18
Const_MsgType.MODULE_DIM_getDimInfo = 1
Const_MsgType.MODULE_DIM_validDimBattle = 2
Const_MsgType.MODULE_DIM_dimBattle = 3
Const_MsgType.MODULE_DIM_openDimBox = 4
Const_MsgType.MODULE_DIM_dimNormalMopup = 5
Const_MsgType.MODULE_DIM_dimEliteMopup = 6
Const_MsgType.MODULE_DIM_dimRank = 7
Const_MsgType.MODULE_DIM_upDimPosition = 8
Const_MsgType.MODULE_DIM_buyDimTimes = 9
Const_MsgType.MODULE_DIM_resetDim = 10
Const_MsgType.MODULE_DIM_acqDimFirstWinReward = 11
--三军演武
Const_MsgType.MODULE_SANJUNYANWU = 19
Const_MsgType.MODULE_SANJUNYANWU_setYwHeroList = 1
Const_MsgType.MODULE_SANJUNYANWU_getYwHeroList = 2
Const_MsgType.MODULE_SANJUNYANWU_matchFight = 3
Const_MsgType.MODULE_SANJUNYANWU_challenge = 4
Const_MsgType.MODULE_SANJUNYANWU_oneKeyTheBattle = 5
Const_MsgType.MODULE_SANJUNYANWU_admitDefeat = 6
Const_MsgType.MODULE_SANJUNYANWU_getRankInfo = 7
Const_MsgType.MODULE_SANJUNYANWU_getWinStreamInfo = 8
Const_MsgType.MODULE_SANJUNYANWU_getWinStreamReward = 9
Const_MsgType.MODULE_SANJUNYANWU_getBattleListInfo = 10
Const_MsgType.MODULE_SANJUNYANWU_getBattleDetailInfo = 11
Const_MsgType.MODULE_SANJUNYANWU_getSeasonPreviewInfo = 12
--------------------------------------------------------------------
--世界boss
Const_MsgType.MODULE_WORLDBOSS = 20
Const_MsgType.MODULE_WORLDBOSS_login = 1
Const_MsgType.MODULE_WORLDBOSS_setHeroList = 2
Const_MsgType.MODULE_WORLDBOSS_encourage = 3
Const_MsgType.MODULE_WORLDBOSS_fight = 4
Const_MsgType.MODULE_WORLDBOSS_revive = 5
Const_MsgType.MODULE_WORLDBOSS_broadcastFightResult = 6
Const_MsgType.MODULE_WORLDBOSS_getBonusProgressInfo = 7
Const_MsgType.MODULE_WORLDBOSS_getBonusReward = 8
Const_MsgType.MODULE_WORLDBOSS_getDropBoxInfo = 9
Const_MsgType.MODULE_WORLDBOSS_getDropBoxReward = 10
Const_MsgType.MODULE_WORLDBOSS_heartBeat = 11
Const_MsgType.MODULE_WORLDBOSS_boxRest = 12
Const_MsgType.MODULE_WORLDBOSS_getMyRank = 13
Const_MsgType.MODULE_WORLDBOSS_broadcastBigRewardResult = 14
--------------------------------------------------------------------
--夺宝奇兵
Const_MsgType.MODULE_ROTLA = 21
Const_MsgType.MODULE_ROTLA_getRotlaInfo = 1
Const_MsgType.MODULE_ROTLA_rotlaBattle = 2
Const_MsgType.MODULE_ROTLA_buyRotlaTimes = 3
Const_MsgType.MODULE_ROTLA_rotlaReward = 4
--传奇挑战
Const_MsgType.MODULE_LEGEND = 22
Const_MsgType.MODULE_LEGEND_getLegendInfo = 1
Const_MsgType.MODULE_LEGEND_validLegendBattle = 2
Const_MsgType.MODULE_LEGEND_LegendBattle = 3
Const_MsgType.MODULE_LEGEND_buyLegendTimes = 4

--------------------------------------------------------------------


--占山为王
Const_MsgType.MODULE_ZhanShanProxy = 23
Const_MsgType.MODULE_ZhanShanProxy_find = 1
Const_MsgType.MODULE_ZhanShanProxy_resources = 2
Const_MsgType.MODULE_ZhanShanProxy_floors = 3
Const_MsgType.MODULE_ZhanShanProxy_ranking = 4
Const_MsgType.MODULE_ZhanShanProxy_faction = 5
Const_MsgType.MODULE_ZhanShanProxy_info = 6
Const_MsgType.MODULE_ZhanShanProxy_records = 7
Const_MsgType.MODULE_ZhanShanProxy_defenseLineup = 8
Const_MsgType.MODULE_ZhanShanProxy_occupy = 9
Const_MsgType.MODULE_ZhanShanProxy_abort = 10
Const_MsgType.MODULE_ZhanShanProxy_getRecords = 11
Const_MsgType.MODULE_ZhanShanProxy_getEnemyOccupy = 12
Const_MsgType.MODULE_ZhanShanProxy_getPlayerInfo = 13;
--------------------------------------------------------------------

--传奇挑战
Const_MsgType.MODULE_DREAMBACK = 24
Const_MsgType.MODULE_DREAMBACK_getDreamBattleInfo = 1
Const_MsgType.MODULE_DREAMBACK_dreamBattle = 2
Const_MsgType.MODULE_DREAMBACK_buyDreamTimes = 3
Const_MsgType.MODULE_DREAMBACK_dreamReward = 4
--------------------------------------------------------------------

--后宫系统
Const_MsgType.MODULE_BEAUTY = 25
Const_MsgType.MODULE_BEAUTY_getBeautyPlayInfo = 1 
Const_MsgType.MODULE_BEAUTY_openBeauty = 2 
Const_MsgType.MODULE_BEAUTY_buyBeautyTimes = 3 
Const_MsgType.MODULE_BEAUTY_darlingBeauty = 4 
Const_MsgType.MODULE_BEAUTY_giveBeauty = 5 
Const_MsgType.MODULE_BEAUTY_upBeautyTalent = 6
Const_MsgType.MODULE_BEAUTY_rewardBeautyTalent = 7
Const_MsgType.MODULE_BEAUTY_getBeautyInfo = 8 

--------------------------------------------------------------------

--天下第一
Const_MsgType.MODULE_PEERLESS = 26
Const_MsgType.MODULE_PEERLESS_getPeerLess = 1
Const_MsgType.MODULE_PEERLESS_getPeerLessRank = 2
Const_MsgType.MODULE_PEERLESS_getPeerLessBattleInfo = 3
Const_MsgType.MODULE_PEERLESS_getPeerLessBattleInfo1 = 4
Const_MsgType.MODULE_PEERLESS_setPeerLessHeroList = 5
Const_MsgType.MODULE_PEERLESS_setPeerLessSupport = 6
Const_MsgType.MODULE_PEERLESS_PeerLessWorship = 7
Const_MsgType.MODULE_PEERLESS_getPeerLessWinerInfo = 8
Const_MsgType.MODULE_PEERLESS_getPeerLessBattleReport = 9

--------------------------------------------------------------------
--过关斩将
Const_MsgType.MODULE_CLEARANCE = 27
Const_MsgType.MODULE_CLEARANCE_getClearanceInfo = 1
Const_MsgType.MODULE_CLEARANCE_clearanceBattle = 2
Const_MsgType.MODULE_CLEARANCE_resurrectionHero = 3
--------------------------------------------------------------------

Const_MsgType.MODULE_CHAT = 200;
Const_MsgType.MODULE_CHAT_login = 1;
Const_MsgType.MODULE_CHAT_worldChat = 2;
Const_MsgType.MODULE_CHAT_pushChat = 3;
Const_MsgType.MODULE_CHAT_heartBeat = 4;


----------------------------------------------------------------------------
Const_MsgType.MODULE_FACTIONWAR = 300;
Const_MsgType.MODULE_FACTIONWAR_login = 1;
Const_MsgType.MODULE_FACTIONWAR_viewBattleReport = 2;
Const_MsgType.MODULE_FACTIONWAR_addGroup_r = 3;
Const_MsgType.MODULE_FACTIONWAR_battleBegin_r = 4;
Const_MsgType.MODULE_FACTIONWAR_battleResult_r = 5;
Const_MsgType.MODULE_FACTIONWAR_battleReward_r = 6;
Const_MsgType.MODULE_FACTIONWAR_viewGroupDetail = 7;
Const_MsgType.MODULE_FACTIONWAR_gridStateChanged_r = 8;

Const_MsgType.MODULE_FACTIONWAR_groupNumChanged_r = 9;
Const_MsgType.MODULE_FACTIONWAR_dispatchGroup = 10;
Const_MsgType.MODULE_FACTIONWAR_retreat = 11;
Const_MsgType.MODULE_FACTIONWAR_removeGroup_r = 12;
Const_MsgType.MODULE_FACTIONWAR_reviveHero = 13;
Const_MsgType.MODULE_FACTIONWAR_warEnded_r = 14;
Const_MsgType.MODULE_FACTIONWAR_getAvailableHeroInfo = 16;
Const_MsgType.MODULE_FACTIONWAR_cityStateChanged_r = 17;
Const_MsgType.MODULE_FACTIONWAR_getCityLeftArmy = 18;
Const_MsgType.MODULE_FACTIONWAR_heartBeat = 19;
Const_MsgType.MODULE_FACTIONWAR_buyShortCutItem = 20;
Const_MsgType.MODULE_FACTIONWAR_countdown = 21;
Const_MsgType.MODULE_FACTIONWAR_getFactionCityJobId = 22;
Const_MsgType.MODULE_FACTIONWAR_getHufuBuyTimes = 23;
Const_MsgType.MODULE_FACTIONWAR_buyHufu = 24;


Const_MsgType.MODULE_PALACEBATTLE = 400;
Const_MsgType.MODULE_PALACEBATTLE_login = 1;
Const_MsgType.MODULE_PALACEBATTLE_npcNumChg_r = 2;
Const_MsgType.MODULE_PALACEBATTLE_enterVIPStands = 3;
Const_MsgType.MODULE_PALACEBATTLE_enterPKStands = 4;
Const_MsgType.MODULE_PALACEBATTLE_positonChg = 5;
Const_MsgType.MODULE_PALACEBATTLE_robPostion = 6;
Const_MsgType.MODULE_PALACEBATTLE_bonus = 7;
Const_MsgType.MODULE_PALACEBATTLE_leaveStands = 8;
Const_MsgType.MODULE_PALACEBATTLE_leaveCity = 9;
Const_MsgType.MODULE_PALACEBATTLE_positionRobbed = 10;
Const_MsgType.MODULE_PALACEBATTLE_result_r = 11;
Const_MsgType.MODULE_PALACEBATTLE_adjustArmy = 13;
Const_MsgType.MODULE_PALACEBATTLE_getArmyCampInfo = 14;
Const_MsgType.MODULE_PALACEBATTLE_leavePosition = 12;
Const_MsgType.MODULE_PALACEBATTLE_getJuesaiRankInfo = 15;
Const_MsgType.MODULE_PALACEBATTLE_standsChg = 16;
Const_MsgType.MODULE_PALACEBATTLE_statusChg_r = 17;
------------------------------------------------------------------
Const_MsgType.MODULE_KUAFU = 500;
Const_MsgType.MODULE_KUAFU_getRedictionRankInfo = 1;
Const_MsgType.MODULE_KUAFU_login = 2;
Const_MsgType.MODULE_KUAFU_getOngoingRankInfo = 3;
Const_MsgType.MODULE_KUAFU_focusSpot = 4;
Const_MsgType.MODULE_KUAFU_cancleFocus = 5;
Const_MsgType.MODULE_KUAFU_broacastFocusInfo = 6;
Const_MsgType.MODULE_KUAFU_broacastCancleFocusInfo = 7;
Const_MsgType.MODULE_KUAFU_broacastKingInfo = 8;
Const_MsgType.MODULE_KUAFU_getMoral = 9;
Const_MsgType.MODULE_KUAFU_enterSpot = 10;
Const_MsgType.MODULE_KUAFU_viewBattleReport = 11;
Const_MsgType.MODULE_KUAFU_addGroup_r = 12;
Const_MsgType.MODULE_KUAFU_battleBegin_r = 13;
Const_MsgType.MODULE_KUAFU_battleResult_r = 14;
Const_MsgType.MODULE_KUAFU_viewGroupDetail = 15;
Const_MsgType.MODULE_KUAFU_gridStateChanged_r = 16;
Const_MsgType.MODULE_KUAFU_groupNumChanged_r = 17;
Const_MsgType.MODULE_KUAFU_dispatchGroup = 18;
Const_MsgType.MODULE_KUAFU_retreat = 19;
Const_MsgType.MODULE_KUAFU_removeGroup_r = 20;
Const_MsgType.MODULE_KUAFU_reviveHero = 21;
Const_MsgType.MODULE_KUAFU_warEnded_r = 22;
Const_MsgType.MODULE_KUAFU_getAvailableHeroInfo = 23;
Const_MsgType.MODULE_KUAFU_cityStateChanged_r = 24;
Const_MsgType.MODULE_KUAFU_getCityLeftArmy = 25;
Const_MsgType.MODULE_KUAFU_heartBeat = 26;
Const_MsgType.MODULE_KUAFU_buyShortCutItem = 27;
Const_MsgType.MODULE_KUAFU_countdown = 28;
Const_MsgType.MODULE_KUAFU_getFactionCityJobId = 29;
Const_MsgType.MODULE_KUAFU_getHufuBuyTimes = 30;
Const_MsgType.MODULE_KUAFU_buyHufu = 31;
Const_MsgType.MODULE_KUAFU_leaveSpot = 32;
Const_MsgType.MODULE_KUAFU_spotStatusChg = 33;
Const_MsgType.MODULE_KUAFU_getPlayerDispatchHero = 34;
Const_MsgType.MODULE_KUAFU_reLogin = 9998;
Const_MsgType.MODULE_KUAFU_illegalConnection = 9999;
Const_MsgType.MODULE_KUAFU_granary_enter = 81
Const_MsgType.MODULE_KUAFU_granary_set_heros = 87
Const_MsgType.MODULE_KUAFU_granary_receive_box = 85
Const_MsgType.MODULE_KUAFU_granary_fight = 83
Const_MsgType.MODULE_KUAFU_granary_get_box_info = 86
Const_MsgType.MODULE_KUAFU_granary_broadcast_box_left_num = 91
Const_MsgType.MODULE_KUAFU_granary_my_rank = 88
Const_MsgType.MODULE_KUAFU_granary_broadcast_fight_result = 92
Const_MsgType.MODULE_KUAFU_granary_broadcast_big_reward = 93
Const_MsgType.MODULE_KUAFU_granary_leave = 82
Const_MsgType.MODULE_KUAFU_granary_revive = 84
Const_MsgType.MODULE_KUAFU_getOneSpotInfo = 35;
Const_MsgType.MODULE_KUAFU_broacastMoral = 36;
Const_MsgType.MODULE_KUAFU_granary_broadcast_hp = 94;
Const_MsgType.MODULE_KUAFU_getBroadcas = 105;
Const_MsgType.MODULE_KUAFU_broacastEndStage = 37;
Const_MsgType.MODULE_KUAFU_getOtherPlayerInfo = 38;
Const_MsgType.MODULE_KUAFU_getCityWarRank = 39;
------------------------------------------------------------------
Const_MsgType.MODULE_SANGUOSHA = 510;
Const_MsgType.MODULE_SANGUOSHA_login = 1;
Const_MsgType.MODULE_SANGUOSHA_brocastNpcNumChg = 2;
Const_MsgType.MODULE_SANGUOSHA_getWarSituation = 3;
Const_MsgType.MODULE_SANGUOSHA_enterSpot = 4;
Const_MsgType.MODULE_SANGUOSHA_viewBattleReport = 5;
Const_MsgType.MODULE_SANGUOSHA_addGroup_r = 6;
Const_MsgType.MODULE_SANGUOSHA_battleBegin_r = 7;
Const_MsgType.MODULE_SANGUOSHA_battleResult_r = 8;
Const_MsgType.MODULE_SANGUOSHA_viewGroupDetail = 9;
Const_MsgType.MODULE_SANGUOSHA_gridStateChanged_r = 10;
Const_MsgType.MODULE_SANGUOSHA_groupNumChanged_r = 11;
Const_MsgType.MODULE_SANGUOSHA_dispatchGroup = 12;
Const_MsgType.MODULE_SANGUOSHA_retreat = 13;
Const_MsgType.MODULE_SANGUOSHA_removeGroup_r = 14;
Const_MsgType.MODULE_SANGUOSHA_reviveHero = 15;
Const_MsgType.MODULE_SANGUOSHA_warEnded_r = 16;
Const_MsgType.MODULE_SANGUOSHA_getAvailableHeroInfo = 17;
Const_MsgType.MODULE_SANGUOSHA_getCityLeftArmy = 18;
Const_MsgType.MODULE_SANGUOSHA_heartBeat = 19;
Const_MsgType.MODULE_SANGUOSHA_buyShortCutItem = 20;
Const_MsgType.MODULE_SANGUOSHA_countdown = 21;
Const_MsgType.MODULE_SANGUOSHA_getHufuBuyTimes = 22;
Const_MsgType.MODULE_SANGUOSHA_buyHufu = 23;
Const_MsgType.MODULE_SANGUOSHA_leaveSpot = 24;
Const_MsgType.MODULE_SANGUOSHA_spotStatusChg = 25;
Const_MsgType.MODULE_SANGUOSHA_getPlayerDispatchHero = 26;
Const_MsgType.MODULE_SANGUOSHA_getOneSpotInfo = 27;
Const_MsgType.MODULE_SANGUOSHA_broacastEndStage = 28;
Const_MsgType.MODULE_SANGUOSHA_getOtherPlayerInfo = 38;
Const_MsgType.MODULE_SANGUOSHA_getBroadcas = 105;
Const_MsgType.MODULE_SANGUOSHA_getCityWarRank = 39;

return Const_MsgType;
