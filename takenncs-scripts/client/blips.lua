-- client/blips.lua
function CreateBlip(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale or 0.7)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

function CreateJobBlip(coords, job, sprite, colour, scale, text)
    local character = GetPlayerData()
    if character and character.job == job then
        return CreateBlip(coords, sprite, colour, scale, text)
    end
    return nil
end