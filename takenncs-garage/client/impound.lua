local Core = exports['takenncs-fw']:GetCoreObject()
local impoundPed = nil
local impoundOpen = false
local currentImpound = nil

-- Lae impoundid
CreateThread(function()
    Wait(1000)
    
    for i = 1, #Config.Garage.Garages do
        local garage = Config.Garage.Garages[i]
        if garage.type == 'impound' or garage.type == 'air_impound' then
            -- Loo ped
            SpawnImpoundPed(garage)
            
            -- Loo blip
            if garage.blip and garage.blip.enabled then
                CreateImpoundBlip(garage)
            end
            
            -- Loo marker
            if garage.marker and garage.marker.enabled then
                CreateImpoundMarker(garage)
            end
            
            -- Lisa target pedile
            AddTargetToImpoundPed(garage)
            
            print('[takenncs-garage] Impound loaded: ' .. garage.label)
        end
    end
end)

-- Spawni ped
function SpawnImpoundPed(garage)
    local model = GetHashKey(garage.ped.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    impoundPed = CreatePed(4, model, 
        garage.ped.coords.x, 
        garage.ped.coords.y, 
        garage.ped.coords.z - 1.0, 
        garage.ped.coords.w, 
        false, true
    )
    
    SetEntityHeading(impoundPed, garage.ped.coords.w)
    FreezeEntityPosition(impoundPed, true)
    SetEntityInvincible(impoundPed, true)
    SetBlockingOfNonTemporaryEvents(impoundPed, true)
    
    if garage.ped.scenario then
        TaskStartScenarioInPlace(impoundPed, garage.ped.scenario, 0, true)
    end
    
    -- Salvesta ped koos garaaži ID-ga
    impoundPed = { ped = impoundPed, garageId = garage.id }
end

-- Loo blip
function CreateImpoundBlip(garage)
    local blip = AddBlipForCoord(garage.coords.x, garage.coords.y, garage.coords.z)
    SetBlipSprite(blip, garage.blip.sprite)
    SetBlipColour(blip, garage.blip.color)
    SetBlipScale(blip, garage.blip.scale)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(garage.blip.name)
    EndTextCommandSetBlipName(blip)
end

-- Loo marker
function CreateImpoundMarker(garage)
    local marker = {
        coords = garage.coords,
        type = garage.marker.type,
        color = garage.marker.color,
        scale = garage.marker.scale,
        rotate = garage.marker.rotate,
        drawDistance = 15.0
    }
    
    -- Joonista marker
    CreateThread(function()
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
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
            
            Wait(sleep)
        end
    end)
end

-- Lisa target pedile
function AddTargetToImpoundPed(garage)
    exports.ox_target:addLocalEntity(impoundPed.ped, {
        {
            name = 'impound_open_' .. garage.id,
            icon = 'fa-solid fa-truck',
            label = 'Ava ' .. garage.label,
            onSelect = function()
                OpenImpound(garage.id)
            end,
            distance = 2.5
        }
    })
end

-- Ava impound
function OpenImpound(garageId)
    if impoundOpen then return end
    
    impoundOpen = true
    currentImpound = garageId
    
    -- Hangi impoundi sõidukid serverist
    TriggerServerEvent('takenncs-garage:getImpoundedVehicles', garageId)
end

-- Sulge impound
function CloseImpound()
    impoundOpen = false
    currentImpound = nil
    exports.ox_lib:hideContext()
end

-- Näita impoundi menüüd
function ShowImpoundMenu(vehicles)
    if #vehicles == 0 then
        Notify('Impound', 'Impoundis pole sõidukeid', 'info')
        CloseImpound()
        return
    end
    
    local options = {}
    
    for _, vehicle in ipairs(vehicles) do
        -- Arvuta väljaostmise hind
        local impoundFee = math.max(math.floor((vehicle.price or 50000) * 0.5), 1000)
        
        table.insert(options, {
            title = vehicle.label or vehicle.model,
            description = string.format('Plaat: %s | Väljaost: $%s', 
                vehicle.plate, 
                FormatNumber(impoundFee)
            ),
            icon = vehicle.vehicle_type == 'helicopter' and 'helicopter' or 'truck',
            onSelect = function()
                BuyOutImpoundedVehicle(vehicle, impoundFee)
            end,
            metadata = {
                {label = 'Mudel', value = vehicle.model},
                {label = 'Plaat', value = vehicle.plate},
                {label = 'Tüüp', value = vehicle.vehicle_type == 'helicopter' and 'Helikopter' or 'Auto'},
                {label = 'Tasu', value = '$' .. FormatNumber(impoundFee)}
            }
        })
    end
    
    exports.ox_lib:registerContext({
        id = 'impound_menu',
        title = 'Impound',
        options = options,
        onExit = function()
            CloseImpound()
        end
    })
    
    exports.ox_lib:showContext('impound_menu')
end

-- Osta sõiduk impoundist välja
function BuyOutImpoundedVehicle(vehicle, fee)
    local alert = exports.ox_lib:alertDialog({
        header = 'Kinnita väljaost',
        content = string.format('Kas soovid osta välja %s (%s)?\nTasu: $%s', 
            vehicle.label or vehicle.model, 
            vehicle.plate,
            FormatNumber(fee)
        ),
        labels = {
            confirm = 'Jah, maksan',
            cancel = 'Katkesta'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-garage:buyOutImpounded', vehicle.id, fee, vehicle.vehicle_type)
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
RegisterNetEvent('takenncs-garage:receiveImpoundedVehicles')
AddEventHandler('takenncs-garage:receiveImpoundedVehicles', function(vehicles)
    ShowImpoundMenu(vehicles)
end)

RegisterNetEvent('takenncs-garage:vehicleBoughtOut')
AddEventHandler('takenncs-garage:vehicleBoughtOut', function(result, vehicle)
    if result and result.success then
        Notify('Impound', 'Sõiduk välja ostetud!', 'success')
        
        -- Spawni sõiduk impoundi juurde
        if vehicle then
            local model = GetHashKey(vehicle.model)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(100)
            end
            
            -- Leia impoundi spawn koht
            local garage = nil
            for _, g in ipairs(Config.Garage.Garages) do
                if g.id == currentImpound then
                    garage = g
                    break
                end
            end
            
            if garage then
                local spawnPos = vector3(garage.spawn.x, garage.spawn.y, garage.spawn.z)
                local car = CreateVehicle(model, spawnPos.x, spawnPos.y, spawnPos.z, garage.spawn.w, true, false)
                
                local attempts = 0
                while not DoesEntityExist(car) and attempts < 100 do
                    Wait(10)
                    attempts = attempts + 1
                end
                
                if DoesEntityExist(car) then
                    SetVehicleNumberPlateText(car, vehicle.plate)
                    SetVehicleColours(car, vehicle.color1 or 0, vehicle.color2 or 0)
                    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
                    SetVehicleEngineOn(car, true, true, false)
                end
            end
        end
        
        CloseImpound()
    else
        Notify('Impound', result.error or 'Viga', 'error')
    end
end)

-- Abifunktsioon numbri formaatimiseks
function FormatNumber(num)
    local formatted = tostring(math.floor(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if k == 0 then break end
    end
    return formatted
end