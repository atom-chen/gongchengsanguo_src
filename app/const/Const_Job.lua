cc.exports.Const_Job =cc.exports.Const_Job or {}
 
Const_Job.PIKEMAN = 1;--盾兵
Const_Job.ARCHER = 2;--弓
Const_Job.CAVALRYMAN= 3;--骑
Const_Job.COUNSELLOR = 4 --谋士
Const_Job.CHARIOT = 5 -- 枪兵
Const_Job.WALL = 6 --城墙
Const_Job.TOWER = 7 --箭塔


Const_Job.ORDER = {};
Const_Job.ORDER[Const_Job.PIKEMAN] = {2,1,3,5,4,6,8,7,9}
Const_Job.ORDER[Const_Job.ARCHER] = {8,7,9,5,4,6,2,1,3}
Const_Job.ORDER[Const_Job.CAVALRYMAN] = {2,1,3,5,4,6,8,7,9}
Const_Job.ORDER[Const_Job.COUNSELLOR] = {5,4,6,8,7,9,2,1,3}
Const_Job.ORDER[Const_Job.CHARIOT] = {2,1,3,5,4,6,8,7,9}
Const_Job.ORDER[Const_Job.WALL] = {2,1,3,5,4,6,8,7,9}
function Const_Job:getOrderByJob(job)
    local order = Const_Job.ORDER[job];
    if order == nil then
        order = Const_Job.ORDER[Const_Job.WALL];
    end
    return order;
end
--是否远程
function Const_Job:checkIsRanger( job )
	if job == self.ARCHER or job == self.COUNSELLOR or job == self.TOWER then
		return true
	end
	return false
end

function Const_Job:checkIsBuilding(job)
    if job == self.WALL or job == self.TOWER then
		return true
	end
	return false
end
--是否近战
function Const_Job:checkIsMelee( job )
	return (not self:checkIsRanger(job))
end
return Const_Job