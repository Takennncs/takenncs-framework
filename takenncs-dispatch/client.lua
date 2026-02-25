local Core = exports['takenncs-fw']:GetCoreObject()
local warnedshooting = false
local menuOpen = false
local mapOpen = false
local PlayerData = nil

CreateThread(function()
    Wait(2000)
    
    local currentChar = exports['takenncs-fw']:GetCurrentCharacter()
    if currentChar then
        PlayerData = currentChar
    end
    
    if not PlayerData then
        local player = Core.GetPlayer(PlayerId())
        if player and player.character then
            PlayerData = player.character
        end
    end
end)

RegisterNetEvent('takenncs:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

RegisterNetEvent('takenncs:client:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

RegisterNetEvent('takenncs:jobUpdated', function(job, grade)
    if PlayerData then
        PlayerData.job = job
        PlayerData.job_grade = grade
    end
end)

CreateThread(function()
    while true do
        if IsPauseMenuActive() and not mapOpen then
            mapOpen = true
            SendNUIMessage({action = 'closeDispatch'})
        elseif not IsPauseMenuActive() and mapOpen then
            mapOpen = false
        end
        Wait(800)
    end
end)

RegisterCommand('openDispatch', function()
    if not PlayerData then
        local currentChar = exports['takenncs-fw']:GetCurrentCharacter()
        if currentChar then
            PlayerData = currentChar
        else
            local player = Core.GetPlayer(PlayerId())
            if player and player.character then
                PlayerData = player.character
            end
        end
    end
    
    if not PlayerData then 
        exports.ox_lib:notify({
            title = 'Dispetser',
            description = 'Sinu andmed ei ole laetud! Proovi uuesti.',
            type = 'error'
        })
        return 
    end
    
    local allowedJobs = {'police', 'ambulance', 'doj'}
    local isAllowed = false
    
    for _, job in ipairs(allowedJobs) do
        if PlayerData.job == job then
            isAllowed = true
            break
        end
    end
    
    if not isAllowed then
        return 
    end

    if not menuOpen then
        exports.ox_lib:showTextUI('[Z] - Sulge dispetser', {position = "left-center"})
        SendNUIMessage({action = 'showCalls'})
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        menuOpen = true
        disableInputs()
    else
        SendNUIMessage({action = 'closeDispatch'})
    end
end, false)

RegisterKeyMapping('openDispatch', 'Ava dispetser', 'keyboard', 'Z')

function disableInputs()
    CreateThread(function()
        while menuOpen do
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 263, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisablePlayerFiring(PlayerPedId(), true)
            Wait(0)
        end
    end)
end

RegisterNUICallback('closeDispatch', function()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    menuOpen = false
    exports.ox_lib:hideTextUI()
end)

RegisterNUICallback('loadCalls', function(args, cb)
    lib.callback('takenncs-dispatch:loadCalls', false, function(response)
        SendNUIMessage({action = 'loadCalls', data = response})
    end)
end)

RegisterNUICallback('acceptCall', function(args, cb)
    TriggerServerEvent('takenncs-dispatch:server:acceptCall', args.id)
    SendNUIMessage({action = 'closeDispatch'})
end)

RegisterNetEvent('takenncs-dispatch:client:sendDispatch', function(call, job, message, panic, answer)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local street = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    local zone = GetNameOfZone(playerCoords)

    local data = {
        street = GetStreetNameFromHashKey(street),
        coords = playerCoords,
        zone = GetLabelText(zone),
        message = message,
        call = call,
        panic = panic or false
    }

    if answer then
        data['answer'] = GetPlayerServerId(PlayerId())
    end

    TriggerServerEvent('takenncs-dispatch:server:alert', job, data)
end)

RegisterNetEvent('takenncs-dispatch:client:showResponder', function(data)
    SendNUIMessage({action = 'addResponder', data = data})
end)

CreateThread(function()
    while true do
        if not warnedshooting and IsPedShooting(PlayerPedId()) and not IsPedCurrentWeaponSilenced(PlayerPedId()) then
            if PlayerData and PlayerData.job == 'police' then
                Wait(100)
            else
                local jobName = 'police'
                local code = '10-71'
                local message = 'TULISTAMINE'
                
                TriggerEvent('takenncs-dispatch:client:sendDispatch', code, jobName, message)

                warnedshooting = true
                SetTimeout(60000, function() 
                    warnedshooting = false 
                end)
            end
        end
        Wait(100)
    end
end)

RegisterNetEvent('takenncs-dispatch:client:setMarker', function(coords)
    SetNewWaypoint(coords.x, coords.y)
end)

RegisterNetEvent('takenncs-dispatch:client:sendAlert', function(data)
    SendNUIMessage({action = 'addCall', data = data})

    if not data.panic then
        PlaySound(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
end)