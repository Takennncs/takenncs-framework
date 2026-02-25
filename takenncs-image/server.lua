local Core = exports['takenncs-fw']:GetCoreObject()

RegisterNetEvent('takenncs-leo:server:updatePicture')
AddEventHandler('takenncs-leo:server:updatePicture', function(id, pic)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then return end
    
    local targetPlayer = Core.GetPlayer(id)
    
    if targetPlayer and targetPlayer.character then
        MySQL.update('UPDATE characters SET profilepic = ? WHERE citizenid = ?', {
            tostring(pic),
            targetPlayer.character.citizenid
        })
    end
end)

lib.callback.register('takenncs-image:update', function(source, targetId, link)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then return false end
    
    if player.character.job ~= 'police' then
        return false
    end
    
    local targetPlayer = Core.GetPlayer(targetId)
    
    if targetPlayer and targetPlayer.character then
        local result = MySQL.update.await('UPDATE characters SET profilepic = ? WHERE citizenid = ?', {
            tostring(link),
            targetPlayer.character.citizenid
        })
        
        if result then
            print(('^2[Image] %s updated profile picture for %s'):format(
                player.character.firstname,
                targetPlayer.character.firstname
            ))
            return true
        end
    end
    
    return false
end)

exports('GetProfilePicture', function(citizenid)
    local result = MySQL.query.await('SELECT profilepic FROM characters WHERE citizenid = ?', { citizenid })
    if result and result[1] then
        return result[1].profilepic
    end
    return nil
end)