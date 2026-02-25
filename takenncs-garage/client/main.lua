local Core = exports['takenncs-fw']:GetCoreObject()
local currentGarage = nil
local garages = {}
local blips = {}
local markers = {}
local parkingMarkers = {}
local garageOpen = false
local garagePed = nil

-- Lae kõik garaažid
CreateThread(function()
    Wait(1000)
    
    for i = 1, #Config.Garage.Garages do
        local garage = Config.Garage.Garages[i]
        garages[garage.id] = garage
        
        -- Loo ped
        if garage.ped then
            SpawnGaragePed(garage)
        end
        
        -- Loo blip
        if garage.blip and garage.blip.enabled then
            CreateGarageBlip(garage)
        end
        
        -- Loo marker garaaži ukse juurde
        if garage.marker and garage.marker.enabled then
            CreateGarageMarker(garage)
        end
        
        -- Loo marker parkimiskohta
        if garage.parkingMarker and garage.parkingMarker.enabled then
            CreateParkingMarker(garage)
        end
        
        -- Lisa target pedile
        if garage.ped then
            AddTargetToPed(garage)
        end
    end
    
    print('[takenncs-garage] Garages loaded: ' .. #Config.Garage.Garages)
end)

-- Spawni ped
function SpawnGaragePed(garage)
    local model = GetHashKey(garage.ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    garagePed = CreatePed(4, model, 
        garage.ped.coords.x, 
        garage.ped.coords.y, 
        garage.ped.coords.z - 1.0, 
        garage.ped.coords.w, 
        false, true
    )
    
    SetEntityHeading(garagePed, garage.ped.coords.w)
    FreezeEntityPosition(garagePed, true)
    SetEntityInvincible(garagePed, true)
    SetBlockingOfNonTemporaryEvents(garagePed, true)
    
    if garage.ped.scenario then
        TaskStartScenarioInPlace(garagePed, garage.ped.scenario, 0, true)
    end
end

-- Lisa target pedile
function AddTargetToPed(garage)
    exports.ox_target:addLocalEntity(garagePed, {
        {
            name = 'garage_open_' .. garage.id,
            icon = 'fa-solid fa-car',
            label = 'Ava Garaaž',
            onSelect = function()
                OpenGarage(garage.id)
            end,
            distance = 2.5
        }
    })
end

-- Loo blip
function CreateGarageBlip(garage)
    local blip = AddBlipForCoord(garage.coords.x, garage.coords.y, garage.coords.z)
    SetBlipSprite(blip, garage.blip.sprite)
    SetBlipColour(blip, garage.blip.color)
    SetBlipScale(blip, garage.blip.scale)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(garage.blip.name or garage.label)
    EndTextCommandSetBlipName(blip)
    
    blips[garage.id] = blip
end

-- Loo marker garaaži ukse juurde
function CreateGarageMarker(garage)
    if not garage.marker.enabled then return end
    
    markers[garage.id] = {
        coords = garage.coords,
        type = garage.marker.type,
        color = garage.marker.color,
        scale = garage.marker.scale,
        rotate = garage.marker.rotate,
        drawDistance = 15.0
    }
end

-- Loo marker parkimiskohta
function CreateParkingMarker(garage)
    if not garage.parkingMarker.enabled then return end
    
    parkingMarkers[garage.id] = {
        coords = garage.parking,
        type = garage.parkingMarker.type,
        color = garage.parkingMarker.color,
        scale = garage.parkingMarker.scale,
        rotate = garage.parkingMarker.rotate,
        drawDistance = 15.0
    }
end

-- Joonista markerid
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local inVehicle = IsPedInAnyVehicle(ped, false)
        
        -- Joonista garaaži markerid
        for id, marker in pairs(markers) do
            local distance = #(pedCoords - marker.coords)
            
            if distance < marker.drawDistance then
                sleep = 0
                
                DrawMarker(
                    marker.type,
                    marker.coords.x, marker.coords.y, marker.coords.z,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    marker.scale.x, marker.scale.y, marker.scale.z,
                    marker.color.r, marker.color.g, marker.color.b, marker.color.a,
                    false, true, 2, nil, nil, marker.rotate
                )
            end
        end
        
        -- Joonista parkimise markerid (ainult kui mängija on autos)
        if inVehicle then
            for id, marker in pairs(parkingMarkers) do
                local distance = #(pedCoords - marker.coords)
                
                if distance < marker.drawDistance then
                    sleep = 0
                    
                    DrawMarker(
                        marker.type,
                        marker.coords.x, marker.coords.y, marker.coords.z,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        marker.scale.x, marker.scale.y, marker.scale.z,
                        marker.color.r, marker.color.g, marker.color.b, marker.color.a,
                        false, true, 2, nil, nil, marker.rotate
                    )
                    
                    -- Näita abiteksti parkimiseks
                    if distance < 2.0 then
                        exports.ox_lib:showTextUI('[E] Pargi sõiduk', {
                            position = 'left-center',
                            icon = 'fa-solid fa-parking'
                        })
                        
                        if IsControlJustPressed(0, 38) then -- E klahv
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if vehicle and vehicle ~= 0 then
                                StoreVehicle(vehicle, garages[id])
                            end
                        end
                    else
                        exports.ox_lib:hideTextUI()
                    end
                end
            end
        else
            exports.ox_lib:hideTextUI()
        end
        
        Wait(sleep)
    end
end)

-- Ava garaaž
function OpenGarage(garageId)
    if garageOpen then return end
    
    local garage = garages[garageId]
    if not garage then return end
    
    -- Kontrolli job ligipääsu
    if garage.type == 'job' and garage.job then
        local character = Core.GetCurrentCharacter()
        if not character or character.job ~= garage.job then
            Notify('Garaaž', 'Sul pole ligipääsu sellele garaažile', 'error')
            return
        end
    end
    
    garageOpen = true
    currentGarage = garage
    
    -- Liiguta kaamera
    if garage.camera then
        DoScreenFadeOut(250)
        Wait(300)
        
        local cam = CreateCameraWithParams(
            "DEFAULT_SCRIPTED_CAMERA",
            garage.camera.x, garage.camera.y, garage.camera.z,
            -15.0, 0.0, garage.camera.w or 0.0,
            60.0
        )
        
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        
        DoScreenFadeIn(250)
    end
    
    -- Hangi sõidukid serverist
    TriggerServerEvent('takenncs-garage:getVehicles', garageId)
end

-- Sulge garaaž
function CloseGarage()
    garageOpen = false
    currentGarage = nil
    
    -- Taasta kaamera
    DoScreenFadeOut(250)
    Wait(300)
    
    RenderScriptCams(false, true, 500, true, true)
    DestroyAllCams(true)
    
    DoScreenFadeIn(250)
    
    exports.ox_lib:hideContext()
end

-- Näita garaaži menüüd
function ShowGarageMenu(vehicles, garage)
    if #vehicles == 0 then
        Notify('Garaaž', 'Sul pole sõidukeid selles garaažis', 'info')
        CloseGarage()
        return
    end
    
    local options = {}
    
    for _, vehicle in ipairs(vehicles) do
        local stats = {}
        
        if Config.Garage.UI.ShowVehicleStats then
            if vehicle.fuel then
                table.insert(stats, string.format('⛽ Kütus: %d%%', vehicle.fuel))
            end
            if vehicle.engine and vehicle.body then
                local health = math.floor(((vehicle.engine / 1000) + (vehicle.body / 1000)) / 2 * 100)
                table.insert(stats, string.format('🔧 Seisukord: %d%%', health))
            end
        end
        
        local description = string.format('Plaat: %s', vehicle.plate)
        if #stats > 0 then
            description = description .. '\n' .. table.concat(stats, ' • ')
        end
        
        table.insert(options, {
            title = vehicle.label or vehicle.model,
            description = description,
            icon = 'car',
            onSelect = function()
                TakeOutVehicle(vehicle, garage)
            end
        })
    end
    
    exports.ox_lib:registerContext({
        id = Config.Garage.UI.ContextMenuId,
        title = garage.label,
        options = options,
        onExit = function()
            CloseGarage()
        end
    })
    
    exports.ox_lib:showContext(Config.Garage.UI.ContextMenuId)
end

-- Võta sõiduk välja
function TakeOutVehicle(vehicle, garage)
    local alert = exports.ox_lib:alertDialog({
        header = 'Kinnita',
        content = string.format('Kas soovid võtta välja %s (%s)?', vehicle.label or vehicle.model, vehicle.plate),
        labels = {
            confirm = 'Jah',
            cancel = 'Ei'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-garage:takeOutVehicle', vehicle.id, garage.id)
    end
end

-- Spawni sõiduk
function SpawnVehicle(vehicle, garage)
    local model = GetHashKey(vehicle.model)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    local spawn = garage.spawn
    local car = CreateVehicle(model, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    
    local attempts = 0
    while not DoesEntityExist(car) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    
    if DoesEntityExist(car) then
        -- Rakenda andmed
        SetVehicleNumberPlateText(car, vehicle.plate)
        SetVehicleColours(car, vehicle.color1 or 0, vehicle.color2 or 0)
        SetVehicleEngineHealth(car, vehicle.engine or 1000)
        SetVehicleBodyHealth(car, vehicle.body or 1000)
        SetVehicleFuelLevel(car, vehicle.fuel or 100)
        
        -- Rakenda modifikatsioonid
        if vehicle.mods and vehicle.mods ~= '' then
            local mods = json.decode(vehicle.mods)
            if mods then
                for modType, modValue in pairs(mods) do
                    SetVehicleMod(car, tonumber(modType), modValue)
                end
            end
        end
        
        -- Istu autosse
        TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
        SetVehicleEngineOn(car, true, true, false)
        SetVehicleDoorsLocked(car, 1)
        
        -- Salvesta aktiivne sõiduk
        TriggerEvent('takenncs-garage:currentVehicle', car)
    else
        Notify('Garaaž', 'Sõiduki loomine ebaõnnestus', 'error')
    end
end

-- Pargi sõiduk - PARANDATUD!
-- Pargi sõiduk - PARANDATUD!
function StoreVehicle(vehicle, garage)
    if not DoesEntityExist(vehicle) then
        Notify('Garaaž', 'Sõidukit ei leitud', 'error')
        return
    end
    
    -- Kontrolli kas sõidukis on inimesi
    if Config.Garage.Parking.CheckForPlayersNearby then
        if GetVehicleNumberOfPassengers(vehicle) > 0 then
            Notify('Garaaž', 'Sõidukis on inimesi!', 'error')
            return
        end
    end
    
    local plate = GetVehicleNumberPlateText(vehicle)
    local coords = GetEntityCoords(vehicle)
    local heading = GetEntityHeading(vehicle)
    local fuel = GetVehicleFuelLevel(vehicle)
    local engine = GetVehicleEngineHealth(vehicle)
    local body = GetVehicleBodyHealth(vehicle)
    local model = GetEntityModel(vehicle)
    local isHelicopter = IsThisModelAHeli(model)
    local vehicleType = isHelicopter and 'helicopter' or 'car'
    
    -- Kogu modifikatsioonid
    local mods = {}
    for i = 0, 49 do
        local mod = GetVehicleMod(vehicle, i)
        if mod ~= -1 then
            mods[i] = mod
        end
    end
    
    local alert = exports.ox_lib:alertDialog({
        header = 'Pargi sõiduk',
        content = string.format('Kas soovid parkida sõiduki %s?', plate),
        labels = {
            confirm = 'Jah',
            cancel = 'Ei'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-garage:storeVehicle', plate, {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            heading = heading,
            fuel = fuel,
            engine = engine,
            body = body,
            mods = json.encode(mods)
        }, garage.id, NetworkGetNetworkIdFromEntity(vehicle), vehicleType) -- LISA vehicleType!
    end
end

-- Müü sõiduk
function SellVehicle(vehicle, garage)
    local alert = exports.ox_lib:alertDialog({
        header = 'Müü sõiduk',
        content = string.format('Kas soovid müüa %s (%s)?', 
            vehicle.label or vehicle.model, 
            vehicle.plate
        ),
        labels = {
            confirm = 'Müü',
            cancel = 'Katkesta'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-garage:sellVehicle', vehicle.id)
    end
end

-- Notifikatsioonid
function Notify(title, msg, type)
    if Config.Garage.Notify.UseOx then
        exports.ox_lib:notify({
            title = title,
            description = msg,
            type = type,
            position = Config.Garage.Notify.Position
        })
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(true, true)
    end
end

-- Server callback vastused
RegisterNetEvent('takenncs-garage:receiveVehicles')
AddEventHandler('takenncs-garage:receiveVehicles', function(vehicles, garageId)
    local garage = garages[garageId]
    if garage then
        ShowGarageMenu(vehicles, garage)
    end
end)

RegisterNetEvent('takenncs-garage:vehicleTakenOut')
AddEventHandler('takenncs-garage:vehicleTakenOut', function(vehicle, garageId)
    if vehicle and vehicle.success then
        Notify('Garaaž', 'Sõiduk on väljas', 'success')
        SpawnVehicle(vehicle.vehicle, garages[garageId])
        CloseGarage()
    else
        Notify('Garaaž', vehicle.error or 'Viga', 'error')
    end
end)

-- PARANDATUD: vehicleStored - nüüd kustutab auto!
RegisterNetEvent('takenncs-garage:vehicleStored')
AddEventHandler('takenncs-garage:vehicleStored', function(result, netId)
    if result and result.success then
        Notify('Garaaž', 'Sõiduk pargitud', 'success')
        
        -- Kustuta auto, kui seaded lubavad
        if Config.Garage.Parking.DeleteVehicleAfterStore and netId then
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end
    else
        Notify('Garaaž', result.error or 'Viga', 'error')
    end
end)

RegisterNetEvent('takenncs-garage:vehicleSold')
AddEventHandler('takenncs-garage:vehicleSold', function(result)
    if result and result.success then
        Notify('Garaaž', 'Sõiduk müüdud! Hind: $' .. result.price, 'success')
    else
        Notify('Garaaž', result.error or 'Viga', 'error')
    end
end)