-- client/progress.lua
function ProgressBar(duration, label, useWhileDead, canCancel, anim, prop, onFinish, onCancel)
    if not lib then return end
    
    local success = lib.progressBar({
        duration = duration,
        label = label,
        useWhileDead = useWhileDead or false,
        canCancel = canCancel or true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false
        },
        anim = anim,
        prop = prop
    })
    
    if success then
        if onFinish then onFinish() end
    else
        if onCancel then onCancel() end
    end
    
    return success
end

function ProgressCircle(duration, label, useWhileDead, canCancel, anim, prop, onFinish, onCancel)
    if not lib then return end
    
    local success = lib.progressCircle({
        duration = duration,
        label = label,
        useWhileDead = useWhileDead or false,
        canCancel = canCancel or true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false
        },
        anim = anim,
        prop = prop
    })
    
    if success then
        if onFinish then onFinish() end
    else
        if onCancel then onCancel() end
    end
    
    return success
end