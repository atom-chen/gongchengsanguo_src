cc.exports.Const_BattleAction = cc.exports.Const_BattleAction or {}
--action                        --params
--0 setTo                       uId,tileX,tileY
--1 move                        uId,toTileX,toTileY
--2 attack                      uId,targetUId
--3 useSkill                    uId,targets(多个,隔开）
--4 damage                      attackerUId,defenderUId,skId,isHit,isCri,value 
--5 addBuff                     uId,stateId,aniType,aniId,offsetX,offsetY,time,adderUId,defenderUId
--6 removeBuff                  uId,stateId
--7 setState                    uId,state,sw
--8 beBeatBack                  uId,adderUId,dis,time
--9 die                         uId
--10 revive                     uId
--11 result                     winParty   1 party1win    2 party2win
--12 batInfo                    战斗基本信息。当前格式为：batType,insId


Const_BattleAction.SETTO = "0";
Const_BattleAction.MOVE = "1";
Const_BattleAction.ATTACK = "2";
Const_BattleAction.USESKILL = "3";
Const_BattleAction.DAMAGE = "4";
Const_BattleAction.ADDBUFF = "5";
Const_BattleAction.REMOVEBUFF = "6";
Const_BattleAction.SETSTATE = "7";
Const_BattleAction.BEBEATBACK = "8";
Const_BattleAction.DIE = "9";
Const_BattleAction.REVIVE = "10";
Const_BattleAction.RESULT = "11";
Const_BattleAction.BATINFO = "12";
return Const_Action