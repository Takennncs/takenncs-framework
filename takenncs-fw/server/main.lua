TakennCS.Server = {}

Config.Server.UnemployedPayInterval = Config.Server.UnemployedPayInterval or 60000
Config.Server.EmployedPayInterval = Config.Server.EmployedPayInterval or 60000

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId, 0)
    
    print(('[takenncs-fw] Player connecting: %s (%s)'):format(name, identifier))
    
    if Config.Queue and Config.Queue.Enabled then
        if GetResourceState('takenncs-queue') == 'started' then
            if Config.Debug then
                print('[takenncs-fw] Queue is handling connection')
            end
            return
        else
            if Config.Debug then
                print('^1[takenncs-fw] WARNING: Queue is enabled but takenncs-queue is not started!^0')
            end
        end
    end
    
    deferrals.defer()
    Wait(0)
    deferrals.update('Ühendatakse...')
    Wait(500)
    deferrals.done()
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local player = TakennCS.GetPlayer(playerId)
    
    if player then
        local playerName = GetPlayerName(playerId)
        if player.character and player.character.firstname and player.character.lastname then
            playerName = player.character.firstname .. ' ' .. player.character.lastname
        end
        
        if player.metadata then
            MySQL.update('UPDATE characters SET hunger = ?, thirst = ?, stress = ? WHERE id = ?',
                { player.metadata.hunger or 100, player.metadata.thirst or 100, player.metadata.stress or 0, player.character.id })
        end
        
        print(('[takenncs-fw] Player dropped: %s (Reason: %s)'):format(playerName, reason))
        TakennCS.Players[playerId] = nil
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        
        for src, player in pairs(TakennCS.Players) do
            if player and player.character then
                local job = player.job or Config.StartingJob
                local jobGrade = player.job_grade or 0
                
                if job == 'unemployed' or job == nil then
                    player.lastUnemployedPay = player.lastUnemployedPay or 0
                    
                    if (GetGameTimer() - player.lastUnemployedPay) >= Config.Server.UnemployedPayInterval then
                        local salary = Config.Server.UnemployedSalary
                        
                        player.bank = (player.bank or 0) + salary
                        
                        MySQL.update(
                            'UPDATE characters SET bank = bank + ? WHERE id = ? AND identifier = ?',
                            { salary, player.character.id, player.identifier }
                        )
                        
                        TriggerClientEvent('takenncs:notification', src, 'Palka saadud', 'Saite $' .. salary .. ' panku', 'success', 3000)
                        
                        player.lastUnemployedPay = GetGameTimer()
                        
                        if Config.Debug then
                            print(('[takenncs-fw] Unemployed salary paid to %s: $%d'):format(player.name, salary))
                        end
                    end
                else
                    if TakennCS.Jobs and TakennCS.Jobs[job] and TakennCS.Jobs[job].grades and TakennCS.Jobs[job].grades[jobGrade] then
                        local salary = tonumber(TakennCS.Jobs[job].grades[jobGrade].salary or 0)
                        
                        if salary > 0 then
                            player.lastEmployedPay = player.lastEmployedPay or 0
                            
                            if (GetGameTimer() - player.lastEmployedPay) >= Config.Server.EmployedPayInterval then
                                player.bank = (player.bank or 0) + salary
                                
                                MySQL.update(
                                    'UPDATE characters SET bank = bank + ? WHERE id = ? AND identifier = ?',
                                    { salary, player.character.id, player.identifier }
                                )
                                
                                TriggerClientEvent('takenncs:notification', src, job .. ' Palka', 'Saite $' .. salary .. ' panku', 'success', 3000)
                                
                                player.lastEmployedPay = GetGameTimer()
                                
                                if Config.Debug then
                                    print(('[takenncs-fw] [%s] Salary paid to %s: $%d'):format(job, player.name, salary))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local function initPlayerMetadata(player)
    if not player.metadata then
        player.metadata = {}
    end
    
    MySQL.single('SELECT hunger, thirst, stress FROM characters WHERE id = ?', { player.character.id }, function(result)
        if result then
            player.metadata.hunger = result.hunger or 100
            player.metadata.thirst = result.thirst or 100
            player.metadata.stress = result.stress or 0
        else
            player.metadata.hunger = 100
            player.metadata.thirst = 100
            player.metadata.stress = 0
        end
        
        TriggerClientEvent('hud:client:UpdateNeeds', player.source, player.metadata.hunger, player.metadata.thirst)
        TriggerClientEvent('hud:client:UpdateStress', player.source, player.metadata.stress)
    end)
end

CreateThread(function()
    while true do
        Wait(Config.Server.NeedsUpdateInterval or 60000)
        
        for src, player in pairs(TakennCS.Players) do
            if player and player.metadata then
                player.metadata.hunger = math.max(0, player.metadata.hunger - 2)
                player.metadata.thirst = math.max(0, player.metadata.thirst - 3)
                
                if player.metadata.hunger > 50 and player.metadata.thirst > 50 then
                    player.metadata.stress = math.max(0, player.metadata.stress - 1)
                end
                
                if player.metadata.hunger < 20 or player.metadata.thirst < 20 then
                    player.metadata.stress = math.min(100, player.metadata.stress + 2)
                end
                
                TriggerClientEvent('hud:client:UpdateNeeds', src, player.metadata.hunger, player.metadata.thirst)
                TriggerClientEvent('hud:client:UpdateStress', src, player.metadata.stress)
                
                if math.random(1, 5) == 1 then
                    MySQL.update('UPDATE characters SET hunger = ?, thirst = ?, stress = ? WHERE id = ?',
                        { player.metadata.hunger, player.metadata.thirst, player.metadata.stress, player.character.id })
                end
            end
        end
    end
end)

RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local player = TakennCS.GetPlayer(src)
    
    if not player or not player.metadata then return end
    
    player.metadata.stress = math.min(100, (player.metadata.stress or 0) + amount)
    TriggerClientEvent('hud:client:UpdateStress', src, player.metadata.stress)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    local src = source
    local player = TakennCS.GetPlayer(src)
    
    if not player or not player.metadata then return end
    
    player.metadata.stress = math.max(0, (player.metadata.stress or 0) - amount)
    TriggerClientEvent('hud:client:UpdateStress', src, player.metadata.stress)
end)

RegisterNetEvent('takenncs:client:Eat')
AddEventHandler('takenncs:client:Eat', function(item, hungerAmount)
    local src = source
    local player = TakennCS.GetPlayer(src)
    
    if not player or not player.metadata then return end
    
    player.metadata.hunger = math.min(100, (player.metadata.hunger or 100) + hungerAmount)
    
    player.metadata.stress = math.max(0, (player.metadata.stress or 0) - 5)
    
    TriggerClientEvent('hud:client:UpdateNeeds', src, player.metadata.hunger, player.metadata.thirst)
    TriggerClientEvent('hud:client:UpdateStress', src, player.metadata.stress)
    
    MySQL.update('UPDATE characters SET hunger = ?, stress = ? WHERE id = ?',
        { player.metadata.hunger, player.metadata.stress, player.character.id })
    
    TriggerClientEvent('takenncs:showNotification', src, 'Sa sõid ja tunned end paremini!', 'success')
end)

RegisterNetEvent('takenncs:client:Drink')
AddEventHandler('takenncs:client:Drink', function(item, thirstAmount)
    local src = source
    local player = TakennCS.GetPlayer(src)
    
    if not player or not player.metadata then return end
    
    player.metadata.thirst = math.min(100, (player.metadata.thirst or 100) + thirstAmount)
    
    player.metadata.stress = math.max(0, (player.metadata.stress or 0) - 3)
    
    TriggerClientEvent('hud:client:UpdateNeeds', src, player.metadata.hunger, player.metadata.thirst)
    TriggerClientEvent('hud:client:UpdateStress', src, player.metadata.stress)
    
    MySQL.update('UPDATE characters SET thirst = ?, stress = ? WHERE id = ?',
        { player.metadata.thirst, player.metadata.stress, player.character.id })
    
    TriggerClientEvent('takenncs:showNotification', src, 'Sa jõid ja kustutasid janu!', 'success')
end)

CreateThread(function()
    while true do
        Wait(Config.Server.SaveInterval)
        
        for src, player in pairs(TakennCS.Players) do
            if player and player.character then
                local ped = GetPlayerPed(src)
                if DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local heading = GetEntityHeading(ped)
                    
                    MySQL.update(
                        'UPDATE characters SET last_x = ?, last_y = ?, last_z = ?, last_h = ?, hunger = ?, thirst = ?, stress = ? WHERE id = ? AND identifier = ?',
                        { coords.x, coords.y, coords.z, heading, 
                          player.metadata.hunger or 100, 
                          player.metadata.thirst or 100, 
                          player.metadata.stress or 0,
                          player.character.id, player.identifier },
                        function(affectedRows)
                            if Config.Debug and affectedRows > 0 then
                                print(('[takenncs-fw] Auto-saved location and needs for %s'):format(player.name))
                            end
                        end
                    )
                end
            end
        end
        
        if Config.Debug then
            print(('[takenncs-fw] Autosave tick - Players online: %d'):format(GetNumPlayerIndices()))
        end
    end
end)

print('[takenncs-fw] Server main loaded with needs system')