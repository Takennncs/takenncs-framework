local Core = exports['takenncs-fw']:GetCoreObject()
local spawned = false
local currentCharacter = nil
local playerLoaded = false
local callbackListeners = {}

print('[takenncs-fw] Client main loaded')

function TriggerServerCallback(name, cb, ...)
    TriggerServerEvent('takenncs:serverCallback', name, ...)
    
    local eventName = 'takenncs:clientCallback:' .. name
    local callbackId = math.random(10000, 99999)
    
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

function ShowNotification(msg, type, duration)
    type = type or 'inform'
    duration = duration or 5000
    
    if Config.Client.Notifications then
        exports.ox_lib:notify({
            title = Config.FrameworkName,
            description = msg,
            type = type,
            duration = duration
        })
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

RegisterNetEvent('takenncs:notification')
AddEventHandler('takenncs:notification', function(title, description, type, duration)
    if Config.Client.Notifications then
        exports.ox_lib:notify({
            title = title or Config.FrameworkName,
            description = description,
            type = type or 'inform',
            duration = duration or 5000
        })
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(description)
        EndTextCommandThefeedPostTicker(false, true)
    end
end)

function SpawnCharacter(character, spawnPos, isNewCharacter)
    if spawned then 
        if Config.Debug then
            print('[takenncs-fw] Already spawned, skipping...')
        end
        return 
    end
    
    spawned = true
    
    if Config.Debug then
        print(('[takenncs-fw] ===== STARTING SPAWN FOR %s %s (New: %s) ====='):format(
            character.firstname, character.lastname, tostring(isNewCharacter)
        ))
    end
    
    local playerPed = PlayerPedId()
    
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    
    if not spawnPos then
        spawnPos = Config.Client.DefaultSpawn
    elseif spawnPos.x == 0.0 and spawnPos.y == 0.0 and spawnPos.z == 0.0 then
        spawnPos = Config.Client.DefaultSpawn
    end
    
    if Config.Debug then
        print(('[takenncs-fw] Using spawn position: %.2f, %.2f, %.2f'):format(
            spawnPos.x, spawnPos.y, spawnPos.z
        ))
    end
    
    SetEntityVisible(playerPed, false, false)
    FreezeEntityPosition(playerPed, true)
    SetEntityCollision(playerPed, false, false)
    SetEntityAlpha(playerPed, 0, false)
    
    local groundFound, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 100.0, false)
    local finalCoords
    
    if groundFound then
        finalCoords = vector3(spawnPos.x, spawnPos.y, groundZ + 1.0)
        if Config.Debug then
            print(('[takenncs-fw] Ground found at Z: %.2f'):format(groundZ))
        end
    else
        finalCoords = vector3(spawnPos.x, spawnPos.y, spawnPos.z + 1.0)
        if Config.Debug then
            print('[takenncs-fw] Ground not found, using spawn Z')
        end
    end
    
    SetEntityCoords(playerPed, finalCoords.x, finalCoords.y, finalCoords.z, false, false, false, false)
    SetEntityHeading(playerPed, spawnPos.w or 0.0)
    
    if Config.Debug then
        print(('[takenncs-fw] Teleported to: %.2f, %.2f, %.2f'):format(
            finalCoords.x, finalCoords.y, finalCoords.z
        ))
    end
    
    Wait(1000)
    
    if character.sex then
        local currentModel = GetEntityModel(playerPed)
        local targetModel = (character.sex == 'male') and `mp_m_freemode_01` or `mp_f_freemode_01`
        
        if currentModel ~= targetModel then
            RequestModel(targetModel)
            while not HasModelLoaded(targetModel) do
                Wait(0)
            end
            
            SetPlayerModel(PlayerId(), targetModel)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(targetModel)
            
            if Config.Debug then
                print('[takenncs-fw] Ped model applied')
            end
            
            Wait(500)
        end
    end
    
    playerPed = PlayerPedId()
    
    SetEntityVisible(playerPed, true, true)
    SetEntityAlpha(playerPed, 255, false)
    FreezeEntityPosition(playerPed, false)
    SetEntityCollision(playerPed, true, true)
    ClearPedTasksImmediately(playerPed)
    SetEntityInvincible(playerPed, false)
    SetPlayerInvincible(PlayerId(), false)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(playerPed, true, true)
    
    Wait(1000)
    DoScreenFadeIn(1000)
    
    Wait(1000)
    DisplayRadar(true)
    DisplayHud(true)
    
    currentCharacter = character
    playerLoaded = true
    
    local finalPos = GetEntityCoords(playerPed)
    TriggerServerEvent('takenncs:playerSpawned', character.id, finalPos.x, finalPos.y, finalPos.z, GetEntityHeading(playerPed))
    
    local birthYear = tonumber(string.sub(character.dob, 1, 4))
    local currentYear = 2026
    local age = currentYear - birthYear
    
        if isNewCharacter then
            CreateThread(function()
                Wait(3000)
                                
                if GetResourceState('takenncs-appearance') == 'started' then
                    if exports['takenncs-appearance'] and exports['takenncs-appearance'].OpenBarberMenu then
                        
                        Wait(2000)
                        
                        exports['takenncs-appearance']:OpenBarberMenu()
                        
                        if Config.Debug then
                            print('[takenncs-fw] Opened BARBER menu for new character')
                        end
                      return
                    end
                end
                
                if GetResourceState('takenncs-clothesmenu') == 'started' then
                    if exports['takenncs-clothesmenu'] then
                        exports['takenncs-clothesmenu']:OpenClothingMenu()
                        
                        if Config.Debug then
                            print('[takenncs-fw] Opened takenncs-clothesmenu for new character')
                        end
                        return
                    end
                end
                
                ShowNotification('⚠️ Riietusmenüü pole saadaval', 'error')
            end)
    else

        CreateThread(function()
            Wait(2000)
            
            if GetResourceState('takenncs-appearance') == 'started' then
                local character = exports['takenncs-fw']:GetCurrentCharacter()
                if character then
                    TriggerServerEvent('takenncs-appearance:loadAppearance', character.id)
                    if Config.Debug then
                        print('[takenncs-fw] Loading appearance from takenncs-appearance')
                    end
                    return
                end
            end
            
            if GetResourceState('takenncs-clothesmenu') == 'started' then
                local character = exports['takenncs-fw']:GetCurrentCharacter()
                if character then
                    TriggerServerEvent('takenncs-clothesmenu:loadOutfit', character.id)
                    if Config.Debug then
                        print('[takenncs-fw] Loading clothes from takenncs-clothesmenu')
                    end
                    return
                end
            end
        end)
    end
    
    if Config.Debug then
        print(('[takenncs-fw] Final position: %.2f, %.2f, %.2f'):format(
            finalPos.x, finalPos.y, finalPos.z
        ))
        print(('[takenncs-fw] ===== SPAWN COMPLETE FOR %s %s ====='):format(
            character.firstname, character.lastname
        ))
    end
end

RegisterNetEvent('takenncs:characterLoaded')
AddEventHandler('takenncs:characterLoaded', function(character, spawnPos, isNewCharacter)
    if Config.Debug then
        print('[takenncs-fw] ===== CHARACTER LOADED EVENT =====')
        print(('[takenncs-fw] Character: %s %s, Sex: %s, New: %s'):format(
            character.firstname, character.lastname, character.sex, tostring(isNewCharacter)
        ))
    end
    
    currentCharacter = character
    playerLoaded = true
    
    spawned = false
    
    if Config.Client.SpawnAfterLoad then
        CreateThread(function()
            Wait(500)
            SpawnCharacter(character, spawnPos, isNewCharacter)
        end)
    end
end)

CreateThread(function()
    Wait(4000)
    if playerLoaded then
        exports.ox_inventory:openInventory('player')
    end
end)

RegisterCommand('inv', function()
    exports.ox_inventory:openInventory()
end)

RegisterNetEvent('takenncs:clientCallback')
AddEventHandler('takenncs:clientCallback', function(name, ...)
    TriggerEvent('takenncs:clientCallback:' .. name, ...)
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('[takenncs-fw] Client resource starting...')
    
    local attempts = 0
    while not lib do
        Wait(100)
        attempts = attempts + 1
        if attempts > 50 then
            print('[takenncs-fw] WARNING: ox_lib not loaded after 5 seconds')
            break
        end
    end
    
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, false)
    SetEntityVisible(playerPed, true, false)
    SetEntityInvincible(playerPed, false)
    
    DisplayRadar(false)
    DisplayHud(false)
    
    spawned = false
    
    print('[takenncs-fw] Client fully loaded, waiting for character selection...')
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    hunger = newHunger
    thirst = newThirst
    SendNUIMessage({
        action = 'hudtick',
        show = true,
        hunger = hunger,
        thirst = thirst,
        stress = stress
    })
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    stress = newStress
    SendNUIMessage({
        action = 'hudtick',
        show = true,
        stress = stress
    })
end)

exports('GetCurrentCharacter', function()
    return currentCharacter
end)

exports('IsPlayerLoaded', function()
    return playerLoaded
end)

exports('SpawnCharacter', SpawnCharacter)

exports('GetPlayer', function()
    return currentCharacter
end)

exports('GetCurrentCharacter', function()
    return currentCharacter
end)

exports('IsPlayerLoaded', function()
    return playerLoaded
end)

print('[takenncs-fw] Client setup complete')