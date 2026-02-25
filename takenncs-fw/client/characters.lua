local Core = exports['takenncs-fw']:GetCoreObject()
print('[takenncs-fw] Characters module loaded')

local callbackListeners = {}

function TriggerServerCallback(name, cb, ...)
    TriggerServerEvent('takenncs:serverCallback', name, ...)
    
    local eventName = 'takenncs:clientCallback:' .. name
    
    if callbackListeners[eventName] then
        RemoveEventHandler(callbackListeners[eventName])
    end
    
    callbackListeners[eventName] = AddEventHandler(eventName, function(...)
        if cb then
            cb(...)
        end
        RemoveEventHandler(callbackListeners[eventName])
        callbackListeners[eventName] = nil
    end)
end

RegisterNetEvent('takenncs:showNotification')
AddEventHandler('takenncs:showNotification', function(message, type)
    if Config.Client.Notifications then
        exports.ox_lib:notify({
            title = Config.FrameworkName,
            description = message,
            type = type or 'inform',
            duration = 5000
        })
    end
end)

local function spawnCharacter(character)
    if not character or not character.id then return end

    print(('[takenncs-fw] ===== STARTING SPAWN FOR %s %s (New: %s) ====='):format(
        character.firstname, character.lastname, tostring(character.isNewCharacter)
    ))

    local x = character.last_x or 195.32
    local y = character.last_y or -933.64
    local z = character.last_z or 30.68
    local h = character.last_h or 140.0

    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, true)
    SetEntityHeading(ped, h)

    if Core.ApplyPedModel then
        Core.ApplyPedModel(character)
    end

    TriggerEvent('takenncs:characterLoaded', character, nil, character.isNewCharacter or false)
    TriggerServerEvent('takenncs:characterLoaded', character)

    if character.isNewCharacter then
        Citizen.CreateThread(function()

            Wait(3000)
            
            print('[takenncs-fw] Calling giveStarterItems callback for character ' .. character.id)
            
            TriggerServerCallback('takenncs:giveStarterItems', function(result)
                if result and result.success then
                    print('[takenncs-fw] Starter items given successfully')
                    
                    exports.ox_lib:notify({
                        title = Config.FrameworkName,
                        description = 'Said vajaminevad asjad!',
                        type = 'success',
                        duration = 5000
                    })
                else
                    print('[takenncs-fw] Failed to give starter items:', result and result.error or 'unknown error')
                    exports.ox_lib:notify({
                        title = Config.FrameworkName,
                        description = '⚠️ Algusesemeid ei õnnestunud anda',
                        type = 'error',
                        duration = 5000
                    })
                end
            end, character.id)
            
            if GetResourceState('takenncs-appearance') == 'started' then
                print('[takenncs-fw] New character detected, opening BARBER menu (face customization)...')
                
                TriggerEvent('takenncs-appearance:newCharacterSpawned')
                
                exports.ox_lib:notify({
                    title = Config.FrameworkName,
                    description = 'Tegele oma karakteriga...',
                    type = 'success',
                    duration = 5000
                })
                
                Wait(2000)
                
                if exports['takenncs-appearance'] and exports['takenncs-appearance'].OpenBarberMenu then
                    exports['takenncs-appearance']:OpenBarberMenu()
                else
                    exports['takenncs-appearance']:OpenClothingMenu()
                end
                
                exports.ox_lib:notify({
                    title = Config.FrameworkName,
                    description = 'Pärast välimusega tegelemist vaata karakterile riided!',
                    type = 'inform',
                    duration = 5000
                })
            else
                print('[takenncs-fw] WARNING: takenncs-appearance not started!')
            end
        end)
    end
end

RegisterNetEvent('takenncs:characterSelected')
AddEventHandler('takenncs:characterSelected', function(character)
    spawnCharacter(character)
end)

CreateThread(function()
    while true do
        Wait(30000)
        local character = exports['takenncs-fw']:GetCurrentCharacter()
        if character and character.id then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            TriggerServerEvent('takenncs:saveLocation', character.id, coords.x, coords.y, coords.z, heading)
        end
    end
end)

print('[takenncs-fw] Characters module loaded successfully')