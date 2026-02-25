local Queue = Queue or {}
local QueueList = {}  
local ConnectedPlayers = {} 
local QueueTimers = {} 

print('[takenncs-queue] Server module loaded')

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local source = source
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        deferrals.done(Config.Queue.Messages.connectingFailed)
        return
    end
    
    deferrals.defer()
    Wait(0)
    
    deferrals.update(Config.Queue.Messages.connecting)
    
    local onlineCount = #GetPlayers()
    
    if onlineCount < Config.Queue.MaxPlayers then
        deferrals.done()
        ConnectedPlayers[source] = {
            identifier = identifier,
            name = playerName,
            joinTime = os.time()
        }
        return
    end
    
    local priority = Queue.HasPriority(identifier)
    
    if priority then
        local reservedSlots = 0
        for group, data in pairs(Config.Queue.PriorityGroups) do
            if data.priority <= priority then
                reservedSlots = reservedSlots + data.slots
            end
        end
        
        local priorityOnline = 0
        for _, player in pairs(ConnectedPlayers) do
            if Queue.HasPriority(player.identifier) then
                priorityOnline = priorityOnline + 1
            end
        end
        
        if priorityOnline < reservedSlots then
            deferrals.done()
            ConnectedPlayers[source] = {
                identifier = identifier,
                name = playerName,
                joinTime = os.time(),
                priority = priority
            }
            
            if Config.Queue.Debug then
                print(('[takenncs-queue] Priority player connected: %s'):format(playerName))
            end
            return
        end
    end
    
    local queuePosition = #QueueList + 1
    
    table.insert(QueueList, {
        source = source,
        identifier = identifier,
        name = playerName,
        priority = priority or 999,
        joinTime = os.time()
    })
    
    table.sort(QueueList, function(a, b)
        return a.priority < b.priority
    end)
    
    for i, player in ipairs(QueueList) do
        if player.source == source then
            queuePosition = i
            break
        end
    end
    
    if Config.Queue.Debug then
        print(('[takenncs-queue] Player added to queue: %s at position %d'):format(playerName, queuePosition))
    end
    
    QueueTimers[source] = setTimeout(Config.Queue.Timeout, function()
        local player = QueueList[queuePosition]
        if player and player.source == source then
            for i, p in ipairs(QueueList) do
                if p.source == source then
                    table.remove(QueueList, i)
                    break
                end
            end
            
            deferrals.done(Config.Queue.Messages.timeout)
            
            if Config.Queue.Debug then
                print(('[takenncs-queue] Player timeout: %s'):format(playerName))
            end
        end
        QueueTimers[source] = nil
    end)
    
    CreateThread(function()
        local lastUpdate = 0
        
        while true do
            Wait(Config.Queue.QueueCheckInterval)
            
            local player = QueueList[queuePosition]
            if not player or player.source ~= source then
                break
            end
            
            local onlineCount = #GetPlayers()
            
            if onlineCount < Config.Queue.MaxPlayers then
                if QueueTimers[source] then
                    clearTimeout(QueueTimers[source])
                    QueueTimers[source] = nil
                end
                
                for i, p in ipairs(QueueList) do
                    if p.source == source then
                        table.remove(QueueList, i)
                        break
                    end
                end
                
                deferrals.done()
                ConnectedPlayers[source] = {
                    identifier = identifier,
                    name = playerName,
                    joinTime = os.time(),
                    priority = priority
                }
                
                if Config.Queue.Debug then
                    print(('[takenncs-queue] Player joined from queue: %s'):format(playerName))
                end
                break
            end
            
            if GetGameTimer() - lastUpdate > Config.Queue.QueuePositionUpdate then
                for i, p in ipairs(QueueList) do
                    if p.source == source then
                        if i ~= queuePosition then
                            queuePosition = i
                            local msg = Config.Queue.Messages.inQueue
                                :gsub('{position}', tostring(i))
                                :gsub('{total}', tostring(#QueueList))
                            
                            deferrals.update(msg)
                            
                            TriggerClientEvent('takenncs-queue:updatePosition', source, i, #QueueList)
                        end
                        break
                    end
                end
                
                lastUpdate = GetGameTimer()
            end
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    
    for i, player in ipairs(QueueList) do
        if player.source == source then
            table.remove(QueueList, i)
            if Config.Queue.Debug then
                print(('[takenncs-queue] Player removed from queue: %s'):format(player.name))
            end
            break
        end
    end
    
    ConnectedPlayers[source] = nil
    
    if QueueTimers[source] then
        clearTimeout(QueueTimers[source])
        QueueTimers[source] = nil
    end
end)

function setTimeout(callback, delay)
    local timer = Citizen.CreateThread(function()
        Wait(delay)
        callback()
    end)
    return timer
end

function clearTimeout(timer)
    if timer then
        Citizen.StopThread(timer)
    end
end

exports('GetQueueLength', function()
    return #QueueList
end)

exports('GetQueueList', function()
    return QueueList
end)

exports('IsPlayerInQueue', function(source)
    for _, player in ipairs(QueueList) do
        if player.source == source then
            return true
        end
    end
    return false
end)

print('[takenncs-queue] Server module loaded successfully')