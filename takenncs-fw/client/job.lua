local Core = exports['takenncs-fw']:GetCoreObject()
local currentJob = nil
local currentGrade = 0

print('[takenncs-fw] Client job module loaded')

RegisterNetEvent('takenncs:jobUpdated')
AddEventHandler('takenncs:jobUpdated', function(job, grade)
    currentJob = job
    currentGrade = grade
    
    TriggerEvent('takenncs:client:jobUpdated', job, grade)
    
    if Config.Debug then
        print(('[takenncs-fw] Job updated to: %s (grade %d)'):format(job, grade))
    end
end)

RegisterCommand('job', function()
    local character = exports['takenncs-fw']:GetCurrentCharacter()
    if character then
        TriggerServerCallback('takenncs:getPlayerJob', function(jobData)
            if jobData then
                lib.alertDialog({
                    header = '💼 Töö info',
                    content = string.format(
                        'Töö: %s\nAste: %s\nPalk: $%d',
                        jobData.label,
                        jobData.gradeLabel,
                        jobData.salary
                    ),
                    centered = true
                })
            end
        end, character.id)
    else
        exports.ox_lib:notify({
            title = Config.FrameworkName,
            description = '❌ Sul pole karakterit laetud',
            type = 'error'
        })
    end
end, false)

RegisterCommand('setjob', function(source, args)
    if #args < 2 then
        exports.ox_lib:notify({
            title = Config.FrameworkName,
            description = 'Kasutus: /setjob [mängija ID] [töö] [aste]',
            type = 'inform'
        })
        return
    end
    
    local targetId = tonumber(args[1])
    local job = args[2]
    local grade = tonumber(args[3]) or 0
    
    if not targetId then
        exports.ox_lib:notify({
            title = Config.FrameworkName,
            description = '❌ Vigane mängija ID',
            type = 'error'
        })
        return
    end
    
    TriggerServerCallback('takenncs:setJob', function(result)
        if result and result.success then
            exports.ox_lib:notify({
                title = Config.FrameworkName,
                description = '✅ Töö muudetud!',
                type = 'success'
            })
        else
            exports.ox_lib:notify({
                title = Config.FrameworkName,
                description = '❌ ' .. (result and result.error or 'Viga'),
                type = 'error'
            })
        end
    end, targetId, job, grade)
end, false)

exports('GetCurrentJob', function()
    return currentJob
end)

exports('GetCurrentGrade', function()
    return currentGrade
end)