--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--endregion
if EventManager then
    EventManager:removeAllEvent()  
    return
end 
cc.exports.EventManager = cc.exports.EventManager or {}
EventManager.eventList = {}
EventManager.sendingMsg = {}
EventManager.needTidyEvents = {}

function EventManager:addEvent(listener,target,event,backFunc)
    if not listener then Logger:throwError("listener") return end 
    if not target then return end 
    if not event then return end 
    if not backFunc then return end 
    if EventManager:hasEvent(listener,target,event,backFunc) then return end 
    if not EventManager.eventList[event] then EventManager.eventList[event] = {} end 
    if not EventManager.eventList[event][target] then EventManager.eventList[event][target] = {} end 
    table.insert(EventManager.eventList[event][target],{listener = listener,func = backFunc})
 
end

function EventManager:removeEvent(listener,target,event)
    if not listener then return end 
    if not target then return end 
    if not event then return end 
    local targets = EventManager.eventList[event]
    dump(EventManager.eventList[event])
    if not targets then return end 
    local params = targets[target]
    if not params then return end 
    local len = #params
    local index = 1 
    for k = 1, len do
        if params[index].listener == listener then 
            if EventManager.sendingMsg[event] then 
                EventManager.needTidyEvents[event] = true
                EventManager.eventList[event][target][index].func = nil 
            else 
                table.remove(EventManager.eventList[event][target],index)
                index = index - 1 
            end 
        end 
        index = index + 1 
    end

    if #params == 0 then 
        EventManager.eventList[event][target] = nil 
    end 
    
end

function EventManager:removeEvents(listener, target)
    
end
function EventManager:sendEvent(tar,event,param)
    
end

function EventManager:hasEvent(listener,target,event,backFunc)
    
end

return cc.exports.EventManager