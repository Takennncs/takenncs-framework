if not TakennCS or not TakennCS.RegisterCallback then
    error('[takenncs-fw] RegisterCallback missing! Load order broken.')
end

print('[takenncs-fw] Characters module loading...')

CreateThread(function()
    Wait(1000)
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `characters` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(50) NOT NULL,
            `firstname` VARCHAR(50) NOT NULL,
            `lastname` VARCHAR(50) NOT NULL,
            `dob` DATE NOT NULL,
            `sex` VARCHAR(10) DEFAULT 'male',
            `height` INT(11) DEFAULT 180,
            `job` VARCHAR(50) DEFAULT 'unemployed',
            `job_grade` INT(11) DEFAULT 0,
            `money` INT(11) DEFAULT 5000,
            `bank` INT(100) DEFAULT 10000,
            `appearance` LONGTEXT DEFAULT NULL,
            `last_x` FLOAT DEFAULT NULL,
            `last_y` FLOAT DEFAULT NULL,
            `last_z` FLOAT DEFAULT NULL,
            `last_h` FLOAT DEFAULT NULL,
            `hunger` INT(11) DEFAULT 100,
            `thirst` INT(11) DEFAULT 100,
            `stress` INT(11) DEFAULT 0,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function(result)
        if Config.Debug then
            print('[takenncs-fw] Characters table ready')
        end
    end)
    
    MySQL.query([[ 
        ALTER TABLE `characters` 
        ADD COLUMN IF NOT EXISTS `citizenid` VARCHAR(50) DEFAULT NULL;
    ]], {}, function()
        if Config.Debug then
            print('[takenncs-fw] Ensured citizenid column exists')
        end
    end)
    
    MySQL.query([[ 
        ALTER TABLE `characters` 
        ADD COLUMN IF NOT EXISTS `onDuty` TINYINT(1) DEFAULT 0;
    ]], {}, function()
        if Config.Debug then
            print('[takenncs-fw] Ensured onDuty column exists')
        end
    end)
end)

TakennCS.RegisterCallback('takenncs:getCharacters', function(source, cb)
    local identifier = GetPlayerIdentifier(source, 0)
    MySQL.query(
        'SELECT id, citizenid, firstname, lastname, dob, sex, height, job, job_grade, money, bank FROM characters WHERE identifier = ? ORDER BY created_at DESC LIMIT ?',
        { identifier, Config.MaxCharacters },
        function(result)
            cb(result or {})
        end
    )
end)

RegisterNetEvent('takenncs:loadCharacter')
AddEventHandler('takenncs:loadCharacter', function(characterId)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    MySQL.single('SELECT * FROM characters WHERE id=? AND identifier=?', {characterId, identifier}, function(character)
        if character then
            local isNewCharacter = false
            if not character.appearance or character.appearance == '' or character.appearance == 'null' then
                isNewCharacter = true
            end
            
            character.isNewCharacter = isNewCharacter
            
            TakennCS.Players[src] = {
                source = src,
                identifier = identifier,
                character = character,
                name = character.firstname..' '..character.lastname,
                job = character.job or Config.StartingJob,
                job_grade = character.job_grade or 0,
                money = character.money or Config.Character.StartingMoney,
                bank = character.bank or Config.Character.StartingBank,
                metadata = {
                    hunger = character.hunger or 100,
                    thirst = character.thirst or 100,
                    stress = character.stress or 0
                }
            }
            
            TriggerEvent('takenncs:serverCharacterLoaded', src, character)
            
            TriggerClientEvent('takenncs:characterLoaded', src, character, vector4(
                character.last_x or Config.Client.DefaultSpawn.x,
                character.last_y or Config.Client.DefaultSpawn.y,
                character.last_z or Config.Client.DefaultSpawn.z,
                character.last_h or Config.Client.DefaultSpawn.w
            ), isNewCharacter)
        else
            TriggerClientEvent('takenncs:showNotification', src, 'Karakterit ei leitud')
        end
    end)
end)

RegisterNetEvent('takenncs:playerSpawned')
AddEventHandler('takenncs:playerSpawned', function(characterId, x, y, z, h)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)
    
    if not characterId or not x or not y or not z then
        if Config.Debug then
            print('[takenncs-fw] Invalid spawn data received')
        end
        return
    end
    
    if x == 0.0 and y == 0.0 and z == 0.0 then
        if Config.Debug then
            print('[takenncs-fw] WARNING: Trying to save invalid spawn location (0,0,0)')
        end
        return
    end
    
    MySQL.update(
        'UPDATE characters SET last_x = ?, last_y = ?, last_z = ?, last_h = ? WHERE id = ? AND identifier = ?',
        { x, y, z, h or 0.0, characterId, identifier },
        function(affectedRows)
            if affectedRows > 0 then
                if Config.Debug then
                    print(('[takenncs-fw] Last location saved for character %s: %.2f, %.2f, %.2f (heading: %.2f)'):format(
                        characterId, x, y, z, h or 0.0
                    ))
                end
            else
                if Config.Debug then
                    print(('[takenncs-fw] WARNING: Failed to save location for character %s'):format(characterId))
                end
            end
        end
    )
end)

RegisterNetEvent('takenncs:characterSelected')
AddEventHandler('takenncs:characterSelected', function(characterId)
    local src = source
    
    local identifier = GetPlayerIdentifier(src, 0)
    MySQL.single('SELECT * FROM characters WHERE id=? AND identifier=?', {characterId, identifier}, function(character)
        if character then
            local isNewCharacter = false
            if not character.appearance or character.appearance == '' or character.appearance == 'null' then
                isNewCharacter = true
            end
            
            character.isNewCharacter = isNewCharacter
            
            TakennCS.Players[src] = {
                source = src,
                identifier = identifier,
                character = character,
                name = character.firstname..' '..character.lastname,
                job = character.job or Config.StartingJob,
                job_grade = character.job_grade or 0,
                money = character.money or Config.Character.StartingMoney,
                bank = character.bank or Config.Character.StartingBank,
                metadata = {
                    hunger = character.hunger or 100,
                    thirst = character.thirst or 100,
                    stress = character.stress or 0
                }
            }
            
            TriggerEvent('takenncs:serverCharacterLoaded', src, character)
            
            TriggerClientEvent('takenncs:characterLoaded', src, character, vector4(
                character.last_x or Config.Client.DefaultSpawn.x,
                character.last_y or Config.Client.DefaultSpawn.y,
                character.last_z or Config.Client.DefaultSpawn.z,
                character.last_h or Config.Client.DefaultSpawn.w
            ), isNewCharacter)
        else
            TriggerClientEvent('takenncs:showNotification', src, 'Karakterit ei leitud')
        end
    end)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local player = TakennCS.GetPlayer(src)
    
    if player and player.character then
        local ped = GetPlayerPed(src)
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            if coords.x ~= 0.0 and coords.y ~= 0.0 and coords.z ~= 0.0 then
                MySQL.update(
                    'UPDATE characters SET last_x = ?, last_y = ?, last_z = ?, last_h = ? WHERE id = ? AND identifier = ?',
                    { coords.x, coords.y, coords.z, heading, player.character.id, player.identifier },
                    function(affectedRows)
                        if affectedRows > 0 and Config.Debug then
                            print(('[takenncs-fw] Last location saved on disconnect for %s: %.2f, %.2f, %.2f'):format(
                                player.name, coords.x, coords.y, coords.z
                            ))
                        end
                    end
                )
            elseif Config.Debug then
                print(('[takenncs-fw] Skipping location save for %s - position is 0,0,0'):format(player.name))
            end
        end
    end
end)

TakennCS.RegisterCallback('takenncs:createCharacter', function(source, cb, data)
    
    ensureUniqueCitizenId(tonumber(identifier:match('%d+')) or 0, function(citizenid)
        MySQL.insert(
            [[
                INSERT INTO characters (
                    identifier, citizenid, firstname, lastname, dob, sex, height, 
                    job, job_grade, money, bank, last_x, last_y, last_z, last_h,
                    hunger, thirst, stress
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ]],
            {
                identifier,
                citizenid,
                data.firstname,
                data.lastname,
                data.dob,
                data.gender,
                data.height or Config.Character.DefaultHeight,
                Config.StartingJob,
                0,
                Config.Character.StartingMoney,
                Config.Character.StartingBank,
                Config.Client.DefaultSpawn.x,
                Config.Client.DefaultSpawn.y,
                Config.Client.DefaultSpawn.z,
                Config.Client.DefaultSpawn.w,
                100, 100, 0
            },
            function(insertId)
                if insertId then
                    if Config.Debug then
                        print(('[takenncs-fw] Character created with ID: %s (citizenid: %s)'):format(insertId, citizenid))
                    end
                    
                    Citizen.CreateThread(function()
                        Wait(1000)
                        
                        local moneyResult = exports.ox_inventory:AddItem(source, 'money', 1200)
                        local phoneResult = exports.ox_inventory:AddItem(source, 'phone', 1)
                        local lockpickResult = exports.ox_inventory:AddItem(source, 'lockpick', 1)
                        local idcardResult = exports.ox_inventory:AddItem(source, 'id_card', 1)
                        
                        print(('[takenncs-fw] Items given - money: %s, phone: %s, lockpick: %s'):format(
                            tostring(moneyResult), tostring(phoneResult), tostring(lockpickResult)
                        ))
                        
                    end)
                    
                    cb({ 
                        success = true,
                        characterId = insertId,
                        citizenid = citizenid,
                        isNewCharacter = true
                    })
                else
                    cb({ success = false, error = 'Andmebaasi viga' })
                end
            end
        )
    end)
end)

TakennCS.RegisterCallback('takenncs:createCharacter', function(source, cb, data)
    if Config.Debug then
        print('[takenncs-fw] Creating character for source ' .. source)
        print('[takenncs-fw] Character data: ' .. json.encode(data))
    end
    
    local identifier = GetPlayerIdentifier(source, 0)
    
    if not identifier then
        identifier = GetPlayerIdentifier(source, 1)
    end
    
    if not identifier then
        for i = 0, 5 do
            local id = GetPlayerIdentifier(source, i)
            if id and string.find(id, 'license:') then
                identifier = id
                break
            end
        end
    end
    
    if not identifier then
        for i = 0, 5 do
            local id = GetPlayerIdentifier(source, i)
            if id and string.find(id, 'steam:') then
                identifier = id
                break
            end
        end
    end
    
    if not identifier then
        if Config.Debug then
            print('[takenncs-fw] ERROR: No identifier found for source ' .. source)

            for i = 0, 10 do
                local id = GetPlayerIdentifier(source, i)
                if id then
                    print(('  identifier[%d]: %s'):format(i, id))
                end
            end
        end
        cb({ success = false, error = 'Identifikaatorit ei leitud' })
        return
    end
    
    if not data.firstname or not data.lastname or not data.dob or not data.gender then
        cb({ success = false, error = 'Puuduvad vajalikud andmed' })
        return
    end
    
    MySQL.scalar('SELECT COUNT(*) FROM characters WHERE identifier = ?', { identifier }, function(count)
        if count >= Config.MaxCharacters then
            cb({ success = false, error = 'Liiga palju karaktereid' })
            return
        end

        local function generateCitizenId(seed)
            local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
            local len = 8
            math.randomseed(os.time() + (seed or 0))
            local id = ''
            for i = 1, len do
                local rand = math.random(1, #charset)
                id = id .. string.sub(charset, rand, rand)
            end
            return id
        end

        local function ensureUniqueCitizenId(seed, cbUnique)
            local newId = generateCitizenId(seed)
            MySQL.scalar('SELECT COUNT(*) FROM characters WHERE citizenid = ?', { newId }, function(count2)
                if tonumber(count2) > 0 then
                    ensureUniqueCitizenId(seed + 1, cbUnique)
                else
                    cbUnique(newId)
                end
            end)
        end

        ensureUniqueCitizenId(tonumber(identifier:match('%d+')) or 0, function(citizenid)
            MySQL.insert(
                [[
                    INSERT INTO characters (
                        identifier, citizenid, firstname, lastname, dob, sex, height, 
                        job, job_grade, money, bank, last_x, last_y, last_z, last_h,
                        hunger, thirst, stress
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ]],
                {
                    identifier,
                    citizenid,
                    data.firstname,
                    data.lastname,
                    data.dob,
                    data.gender,
                    data.height or Config.Character.DefaultHeight,
                    Config.StartingJob,
                    0,
                    Config.Character.StartingMoney,
                    Config.Character.StartingBank,
                    Config.Client.DefaultSpawn.x,
                    Config.Client.DefaultSpawn.y,
                    Config.Client.DefaultSpawn.z,
                    Config.Client.DefaultSpawn.w,
                    100, 100, 0
                },
                function(insertId)
                    if insertId then
                        if Config.Debug then
                            print(('[takenncs-fw] Character created with ID: %s (citizenid: %s)'):format(insertId, citizenid))
                        end
                        
                        Citizen.CreateThread(function()
                            Wait(1000)
                            
                            if exports.ox_inventory then
                                local moneyGiven = exports.ox_inventory:AddItem(source, 'money', 1200)
                                local phoneGiven = exports.ox_inventory:AddItem(source, 'phone', 1)
                                local lockpickGiven = exports.ox_inventory:AddItem(source, 'lockpick', 1)
                                local idcardResult = exports.ox_inventory:AddItem(source, 'id_card', 1)
                                
                                print(('[takenncs-fw] Items given - money: %s, phone: %s, lockpick: %s, id_card: %s'):format(
                                    tostring(moneyGiven), tostring(phoneGiven), tostring(lockpickGiven), tostring(idcardResult)
                                ))
                                
                                if moneyGiven and phoneGiven and lockpickGiven then
                                else
                                    TriggerClientEvent('takenncs:showNotification', source, '⚠️ Esemete andmisel tekkis viga', 'error')
                                end
                            else
                                print('[takenncs-fw] ERROR: ox_inventory not available')
                            end
                        end)
                        
                        cb({ 
                            success = true,
                            characterId = insertId,
                            citizenid = citizenid,
                            isNewCharacter = true
                        })
                    else
                        cb({ success = false, error = 'Andmebaasi viga' })
                    end
                end
            )
        end)
    end)
end)

print('[takenncs-fw] Characters module loaded')