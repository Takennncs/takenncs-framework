local dealershipPed = nil
local helicopterDealershipPed = nil
local previewHelicopter = nil

CreateThread(function()
    Wait(1000)
    
    if Config.DealershipBlip.enabled then
        local blip = AddBlipForCoord(Config.DealershipBlip.coords.x, Config.DealershipBlip.coords.y, Config.DealershipBlip.coords.z)
        SetBlipSprite(blip, Config.DealershipBlip.sprite)
        SetBlipColour(blip, Config.DealershipBlip.color)
        SetBlipScale(blip, Config.DealershipBlip.scale)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.DealershipBlip.name)
        EndTextCommandSetBlipName(blip)
    end
    
    if Config.HelicopterDealershipBlip.enabled then
        local blip = AddBlipForCoord(Config.HelicopterDealershipBlip.coords.x, Config.HelicopterDealershipBlip.coords.y, Config.HelicopterDealershipBlip.coords.z)
        SetBlipSprite(blip, Config.HelicopterDealershipBlip.sprite)
        SetBlipColour(blip, Config.HelicopterDealershipBlip.color)
        SetBlipScale(blip, Config.HelicopterDealershipBlip.scale)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.HelicopterDealershipBlip.name)
        EndTextCommandSetBlipName(blip)
    end
    
    SpawnDealershipPed()
    SpawnHelicopterDealershipPed()
    
    AddTargetToPeds()
    
    print('[takenncs-vehicleshop] Dealership peds and blips created')
end)

function SpawnDealershipPed()
    local model = GetHashKey(Config.DealershipPed.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    dealershipPed = CreatePed(4, model, Config.DealershipPed.coords.x, Config.DealershipPed.coords.y, Config.DealershipPed.coords.z - 1.0, Config.DealershipPed.coords.w, false, true)
    SetEntityHeading(dealershipPed, Config.DealershipPed.coords.w)
    FreezeEntityPosition(dealershipPed, Config.DealershipPed.freeze)
    SetEntityInvincible(dealershipPed, Config.DealershipPed.invincible)
    SetBlockingOfNonTemporaryEvents(dealershipPed, Config.DealershipPed.blockEvents)
    
    if Config.DealershipPed.scenario then
        TaskStartScenarioInPlace(dealershipPed, Config.DealershipPed.scenario, 0, true)
    end
end

function SpawnHelicopterDealershipPed()
    local model = GetHashKey(Config.HelicopterDealershipPed.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    helicopterDealershipPed = CreatePed(4, model, Config.HelicopterDealershipPed.coords.x, Config.HelicopterDealershipPed.coords.y, Config.HelicopterDealershipPed.coords.z - 1.0, Config.HelicopterDealershipPed.coords.w, false, true)
    SetEntityHeading(helicopterDealershipPed, Config.HelicopterDealershipPed.coords.w)
    FreezeEntityPosition(helicopterDealershipPed, Config.HelicopterDealershipPed.freeze)
    SetEntityInvincible(helicopterDealershipPed, Config.HelicopterDealershipPed.invincible)
    SetBlockingOfNonTemporaryEvents(helicopterDealershipPed, Config.HelicopterDealershipPed.blockEvents)
    
    if Config.HelicopterDealershipPed.scenario then
        TaskStartScenarioInPlace(helicopterDealershipPed, Config.HelicopterDealershipPed.scenario, 0, true)
    end
end

function AddTargetToPeds()

    exports.ox_target:addLocalEntity(dealershipPed, {
        {
            name = 'vehicleshop_open',
            icon = 'fa-solid fa-car',
            label = 'Open Vehicle Shop',
            onSelect = function()
                OpenDealershipMenu()
            end,
            distance = 2.5
        }
    })
    
    exports.ox_target:addLocalEntity(helicopterDealershipPed, {
        {
            name = 'helicoptershop_open',
            icon = 'fa-solid fa-helicopter',
            label = 'Ava kopteri valikud',
            onSelect = function()
                OpenHelicopterMenu()
            end,
            distance = 2.5
        }
    })
end

function OpenDealershipMenu()
    if not Config.DealershipVehicles or #Config.DealershipVehicles == 0 then
        Notify('Vehicle Shop', 'No vehicles available', 'info')
        return
    end

    local categories = {}
    for _, vehicle in ipairs(Config.DealershipVehicles) do
        local category = vehicle.category or 'Other'
        categories[category] = categories[category] or {}
        table.insert(categories[category], vehicle)
    end

    local menuOptions = {}

    for category, vehicles in pairs(categories) do
        local submenuId = 'vehicleshop_cat_' .. category:gsub('%s+', '_')

        local vehicleOptions = {}
        for _, vehicle in ipairs(vehicles) do
            table.insert(vehicleOptions, {
                title = vehicle.label,
                description = 'Price: $' .. FormatNumber(vehicle.price),
                icon = 'car',
                onSelect = function()
                    BuyVehicle(vehicle)
                end
            })
        end

        exports.ox_lib:registerContext({
            id = submenuId,
            title = category .. ' Vehicles',
            options = vehicleOptions
        })

        table.insert(menuOptions, {
            title = category,
            description = #vehicles .. ' vehicles available',
            icon = 'layer-group',
            menu = submenuId
        })
    end

    exports.ox_lib:registerContext({
        id = 'vehicleshop_main_menu',
        title = 'Vehicle Dealership',
        options = menuOptions
    })

    exports.ox_lib:showContext('vehicleshop_main_menu')
end

function OpenHelicopterMenu()
    if not Config.HelicopterVehicles or #Config.HelicopterVehicles == 0 then
        Notify('Helicopter Shop', 'No helicopters available', 'info')
        return
    end

    ShowHelicopterPreview()

    local categories = {}
    for _, helicopter in ipairs(Config.HelicopterVehicles) do
        local category = helicopter.category or 'Other'
        categories[category] = categories[category] or {}
        table.insert(categories[category], helicopter)
    end

    local menuOptions = {}

    for category, helicopters in pairs(categories) do
        local submenuId = 'helicoptershop_cat_' .. category:gsub('%s+', '_')

        local helicopterOptions = {}
        for _, helicopter in ipairs(helicopters) do
            table.insert(helicopterOptions, {
                title = helicopter.label,
                description = 'Price: $' .. FormatNumber(helicopter.price),
                icon = 'helicopter',
                onSelect = function()
                    BuyHelicopter(helicopter)
                end
            })
        end

        exports.ox_lib:registerContext({
            id = submenuId,
            title = category .. ' Helicopters',
            options = helicopterOptions
        })

        table.insert(menuOptions, {
            title = category,
            description = #helicopters .. ' helikopterit alles',
            icon = 'layer-group',
            menu = submenuId
        })
    end

    exports.ox_lib:registerContext({
        id = 'helicoptershop_main_menu',
        title = 'Pood',
        options = menuOptions
    })

    exports.ox_lib:showContext('helicoptershop_main_menu')
end

function ShowHelicopterPreview()
    if previewHelicopter and DoesEntityExist(previewHelicopter) then
        DeleteEntity(previewHelicopter)
    end
    
    -- Preview the first helicopter in the list
    local previewModel = Config.HelicopterVehicles[1].model
    local model = GetHashKey(previewModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    previewHelicopter = CreateVehicle(model, Config.HelicopterPreviewSpawn.coords.x, Config.HelicopterPreviewSpawn.coords.y, Config.HelicopterPreviewSpawn.coords.z, Config.HelicopterPreviewSpawn.heading, false, false)
    SetVehicleDoorsLocked(previewHelicopter, 2)
    SetEntityInvincible(previewHelicopter, true)
    FreezeEntityPosition(previewHelicopter, true)
end

function BuyVehicle(vehicleData)
    local alert = exports.ox_lib:alertDialog({
        header = 'Confirm Purchase',
        content = ('Are you sure you want to buy the %s for $%s?'):format(vehicleData.label, FormatNumber(vehicleData.price)),
        labels = {
            confirm = 'Yes, buy it',
            cancel = 'Cancel'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-vehicleshop:purchaseVehicle', vehicleData)
    end
end

function BuyHelicopter(helicopterData)
    local alert = exports.ox_lib:alertDialog({
        header = 'Confirm Purchase',
        content = ('Are you sure you want to buy the %s for $%s?'):format(helicopterData.label, FormatNumber(helicopterData.price)),
        labels = {
            confirm = 'Yes, buy it',
            cancel = 'Cancel'
        }
    })

    if alert == 'confirm' then
        TriggerServerEvent('takenncs-vehicleshop:purchaseHelicopter', helicopterData)
    end
end

RegisterNetEvent('takenncs-vehicleshop:purchaseResult', function(result)
    if result.success then
        Notify('Vehicle Shop', result.message, 'success')
        
        if result.vehicle then
            SpawnPurchasedVehicle(result.vehicle)
        end
    else
        Notify('Vehicle Shop', result.message, 'error')
    end
end)

RegisterNetEvent('takenncs-vehicleshop:helicopterPurchaseResult', function(result)
    if result.success then
        Notify('Helicopter Shop', result.message, 'success')
        
        if result.helicopter then
            SpawnPurchasedHelicopter(result.helicopter)
        end
    else
        Notify('Helicopter Shop', result.message, 'error')
    end
end)

function SpawnPurchasedVehicle(vehicleData)
    local model = GetHashKey(vehicleData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    if not Config.VehicleSpawn or not Config.VehicleSpawn.coords then
        print('^1ERROR: Vehicle spawn position not configured!')
        return
    end
    
    local vehicle = CreateVehicle(model, Config.VehicleSpawn.coords.x, Config.VehicleSpawn.coords.y, Config.VehicleSpawn.coords.z, Config.VehicleSpawn.heading, true, false)
    
    local attempts = 0
    while not DoesEntityExist(vehicle) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    
    if DoesEntityExist(vehicle) then
        SetVehicleNumberPlateText(vehicle, vehicleData.plate or GeneratePlate())
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        Notify('Vehicle Shop', 'Your new vehicle has been delivered!', 'success')
    else
        Notify('Vehicle Shop', 'Failed to spawn vehicle', 'error')
    end
end

function SpawnPurchasedHelicopter(helicopterData)
    local model = GetHashKey(helicopterData.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end
    
    if not Config.HelicopterSpawn or not Config.HelicopterSpawn.coords then
        print('^1ERROR: Helicopter spawn position not configured!')
        return
    end
    
    local helicopter = CreateVehicle(model, Config.HelicopterSpawn.coords.x, Config.HelicopterSpawn.coords.y, Config.HelicopterSpawn.coords.z, Config.HelicopterSpawn.heading, true, false)
    
    local attempts = 0
    while not DoesEntityExist(helicopter) and attempts < 100 do
        Wait(10)
        attempts = attempts + 1
    end
    
    if DoesEntityExist(helicopter) then
        SetVehicleNumberPlateText(helicopter, helicopterData.plate or GeneratePlate())
        TaskWarpPedIntoVehicle(PlayerPedId(), helicopter, -1)
        Notify('Helicopter Shop', 'Your new helicopter has been delivered!', 'success')
    else
        Notify('Helicopter Shop', 'Failed to spawn helicopter', 'error')
    end
end

function Notify(title, msg, type)
    if Config.Notify.useOx then
        exports.ox_lib:notify({
            title = title,
            description = msg,
            type = type,
            position = Config.Notify.position
        })
    else
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(true, true)
    end
end

function FormatNumber(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if k == 0 then break end
    end
    return formatted
end

function GeneratePlate()
    local letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local numbers = "0123456789"
    local plate = ""
    for i = 1, 3 do
        plate = plate .. letters:sub(math.random(1, #letters), math.random(1, #letters))
    end
    plate = plate .. " "
    for i = 1, 3 do
        plate = plate .. numbers:sub(math.random(1, #numbers), math.random(1, #numbers))
    end
    return plate
end

print('[takenncs-vehicleshop] Client loaded')