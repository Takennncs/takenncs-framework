-- Disable weapon whiping

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-- Disable known stealth kills

local stealthKills = {
    "ACT_stealth_kill_a",
    "ACT_stealth_kill_weapon",
    "ACT_stealth_kill_b",
    "ACT_stealth_kill_c",
    "ACT_stealth_kill_d",
    "ACT_stealth_kill_a_gardener"
}

CreateThread(function()
    for _, killName in ipairs(stealthKills) do
        local hash = GetHashKey(killName)
        RemoveStealthKill(hash, false)
    end
end)

-- Disable stealth kill animation
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if IsPedPerformingStealthKill(playerPed) then
            ClearPedTasksImmediately(playerPed)
        end

       Wait(1)
    end
end)

-- Pigi?

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        SetPedResetFlag(ped,438,true)
    end
end)

-- Disable front/back takedown

CreateThread(function()
    while true do
        Wait(0)
        local ped = GetPlayerPed(-1)
        SetPedConfigFlag(ped, 69, false)
        SetPedConfigFlag(ped, 70, false)
    end
end)

-- Disable headshot

CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed = GetPlayerPed(-1)
            SetPedSuffersCriticalHits(playerPed, false)
    end
end)

-- Disable Spam Punch

CreateThread(function()
    while true do
        Wait(0)
        DisableControlAction(1, 140, true)
        if not IsPlayerTargettingAnything(PlayerId()) then
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-- This flag is used to allow the ped to sprint in any interior

SetPedConfigFlag(PlayerPedId(), 427, true)

-- Sync player head movement

CreateThread(function()
    NetworkSetLocalPlayerSyncLookAt(true)
end)

-- Disable Ammunation Ambient Gun Shots

CreateThread(function()
	ClearAmbientZoneState("collision_ybmrar", false)
	SetAmbientZoneState("collision_ybmrar", false, false)
end)