local Core = exports['takenncs-fw']:GetCoreObject()

RegisterNetEvent('takenncs-playerlist:server:open')
AddEventHandler('takenncs-playerlist:server:open', function()
    local src = source
    local player = Core.GetPlayer(src)

    if player and player.character then
        local players = {}
        local allPlayers = GetPlayers()
        
        players[1] = {
            me = true,
            source = src,
            identifier = player.character.citizenid or player.identifier,
            ping = GetPlayerPing(src),
            cName = player.character.firstname .. ' ' .. player.character.lastname
        }
        
        for i = 1, #allPlayers do
            local targetId = tonumber(allPlayers[i])
            local targetPlayer = Core.GetPlayer(targetId)
            
            if targetPlayer and targetPlayer.character and targetId ~= src then
                local data = {
                    source = targetId,
                    identifier = targetPlayer.character.citizenid or targetPlayer.identifier,
                    ping = GetPlayerPing(targetId),
                    cName = targetPlayer.character.firstname .. ' ' .. targetPlayer.character.lastname
                }
                
                players[#players + 1] = data
            end
        end
        
        TriggerClientEvent('takenncs-playerlist:client:openMenu', src, players)
    end
end)

RegisterNetEvent('takenncs-playerlist:server:adminOpen')
AddEventHandler('takenncs-playerlist:server:adminOpen', function()
    local src = source
    local player = Core.GetPlayer(src)
    
        local players = {}
        local allPlayers = GetPlayers()
        
        for i = 1, #allPlayers do
            local targetId = tonumber(allPlayers[i])
            local targetPlayer = Core.GetPlayer(targetId)
            
            local data = {
                source = targetId,
                identifier = targetPlayer and targetPlayer.character.citizenid or 'No Character',
                ping = GetPlayerPing(targetId),
                cName = targetPlayer and (targetPlayer.character.firstname .. ' ' .. targetPlayer.character.lastname) or GetPlayerName(targetId),
                hasCharacter = targetPlayer and true or false
            }
            
            players[#players + 1] = data
        end
        
        TriggerClientEvent('takenncs-playerlist:client:openMenu', src, players)
end)