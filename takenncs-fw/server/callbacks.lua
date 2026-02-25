RegisterNetEvent('takenncs:serverCallback')
AddEventHandler('takenncs:serverCallback', function(name, ...)
    local src = source
    local args = { ... }
    
    if Config.Debug then
        print(('[takenncs-fw] Server callback: %s from %s'):format(name, src))
    end
    
    if not TakennCS.Callbacks[name] then
        if Config.Debug then
            print(('[takenncs-fw] ERROR: Callback not found: %s'):format(name))
        end
        TriggerClientEvent('takenncs:clientCallback', src, name, nil)
        return
    end
    
    TakennCS.Callbacks[name](src, function(...)
        TriggerClientEvent('takenncs:clientCallback', src, name, ...)
    end, table.unpack(args))
end)

TakennCS.RegisterCallback('takenncs:getPlayerJob', function(source, cb, characterId)
    local player = TakennCS.GetPlayer(source)
    if player and player.character then
        local jobData = {
            name = player.character.job or 'unemployed',
            grade = player.character.job_grade or 0,
            label = TakennCS.GetJobLabel(player.character.job, player.character.job_grade),
            gradeLabel = TakennCS.GetJobGrade(player.character.job, player.character.job_grade).label,
            salary = TakennCS.GetJobSalary(player.character.job, player.character.job_grade)
        }
        cb(jobData)
    else
        cb(nil)
    end
end)

TakennCS.RegisterCallback('takenncs:isPlayerBoss', function(source, cb)
    local player = TakennCS.GetPlayer(source)
    if player and player.character then
        cb(IsPlayerBoss(source, player.character.job, player.character.job_grade))
    else
        cb(false)
    end
end)

print('[takenncs-fw] Server callbacks loaded')