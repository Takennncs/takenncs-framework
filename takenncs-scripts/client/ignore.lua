local Core = exports['takenncs-fw']:GetCoreObject()
local density = 0.4
local vehicleModel = nil

Config = Config or {}
Config.BlacklistedScenarios = Config.BlacklistedScenarios or {
    TYPES = {},
    GROUPS = {}
}

CreateThread(function()
    while true do
        if Config.BlacklistedScenarios.TYPES then
            for _, sctyp in next, Config.BlacklistedScenarios.TYPES do
                SetScenarioTypeEnabled(sctyp, false)
            end
        end
        
        if Config.BlacklistedScenarios.GROUPS then
            for _, scgrp in next, Config.BlacklistedScenarios.GROUPS do
                SetScenarioGroupEnabled(scgrp, false)
            end
        end
        Wait(10000)
    end
end)

CreateThread(function()
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end

    SetVehicleModelIsSuppressed(joaat('rubble'), true)
    SetVehicleModelIsSuppressed(joaat('dump'), true)
    SetVehicleModelIsSuppressed(joaat('taco'), true)
    SetVehicleModelIsSuppressed(joaat('biff'), true)
    SetVehicleModelIsSuppressed(joaat('blimp'), true)
    
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("DisableFlightMusic", true)
    SetMaxWantedLevel(0)
    SetAudioFlag("PoliceScannerDisabled", true)
    SetGarbageTrucks(false)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)
    DistantCopCarSirens(false)
    
    RemoveVehiclesFromGeneratorsInArea(335.2616 - 300.0, -1432.455 - 300.0, 46.51 - 300.0, 335.2616 + 300.0, -1432.455 + 300.0, 46.51 + 300.0)
    RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0)
    RemoveVehiclesFromGeneratorsInArea(316.79 - 300.0, -592.36 - 300.0, 43.28 - 300.0, 316.79 + 300.0, -592.36 + 300.0, 43.28 + 300.0)
    RemoveVehiclesFromGeneratorsInArea(-2150.44 - 500.0, 3075.99 - 500.0, 32.8 - 500.0, -2150.44 + 500.0, -3075.99 + 500.0, 32.8 + 500.0)
    RemoveVehiclesFromGeneratorsInArea(-1108.35 - 300.0, 4920.64 - 300.0, 217.2 - 300.0, -1108.35 + 300.0, 4920.64 + 300.0, 217.2 + 300.0)
    RemoveVehiclesFromGeneratorsInArea(-458.24 - 300.0, 6019.81 - 300.0, 31.34 - 300.0, -458.24 + 300.0, 6019.81 + 300.0, 31.34 + 300.0)
    RemoveVehiclesFromGeneratorsInArea(1854.82 - 300.0, 3679.4 - 300.0, 33.82 - 300.0, 1854.82 + 300.0, 3679.4 + 300.0, 33.82 + 300.0)
    RemoveVehiclesFromGeneratorsInArea(-724.46 - 300.0, -1444.03 - 300.0, 5.0 - 300.0, -724.46 + 300.0, -1444.03 + 300.0, 5.0 + 300.0)
end)

RegisterNetEvent('takenncs:characterLoaded', function()
    CreateWeaponThread()
end)

function CreateWeaponThread()
    CreateThread(function()
        local sleep
        local ped = PlayerPedId()
        
        while true do
            sleep = 500
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= `WEAPON_UNARMED` then
                if IsPedArmed(ped, 6) then
                    sleep = 0
                    DisableControlAction(1, 140, true) -- RELOAD
                    DisableControlAction(1, 141, true) -- MELEE_ATTACK_LIGHT
                    DisableControlAction(1, 142, true) -- MELEE_ATTACK_HEAVY
                end

                if weapon == `WEAPON_FIREEXTINGUISHER` or weapon == `WEAPON_PETROLCAN` then
                    if IsPedShooting(ped) then
                        SetPedInfiniteAmmo(ped, true, weapon)
                    end
                end
            end

            Wait(sleep)
        end
    end)
end

CreateThread(function()
    local pedPool = GetGamePool('CPed')
    for _, v in pairs(pedPool) do
        SetPedDropsWeaponsWhenDead(v, false)
    end
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)
        
        if DoesEntityExist(veh) then
            local speed = GetEntitySpeed(veh)
            local current_mph = math.floor(speed * 3.6 + 0.5)
            
            if IsPedShooting(playerPed) and not IsEntityDead(veh) then
                if current_mph >= 10 and current_mph < 40 then
                    ShakeGameplayCam('JOLT_SHAKE', 0.2)
                elseif current_mph >= 40 and current_mph < 60 then
                    ShakeGameplayCam('JOLT_SHAKE', 0.4)
                elseif current_mph >= 60 and current_mph < 80 then
                    ShakeGameplayCam('JOLT_SHAKE', 0.6)
                elseif current_mph >= 80 and current_mph < 100 then
                    ShakeGameplayCam('JOLT_SHAKE', 0.8)
                elseif current_mph >= 100 and current_mph < 120 then
                    ShakeGameplayCam('JOLT_SHAKE', 1.0)
                elseif current_mph >= 120 and current_mph < 140 then
                    ShakeGameplayCam('JOLT_SHAKE', 1.2)
                elseif current_mph >= 140 and current_mph < 160 then
                    ShakeGameplayCam('JOLT_SHAKE', 1.4)
                elseif current_mph >= 160 then
                    ShakeGameplayCam('JOLT_SHAKE', 1.6)
                end
            end
        end
        
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        Wait(1)
        
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if DoesEntityExist(vehicle) then
            local class = GetVehicleClass(vehicle)
            local currentcarspeed = GetEntitySpeed(vehicle)
            local kmh = 3.6
            local speedKmh = math.floor(currentcarspeed * kmh)
            
            if class ~= 16 then
                if speedKmh >= 300 then
                    SetVehicleMaxSpeed(vehicle, currentcarspeed)
                end
            else
                local maxspeed = GetVehicleModelMaxSpeed(GetEntityModel(vehicle))
                SetVehicleMaxSpeed(vehicle, maxspeed)
            end
        end
    end
end)