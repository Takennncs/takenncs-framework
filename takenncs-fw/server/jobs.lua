print('[takenncs-fw] Jobs module loading...')

CreateThread(function()
    Wait(1000)
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `jobs` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `name` varchar(50) NOT NULL UNIQUE,
          `label` varchar(100) NOT NULL,
          `whitelisted` tinyint(1) DEFAULT 0,
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]], {})
    
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `job_grades` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `job_name` varchar(50) NOT NULL,
          `grade` int(11) NOT NULL,
          `name` varchar(100) NOT NULL,
          `label` varchar(100) NOT NULL,
          `salary` int(11) DEFAULT 0,
          `skin_male` longtext,
          `skin_female` longtext,
          PRIMARY KEY (`id`),
          UNIQUE KEY `unique_job_grade` (`job_name`, `grade`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]], {})
    
    if Config.Debug then
        print('[takenncs-fw] Job tables initialized')
    end
    
    Wait(500)
    LoadAllJobs()
end)

function LoadAllJobs()
    MySQL.query('SELECT * FROM jobs', {}, function(jobs)
        TakennCS.Jobs = {}
        
        for _, job in ipairs(jobs) do
            MySQL.query('SELECT * FROM job_grades WHERE job_name = ? ORDER BY grade', {job.name}, function(grades)
                TakennCS.Jobs[job.name] = {
                    label = job.label,
                    whitelisted = job.whitelisted == 1,
                    grades = {}
                }
                
                for _, grade in ipairs(grades) do
                    TakennCS.Jobs[job.name].grades[grade.grade] = {
                        name = grade.name,
                        label = grade.label,
                        salary = grade.salary,
                        skin_male = grade.skin_male,
                        skin_female = grade.skin_female
                    }
                end
                
                if Config.Debug then
                    print(('[takenncs-fw] Loaded job: %s with %d grades'):format(job.name, #grades))
                end
            end)
        end
    end)
end

exports('GetJobs', function()
    return TakennCS.Jobs
end)

function TakennCS.GetJob(jobName)
    return TakennCS.Jobs and TakennCS.Jobs[jobName]
end

function TakennCS.GetJobGrade(jobName, grade)
    if TakennCS.Jobs and TakennCS.Jobs[jobName] and TakennCS.Jobs[jobName].grades then
        return TakennCS.Jobs[jobName].grades[grade]
    end
    return nil
end

function TakennCS.GetPlayerJob(source)
    local player = TakennCS.GetPlayer(source)
    if player and player.character then
        return {
            name = player.character.job or 'unemployed',
            grade = player.character.job_grade or 0,
            label = TakennCS.GetJobLabel(player.character.job, player.character.job_grade),
            salary = TakennCS.GetJobSalary(player.character.job, player.character.job_grade)
        }
    end
    return { name = 'unemployed', grade = 0, label = 'Töötu', salary = 100 }
end

function TakennCS.GetJobLabel(jobName, grade)
    local job = TakennCS.GetJob(jobName)
    if job then
        if grade ~= nil and job.grades[grade] then
            return job.grades[grade].label
        end
        return job.label
    end
    return 'Töötu'
end

function TakennCS.GetJobSalary(jobName, grade)
    local job = TakennCS.GetJob(jobName)
    if job and job.grades[grade] then
        return job.grades[grade].salary
    end
    return 100
end

TakennCS.RegisterCallback('takenncs:setJob', function(source, cb, target, job, grade)
    local player = TakennCS.GetPlayer(source)
    
    if not player or not IsPlayerBoss(source, player.character.job, player.character.job_grade) then
        cb({ success = false, error = 'Pole õigusi' })
        return
    end
    
    local targetPlayer = TakennCS.GetPlayer(target)
    if not targetPlayer then
        cb({ success = false, error = 'Mängijat ei leitud' })
        return
    end
    
    if not TakennCS.GetJob(job) then
        cb({ success = false, error = 'Tööd ei leitud' })
        return
    end
    
    MySQL.update('UPDATE characters SET job = ?, job_grade = ? WHERE id = ? AND identifier = ?',
        { job, grade, targetPlayer.character.id, targetPlayer.identifier },
        function(affectedRows)
            if affectedRows > 0 then
                targetPlayer.character.job = job
                targetPlayer.character.job_grade = grade
                targetPlayer.job = job
                
                TriggerClientEvent('takenncs:jobUpdated', target, job, grade)
                TriggerClientEvent('takenncs:showNotification', target, ('Sinu töö on nüüd: %s'):format(TakennCS.GetJobLabel(job, grade)), 'success')
                
                cb({ success = true })
            else
                cb({ success = false, error = 'Andmebaasi viga' })
            end
        end
    )
end)

TakennCS.RegisterCallback('takenncs:promotePlayer', function(source, cb, target)
    local player = TakennCS.GetPlayer(source)
    local targetPlayer = TakennCS.GetPlayer(target)
    
    if not player or not targetPlayer then
        cb({ success = false, error = 'Mängijat ei leitud' })
        return
    end
    
    if not IsPlayerBoss(source, player.character.job, player.character.job_grade) then
        cb({ success = false, error = 'Pole õigusi' })
        return
    end
    
    local job = TakennCS.GetJob(targetPlayer.character.job)
    if not job then return cb({ success = false, error = 'Tööd ei leitud' }) end
    
    local currentGrade = targetPlayer.character.job_grade
    local nextGrade = currentGrade + 1
    
    if not job.grades[nextGrade] then
        cb({ success = false, error = 'Kõrgeim aste juba saavutatud' })
        return
    end
    
    MySQL.update('UPDATE characters SET job_grade = ? WHERE id = ? AND identifier = ?',
        { nextGrade, targetPlayer.character.id, targetPlayer.identifier },
        function(affectedRows)
            if affectedRows > 0 then
                targetPlayer.character.job_grade = nextGrade
                TriggerClientEvent('takenncs:jobUpdated', target, targetPlayer.character.job, nextGrade)
                TriggerClientEvent('takenncs:showNotification', target, ('Õnnitlused! Sinu uus aste: %s'):format(job.grades[nextGrade].label), 'success')
                cb({ success = true })
            else
                cb({ success = false, error = 'Andmebaasi viga' })
            end
        end
    )
end)

TakennCS.RegisterCallback('takenncs:demotePlayer', function(source, cb, target)
    local player = TakennCS.GetPlayer(source)
    local targetPlayer = TakennCS.GetPlayer(target)
    
    if not player or not targetPlayer then
        cb({ success = false, error = 'Mängijat ei leitud' })
        return
    end
    
    if not IsPlayerBoss(source, player.character.job, player.character.job_grade) then
        cb({ success = false, error = 'Pole õigusi' })
        return
    end
    
    local job = TakennCS.GetJob(targetPlayer.character.job)
    if not job then return cb({ success = false, error = 'Tööd ei leitud' }) end
    
    local currentGrade = targetPlayer.character.job_grade
    local prevGrade = currentGrade - 1
    
    if prevGrade < 0 then
        cb({ success = false, error = 'Madalaim aste juba saavutatud' })
        return
    end
    
    MySQL.update('UPDATE characters SET job_grade = ? WHERE id = ? AND identifier = ?',
        { prevGrade, targetPlayer.character.id, targetPlayer.identifier },
        function(affectedRows)
            if affectedRows > 0 then
                targetPlayer.character.job_grade = prevGrade
                TriggerClientEvent('takenncs:jobUpdated', target, targetPlayer.character.job, prevGrade)
                TriggerClientEvent('takenncs:showNotification', target, ('Sinu uus aste: %s'):format(job.grades[prevGrade].label), 'inform')
                cb({ success = true })
            else
                cb({ success = false, error = 'Andmebaasi viga' })
            end
        end
    )
end)

TakennCS.RegisterCallback('takenncs:firePlayer', function(source, cb, target)
    local player = TakennCS.GetPlayer(source)
    local targetPlayer = TakennCS.GetPlayer(target)
    
    if not player or not targetPlayer then
        cb({ success = false, error = 'Mängijat ei leitud' })
        return
    end
    
    if not IsPlayerBoss(source, player.character.job, player.character.job_grade) then
        cb({ success = false, error = 'Pole õigusi' })
        return
    end
    
    MySQL.update('UPDATE characters SET job = ?, job_grade = ? WHERE id = ? AND identifier = ?',
        { 'unemployed', 0, targetPlayer.character.id, targetPlayer.identifier },
        function(affectedRows)
            if affectedRows > 0 then
                targetPlayer.character.job = 'unemployed'
                targetPlayer.character.job_grade = 0
                targetPlayer.job = 'unemployed'
                
                TriggerClientEvent('takenncs:jobUpdated', target, 'unemployed', 0)
                TriggerClientEvent('takenncs:showNotification', target, 'Sa vallandati!', 'error')
                cb({ success = true })
            else
                cb({ success = false, error = 'Andmebaasi viga' })
            end
        end
    )
end)

TakennCS.RegisterCallback('takenncs:getJobPlayers', function(source, cb, jobName)
    local player = TakennCS.GetPlayer(source)
    
    if not player or player.character.job ~= jobName then
        cb({})
        return
    end
    
    local players = {}
    for src, p in pairs(TakennCS.Players) do
        if p.character and p.character.job == jobName then
            table.insert(players, {
                source = src,
                name = p.name,
                grade = p.character.job_grade,
                gradeLabel = TakennCS.GetJobLabel(jobName, p.character.job_grade)
            })
        end
    end
    
    cb(players)
end)

function IsPlayerBoss(source, jobName, grade)
    if not jobName or jobName == 'unemployed' then return false end
    
    local job = TakennCS.GetJob(jobName)
    if not job then return false end
    
    local highestGrade = 0
    for g, _ in pairs(job.grades) do
        if tonumber(g) > highestGrade then
            highestGrade = tonumber(g)
        end
    end
    
    return grade == highestGrade
end

print('[takenncs-fw] Jobs module loaded')