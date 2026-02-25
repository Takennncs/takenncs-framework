local Core = exports['takenncs-fw']:GetCoreObject()

-- Abifunktsioon tabeli nime saamiseks
function GetVehicleTableName(vehicleType)
    if vehicleType == 'helicopter' then
        return 'owned_helicopters'
    else
        return 'owned_vehicles'
    end
end

-- Hangi kasutaja sõidukid
RegisterNetEvent('takenncs-garage:getVehicles')
AddEventHandler('takenncs-garage:getVehicles', function(garageId)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    -- Leia garaaži konfiguratsioon
    local garage = nil
    for _, g in ipairs(Config.Garage.Garages) do
        if g.id == garageId then
            garage = g
            break
        end
    end
    
    if not garage then return end
    
    -- Vali õige tabel
    local tableName = GetVehicleTableName(garage.vehicle_type)
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    -- Helikopterite tabelis pole stored veergu, võtame kõik
    if tableName == 'owned_helicopters' then
        MySQL.query(
            'SELECT * FROM ' .. tableName .. ' WHERE ' .. ownerColumn .. ' = ?',
            { player.identifier },
            function(vehicles)
                local formattedVehicles = {}
                for _, v in ipairs(vehicles or {}) do
                    local metadata = {}
                    if v.customization and v.customization ~= '' then
                        metadata = json.decode(v.customization) or {}
                    end
                    
                    table.insert(formattedVehicles, {
                        id = v.id,
                        model = v.model,
                        label = metadata.label or v.model,
                        plate = v.plate,
                        fuel = 100,
                        engine = 1000,
                        body = 1000,
                        price = metadata.price or 50000,
                        garage_id = garageId,
                        vehicle_type = 'helicopter'
                    })
                end
                
                TriggerClientEvent('takenncs-garage:receiveVehicles', src, formattedVehicles, garageId)
            end
        )
    else
        -- Autode tabel - stored = 1
        MySQL.query(
            'SELECT * FROM ' .. tableName .. ' WHERE ' .. ownerColumn .. ' = ? AND stored = 1',
            { player.identifier },
            function(vehicles)
                local formattedVehicles = {}
                for _, v in ipairs(vehicles or {}) do
                    local metadata = {}
                    if v.metadata and v.metadata ~= '' then
                        metadata = json.decode(v.metadata) or {}
                    end
                    
                    table.insert(formattedVehicles, {
                        id = v.id,
                        model = v.model,
                        label = metadata.label or v.model,
                        plate = v.plate,
                        fuel = 100,
                        engine = 1000,
                        body = 1000,
                        price = metadata.price or 50000,
                        garage_id = garageId,
                        vehicle_type = 'car'
                    })
                end
                
                TriggerClientEvent('takenncs-garage:receiveVehicles', src, formattedVehicles, garageId)
            end
        )
    end
end)

-- Võta sõiduk välja
RegisterNetEvent('takenncs-garage:takeOutVehicle')
AddEventHandler('takenncs-garage:takeOutVehicle', function(vehicleId, garageId)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    -- Leia garaaž
    local garage = nil
    for _, g in ipairs(Config.Garage.Garages) do
        if g.id == garageId then
            garage = g
            break
        end
    end
    
    if not garage then return end
    
    local tableName = GetVehicleTableName(garage.vehicle_type)
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    -- Kontrolli, kas sõiduk kuulub mängijale
    MySQL.single(
        'SELECT * FROM ' .. tableName .. ' WHERE id = ? AND ' .. ownerColumn .. ' = ?',
        { vehicleId, player.identifier },
        function(vehicle)
            if not vehicle then
                TriggerClientEvent('takenncs-garage:vehicleTakenOut', src, { success = false, error = 'Sõidukit ei leitud' })
                return
            end
            
            -- Metaandmete parsing
            local metadata = {}
            if vehicle.customization and vehicle.customization ~= '' then
                metadata = json.decode(vehicle.customization) or {}
            elseif vehicle.metadata and vehicle.metadata ~= '' then
                metadata = json.decode(vehicle.metadata) or {}
            end
            
            -- Autode puhul uuenda stored = 0
            if tableName == 'owned_vehicles' then
                MySQL.update(
                    'UPDATE ' .. tableName .. ' SET stored = 0 WHERE id = ?',
                    { vehicleId },
                    function(affected)
                        if affected and affected > 0 then
                            TriggerClientEvent('takenncs-garage:vehicleTakenOut', src, { 
                                success = true, 
                                vehicle = {
                                    id = vehicle.id,
                                    model = vehicle.model,
                                    label = metadata.label or vehicle.model,
                                    plate = vehicle.plate,
                                    fuel = 100,
                                    engine = 1000,
                                    body = 1000,
                                    color1 = 0,
                                    color2 = 0,
                                    vehicle_type = garage.vehicle_type
                                }
                            }, garageId)
                        else
                            TriggerClientEvent('takenncs-garage:vehicleTakenOut', src, { success = false, error = 'Andmebaasi viga' })
                        end
                    end
                )
            else
                -- Helikopterite puhul lihtsalt teata, et saab välja võtta
                TriggerClientEvent('takenncs-garage:vehicleTakenOut', src, { 
                    success = true, 
                    vehicle = {
                        id = vehicle.id,
                        model = vehicle.model,
                        label = metadata.label or vehicle.model,
                        plate = vehicle.plate,
                        fuel = 100,
                        engine = 1000,
                        body = 1000,
                        color1 = 0,
                        color2 = 0,
                        vehicle_type = garage.vehicle_type
                    }
                }, garageId)
            end
        end
    )
end)

-- Pargi sõiduk
RegisterNetEvent('takenncs-garage:storeVehicle')
AddEventHandler('takenncs-garage:storeVehicle', function(plate, data, garageId, netId, vehicleType)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    local tableName = GetVehicleTableName(vehicleType)
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    -- Kontrolli kas sõiduk kuulub mängijale
    MySQL.single(
        'SELECT id FROM ' .. tableName .. ' WHERE plate = ? AND ' .. ownerColumn .. ' = ?',
        { plate, player.identifier },
        function(vehicle)
            if not vehicle then
                TriggerClientEvent('takenncs-garage:vehicleStored', src, { success = false, error = 'See pole sinu sõiduk' }, netId)
                return
            end
            
            -- Autode puhul uuenda stored = 1
            if tableName == 'owned_vehicles' then
                MySQL.update(
                    'UPDATE ' .. tableName .. ' SET stored = 1 WHERE plate = ? AND ' .. ownerColumn .. ' = ?',
                    { plate, player.identifier },
                    function(affected)
                        if affected and affected > 0 then
                            TriggerClientEvent('takenncs-garage:vehicleStored', src, { success = true }, netId)
                        else
                            TriggerClientEvent('takenncs-garage:vehicleStored', src, { success = false, error = 'Andmebaasi viga' }, netId)
                        end
                    end
                )
            else
                -- Helikopterite puhul lihtsalt teata, et pargitud (kui stored veergu pole)
                TriggerClientEvent('takenncs-garage:vehicleStored', src, { success = true }, netId)
            end
        end
    )
end)

-- Kontrolli omandust
RegisterNetEvent('takenncs-garage:checkOwnership')
AddEventHandler('takenncs-garage:checkOwnership', function(plate, vehicle, vehicleType)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    local tableName = GetVehicleTableName(vehicleType)
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    MySQL.scalar(
        'SELECT id FROM ' .. tableName .. ' WHERE plate = ? AND ' .. ownerColumn .. ' = ?',
        { plate, player.identifier },
        function(id)
            TriggerClientEvent('takenncs-garage:ownershipResult', src, id and true or false, plate, vehicle)
        end
    )
end)

print('[takenncs-garage] Server loaded')