local Core = exports['takenncs-fw']:GetCoreObject()
local dispatchData = {}

MySQL.ready(function()
    local result = MySQL.query.await('SELECT name, type FROM jobs', {})
    
    for i = 1, #result do
        dispatchData[result[i].name] = {}
        
        if result[i].type == 'legal' then
            RegisterCommand(result[i].name, function(source, args)
                local src = source
                local player = Core.GetPlayer(src)
                
                if player and player.character then
                    local hasPhone = exports.ox_inventory:Search(src, 'count', 'phone') > 0
                    
                    if hasPhone then
                        if args[1] then
                            local message = table.concat(args, " ")
                            
                            TriggerClientEvent('takenncs-dispatch:client:sendDispatch', src, 
                                'TELEFON: ' .. (player.character.phone or '??'), 
                                result[i].name, 
                                string.upper(message), 
                                nil, 
                                true
                            )
                        else
                            TriggerClientEvent('ox_lib:notify', src, {
                                title = 'Dispetser',
                                description = 'Palun sisestage sõnum!',
                                type = 'error'
                            })
                        end
                    else
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = 'Dispetser',
                            description = 'Teil ei ole telefoni!',
                            type = 'error'
                        })
                    end
                end
            end, false)
        end
    end
end)

exports('getCalls', function()
    return dispatchData
end)

lib.callback.register('takenncs-dispatch:loadCalls', function(source)
    local player = Core.GetPlayer(source)
    
    if player and player.character and dispatchData[player.character.job] then
        return dispatchData[player.character.job]
    end
    return {}
end)

RegisterServerEvent('takenncs-dispatch:server:acceptCall')
AddEventHandler('takenncs-dispatch:server:acceptCall', function(id)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then return end
    
    local nr = tonumber(id)
    
    local jobCalls = dispatchData[player.character.job]
    
    if jobCalls and #jobCalls >= nr then
        local call = jobCalls[nr]
        
        if call then
            local myName = player.character.firstname .. ' ' .. player.character.lastname
            
            if player.character.job == 'police' then
                local callsign = player.character.callsign or 'XXX'
                myName = '[' .. callsign .. '] ' .. myName
            end
            
            TriggerClientEvent('takenncs-dispatch:client:setMarker', src, {x = call.coords.x, y = call.coords.y})
            
            Wait(500)
            
            local players = GetPlayers()
            for i = 1, #players do
                local targetId = tonumber(players[i])
                local targetPlayer = Core.GetPlayer(targetId)
                
                if targetPlayer and targetPlayer.character and targetPlayer.character.job == player.character.job then
                    TriggerClientEvent('takenncs-dispatch:client:showResponder', targetId, {
                        id = id,
                        call = call.call,
                        worker = myName
                    })
                end
            end
            
            if call.answer then
                TriggerClientEvent('ox_lib:notify', call.answer, {
                    title = 'Dispetser',
                    description = 'Teie kutsele [' .. nr .. '] reageeritakse!',
                    type = 'success'
                })
            end
            
            table.remove(jobCalls, nr)
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Dispetser',
                description = 'Kutset ei leitud!',
                type = 'error'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Dispetser',
            description = 'Hetkel ei ole aktiivseid kutseid!',
            type = 'error'
        })
    end
end)

RegisterServerEvent('takenncs-dispatch:server:alert')
AddEventHandler('takenncs-dispatch:server:alert', function(job, info)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not job or not info then return end
    
    if dispatchData[job] then

        local newId = #dispatchData[job] + 1
        
        dispatchData[job][newId] = {
            id = newId,
            call = info.call,
            description = info.message,
            answer = info.answer,
            location = info.street .. ' | ' .. info.zone,
            coords = {x = info.coords.x, y = info.coords.y}
        }
        
        local players = GetPlayers()
        
        for i = 1, #players do
            local targetId = tonumber(players[i])
            local targetPlayer = Core.GetPlayer(targetId)
            
            if targetPlayer and targetPlayer.character and targetPlayer.character.job == job then
                TriggerClientEvent('takenncs-dispatch:client:sendAlert', targetId, {
                    id = newId,
                    call = info.call,
                    description = info.message,
                    location = info.street .. ' | ' .. info.zone,
                    panic = info.panic or false
                })
            end
        end
        
        if info.panic then
            print(('^1[PANIC] %s from %s'):format(info.message, src))
        end
    end
end)
