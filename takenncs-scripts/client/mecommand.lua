-- takenncs-fw - mecommand.lua
local displayedTexts = {}
local nbrDisplaying = 0

TriggerEvent('chat:addSuggestion', '/me', 'Väljenda oma karakteri tegevust', {
    { name="sisu"}
})

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 255, 165, 0, 150)
    ClearDrawOrigin()
end

RegisterNetEvent("TAKENNCS:chat:me", function(text, source)
    local playerId = GetPlayerFromServerId(source)

    if playerId ~= -1 or source == GetPlayerServerId(PlayerId()) then
        if not displayedTexts[playerId] then
            displayedTexts[playerId] = {}
        end

        local newDisplay = {
            text = text,
            startTime = GetGameTimer(),
        }

        table.insert(displayedTexts[playerId], newDisplay)

        if #displayedTexts[playerId] == 1 then
            CreateThread(function()
                while #displayedTexts[playerId] > 0 do
                    Wait(0)
                    local sourceCoords = GetEntityCoords(GetPlayerPed(playerId))
                    local nearCoords = GetEntityCoords(PlayerPedId())
                    local distance = Vdist2(sourceCoords, nearCoords)

                    if distance < 25.0 then
                        for i, display in ipairs(displayedTexts[playerId]) do
                            DrawText3D(
                                sourceCoords.x,
                                sourceCoords.y,
                                sourceCoords.z + 0.2 + (#displayedTexts[playerId] - i) * 0.14,
                                display.text
                            )
                        end
                    end

                    for i = #displayedTexts[playerId], 1, -1 do
                        if GetGameTimer() - displayedTexts[playerId][i].startTime > 8500 then
                            table.remove(displayedTexts[playerId], i)
                        end
                    end
                end
            end)
        end
    end
end)