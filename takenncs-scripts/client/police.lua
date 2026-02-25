-- client/police.lua
function IsPlayerCop()
    local character = GetPlayerData()
    return character and character.job == 'police'
end

function IsPlayerEMS()
    local character = GetPlayerData()
    return character and character.job == 'ambulance'
end

function IsPoliceDuty()
    return IsPlayerCop()
end

function NotifyPolice(msg, coords)
    coords = coords or GetEntityCoords(PlayerPedId())
    TriggerServerEvent('takenncs-police:server:notify', msg, coords)
end