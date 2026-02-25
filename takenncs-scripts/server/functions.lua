-- server/functions.lua
local Core = exports['takenncs-fw']:GetCoreObject()

function GetPlayer(source)
    return Core.GetPlayer(source)
end

function GetPlayerByCitizenId(citizenId)
    for src, player in pairs(Core.GetPlayers()) do
        if player.character and player.character.citizenid == citizenId then
            return player
        end
    end
    return nil
end

function GetPlayersByJob(job)
    local players = {}
    for src, player in pairs(Core.GetPlayers()) do
        if player.character and player.character.job == job then
            table.insert(players, player)
        end
    end
    return players
end

function NotifyPlayer(source, msg, type)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'teade',
        description = msg,
        type = type or 'inform'
    })
end

function SendWebhook(webhook, title, message, color)
    if Config.Debug then
        print(('Webhook: %s - %s'):format(title, message))
    end
end