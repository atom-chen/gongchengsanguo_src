
local MyApp = class("MyApp", cc.load("mvc").AppBase)
require "app.resCheck"
function MyApp:onCreate()
    math.randomseed(os.time())
end
function MyApp:needClearCache()
    local writablePath = cc.FileUtils:getInstance():getWritablePath()
    local path = writablePath.."installVersion.txt";
    local tt = cc.FileUtils:getInstance():getValueMapFromFile(path)
    local installVersion = tt.version;

    local fileName = "version/version.manifest";
    local strCon = cc.FileUtils:getInstance():getStringFromFile(fileName)
    local json = require "cjson"
    local _strJson = json.decode(strCon)
    local version =  _strJson.version;

    if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."talks/") then
        cc.FileUtils:getInstance():removeDirectory(writablePath.."talks/");
    end


    if tt.version == nil then --没有缓存文件 写入
        if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."new_version/" ) then
            cc.FileUtils:getInstance():removeDirectory(writablePath.."new_version/" );
        end
        --cc.FileUtils:getInstance():removeDirectory(writablePath.."new_version/src/" );
        tt = { version = _strJson.version }
        --win32、mac下不写installVersion文件
        if device.platform ~= "windows" and device.platform ~= cc.PLATFORM_OS_MAC then
            cc.FileUtils:getInstance():writeToFile(tt,path);
        end
        if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."new_version/" ) then
            _G.cannotClearCache  = true
            return false;
        end
        return true
    end
    --如果是新装的包且缓存未删掉
    if installVersion ~= version then
        if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."new_version/" ) then
            cc.FileUtils:getInstance():removeDirectory(writablePath.."new_version/" );
        end
       -- cc.FileUtils:getInstance():removeDirectory(writablePath.."new_version/src/" );
        tt = { version = _strJson.version }
        --win32、mac下不写installVersion文件
        if device.platform ~= "windows" and device.platform ~= cc.PLATFORM_OS_MAC then
            cc.FileUtils:getInstance():writeToFile(tt,path);
        end
        if cc.FileUtils:getInstance():isDirectoryExist(writablePath.."new_version/" ) then
            _G.cannotClearCache  = true
            return false;
        end
        return true
    end
end

function MyApp:run()

    --资源、lua搜索路径    
    local writablePath = cc.FileUtils:getInstance():getWritablePath()
    local storagePath = writablePath.."new_version" 
    local storagePathRes = writablePath.."new_version/res" 
    local storagePathSrc = writablePath.."new_version/src"
    cc.FileUtils:getInstance():addSearchPath(storagePath)
    cc.FileUtils:getInstance():addSearchPath(storagePathRes)
    cc.FileUtils:getInstance():addSearchPath(storagePathSrc)
    
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/")

    --文件读取优先指向new_version
    local searchPaths = cc.FileUtils:getInstance():getSearchPaths()
    local correctSearchPaths = {}
    correctSearchPaths[1] = cc.FileUtils:getInstance():getWritablePath().."new_version/" 
    local last = nil;
    for i = 1,#searchPaths do
        if searchPaths[i]:find("win32/src") then
            last = searchPaths[i]
        else
            table.insert(correctSearchPaths,searchPaths[i]);
        end
    end
    if last then 
        table.insert(correctSearchPaths,last); 
    end;   
        cc.FileUtils:getInstance():setSearchPaths(correctSearchPaths)

    self:needClearCache();
    self:enterScene("MainScene")
end
return MyApp
