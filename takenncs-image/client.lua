local Core = exports['takenncs-fw']:GetCoreObject()
local CLIENT_ID = 'SINU CLIENT ID SIIA'
local active = false
local PlayerData = nil
local locations = {
    vec3(459.7575, -989.1176, 24.9148),
    vec3(0, 0, 0)
}

RegisterNetEvent('takenncs:characterLoaded', function(character)
    if character then
        PlayerData = character
    end
end)

RegisterNetEvent('takenncs:jobUpdated', function(job, grade)
    if PlayerData then
        PlayerData.job = job
        PlayerData.job_grade = grade
    end
end)

for k, v in pairs(locations) do
    local point = lib.points.new(v, 1.5)

    function point:onEnter()
        if PlayerData and PlayerData.job == 'police' then
            lib.showTextUI('[E] - Tee pilti', {position = "left-center"})
        end
    end
    
    function point:onExit()
        if PlayerData and PlayerData.job == 'police' then
            lib.hideTextUI()
        end
    end
    
    function point:nearby()
        if self.currentDistance < 1.5 and IsControlJustReleased(0, 38) then
            if PlayerData and PlayerData.job == 'police' then
                local players = GetActivePlayers()
                local nearbyPlayers = {}
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                
                for i = 1, #players do
                    local target = GetPlayerPed(players[i])
                    if target ~= ped then
                        local targetCoords = GetEntityCoords(target)
                        local distance = #(coords - targetCoords)
                        
                        if distance < 3.0 then
                            local serverId = GetPlayerServerId(players[i])
                            table.insert(nearbyPlayers, {
                                id = serverId,
                                name = GetPlayerName(serverId)
                            })
                        end
                    end
                end

                if #nearbyPlayers == 0 then
                    TriggerEvent('ox_lib:notify', {
                        title = 'Pildistamine',
                        description = 'Läheduses ei ole ühtegi mängijat!',
                        type = 'error'
                    })
                    return
                end

                local options = {}
                for i = 1, #nearbyPlayers do
                    options[#options + 1] = {
                        title = ('ID: %s - %s'):format(nearbyPlayers[i].id, nearbyPlayers[i].name),
                        onSelect = function()
                            TriggerEvent('takenncs-image:playerSelected', nearbyPlayers[i].id)
                        end
                    }
                end

                lib.registerContext({
                    id = 'players_menu',
                    title = 'Vali mängija',
                    options = options
                })

                lib.showContext('players_menu')
            end
        end
    end
end

RegisterNetEvent('takenncs-image:playerSelected', function(playerId)
    SendNUIMessage({
        action = 'openMenu',
        id = playerId
    })
    SetFollowPedCamViewMode(4)
    SetNuiFocus(true, true)
end)

RegisterNUICallback('postImage', function(args)
    local x, y = GetActiveScreenResolution()

    exports['screenshot-basic']:requestScreenshotUpload('https://api.imgur.com/3/image', 'imgur', {
        headers = {
            ['authorization'] = string.format('Client-ID %s', CLIENT_ID),
            ['content-type'] = 'multipart/form-data'
        },
        crop = {
            offsetX = args.left,
            offsetY = args.top,
            width = x / 8,
            height = y / 4
        }
    }, function(data)
        if data then
            local imgData = json.decode(data)
            if imgData and imgData.data and imgData.data.link then
                lib.callback('takenncs-image:update', false, function(success)
                    if success then
                        TriggerEvent('ox_lib:notify', {
                            title = 'Pildistamine',
                            description = 'Pilt edukalt salvestatud!',
                            type = 'success'
                        })
                    end
                    
                    SendNUIMessage({action = 'closeMenu'})
                    SetNuiFocus(false, false)
                    Wait(500)
                    SetFollowPedCamViewMode(0)
                end, args.player, imgData.data.link)
            end
        end
    end)
end)

RegisterNUICallback('closeMenu', function()
    SendNUIMessage({action = 'closeMenu'})
    SetNuiFocus(false, false)
    SetFollowPedCamViewMode(0)
end)

RegisterNetEvent('takenncs:characterUnloaded', function()
    lib.hideTextUI()
end)