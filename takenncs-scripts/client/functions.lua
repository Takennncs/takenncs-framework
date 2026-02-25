-- client/functions.lua
local Core = exports['takenncs-fw']:GetCoreObject()

function GetPlayerData()
    return Core.GetCurrentCharacter()
end

function GetCoords(entity)
    local entity = entity or PlayerPedId()
    local coords = GetEntityCoords(entity)
    return vector4(coords.x, coords.y, coords.z, GetEntityHeading(entity))
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(pX, pY, pZ) - vector3(x, y, z))

    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

function Notify(msg, type, duration)
    type = type or 'inform'
    duration = duration or 5000
    
    exports.ox_lib:notify({
        title = 'teade',
        description = msg,
        type = type,
        duration = duration
    })
end