RegisterNetEvent("takenncs-scripts:sendMeText")
AddEventHandler("takenncs-scripts:sendMeText", function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent("takenncs-scripts:showMeText", -1, text, coords)
end)
