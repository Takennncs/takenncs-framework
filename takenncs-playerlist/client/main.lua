local Core = exports['takenncs-fw']:GetCoreObject()
local guiEnabled = false
local PlayerData = nil

RegisterNetEvent('takenncs:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

local function showMenu(players)
    SendNUIMessage({ action = "openMenu", ply = players })

    guiEnabled = true
    SetNuiFocus(true, true)
end

RegisterNUICallback("disableFocus", function(args, cb)
    if not guiEnabled then
        return
    end

    SetNuiFocus(false, false)
    guiEnabled = false
    cb('ok')
end)

RegisterKeyMapping('playerlist', 'Ava mängijate scoreboard', 'keyboard', 'HOME')

RegisterCommand('playerlist', function()
    TriggerServerEvent("takenncs-playerlist:server:open")
end)

RegisterNetEvent('takenncs-playerlist:client:openMenu', function(players)
    showMenu(players)
end)