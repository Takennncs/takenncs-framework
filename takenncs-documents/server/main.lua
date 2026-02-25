local Core = exports['takenncs-fw']:GetCoreObject()

RegisterServerEvent('takenncs-documents:server:showId')
AddEventHandler('takenncs-documents:server:showId', function()
    local src = source
    local player = Core.GetPlayer(src)

    if player and player.character then
        local hasIdCard = exports.ox_inventory:Search(src, 'count', 'id_card') > 0
        
        if not hasIdCard then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Dokumendid',
                description = 'Sul ei ole ID-kaarti! Osta see politseijaoskonnast.',
                type = 'error'
            })
            return
        end
        
        local data = {
            ['firstname'] = player.character.firstname,
            ['lastname'] = player.character.lastname,
            ['sex'] = player.character.sex == 'male' and 'M/M' or 'N/F',
            ['dob'] = player.character.dob,
            ['pid'] = player.character.citizenid,
            ['picture'] = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShg8keaWuTWemET3-1mWqZae05N8W6SLGgGg&usqp=CAU'
        }

        TriggerClientEvent('takenncs-documents:client:animation', src)
        TriggerClientEvent('takenncs-documents:client:showId', -1, data, src)
    end
end)

RegisterServerEvent('takenncs-documents:server:showOthersId')
AddEventHandler('takenncs-documents:server:showOthersId', function(targetId)
    local src = source
    local target = tonumber(targetId)
    local targetPlayer = Core.GetPlayer(target)

    if targetPlayer and targetPlayer.character then
        local hasIdCard = exports.ox_inventory:Search(target, 'count', 'id_card') > 0
        
        if not hasIdCard then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Dokumendid',
                description = 'Sellel mängijal ei ole ID-kaarti!',
                type = 'error'
            })
            return
        end
        
        local data = {
            ['firstname'] = targetPlayer.character.firstname,
            ['lastname'] = targetPlayer.character.lastname,
            ['sex'] = targetPlayer.character.sex == 'male' and 'M/M' or 'N/F',
            ['dob'] = targetPlayer.character.dob,
            ['pid'] = targetPlayer.character.citizenid,
            ['picture'] = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShg8keaWuTWemET3-1mWqZae05N8W6SLGgGg&usqp=CAU'
        }

        TriggerClientEvent('takenncs-documents:client:showIdLocal', src, data)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Dokumendid',
            description = 'Mängijat ei leitud!',
            type = 'error'
        })
    end
end)

RegisterNetEvent('takenncs-documents:server:viewId')
AddEventHandler('takenncs-documents:server:viewId', function()
    local src = source
    local player = Core.GetPlayer(src)

    if player and player.character then
        local hasIdCard = exports.ox_inventory:Search(src, 'count', 'id_card') > 0
        
        if not hasIdCard then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Dokumendid',
                description = 'Sul ei ole ID-kaarti! Osta see politseijaoskonnast.',
                type = 'error'
            })
            return
        end
        
        local profilePic = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcShg8keaWuTWemET3-1mWqZae05N8W6SLGgGg&usqp=CAU'

        local data = {
            ['firstname'] = player.character.firstname,
            ['lastname'] = player.character.lastname,
            ['sex'] = player.character.sex == 'male' and 'M/M' or 'N/F',
            ['dob'] = player.character.dob,
            ['pid'] = player.character.citizenid,
            ['picture'] = profilePic
        }

        TriggerClientEvent('takenncs-documents:client:showIdLocal', src, data)
    end
end)
