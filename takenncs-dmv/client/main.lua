local Core = exports['takenncs-fw']:GetCoreObject()
local PlayerData = nil
local CurrentTest = nil
local CurrentVehicle = nil
local CurrentCheckPoint = 0
local DriverErrors = 0
local LastCheckPoint = -1
local CurrentBlip = nil
local CurrentZoneType = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

RegisterNetEvent('takenncs:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

function DrawMissionText(msg, time)
    exports.ox_lib:notify({
        title = 'Autokool',
        description = msg,
        type = 'info',
        duration = time or 5000
    })
end

RegisterNetEvent('takenncs-dmv:client:openLicenseMenu')
AddEventHandler('takenncs-dmv:client:openLicenseMenu', function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'showMenu' })
end)

RegisterNUICallback("disableFocus", function(args, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback("startExam", function(args, cb)
    TriggerServerEvent("takenncs-dmv:server:startExam")
    cb('ok')
end)

RegisterNetEvent('takenncs-dmv:client:startExam')
AddEventHandler('takenncs-dmv:client:startExam', function()
    StartDriverTest()
end)

function StartDriverTest()
    local playerPed = PlayerPedId()
    
    lib.requestModel(GetHashKey(Config.Vehicle), 5000)

    local vehicle = CreateVehicle(GetHashKey(Config.Vehicle), 
        Config.Zones.VehicleSpawnPoint.Pos.x, 
        Config.Zones.VehicleSpawnPoint.Pos.y, 
        Config.Zones.VehicleSpawnPoint.Pos.z, 
        86.69, true, false)
    
    local plate = 'KOOL' .. math.random(1111, 9999)
    SetVehicleNumberPlateText(vehicle, plate)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleEngineOn(vehicle, true, true, false)
    
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    
    if Entity(vehicle).state then
        Entity(vehicle).state:set('fuel', 100, true)
    end

    CurrentTest = 'driver'
    CurrentCheckPoint = 0
    LastCheckPoint = -1
    CurrentZoneType = 'town'
    DriverErrors = 0
    IsAboveSpeedLimit = false
    CurrentVehicle = vehicle
    LastVehicleHealth = GetEntityHealth(vehicle)
    
    exports.ox_lib:notify({
        title = 'Autokool',
        description = 'Eksam algas! Jälgi teekonda ja liiklusreegleid.',
        type = 'success'
    })
end

function StopDriverTest(success)
    if not success then
        exports.ox_lib:notify({
            title = 'Autokool',
            description = 'Kahjuks ei läbinud sa eksamit! Soovi korral saad uuesti proovida.',
            type = 'error',
            duration = 7500
        })
    else
        exports.ox_lib:notify({
            title = 'Autokool',
            description = 'Palju õnne! Läbisid edukalt eksami ning oled nüüdsest juhiloa omanik.',
            type = 'success',
            duration = 10000
        })
        TriggerServerEvent('takenncs-dmv:server:complete')
    end

    if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
        DeleteVehicle(CurrentVehicle)
    end

    CurrentTest = nil
    CurrentVehicle = nil
    CurrentCheckPoint = 0
    LastCheckPoint = -1
    DriverErrors = 0
    IsAboveSpeedLimit = false
    LastVehicleHealth = nil
    
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end
end

function SetCurrentZoneType(type)
    CurrentZoneType = type
end

function CheckIfFailed()
    if DriverErrors >= Config.MaxErrors then
        StopDriverTest(false)
    end
end

CreateThread(function()
    local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)
    SetBlipSprite(blip, 408)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Autokool')
    EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
    while true do
        Wait(5)
        if CurrentTest == 'driver' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local nextCheckPoint = CurrentCheckPoint + 1

            if Config.CheckPoints[nextCheckPoint] == nil then
                if DoesBlipExist(CurrentBlip) then
                    RemoveBlip(CurrentBlip)
                end
                StopDriverTest(DriverErrors < Config.MaxErrors)
            else
                if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
                    local plate = GetVehicleNumberPlateText(CurrentVehicle)
                    if plate and plate:find('KOOL') then
                        if CurrentCheckPoint ~= LastCheckPoint then
                            if DoesBlipExist(CurrentBlip) then
                                RemoveBlip(CurrentBlip)
                            end
                            local cp = Config.CheckPoints[nextCheckPoint]
                            CurrentBlip = AddBlipForCoord(cp.Pos.x, cp.Pos.y, cp.Pos.z)
                            SetBlipRoute(CurrentBlip, true)
                            LastCheckPoint = CurrentCheckPoint
                        end

                        local distance = GetDistanceBetweenCoords(coords, 
                            Config.CheckPoints[nextCheckPoint].Pos.x, 
                            Config.CheckPoints[nextCheckPoint].Pos.y, 
                            Config.CheckPoints[nextCheckPoint].Pos.z, true)

                        if distance <= 100.0 then
                            DrawMarker(1, 
                                Config.CheckPoints[nextCheckPoint].Pos.x, 
                                Config.CheckPoints[nextCheckPoint].Pos.y, 
                                Config.CheckPoints[nextCheckPoint].Pos.z - 1, 
                                0.0, 0.0, 0.0, 0, 0.0, 0.0, 
                                1.5, 1.5, 1.5, 
                                255, 255, 255, 255, 
                                false, true, 2, false, false, false, false)
                        end

                        if distance <= 3.0 then
                            Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
                            CurrentCheckPoint = CurrentCheckPoint + 1
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

local currentSpeed = 0.0
local currentErrors = 0
local showHud = false

CreateThread(function()
    while true do
        Wait(0)
        if showHud then
            DrawTextOnScreen(string.format("Oled teinud vigu: %d/%d", currentErrors, Config.MaxErrors), 0.030, 0.6)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(100)
        if CurrentTest == 'driver' then
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local speed = GetEntitySpeed(vehicle) * Config.SpeedMultiplier

                for k, v in pairs(Config.SpeedLimits) do
                    if CurrentZoneType == k and speed > v then
                        if not IsAboveSpeedLimit then
                            DriverErrors = DriverErrors + 1
                            IsAboveSpeedLimit = true
                            exports.ox_lib:notify({
                                title = 'Autokool',
                                description = "⚠️ Ületasid kiirust! Eksimusi: " .. DriverErrors .. "/" .. Config.MaxErrors,
                                type = 'error'
                            })
                            CheckIfFailed()
                        end
                    elseif CurrentZoneType == k and speed <= v then
                        IsAboveSpeedLimit = false
                    end
                end

                local health = GetEntityHealth(vehicle)
                if health < LastVehicleHealth then
                    DriverErrors = DriverErrors + 1
                    exports.ox_lib:notify({
                        title = 'Autokool',
                        description = "⚠️ Vigastasid sõidukit! Eksimusi: " .. DriverErrors .. "/" .. Config.MaxErrors,
                        type = 'error'
                    })
                    CheckIfFailed()
                    LastVehicleHealth = health
                    Wait(1500)
                else
                    LastVehicleHealth = health
                end
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.Zones.DMVSchool.Pos,
        size = vec3(1.5, 1.5, 1.0),
        rotation = 50.8065,
        debug = false,
        options = {
            {
                name = 'dmv_menu',
                icon = 'fa-solid fa-car',
                label = 'Ava autokooli menüü',
                distance = 2.0,
                onSelect = function()
                    TriggerEvent('takenncs-dmv:client:openLicenseMenu')
                end
            }
        }
    })
end)

function DrawTextOnScreen(text, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

CreateThread(function()
    for i, pedData in ipairs(Config.PedList) do
        local model = GetHashKey(pedData.model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end

        local groundZ = pedData.coords.z
        local foundGround, zPos = GetGroundZFor_3dCoord(pedData.coords.x, pedData.coords.y, pedData.coords.z, 0)
        if foundGround then
            groundZ = zPos
        end

        local ped = CreatePed(4, model, pedData.coords.x, pedData.coords.y, groundZ, pedData.heading, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedDiesWhenInjured(ped, false)
        SetPedCanPlayAmbientAnims(ped, true)

        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

        Config.PedList[i].ped = ped
        Config.PedList[i].isRendered = true
    end
end)