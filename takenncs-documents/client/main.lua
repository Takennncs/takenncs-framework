local Core = exports['takenncs-fw']:GetCoreObject()
local opened = false
local PlayerData = nil

RegisterNetEvent('takenncs:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

RegisterNetEvent('takenncs-documents:client:showId', function(data, pid)
    local person_src = pid
    local pid = GetPlayerFromServerId(person_src)
    local targetPed = GetPlayerPed(pid)
    local myCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(targetPed)

    if pid ~= -1 then
        if #(myCoords - targetCoords) <= 3.5 then
            opened = true
            SendNUIMessage({
                action = 'showId',
                userInfo = data
            })
        end
    end
end)

RegisterNetEvent('takenncs-documents:client:showIdLocal', function(data)
    opened = true
    SendNUIMessage({
        action = 'showId',
        userInfo = data
    })
end)

CreateThread(function()
    while true do
        wait = 0

        if opened then
            if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
                SendNUIMessage({ action = 'hide' })
                opened = false
            end
        else
            wait = 500
        end

        Wait(wait)
    end
end)

RegisterNetEvent("takenncs-documents:client:animation")
AddEventHandler("takenncs-documents:client:animation", function()
    lib.requestModel(GetHashKey("p_ld_id_card_002"), 1000)

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local badgeProp = CreateObject(GetHashKey("p_ld_id_card_002"), coords.x, coords.y, coords.z, true, true, true)
    local boneIndex = GetPedBoneIndex(ped, 28422)

    AttachEntityToEntity(
        badgeProp,
        ped,
        boneIndex,
        0.065, 0.029, -0.035,
        80.0, -1.90, 75.0,
        true, true, false, true, 1, true
    )

    lib.requestAnimDict('paper_1_rcm_alt1-9', 1000)
    TaskPlayAnim(ped, "paper_1_rcm_alt1-9", "player_one_dual-9", 15.0, -15, 5000, 49, 0, 0, 0, 0)
    
    Citizen.Wait(3000)
    ClearPedTasks(ped)
    DeleteObject(badgeProp)
end)

CreateThread(function()
    exports.ox_target:addGlobalPlayer({
        {
            name = 'show_id_card',
            icon = 'fa-solid fa-id-card',
            label = 'Näita ID-kaarti',
            distance = 2.0,
            onSelect = function(data)
                local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TriggerServerEvent('takenncs-documents:server:showOthersId', playerId)
            end
        }
    })
end)

RegisterNetEvent('ox_inventory:usedItem', function(item, slot, data)
    if item == 'id_card' then
        TriggerServerEvent('takenncs-documents:server:viewId')
    end
end)

exports.ox_inventory:displayMetadata({
    id_card = {
        description = "Kaart, mis sisaldab kõiki teie andmeid teie isiku tuvastamiseks",
        weight = 0,
        stack = false,
        close = false,
        onUse = function(slot, data)
            TriggerServerEvent('takenncs-documents:server:viewId')
            return true
        end
    }
})