local players = {}

local function removeEntity(entity)
    if entity and DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end

local function removePlayer(serverId)
    local Player = players[serverId]

    if Player then
        removeEntity(Player)
        players[serverId] = nil
    end
end

RegisterNetEvent('onPlayerDropped', function(serverId)
    removePlayer(serverId)
end)

RegisterNetEvent('TIPBXR.Player.Unloaded', function()
    LocalPlayer.state:set('hasTablet', false, true)
end)

local function getEntityFromStateBag(bagName, keyName)
    if bagName:find('entity:') then
        local netId = tonumber(bagName:gsub('entity:', ''), 10)

        local entity =  lib.waitFor(function()
            if NetworkDoesEntityExistWithNetworkId(netId) then return NetworkGetEntityFromNetworkId(netId) end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return entity
    elseif bagName:find('player:') then
        local serverId = tonumber(bagName:gsub('player:', ''), 10)
        local playerId = GetPlayerFromServerId(serverId)

        local entity = lib.waitFor(function()
            local ped = GetPlayerPed(playerId)
            if ped > 0 then return ped end
        end, ('%s received invalid entity! (%s)'):format(keyName, bagName), 10000)

        return serverId, entity
    end
end

local function createObject(ped)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(joaat('prop_cs_tablet'), coords.x, coords.y, coords.z + 0.2, false, false, false)

    if newProp then
        AttachEntityToEntity(newProp, ped, GetPedBoneIndex(ped, 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    end

    SetModelAsNoLongerNeeded(joaat('prop_cs_tablet'))

    return newProp
end

AddStateBagChangeHandler('hasTablet', nil, function(bagName, keyName, value, _, replicated)
    if replicated then
        return
    end

    local serverId, pedHandle = getEntityFromStateBag(bagName, keyName)

    if serverId and not value then
        return removePlayer(serverId)
    end

    if pedHandle and pedHandle > 0 then
        local currentObject = players[serverId]

        if currentObject then
            removeEntity(currentObject)
            currentObject = nil
        end

        if value then
            currentObject = createObject(pedHandle)
        end

        players[serverId] = currentObject
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, v in pairs(players) do
            if v then
                removeEntity(v)
            end
        end

        LocalPlayer.state:set('hasTablet', false, true)
    end
end)

AddStateBagChangeHandler('instance', ('player:%s'):format(cache.serverId), function(_, _, value)
    if value == 0 then
        local currentObject = players[cache.serverId]

        if currentObject then
            removeEntity(currentObject)
            LocalPlayer.state:set('hasTablet', false, true)
        end
    end
end)

CreateThread(function()
    while not LocalPlayer.state.isLoggedIn do
        Wait(2000)
    end

    LocalPlayer.state:set('hasTablet', false, true)
end)

local function toggleTab(toggle)
    if toggle and not LocalPlayer.state.hasTablet then
		if not cache.vehicle then            
            LocalPlayer.state:set('hasTablet', true, true)

			CreateThread(function()
				lib.requestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@idle_a')
				SetCurrentPedWeapon(cache.ped, `weapon_unarmed`, true)

				while LocalPlayer.state.hasTablet do
					Wait(100)

					InvalidateIdleCam()
					InvalidateVehicleIdleCam()

					if not IsEntityPlayingAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', 'idle_a', 3) then
						TaskPlayAnim(cache.ped, 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', 'idle_a', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					end
				end

				ClearPedSecondaryTask(cache.ped)
                RemoveAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@idle_a')
			end)
		end
    elseif not toggle and LocalPlayer.state.hasTablet then
        LocalPlayer.state:set('hasTablet', false, true)
    end
end

exports('toggleTab', toggleTab) 