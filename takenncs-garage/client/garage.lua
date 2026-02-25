-- Lisa funktsioonid client/garage.lua

-- Auto parkimine kui mängija lahkub
CreateThread(function()
    while true do
        Wait(5000)
        
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle == 0 or vehicle == nil then
            -- Mängija on jalas - kontrolli kas läheduses on sõiduk
            local coords = GetEntityCoords(ped)
            local handle, veh = FindFirstVehicle()
            local success
            
            repeat
                if DoesEntityExist(veh) and GetEntityHealth(veh) > 0 then
                    local vehCoords = GetEntityCoords(veh)
                    local distance = #(coords - vehCoords)
                    
                    if distance < Config.Garage.Parking.StoreDistance then
                        local plate = GetVehicleNumberPlateText(veh)
                        local class = GetVehicleClass(veh)
                        local model = GetEntityModel(veh)
                        
                        -- Tuvasta kas on helikopter
                        local isHelicopter = IsThisModelAHeli(model)
                        
                        -- Ainult pargi kui on tavaline sõiduk või helikopter
                        if (class >= 0 and class <= 15) or isHelicopter then
                            -- Salvesta asukoht (siin saad lisada oma loogika)
                        end
                    end
                end
                success, veh = FindNextVehicle(handle)
            until not success
            
            EndFindVehicle(handle)
        end
    end
end)

-- Parki lähim sõiduk
RegisterNetEvent('takenncs-garage:parkClosestVehicle')
AddEventHandler('takenncs-garage:parkClosestVehicle', function(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    -- Kontrolli kas sõidukis on keegi
    if GetVehicleNumberOfPassengers(vehicle) > 0 then
        Notify('Garaaž', 'Sõidukis on inimesi!', 'error')
        return
    end
    
    -- Kontrolli kas sõiduk on lukus
    if GetVehicleDoorLockStatus(vehicle) == 2 then
        Notify('Garaaž', 'Sõiduk on lukus', 'error')
        return
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    local isHelicopter = IsThisModelAHeli(model)
    local vehicleType = isHelicopter and 'helicopter' or 'car'
    
    -- Kasuta eventi, mitte callbacki
    TriggerServerEvent('takenncs-garage:checkOwnership', plate, vehicle, vehicleType)
end)

-- Lisa uus event omaniku kontrolli vastuseks
RegisterNetEvent('takenncs-garage:ownershipResult')
AddEventHandler('takenncs-garage:ownershipResult', function(isOwner, plate, vehicle)
    if isOwner then
        -- Leia lähim garaaž
        local coords = GetEntityCoords(vehicle)
        local closestGarage = nil
        local closestDist = 100.0
        local model = GetEntityModel(vehicle)
        local isHelicopter = IsThisModelAHeli(model)
        
        for id, garage in pairs(garages) do
            -- Kui on helikopter, otsi ainult helikopteri garaaže
            if isHelicopter and garage.vehicle_type == 'helicopter' then
                local dist = #(coords - garage.coords)
                if dist < closestDist then
                    closestDist = dist
                    closestGarage = garage
                end
            -- Kui on auto, otsi ainult auto garaaže
            elseif not isHelicopter and garage.vehicle_type == 'car' then
                local dist = #(coords - garage.coords)
                if dist < closestDist then
                    closestDist = dist
                    closestGarage = garage
                end
            end
        end
        
        if closestGarage and closestDist < Config.Garage.Parking.MaxDistanceFromSpawn then
            StoreVehicle(vehicle, closestGarage)
        else
            Notify('Garaaž', 'Liiga kaugel ' .. (isHelicopter and 'helikopterite' or 'auto') .. ' garaažist', 'error')
        end
    else
        Notify('Garaaž', 'See pole sinu sõiduk', 'error')
    end
end)