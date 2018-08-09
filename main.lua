
if 0 == targetPlatform then --windows平台 babelua输出到控制台 windows平台为0，现在还没初始化cc.PLATFORM_OS_WINDOWS常量
    function babe_tostring(...)  
        local num = select("#",...);  
        local args = {...};  
        local outs = {};  
        for i = 1, num do  
            if i > 1 then       
                outs[#outs+1] = "\t";  
            end  
            outs[#outs+1] = tostring(args[i]);  
        end  
        return table.concat(outs);  
    end  
  
    local babe_print = print;  
    local babe_output = function(...)  
        babe_print(...);  
  
        if decoda_output ~= nil then  
            local str = babe_tostring(...);  
            decoda_output(str);  
        end  
    end  
    print = babe_output;  
end


package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
local searchPaths = cc.FileUtils:getInstance():getSearchPaths()
local correctSearchPaths = {}
       
local last = nil;
for i = 1,#searchPaths do         
    if searchPaths[i]:find("win32/src") then
        last = searchPaths[i]
    else
        table.insert(correctSearchPaths,searchPaths[i]);
    end
end
if last then table.insert(correctSearchPaths,last); end;
table.insert(correctSearchPaths,"/res")
table.insert(correctSearchPaths,"/src")
cc.FileUtils:getInstance():setSearchPaths(correctSearchPaths)
 
lfs = require("lfs")
require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
