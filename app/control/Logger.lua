--region *.lua
--Date
--此文件由[BabeLua]插件自动生成



--endregion

cc.exports.Logger = cc.exports.Logger or {}

Logger.str = "";
Logger.writeFile = nil;
Logger.timeCostTab = nil;
function Logger:out(...)
    local needPrint = Config_Sys.showPrint;
    local printTime = Config_Sys.printTime;   
    if needPrint < 1 then
        return;
    end        
    local arg = {...}
    if arg == nil then
        print ("Error! Logger:out的参数：arg为nil!检查调用者")
    end
    --Logger:dump(arg)
    local n = #arg;
    local str = "";
    for i = 1,n do        
        str = str .. tostring(arg[i]);
        if i ~= n then
            str = str .. ",";    
        end
    end
    Logger:save(str);
end
function Logger:save(str)
    local needPrint = Config_Sys.showPrint;
    local printTime = Config_Sys.printTime;   
    local timeStr = "";
    if printTime == 1 then
        --lua的时间实现（秒）
        timeStr = os.date();        
    elseif printTime == 2 then
        --c++的时间实现（毫秒）
        timeStr = CUtil:getSystemTime(); 
    end

    print(timeStr .. "  " .. str);
    if needPrint == 2 then
        --写到sd卡 日志信息
        if Logger.writeFile == nil then            
            local path  = cc.FileUtils:getInstance():getWritablePath().."dwsgLog.txt";
            os.remove(path);
            Logger.writeFile = assert(io.open(path, "a"));
        end        
        Logger.writeFile:write(timeStr .. "  " .. str .. "\n");
        --Logger.writeFile:close()
    end
end
function Logger:format( ... )
    if Config_Sys.showPrint < 1 then
        return
    end
    print(string.format(...))
end

function Logger:outf(...)   
    local needPrint = Config_Sys.showPrint;
    local printTime = Config_Sys.printTime;   
    if needPrint < 1 then
        return;
    end 

    local arg = {...}
    --Logger:dump(arg)
    local n = #arg; 
    local timeStr = "";
    if printTime == 1 then
        --lua的时间实现（秒）
        timeStr = os.date();        
    elseif printTime == 2 then
        --c++的时间实现（毫秒）
        timeStr = CUtil:getSystemTime(); 
    end
    arg[1] = timeStr .. " " .. arg[1]
    if n == 1 then  printf(arg[1]) end
    if n == 2 then  printf(arg[1],arg[2]) end
    if n == 3 then  printf(arg[1],arg[2],arg[3]) end
    if n == 4 then  printf(arg[1],arg[2],arg[3], arg[4]) end
    if n == 5 then  printf(arg[1],arg[2],arg[3],arg[4],arg[5]) end
    if n == 6 then  printf(arg[1],arg[2],arg[3],arg[4],arg[5],arg[6]) end
    if n == 7 then  printf(arg[1],arg[2],arg[3],arg[4],arg[5],arg[6], arg[7]) end
    if n == 8 then  printf(arg[1],arg[2],arg[3],arg[4],arg[5],arg[6], arg[7],arg[8]) end
    local str = tostring(arg);
    Logger:save(str);
end
--Logger:dump现在支持两种写法：
--方法一：Logger:dump(tab);
--方法二：Logger:dump(self, tab);--可以带上类本身（或字符串），方便显示你从哪里dump的。
function Logger:dump(...)
    local needPrint = Config_Sys.showPrint    
    if needPrint < 1 then
        return;
    end           
    local arg = {...}
    if #arg == 1 then
        local param = arg[1];
        dump(param);
    else
        --2个参数
        if arg[1] == nil then arg[1] = "" end;
        --若是table或userdata类型
        if type(arg[1]) == "userdata" or type(arg[1]) == "table" then
            arg[1] = arg[1].__cname;
            --若取不到__cname的值，则显示不出来啦
            if arg[1] == nil then arg[1] = "" end
        end        
        Logger:out("Actual Dump from:" .. tostring(arg[1]));
        local param = arg[2]
        dump(param);
    end
     --Logger:save(str);
end
function Logger:throwError(str)
    if __G__TRACKBACK__ then
        __G__TRACKBACK__(str)
    end
end
--method：方法名，string
--beginOrEnd：0代表开始   1代表结束
--extStr: 想顺便记录下来的额外信息(结束的时候传入才起作用)
--注意：若是递归的方法，则会以第一次的开始时间计算
function Logger:recTimeCost(method, beginOrEnd, extStr)    
    if Config_Sys.showPrint == 0 then return end;
    if Logger.timeCostTab == nil then Logger.timeCostTab = {}; end
    if Logger.timeCostTab[method] == nil then 
        Logger.timeCostTab[method] = {};
        Logger.timeCostTab[method].time = {};  
        Logger.timeCostTab[method].total = 0; 
        Logger.timeCostTab[method].calls = 1; 
    end;    
    if beginOrEnd == 0 then
        if Logger.timeCostTab[method].time[Logger.timeCostTab[method].calls] == nil then
            Logger.timeCostTab[method].time[Logger.timeCostTab[method].calls]  = CUtil:getSystemTime();                         
        end        
    end
    if beginOrEnd == 1 then
        local cTime = CUtil:getSystemTime() - Logger.timeCostTab[method].time[Logger.timeCostTab[method].calls];
        if extStr ~= nil then
            Logger.timeCostTab[method].time[Logger.timeCostTab[method].calls] = cTime .. "  " .. extStr;
        else
            Logger.timeCostTab[method].time[Logger.timeCostTab[method].calls] = cTime
        end
        Logger.timeCostTab[method].total  = Logger.timeCostTab[method].total  + cTime;                
        Logger.timeCostTab[method].calls = Logger.timeCostTab[method].calls + 1;
    end    
end
function Logger:clearTimeCost()
    Logger.timeCostTab = nil;
end
--打印的time是毫秒，calls是调用次数，total是总耗时
function Logger:dumpTimeCost()
    if Config_Sys.showPrint == 0 then return end;    
    if Logger.timeCostTab == nil then return end;
    local total = 0;
    for k,v in pairs(Logger.timeCostTab) do
        total = total + v.total;
        v.calls = v.calls - 1;
    end
    dump(Logger.timeCostTab)
    print("all above total time cost:" .. total);
    Logger:clearTimeCost()
end
 