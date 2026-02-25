local queueActive = false
local queuePosition = 0
local queueTotal = 0
local queueStartTime = 0

print('[takenncs-queue] Client module loaded')

RegisterNetEvent('takenncs-queue:updatePosition')
AddEventHandler('takenncs-queue:updatePosition', function(position, total)
    queueActive = true
    queuePosition = position
    queueTotal = total
    
    if queueStartTime == 0 then
        queueStartTime = GetGameTimer()
    end
    
    ShowQueueProgress(position, total)
end)

function ShowQueueProgress(position, total)
    if not Config.Queue.UI.ShowPosition then return end
    
    local progress = (total - position) / total
    local estimatedTime = CalculateEstimatedTime(position, total)
    
    local positionText = Config.Queue.UI.PositionFormat
        :gsub('{current}', tostring(position))
        :gsub('{total}', tostring(total))
    
    lib.progressBar({
        duration = Config.Queue.QueuePositionUpdate,
        label = Config.Queue.UI.Title,
        position = 'bottom',
        percentage = progress * 100,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    })
    
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(positionText)
    EndTextCommandDisplayHelp(0, false, true, -1)
    
    exports.ox_lib:notify({
        title = Config.Queue.UI.Title,
        description = positionText,
        type = 'inform',
        duration = 3000,
        position = 'top'
    })
end

function CalculateEstimatedTime(position, total)
    local timePerPlayer = 30
    local estimatedSeconds = (position - 1) * timePerPlayer
    
    if estimatedSeconds > 60 then
        local minutes = math.floor(estimatedSeconds / 60)
        local seconds = estimatedSeconds % 60
        return string.format('%d min %d sek', minutes, seconds)
    else
        return string.format('%d sek', estimatedSeconds)
    end
end

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        queueActive = false
    end
end)

RegisterNetEvent('takenncs-queue:queueComplete')
AddEventHandler('takenncs-queue:queueComplete', function()
    queueActive = false
    queueStartTime = 0
    
    lib.hideTextUI()
end)

exports('IsInQueue', function()
    return queueActive
end)

exports('GetQueuePosition', function()
    return queuePosition, queueTotal
end)

print('[takenncs-queue] Client module loaded successfully')