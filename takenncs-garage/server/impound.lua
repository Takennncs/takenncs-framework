local Core = exports['takenncs-fw']:GetCoreObject()

-- Hangi impoundis olevad sõidukid
RegisterNetEvent('takenncs-garage:getImpoundedVehicles')
AddEventHandler('takenncs-garage:getImpoundedVehicles', function(garageId)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    -- Leia impoundi konfiguratsioon
    local garage = nil
    for _, g in ipairs(Config.Garage.Garages) do
        if g.id == garageId then
            garage = g
            break
        end
    end
    
    if not garage then return end
    
    local tableName = (garage.vehicle_type == 'helicopter') and 'owned_helicopters' or 'owned_vehicles'
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    if tableName == 'owned_helicopters' then
        -- Helikopterid - võtame kõik mis on impoundis (stored = 0 kui veerg on olemas)
        MySQL.query([[
            SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'owned_helicopters' AND COLUMN_NAME = 'stored'
        ]], {}, function(columns)
            if columns and #columns > 0 then
                -- Stored veerg on olemas
                MySQL.query(
                    'SELECT * FROM owned_helicopters WHERE ' .. ownerColumn .. ' = ? AND stored = 0',
                    { player.identifier },
                    function(vehicles)
                        SendImpoundedVehicles(src, vehicles, 'helicopter')
                    end
                )
            else
                -- Stored veergu pole - näitame tühja impoundi või võtame kõik
                MySQL.query(
                    'SELECT * FROM owned_helicopters WHERE ' .. ownerColumn .. ' = ?',
                    { player.identifier },
                    function(vehicles)
                        -- Siin saad ise otsustada, kas näidata kõiki või mitte
                        -- Näiteks võtame ainult need mis on mingi tingimusega
                        SendImpoundedVehicles(src, vehicles, 'helicopter')
                    end
                )
            end
        end)
    else
        -- Autod - stored = 0 (väljas)
        MySQL.query(
            'SELECT * FROM owned_vehicles WHERE ' .. ownerColumn .. ' = ? AND stored = 0',
            { player.identifier },
            function(vehicles)
                SendImpoundedVehicles(src, vehicles, 'car')
            end
        )
    end
end)

function SendImpoundedVehicles(src, vehicles, vehicleType)
    local formattedVehicles = {}
    for _, v in ipairs(vehicles or {}) do
        local metadata = {}
        if v.customization and v.customization ~= '' then
            metadata = json.decode(v.customization) or {}
        elseif v.metadata and v.metadata ~= '' then
            metadata = json.decode(v.metadata) or {}
        end
        
        table.insert(formattedVehicles, {
            id = v.id,
            model = v.model,
            label = metadata.label or v.model,
            plate = v.plate,
            price = metadata.price or 50000,
            vehicle_type = vehicleType
        })
    end
    
    TriggerClientEvent('takenncs-garage:receiveImpoundedVehicles', src, formattedVehicles)
end

-- Osta sõiduk impoundist välja
RegisterNetEvent('takenncs-garage:buyOutImpounded')
AddEventHandler('takenncs-garage:buyOutImpounded', function(vehicleId, fee, vehicleType)
    local src = source
    local player = Core.GetPlayer(src)
    
    if not player or not player.character then
        return
    end
    
    local tableName = (vehicleType == 'helicopter') and 'owned_helicopters' or 'owned_vehicles'
    local ownerColumn = (tableName == 'owned_helicopters') and 'owner_id' or 'owner'
    
    -- Kontrolli, kas sõiduk kuulub mängijale
    MySQL.single(
        'SELECT * FROM ' .. tableName .. ' WHERE id = ? AND ' .. ownerColumn .. ' = ?',
        { vehicleId, player.identifier },
        function(vehicle)
            if not vehicle then
                TriggerClientEvent('takenncs-garage:vehicleBoughtOut', src, { success = false, error = 'Sõidukit ei leitud' })
                return
            end
            
            -- Kontrolli, kas mängijal on piisavalt sularaha
            local cash = GetPlayerCash(src)
            
            if cash < fee then
                TriggerClientEvent('takenncs-garage:vehicleBoughtOut', src, { 
                    success = false, 
                    error = string.format('Pole piisavalt sularaha! Vaja: $%s, sul: $%s', FormatNumber(fee), FormatNumber(cash))
                })
                return
            end
            
            -- Võta raha maha
            RemovePlayerCash(src, fee)
            
            -- Metaandmete parsing
            local metadata = {}
            if vehicle.customization and vehicle.customization ~= '' then
                metadata = json.decode(vehicle.customization) or {}
            elseif vehicle.metadata and vehicle.metadata ~= '' then
                metadata = json.decode(vehicle.metadata) or {}
            end
            
            -- Autode puhul uuenda stored = 1
            if tableName == 'owned_vehicles' then
                MySQL.update(
                    'UPDATE ' .. tableName .. ' SET stored = 1 WHERE id = ?',
                    { vehicleId },
                    function(affected)
                        if affected and affected > 0 then
                            TriggerClientEvent('takenncs-garage:vehicleBoughtOut', src, { 
                                success = true,
                                vehicle = {
                                    id = vehicle.id,
                                    model = vehicle.model,
                                    label = metadata.label or vehicle.model,
                                    plate = vehicle.plate,
                                    color1 = 0,
                                    color2 = 0,
                                    vehicle_type = vehicleType
                                }
                            })
                        else
                            TriggerClientEvent('takenncs-garage:vehicleBoughtOut', src, { success = false, error = 'Andmebaasi viga' })
                        end
                    end
                )
            else
                -- Helikopterite puhul lihtsalt teata, et välja ostetud
                TriggerClientEvent('takenncs-garage:vehicleBoughtOut', src, { 
                    success = true,
                    vehicle = {
                        id = vehicle.id,
                        model = vehicle.model,
                        label = metadata.label or vehicle.model,
                        plate = vehicle.plate,
                        color1 = 0,
                        color2 = 0,
                        vehicle_type = vehicleType
                    }
                })
            end
        end
    )
end)

-- Abifunktsioonid raha käsitlemiseks (kohanda oma süsteemi järgi!)
function GetPlayerCash(source)
    local cash = exports.ox_inventory:GetItemCount(source, 'money')
    return cash or 0
end

function RemovePlayerCash(source, amount)
    exports.ox_inventory:RemoveItem(source, 'money', amount)
end

function FormatNumber(num)
    local formatted = tostring(math.floor(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if k == 0 then break end
    end
    return formatted
end