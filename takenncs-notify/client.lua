local Core = exports['takenncs-fw']:GetCoreObject()
local instructionVisible = false

RegisterCommand('toggleInstruction', function()
    instructionVisible = not instructionVisible
    if instructionVisible then
        SendNUIMessage({
            action = 'showInstruction',
            data = { 
                title = "Breakingsf.ee/takenncs", 
                description = "Sul pole siin ühtegi ülesannet!", 
                position = "left-center" 
            }
        })
    else
        SendNUIMessage({ action = 'hideInstruction' })
    end
end, false)

RegisterKeyMapping('toggleInstruction', 'Aktiveeri ülessande/task menu', 'keyboard', 'G')

RegisterNetEvent('takenncs-notify:client:showInstruction', function(title, description)
    SendNUIMessage({ action = 'showInstruction', data = { title = title, description = description } })
end)

RegisterNetEvent('takenncs-notify:client:hideInstruction', function()
    SendNUIMessage({ action = 'hideInstruction' })
end)

local interactActive = false

RegisterNetEvent('takenncs-notify:client:showInteract', function(text, key)
    SendNUIMessage({ action = 'showInteract', data = { text = text, key = key } }); interactActive = true
end)

RegisterNetEvent('takenncs-notify:client:hideInteract', function()
    SendNUIMessage({ action = 'hideInteract' }); interactActive = false
end)

exports('interactActive', function()
    return interactActive
end)

RegisterNetEvent('takenncs-notify:client:showNotification', function(type, message, duration)
    SendNUIMessage({
        action = 'showNotification',
        data = {
            type = type,
            message = message,
            timer = duration or 5000
        }
    })
end)
