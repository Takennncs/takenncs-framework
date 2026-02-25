RegisterNetEvent("spawnPersistentProp")
AddEventHandler("spawnPersistentProp", function(data)
    RequestModel(data.model)
    while not HasModelLoaded(data.model) do Wait(10) end

    local prop = CreateObject(GetHashKey(data.model), data.x, data.y, data.z - 1.0, false, true, false)
    SetEntityHeading(prop, data.heading)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
end)

AddEventHandler("onClientResourceStart", function(resName)
    if GetCurrentResourceName() ~= resName then return end
    TriggerServerEvent("requestPersistentProps")
end)
