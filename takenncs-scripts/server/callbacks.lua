-- server/callbacks.lua (lisa need callbackid)
local Core = exports['takenncs-fw']:GetCoreObject()

Core.RegisterCallback('takenncs-scripts:getClosestPlayers', function(source, cb, coords, maxDistance)
    local players = {}
    local playerCoords = coords or GetEntityCoords(GetPlayerPed(source))
    
    for _, player in pairs(Core.GetPlayers()) do
        local target = tonumber(player.source)
        if target ~= source then
            local targetCoords = GetEntityCoords(GetPlayerPed(target))
            local distance = #(playerCoords - targetCoords)
            
            if distance < (maxDistance or 5.0) then
                table.insert(players, {
                    source = target,
                    distance = distance,
                    coords = targetCoords
                })
            end
        end
    end
    
    table.sort(players, function(a, b)
        return a.distance < b.distance
    end)
    
    cb(players)
end)

Core.RegisterCallback('takenncs-scripts:getPlayerJob', function(source, cb, target)
    local player = Core.GetPlayer(target or source)
    if player and player.character then
        cb({
            name = player.character.job or 'unemployed',
            grade = player.character.job_grade or 0,
            label = player.character.job_label or 'Töötu'
        })
    else
        cb(nil)
    end
end)