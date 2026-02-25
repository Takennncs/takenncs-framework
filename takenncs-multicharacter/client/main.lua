local Core = nil
local inCharSelect = false
local multicharCam = nil
local selectedCharacter = 1
local totalCharacters = 0
local ableToCreate = false
local characterSpawns = {}
local callbackListeners = {}
local nuiReady = false
local pendingNuiMessage = nil

local function SendUI(msg)
    if nuiReady then
        SendNUIMessage(msg)
    else
        print('[takenncs-multicharacter] NUI not ready yet, queuing message')
        pendingNuiMessage = msg
    end
end

RegisterNUICallback('ready', function(data, cb)
    print('[takenncs-multicharacter] NUI ready')
    nuiReady = true
    if pendingNuiMessage then
        SetNuiFocus(true, true)
        SendNUIMessage(pendingNuiMessage)
        pendingNuiMessage = nil
    end
    cb('ok')
end)

CreateThread(function()
    local attempts = 0
    while not Core do
        Core = exports['takenncs-fw']:GetCoreObject()
        if not Core then
            Wait(100)
            attempts = attempts + 1
            if attempts > 50 then
                print('[takenncs-multicharacter] ERROR: Cannot find takenncs-fw core!')
                return
            end
        end
    end
    print('[takenncs-multicharacter] Framework connected')
    
    characterSpawns = Config.Multichar.SpawnLocations
end)

function TriggerServerCallback(name, cb, ...)
    TriggerServerEvent('takenncs:serverCallback', name, ...)
    
    local eventName = 'takenncs:clientCallback:' .. name
    
    if callbackListeners[eventName] then
        RemoveEventHandler(callbackListeners[eventName])
    end
    
    callbackListeners[eventName] = AddEventHandler(eventName, function(...)
        if cb then
            cb(...)
        end
        RemoveEventHandler(callbackListeners[eventName])
        callbackListeners[eventName] = nil
    end)
end

function CreateMulticharCamera()
    local camPos = Config.Multichar.CameraPosition
    local camRot = Config.Multichar.CameraRotation
    
    if multicharCam and DoesCamExist(multicharCam) then
        DestroyCam(multicharCam, false)
        multicharCam = nil
    end
    
    multicharCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(multicharCam, camPos.x, camPos.y, camPos.z)
    SetCamRot(multicharCam, camRot.x, camRot.y, camRot.z, 2)
    SetCamActive(multicharCam, true)
    RenderScriptCams(true, false, 0, true, true)
    
    if Config.Debug then
        print(('[takenncs-multicharacter] Multichar camera created at: %.2f, %.2f, %.2f'):format(camPos.x, camPos.y, camPos.z))
    end
    
    return multicharCam
end

function DestroyMulticharCamera()
    if multicharCam and DoesCamExist(multicharCam) then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(multicharCam, false)
        multicharCam = nil
    end
end

local function requestModel(modelHash, cb)
    modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

    if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
        RequestModel(modelHash)

        while not HasModelLoaded(modelHash) do
            Wait(0)
        end
    end

    if cb then cb() end
end

local function setPedAppearance(ped, character)
    if character.sex == 'male' then
        SetPedComponentVariation(ped, 0, 0, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    else
        SetPedComponentVariation(ped, 0, 0, 0, 0)
        SetPedComponentVariation(ped, 1, 0, 0, 0)
        SetPedComponentVariation(ped, 2, 0, 0, 0)
        SetPedComponentVariation(ped, 3, 0, 0, 0)
        SetPedComponentVariation(ped, 4, 0, 0, 0)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        SetPedComponentVariation(ped, 6, 0, 0, 0)
        SetPedComponentVariation(ped, 7, 0, 0, 0)
        SetPedComponentVariation(ped, 8, 0, 0, 0)
        SetPedComponentVariation(ped, 9, 0, 0, 0)
        SetPedComponentVariation(ped, 10, 0, 0, 0)
        SetPedComponentVariation(ped, 11, 0, 0, 0)
    end
end

function LoadCharacters()
    if inCharSelect then return end
    
    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()
    
    local character = exports['takenncs-fw']:GetCurrentCharacter()
    if character then
        print('[takenncs-multicharacter] Player already has character loaded, skipping selection')
        return
    end
    
    inCharSelect = true
    
    if Config.Debug then
        print('[takenncs-multicharacter] Loading characters...')
    end
    
    local playerPed = PlayerPedId()
    
    SetEntityVisible(playerPed, false, false)
    FreezeEntityPosition(playerPed, true)
    SetEntityCollision(playerPed, false, false)
    DisplayRadar(false)
    DisplayHud(false)
    
    local camPos = Config.Multichar.CameraPosition
    SetEntityCoords(playerPed, camPos.x, camPos.y - 5.0, camPos.z, false, false, false, false)
    
    CreateMulticharCamera()
    
    TriggerServerCallback('takenncs:getCharacters', function(characters)
        if not characters then characters = {} end
        
        totalCharacters = #characters
        ableToCreate = totalCharacters < Config.Multichar.MaxCharacters
        
        for k, v in pairs(characterSpawns) do
            if v.ped and v.ped ~= 0 then
                DeleteEntity(v.ped)
                v.ped = 0
            end
        end
        
        for i = 1, #characters do
            local char = characters[i]
            local spawnData = characterSpawns[i]
            
            if spawnData then
                spawnData.data = {
                    id = char.id,
                    citizenid = char.id,
                    name = char.firstname .. ' ' .. char.lastname,
                    firstname = char.firstname,
                    lastname = char.lastname,
                    sex = char.sex,
                    dob = char.dob,
                    height = char.height,
                    job = char.job or 'Töötu',
                    disabled = false,
                    locked = false
                }
                
                local model = (char.sex == 'male') and `mp_m_freemode_01` or `mp_f_freemode_01`
                
                requestModel(model, function()
                    spawnData.ped = CreatePed(4, model, spawnData.pos.x, spawnData.pos.y, spawnData.pos.z - 1.0, spawnData.pos.w, false, false)
                    SetEntityHeading(spawnData.ped, spawnData.pos.w)
                    setPedAppearance(spawnData.ped, char)
                    FreezeEntityPosition(spawnData.ped, true)
                    SetEntityInvincible(spawnData.ped, true)
                    SetEntityAlpha(spawnData.ped, 130, false)
                    
                    local tag = CreateFakeMpGamerTag(spawnData.ped, spawnData.data.name, false, false, '', 0)
                    SetMpGamerTagVisibility(tag, 0, true)
                    SetMpGamerTagAlpha(tag, 0, 255)
                    SetMpGamerTagColour(tag, 0, 0)
                end)
            end
        end
        
        for i = #characters + 1, Config.Multichar.MaxCharacters do
            local spawnData = characterSpawns[i]
            if spawnData then
                spawnData.data = {
                    id = nil,
                    citizenid = nil,
                    name = 'Vaba Koht',
                    firstname = '',
                    lastname = '',
                    sex = 'male',
                    disabled = false,
                    locked = false
                }
                
                local model = `mp_m_freemode_01`
                requestModel(model, function()
                    spawnData.ped = CreatePed(4, model, spawnData.pos.x, spawnData.pos.y, spawnData.pos.z - 1.0, spawnData.pos.w, false, false)
                    SetEntityHeading(spawnData.ped, spawnData.pos.w)
                    FreezeEntityPosition(spawnData.ped, true)
                    SetEntityInvincible(spawnData.ped, true)
                    SetEntityAlpha(spawnData.ped, 130, false)
                end)
            end
        end
        
        selectedCharacter = 1
        if characterSpawns[1] and characterSpawns[1].ped then
            SetEntityAlpha(characterSpawns[1].ped, 255, false)
        end
        
        SetNuiFocus(true, true)
        SendUI({
            action = 'update',
            character = characterSpawns[selectedCharacter],
            totalCharacters = totalCharacters,
            maxCharacters = Config.Multichar.MaxCharacters,
            canCreate = ableToCreate
        })
        
        DoScreenFadeIn(1000)
    end)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    DestroyMulticharCamera()
    
    for k, v in pairs(characterSpawns) do
        if v.ped and v.ped ~= 0 then
            DeleteEntity(v.ped)
            v.ped = 0
        end
    end
    
    inCharSelect = false
    cb('ok')
end)

RegisterNUICallback('left', function(data, cb)
    if inCharSelect then
        local newNumber = selectedCharacter - 1
        
        if newNumber >= 1 then
            if characterSpawns[selectedCharacter] and characterSpawns[selectedCharacter].ped then
                SetEntityAlpha(characterSpawns[selectedCharacter].ped, 130, false)
            end
            
            selectedCharacter = newNumber
            
            if characterSpawns[selectedCharacter] and characterSpawns[selectedCharacter].ped then
                SetEntityAlpha(characterSpawns[selectedCharacter].ped, 255, false)
            end
            
            SendUI({
                action = 'update',
                character = characterSpawns[selectedCharacter],
                totalCharacters = totalCharacters,
                maxCharacters = Config.Multichar.MaxCharacters,
                canCreate = ableToCreate
            })
        end
    end
    cb('ok')
end)

RegisterNUICallback('right', function(data, cb)
    if inCharSelect then
        local newNumber = selectedCharacter + 1
        
        if newNumber <= Config.Multichar.MaxCharacters then
            if characterSpawns[selectedCharacter] and characterSpawns[selectedCharacter].ped then
                SetEntityAlpha(characterSpawns[selectedCharacter].ped, 130, false)
            end
            
            selectedCharacter = newNumber
            
            if characterSpawns[selectedCharacter] and characterSpawns[selectedCharacter].ped then
                SetEntityAlpha(characterSpawns[selectedCharacter].ped, 255, false)
            end
            
            SendUI({
                action = 'update',
                character = characterSpawns[selectedCharacter],
                totalCharacters = totalCharacters,
                maxCharacters = Config.Multichar.MaxCharacters,
                canCreate = ableToCreate
            })
        end
    end
    cb('ok')
end)

RegisterNUICallback('play', function(data, cb)
    if inCharSelect then
        local charData = characterSpawns[selectedCharacter].data
        
        if charData and charData.id then
            SetNuiFocus(false, false)
            SendUI({
                action = 'close'
            })
            
            for k, v in pairs(characterSpawns) do
                if v.ped and v.ped ~= 0 then
                    DeleteEntity(v.ped)
                    v.ped = 0
                end
            end

            TriggerServerEvent('takenncs:loadCharacter', charData.id)
        else
            SendUI({
                action = 'showCreator'
            })
        end
    end
    cb('ok')
end)

-- ========== PARANDATUD CREATE CHARACTER CALLBACK ==========
RegisterNUICallback('createCharacter', function(data, cb)
    print("========== NUI CREATE CHARACTER ==========")
    print("Raw data: " .. json.encode(data))
    
    if not ableToCreate then
        SendUI({
            action = 'error',
            message = 'Liiga palju karaktereid!'
        })
        cb('ok')
        return
    end
    
    -- Parse data if needed
    if type(data) == "string" then
        data = json.decode(data)
    end
    
    local firstname = data.firstname
    local lastname = data.lastname
    local birthdate = data.dob or data.birthdate  -- Support both formats
    local gender = data.gender
    
    print(string.format("Parsed data - First: %s, Last: %s, DOB: %s, Gender: %s", 
        tostring(firstname), tostring(lastname), tostring(birthdate), tostring(gender)))
    
    -- Validation
    if not firstname or #firstname < 2 or #firstname > 20 then
        SendNUIMessage({
            action = 'error',
            message = 'Eesnimi peab olema 2-20 tähemärki pikk!'
        })
        cb('ok')
        return
    end
    
    if not lastname or #lastname < 2 or #lastname > 20 then
        SendNUIMessage({
            action = 'error',
            message = 'Perekonnanimi peab olema 2-20 tähemärki pikk!'
        })
        cb('ok')
        return
    end
    
    if not birthdate or birthdate == '' then
        SendNUIMessage({
            action = 'error',
            message = 'Palun vali sünniaeg!'
        })
        cb('ok')
        return
    end
    
    -- Age validation
    local year = tonumber(string.sub(birthdate, 1, 4))
    local currentYear = 2026
    local age = currentYear - year
    
    if age < Config.Character.MinAge or age > Config.Character.MaxAge then
        SendUI({
            action = 'error',
            message = string.format('Vanus peab olema %d-%d aastat!', Config.Character.MinAge, Config.Character.MaxAge)
        })
        cb('ok')
        return
    end
    
    -- Prepare data for server
    local charData = {
        firstname = firstname,
        lastname = lastname,
        dob = birthdate,
        gender = (gender == 'm' or gender == 'male') and 'male' or 'female',
        height = Config.Character.DefaultHeight
    }
    
    print("Sending to server: " .. json.encode(charData))
    
    -- Use TriggerServerCallback to get response
    TriggerServerCallback('takenncs:createCharacter', function(response)
        print("Server response: " .. json.encode(response))
        
        if response and response.success then
            -- Close creator UI immediately
            SendUI({
                action = 'closeCreator'
            })
            
            -- Instead of reloading characters and waiting for click,
            -- automatically load the new character if we have the ID
            if response.characterId then
                -- Small delay to clean up UI
                Wait(500)
                
                -- Clean up character spawns
                for k, v in pairs(characterSpawns) do
                    if v.ped and v.ped ~= 0 then
                        DeleteEntity(v.ped)
                        v.ped = 0
                    end
                end
                
                -- Load the new character directly
                TriggerServerEvent('takenncs:loadCharacter', response.characterId)
            else
                -- Fallback: refresh character list
                SetNuiFocus(false, false)
                Wait(500)
                LoadCharacters()
            end
        else
            SendUI({
                action = 'error',
                message = (response and response.error) or 'Karakteri loomine ebaõnnestus!'
            })
        end
    end, charData)
    
    cb('ok')
end)

RegisterNUICallback('cancel', function(data, cb)
    SendUI({
        action = 'closeCreator'
    })
    cb('ok')
end)

function LogoutCharacter()
    if not inCharSelect then
        TriggerServerEvent('takenncs:logout')
        
        DisplayRadar(false)
        DisplayHud(false)
        
        DoScreenFadeOut(1000)
        Wait(1000)
        
        local safePos = Config.Multichar.CameraPosition
        SetEntityCoords(PlayerPedId(), safePos.x, safePos.y - 5.0, safePos.z, false, false, false, false)
        
        Wait(500)
        LoadCharacters()
    end
end

RegisterNetEvent('takenncs:characterLoaded')
AddEventHandler('takenncs:characterLoaded', function(character, spawnPos, isNewCharacter)
    if Config.Debug then
        print('[takenncs-multicharacter] Character loaded, closing selection')
    end
    
    if inCharSelect then
        inCharSelect = false
        DestroyMulticharCamera()
        SetNuiFocus(false, false)
        
        SendUI({
            action = 'close'
        })
        
        for k, v in pairs(characterSpawns) do
            if v.ped and v.ped ~= 0 then
                DeleteEntity(v.ped)
                v.ped = 0
            end
        end
        
        DoScreenFadeOut(0)
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('[takenncs-multicharacter] Starting...')
    
    local attempts = 0
    while not Core do
        Core = exports['takenncs-fw']:GetCoreObject()
        Wait(100)
        attempts = attempts + 1
        if attempts > 50 then
            print('[takenncs-multicharacter] ERROR: Framework not found after 5 seconds')
            return
        end
    end
    
    if Config.Multichar.AutoShowOnStart then
        Wait(2000)
        LoadCharacters()
    end
end)

if Config.Multichar.EnableLogoutCommand then
    RegisterCommand('logout', function()
        LogoutCharacter()
    end, false)
    
    RegisterCommand('chars', function()
        LoadCharacters()
    end, false)
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for eventName, handler in pairs(callbackListeners) do
        RemoveEventHandler(handler)
    end
    
    if inCharSelect then
        DestroyMulticharCamera()
        SetNuiFocus(false, false)
        
        SendNUIMessage({
            action = 'close'
        })
    end
end)

exports('ShowCharacterSelection', LoadCharacters)
exports('LogoutCharacter', LogoutCharacter)

print('[takenncs-multicharacter] Loaded successfully')