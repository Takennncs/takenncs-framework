local showIDs = false
local lastMeTime = 0
local meCooldown = 5000
local displayRadius = 9.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        showIDs = IsControlPressed(0, 121) 

        if showIDs then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local players = GetActivePlayers()

            for _, player in ipairs(players) do
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    local targetCoords = GetEntityCoords(ped)
                    local dist = #(playerCoords - targetCoords)

                    if dist <= displayRadius then
                        local playerId = GetPlayerServerId(player)
                        local isTalking = NetworkIsPlayerTalking(player)
                        local color = isTalking and {255, 165, 0, 255} or {255, 255, 255, 215}
                        local textCoords = vector3(targetCoords.x, targetCoords.y, targetCoords.z + 1.0)

                        DrawText3D(textCoords.x, textCoords.y, textCoords.z, "" .. playerId, color)
                    end
                end
            end

            local currentTime = GetGameTimer()
            if currentTime - lastMeTime > meCooldown then
                ExecuteCommand('me Uurib pingsalt ümbrust')
                lastMeTime = currentTime
            end
        end
    end
end)

function DrawText3D(x, y, z, text, rgba, icon)
    icon = icon or ""

    local pos = vector3(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - pos)
    if dist < 1.0 then dist = 1.0 end

    local size = 0.5 -- väiksem tekstisuurus
    local scale = (size / dist) * 1.5
    local fov = (1 / GetGameplayCamFov()) * 100
    local finalScale = scale * fov

    SetDrawOrigin(pos.x, pos.y, pos.z, 0)
    SetTextProportional(1)
    SetTextScale(0.0 * finalScale, 1.35 * finalScale)

    -- ORANŽ värv (kui rgba ei anta)
    local color = rgba or {255, 140, 0, 255}
    SetTextColour(color[1], color[2], color[3], color[4])

    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(icon .. text)
    DrawText(0.0, 0.0)

    -- Oranži varje efekt (valge taust eemaldatud)
    SetTextColour(color[1], color[2], color[3], color[4] / 5)
    DrawText(0.01, 0.01)

    ClearDrawOrigin()
end

