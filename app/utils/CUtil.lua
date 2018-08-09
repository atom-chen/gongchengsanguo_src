--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion
cc.exports.CUtil = cc.exports.CUtil or {}
local aStarForC = require("data.manual.Config_Sys").aStarForC
--本类是c++实现的util
 
function CUtil:getSystemTime()
    --返回1970年到目前为止的毫秒数
    return ccext.GameUtil:getSystemTime();
    --return os.clock();      
end

-- function CUtil:astarFind(map, startPt, endPt, extBlock, fourDir)
--     if nil == fourDir then
--         fourDir = false
--     end
--     return ccext.GameUtil:(map, table.maxn(map[1]), table.maxn(map), startPt, endPt, extBlock, table.maxn(extBlock), fourDir)
-- end
function CUtil:DownloaderBPEx()
    local dl = cc.DownloaderBPEx:create();

    --下载文件如下
    -- dl:setPackageUrl("http://120.26.0.188:8080/resource/dp01_tw/serverList.txt")
    -- dl:packageName("serv.txt");--存到本地的名字
    -- dl:setStoragePath("E://");--存储路径
    -- dl:getErrorCode(); -- 初始化的时候是-1  --正常下载是0 --大于0为下载错误
    -- dl:update();--开始下载
    -- dl:retain();-- 

    --解压文件如下
    --dl:unzip("E://","main.133.com.gametaiwan.jiangdan.obb.obb","E://tmp//");
    --dl:retain();-- 
    --dl:getUnzipInfo() scheduler调用次方法获取解压状态，>=0 为解压的百分比 取的整数  -1为解压失败  -2为解压成功

    return dl;
end
function CUtil:astarCreate(map, startPt, endPt, extBlock)
    -- self.Astar = {}
    if extBlock == nil then extBlock = {} end;
    if 0 == aStarForC then
        if nil == self.Astar then
            self.Astar = require("app.utils.Astar"):create(map, startPt, endPt, extBlock)
        else
            self.Astar:reset(self.Astar, map, startPt, endPt, extBlock)
        end
    elseif 1 == aStarForC then       
        -- self.Astar.map = map
        -- self.Astar.startPt = startPt
        -- self.Astar.endPt = endPt
        -- self.Astar.extBlock = extBlock
        if nil == self.Astar then
            --todo
            self.Astar = ccext.GameUtil:getInstance()
            self.Astar:bindAstar(map, table.maxn(map[1]), table.maxn(map),
                startPt, endPt, extBlock, table.maxn(extBlock))
        else
            self.Astar:aStarReset(startPt, endPt, extBlock, table.maxn(extBlock))
        end
    end
end

function CUtil:find_4dir()
	return self:find(true)
end

function CUtil:find(fourDir)
	if fourDir == nil then
		fourDir = false
	end
    if 1 == aStarForC then
        return self.Astar:aStarFind(fourDir)
    else
        return self.Astar:find(fourDir)
    end
end
