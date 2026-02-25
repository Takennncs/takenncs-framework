local entryCoords = vec4(1119.1256, -3193.3779, -40.3918, 3.2481)
local exitCoords  = vec4(-283.1844, -989.8070, 31.1824, 329.3676)

local function teleportTo(coords)
    DoScreenFadeOut(500)
    Wait(500)
    SetEntityCoords(PlayerPedId(), coords.xyz)
    SetEntityHeading(PlayerPedId(), coords.w)
    Wait(500)
    DoScreenFadeIn(500)
end

local function playExitEmote()
    local ped = PlayerPedId()
    lib.requestAnimDict('anim@heists@keycard@')
    TaskPlayAnim(
        ped,
        'anim@heists@keycard@',
        'exit',
        8.0, -8.0,
        -1,
        49,
        0,
        false, false, false
    )
end

exports.ox_target:addSphereZone({
    coords = entryCoords.xyz,
    radius = 1.5,
    debug = false,
    options = {
        {
            name = 'exit_building',
            label = 'Välju hoonest',
            icon = 'fa-solid fa-door-open',
            onSelect = function()
                playExitEmote()

                local success = lib.progressBar({
                    duration = 3000,
                    label = 'Väljud...',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = true,
                        car = true,
                        combat = true
                    }
                })

                ClearPedTasks(PlayerPedId())

                if success then
                    teleportTo(exitCoords)
                end
            end
        }
    }
})