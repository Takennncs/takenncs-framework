local Core = exports['takenncs-fw']:GetCoreObject()

local ALLOWED_CHAT_TYPES = {
    'normal', 'success', 'error', 'info', 'warning', 
    '311', 'announce', 'ad', 'admin', 'adminchat'
}

local playerData = {}

local function IsPlayerAdmin(src)
    local Player = QBCore.Functions.GetPlayer(src)
    return Player and Player.PlayerData.isAdmin
end

RegisterNetEvent('takenncs-chat:adminCommand', function(command, ...)
    local src = source
    local args = {...}

    if IsPlayerAdmin(src) then
        ExecuteCommand(command .. " " .. table.concat(args, " "))
    else
        TriggerClientEvent('chatTypedMessage', src, 'ADMIN', 'error', 'Sul puuduvad õigused selle käskluse kasutamiseks!')
    end
end)

RegisterNetEvent('takenncs-chat:sendAdminMessage', function(message)
    local src = source
    if IsPlayerAdmin(src) then
        -- Saada sõnum ainult adminitele
        for _, playerId in ipairs(GetPlayers()) do
            if IsPlayerAdmin(playerId) then
                TriggerClientEvent('chatTypedMessage', playerId, 'ADMIN', 'admin', message)
            end
        end
    else
        TriggerClientEvent('chatTypedMessage', src, 'ADMIN', 'error', 'Sul puuduvad õigused selle sõnumi saatmiseks!')
    end
end)

RegisterNetEvent('chat:adminMessage', function(message)
    local src = source
    local playerName = GetPlayerName(src)
    
    if IsPlayerAdmin(src) then
        TriggerClientEvent('chatMessage', -1, playerName, 'admin', message)
        LogMessage(src, playerName, message, 'admin_chat')
    else
        TriggerClientEvent('chatMessage', src, 'SYSTEM', 'error', 'Sul pole selleks õigusi!')
    end
end)

RegisterNetEvent('chat:sendToPlayer', function(targetId, messageType, message)
    local src = source
    
    if IsPlayerAdmin(src) then
        local playerName = GetPlayerName(src)
        TriggerClientEvent('chatMessage', targetId, playerName, messageType, message)
    end
end)


function FilterMessage(message)
    local badWords = {"", ""}
    local filtered = message
    
    for _, word in ipairs(badWords) do
        filtered = string.gsub(filtered:lower(), word:lower(), string.rep("*", #word))
    end
    
    return filtered
end

function LogMessage(source, author, message, type)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] [%s] %s: %s", timestamp, type, author, message)
    print(logMessage)
end

function IsPlayerAdmin(source)
    return IsPlayerAceAllowed(source, 'command')
end

function AddDefaultSuggestions(src)
    local suggestions = {
        {
            name = '/me',
            help = 'Kirjelda oma tegevust',
            params = {
                {name = 'tegevus', help = 'Sinu tegevuse kirjeldus'}
            }
        }
    }
    
    TriggerClientEvent('chat:addSuggestions', src, suggestions)
end

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^2Chat süsteem käivitatud!^0')
    
    for _, playerId in ipairs(GetPlayers()) do
        playerData[tonumber(playerId)] = {
            name = GetPlayerName(tonumber(playerId)),
            muted = false,
            lastMessageTime = 0
        }
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('^1Chat süsteem peatatud!^0')
    playerData = {}
end)

AddEventHandler('playerJoining', function()
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    TriggerEvent('chat:playerDropped', reason)
end)

exports('SendMessage', function(target, type, title, message)
    if not ALLOWED_CHAT_TYPES[type] then
        type = 'normal'
    end
    
    TriggerClientEvent('chatMessage', target, title, type, message)
end)

exports('BroadcastMessage', function(type, title, message)
    TriggerClientEvent('chatMessage', -1, title, type, message)
end)

exports('IsPlayerMuted', function(playerId)
    return playerData[playerId] and playerData[playerId].muted or false
end)

exports('SetPlayerMuted', function(playerId, muted)
    if playerData[playerId] then
        playerData[playerId].muted = muted
        return true
    end
    return false
end)

