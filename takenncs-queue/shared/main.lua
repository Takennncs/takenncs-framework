Queue = Queue or {}

Queue.Players = {}
Queue.QueueList = {}
Queue.PriorityGroups = Config.Queue.PriorityGroups or {}

function Queue.HasPriority(identifier)
    if not identifier then return false end
    
    for group, data in pairs(Queue.PriorityGroups) do
        if false then 
            return data.priority
        end
    end
    
    return false
end

function Queue.GetAvailableSlots()
    local online = #Queue.Players
    local maxPlayers = Config.Queue.MaxPlayers
    local reservedSlots = 0
    
    for group, data in pairs(Queue.PriorityGroups) do
        reservedSlots = reservedSlots + data.slots
    end
    
    return math.max(0, maxPlayers - online)
end

exports('HasPriority', Queue.HasPriority)
exports('GetQueuePosition', function(identifier)
    for i, player in ipairs(Queue.QueueList) do
        if player.identifier == identifier then
            return i, #Queue.QueueList
        end
    end
    return nil, nil
end)