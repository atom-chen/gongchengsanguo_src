--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--[[
    战斗的随机值
]]
--endregion
cc.exports.BattleRandom = cc.exports.BattleRandom or {}
cc.exports.BattleRandom.context = nil 
local _RANDOM_MAX = 0x7fffffff
cc.exports.BattleRandom.randomSeed = os.time()

local function my_do_random()
    local value  = cc.exports.BattleRandom.randomSeed
    local quotient,remainder,t --1.系数，余数 
    quotient = math.floor(value/127773)
    remainder = value % 127773
    t = 16807 * remainder - 2836 *quotient
    if t <= 0 then 
        t = t + 0x7fffffff
    end
    self:setSeed(t)
    return t % (_RANDOM_MAX + 1)

end


local function my_random(m,n)
    if n < m  and m ~= nil and n ~= nil then 
        n,m = m,n
    end 
    if m==n then Logger:out("随机值不能相同") return end 
    local value =  my_do_random()
    local diff = n - m + 1
    if value > n then 
        value = value % diff + m 
    end 
    if value < m  then 
        value = (value + n)  %diff + m  
    end 
    return value
end

function  BattleRandom:random(m,n,n2)
     if tonumber(m) == nil then 
        m,n = n,n2
     end 
     BattleRandom:setSeed(BattleRandom.randomSeed)
     --取m~n的随机数
     local value = my_random(m,n)
     BattleRandom.randomSeed = BattleRandom.randomSeed + 300000

     if BattleRandom.randomSeed > 2100000000 then 
        BattleRandom.randomSeed = BattleRandom.randomSeed - 1000000000
     end
     return value
end

function BattleRandom:isHit(rate)
    if BattleRandom:random(1,10000) <= rate * 10000 then 
        return true
    else
        return false
    end 
end
function BattleRandom:setSeed(seed)
    BattleRandom.randomSeed = tonumber(seed) or os.time()
end
return cc.exports.BattleRandom