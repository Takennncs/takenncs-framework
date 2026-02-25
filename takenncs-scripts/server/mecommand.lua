local Core = exports['takenncs-fw']:GetCoreObject()

RegisterCommand('me', function(source, args, raw)
    local memsg = table.concat(args, " ")
    if memsg and memsg ~= "" then
        local xPlayer = Core.GetPlayer(source)
        if xPlayer then
            TriggerClientEvent('TAKENNCS:chat:me', -1, memsg, source)
                if xPlayer.PlayerData then
                exports['takenncs-scripts']:sendLog(xPlayer.PlayerData.citizenid, 'ME', 'Teostas käskluse /me ' .. memsg .. '.')
            end
        end
    end
end, false)
