Sync = {}

RegisterNetEvent('sync:execute', function(native, netID, ...)
    local entity = NetworkGetEntityFromNetworkId(netID)

    if not DoesEntityExist(entity) then

        return TriggerServerEvent('sync:execute:aborted', native, netID)
    end

    if Sync[native] then
        Sync[native](entity, ...)
    end
end)

local function RequestSyncExecution(native, entity, ...)
    if DoesEntityExist(entity) then
        TriggerServerEvent(
            'sync:request',
            GetInvokingResource(),
            native,
            GetPlayerServerId(NetworkGetEntityOwner(entity)),
            NetworkGetNetworkIdFromEntity(entity),
            ...
        )
    end
end

function Sync.Execute(native, entity, ...)
    if DoesEntityExist(entity) then
        if NetworkHasControlOfEntity(entity) then
            if Sync[native] then
                Sync[native](entity, ...)
            end
        else
            RequestSyncExecution(native, entity, ...)
        end
    end
end

function Sync.DeleteVehicle(vehicle)
    DeleteVehicle(vehicle)
end

function Sync.DeleteEntity(entity)
    DeleteEntity(entity)
end

function Sync.DeletePed(ped)
    DeletePed(ped)
end

function Sync.DeleteObject(object)
    DeleteObject(object)
end

function Sync.SetVehicleFuelLevel(vehicle, level)
    SetVehicleFuelLevel(vehicle, level)
end

function Sync.SetVehicleTyreBurst(vehicle, index, onRim, p3)
    SetVehicleTyreBurst(vehicle, index, onRim, p3)
end

function Sync.SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
    SetVehicleDoorShut(vehicle, doorIndex, closeInstantly)
end

function Sync.SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
    SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly)
end

function Sync.SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
    SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor)
end

function Sync.SetVehicleEngineOn(vehicle, value, instantly, noAutoTurnOn)
    SetVehicleEngineOn(vehicle, value, instantly, noAutoTurnOn)
end

function Sync.SetVehicleUndriveable(vehicle, toggle)
    SetVehicleUndriveable(vehicle, toggle)
end

function Sync.SetVehicleHandbrake(vehicle, toggle)
    SetVehicleHandbrake(vehicle, toggle)
end

function Sync.DecorSetFloat(entity, propertyName, value)
    DecorSetFloat(entity, propertyName, value)
end

function Sync.DecorSetBool(entity, propertyName, value)
    DecorSetBool(entity, propertyName, value)
end

function Sync.DecorSetInt(entity, propertyName, value)
    DecorSetInt(entity, propertyName, value)
end

function Sync.DetachEntity(entity, p1, collision)
    DetachEntity(entity, p1, collision)
end

function Sync.SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
    SetEntityCoords(entity, xPos, yPos, zPos, xAxis, yAxis, zAxis, clearArea)
end

function Sync.SetEntityHeading(entity, heading)
    SetEntityHeading(entity, heading)
end

function Sync.FreezeEntityPosition(entity, freeze)
    FreezeEntityPosition(entity, freeze)
end

function Sync.SetVehicleDoorsLocked(entity, status)
    SetVehicleDoorsLocked(entity, status)
end

function Sync.NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3)
    NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3)
end

function Sync.SetBoatAnchor(vehicle, state)
    SetBoatAnchor(vehicle, state)
end

function Sync.SetBoatFrozenWhenAnchored(vehicle, state)
    SetBoatFrozenWhenAnchored(vehicle, state)
end

function Sync.SetForcedBoatLocationWhenAnchored(vehicle, state)
    SetForcedBoatLocationWhenAnchored(vehicle, state)
end

function Sync.SetVehicleOnGroundProperly(vehicle)
    SetVehicleOnGroundProperly(vehicle)
end

function Sync.SetVehicleTyreFixed(vehicle, index)
    SetVehicleTyreFixed(vehicle, index)
end

function Sync.SetVehicleEngineHealth(vehicle, health)
    SetVehicleEngineHealth(vehicle, health + 0.0)
end

function Sync.SetVehicleBodyHealth(vehicle, health)
    SetVehicleBodyHealth(vehicle, health + 0.0)
end

function Sync.SetVehicleDeformationFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
end

function Sync.SetVehicleFixed(vehicle)
    SetVehicleFixed(vehicle)
end

function Sync.SetEntityAsNoLongerNeeded(entity)
    SetEntityAsNoLongerNeeded(entity)
end

function Sync.SetPedKeepTask(ped, keepTask)
    SetPedKeepTask(ped, keepTask)
end

function Sync.SetVehicleTyresCanBurst(vehicle, enabled)
    SetVehicleTyresCanBurst(vehicle, enabled)
end
