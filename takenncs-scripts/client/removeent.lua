local Core = exports['takenncs-fw']:GetCoreObject()
local entPoly = {}
local isPlayerLoaded = false

RegisterNetEvent('takenncs:characterLoaded', function()
    isPlayerLoaded = true
    Wait(5000)
    
    for _, v in pairs(Config.Objects) do
        local zone = lib.zones.box({
            coords = v.coords,
            size = vec3(v.length, v.width, 5.0),
            rotation = 0,
            debug = Config.Debug or false,
            onEnter = function()
                for _, obj in pairs(Config.Objects) do
                    local model = obj.model
                    if type(model) == 'string' then
                        model = GetHashKey(model)
                    end
                    
                    local entity = GetClosestObjectOfType(obj.coords.x, obj.coords.y, obj.coords.z, 5.0, model, false, false, false)
                    
                    if DoesEntityExist(entity) then
                        SetEntityAsMissionEntity(entity, true, true)
                        DeleteObject(entity)
                        SetEntityAsNoLongerNeeded(entity)
                        
                        if Config.Debug then
                            print(('[takenncs] Deleted object: %s'):format(obj.model))
                        end
                    end
                end
            end
        })
        
        table.insert(entPoly, zone)
    end
end)

RegisterNetEvent('takenncs:characterUnloaded', function()
    isPlayerLoaded = false
    for _, zone in ipairs(entPoly) do
        zone:remove()
    end
    entPoly = {}
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, zone in ipairs(entPoly) do
            zone:remove()
        end
        entPoly = {}
    end
end)