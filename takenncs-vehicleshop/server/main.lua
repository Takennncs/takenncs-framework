print('[takenncs-vehicleshop] Using TAKENNCS framework')

RegisterNetEvent('takenncs-vehicleshop:purchaseVehicle', function(vehicleData)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then return end

    local price = vehicleData.price
    local plate = GeneratePlate()

    local cash = exports.ox_inventory:GetItemCount(src, 'money')

    if cash < price then
        TriggerClientEvent('takenncs-vehicleshop:purchaseResult', src, {
            success = false,
            message = 'Sul ei ole piisavalt sularaha'
        })
        return
    end

    exports.ox_inventory:RemoveItem(src, 'money', price)

    exports.oxmysql:insert([[
        INSERT INTO owned_vehicles
        (owner, plate, model, state, stored, metadata, created)
        VALUES (?, ?, ?, ?, ?, ?, NOW())
    ]], {
        identifier,
        plate,
        vehicleData.model,
        0, -- state (väljas)
        1, -- stored (garaažis)
        json.encode({
            label = vehicleData.label,
            price = price
        })
    })

    print(('[takenncs-vehicleshop] Vehicle added | %s | %s | %s')
        :format(identifier, vehicleData.model, plate)
    )

    TriggerClientEvent('takenncs-vehicleshop:purchaseResult', src, {
        success = true,
        message = 'Sõiduk ostetud sularaha eest!',
        vehicle = {
            model = vehicleData.model,
            plate = plate,
            label = vehicleData.label
        }
    })
end)

RegisterNetEvent('takenncs-vehicleshop:purchaseHelicopter', function(helicopterData)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    if not identifier then 
        TriggerClientEvent('takenncs-vehicleshop:helicopterPurchaseResult', src, {
            success = false,
            message = 'Could not find player identifier'
        })
        return
    end

    local price = helicopterData.price
    local plate = GeneratePlate()

    local cash = exports.ox_inventory:GetItemCount(src, 'money')

    if cash < price then
        TriggerClientEvent('takenncs-vehicleshop:helicopterPurchaseResult', src, {
            success = false,
            message = 'Sul ei ole piisavalt sularaha'
        })
        return
    end

    exports.ox_inventory:RemoveItem(src, 'money', price)

    exports.oxmysql:insert([[
        INSERT INTO owned_helicopters
        (owner_id, model, plate, customization, created_at)
        VALUES (?, ?, ?, ?, NOW())
    ]], {
        identifier,
        helicopterData.model,
        plate,
        json.encode({
            label = helicopterData.label,
            price = price
        })
    })

    print(('[takenncs-vehicleshop] Helicopter added | %s | %s | %s')
        :format(identifier, helicopterData.model, plate)
    )

    TriggerClientEvent('takenncs-vehicleshop:helicopterPurchaseResult', src, {
        success = true,
        message = 'Kopter ostetud sularaha eest!',
        helicopter = {
            model = helicopterData.model,
            plate = plate,
            label = helicopterData.label
        }
    })
end)

function GeneratePlate()
    local plate = string.upper(
        GetRandomLetter() ..
        GetRandomLetter() ..
        GetRandomLetter() ..
        ' ' ..
        GetRandomNumber() ..
        GetRandomNumber() ..
        GetRandomNumber()
    )

    local exists = exports.oxmysql:scalar(
        'SELECT plate FROM owned_vehicles WHERE plate = ?',
        { plate }
    )

    if exists then
        return GeneratePlate()
    end

    return plate
end

function GetRandomLetter()
    return string.char(math.random(65, 90))
end

function GetRandomNumber()
    return math.random(0, 9)
end