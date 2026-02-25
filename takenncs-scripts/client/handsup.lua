-- client/handsup.lua
local Core = exports['takenncs-fw']:GetCoreObject()
local handsUpKey = 323 -- X key
local animDict = 'missminuteman_1ig_2'
local animName = 'handsup_base'
local handsUp = false
local disabledControls = {24, 25, 58, 263, 264, 257} 

RequestAnimDict(animDict)
while not HasAnimDictLoaded(animDict) do
    Citizen.Wait(10)
end

local function toggleControls(toggle)
    for _, control in ipairs(disabledControls) do
        DisableControlAction(0, control, toggle)
    end
end

local function toggleHandsUp()
    local ped = PlayerPedId()
    handsUp = not handsUp

    if handsUp then
        TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, -1, 50, 0, false, false, false)
        toggleControls(true)
    else
        ClearPedTasks(ped)
        toggleControls(false)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, handsUpKey) then
            toggleHandsUp()
        end
    end
end)

exports('getHandsup', function()
    return handsUp
end)