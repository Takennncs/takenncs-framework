-- client/vehicle.lua
function GetVehicleInDirection()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local direction = GetEntityForwardVector(playerPed)
    local rayHandle = StartShapeTestCapsule(coords.x, coords.y, coords.z, 
        coords.x + direction.x * 10.0, coords.y + direction.y * 10.0, coords.z + direction.z * 10.0,
        2.0, 10, playerPed, 4)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)
    return vehicle
end

function GetClosestVehicle(coords)
    coords = coords or GetEntityCoords(PlayerPedId())
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    
    for i = 1, #vehicles do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(coords - vehicleCoords)
        
        if closestDistance == -1 or distance < closestDistance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    
    return closestVehicle, closestDistance
end

function GetVehicleProperties(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    
    return {
        model = GetEntityModel(vehicle),
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
        colorPrimary = colorPrimary,
        colorSecondary = colorSecondary,
        pearlescentColor = pearlescentColor,
        wheelColor = wheelColor,
        wheels = GetVehicleWheelType(vehicle),
        windowTint = GetVehicleWindowTint(vehicle),
        neonEnabled = {
            GetVehicleNeonLightEnabled(vehicle, 0),
            GetVehicleNeonLightEnabled(vehicle, 1),
            GetVehicleNeonLightEnabled(vehicle, 2),
            GetVehicleNeonLightEnabled(vehicle, 3)
        },
        neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
        interiorColor = GetVehicleInteriorColour(vehicle),
        dashboardColor = GetVehicleDashboardColour(vehicle)
    }
end

function SetVehicleProperties(vehicle, props)
    if not DoesEntityExist(vehicle) then return end
    
    SetVehicleModKit(vehicle, 0)
    
    if props.plate then
        SetVehicleNumberPlateText(vehicle, props.plate)
    end
    
    if props.colorPrimary and props.colorSecondary then
        SetVehicleColours(vehicle, props.colorPrimary, props.colorSecondary)
    end
    
    if props.pearlescentColor and props.wheelColor then
        SetVehicleExtraColours(vehicle, props.pearlescentColor, props.wheelColor)
    end
    
    if props.wheels then
        SetVehicleWheelType(vehicle, props.wheels)
    end
    
    if props.windowTint then
        SetVehicleWindowTint(vehicle, props.windowTint)
    end
    
    if props.neonEnabled then
        SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
        SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
        SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
        SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
    end
    
    if props.neonColor then
        SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
    end
end