-- ox_inventory + ammo notify full created by takenncs SERVER 2.0
local ammoCount = 0
local messageLifetime = 2000
local maxMessages = 3
local shotMessages = {}
local previousItems = {}

local weaponCategories = {
PISTOL = {
    "WEAPON_PISTOL",             
    "WEAPON_COMBATPISTOL",   
    "WEAPON_APPISTOL",          
    "WEAPON_PISTOL50",          
    "WEAPON_HEAVYPISTOL",  
    "WEAPON_VINTAGEPISTOL",     
    "WEAPON_SNSPISTOL",        
    "WEAPON_SNSPISTOL_MK2",     
    "WEAPON_REVOLVER_MK2",    
    "WEAPON_HEAVYREVOLVER",      
    "WEAPON_MARKSMANPISTOL",   
    "WEAPON_FLAREGUN",
    "WEAPON_PISTOLXM3",
    "WEAPON_GUSENBERG",             
},
SMG = {
    "WEAPON_MICROSMG",      
    "WEAPON_SMG",            
    "WEAPON_SMG_MK2",          
    "WEAPON_ASSAULTSMG",       
    "WEAPON_COMBATPDW",       
    "WEAPON_MACHINEPISTOL",    
    "WEAPON_MINISMG",
    "WEAPON_TECPISTOL"          
},
RIFLE = {
    "WEAPON_ASSAULTRIFLE",     
    "WEAPON_ASSAULTRIFLE_MK2",    
    "WEAPON_CARBINERIFLE",        
    "WEAPON_CARBINERIFLE_MK2",   
    "WEAPON_ADVANCEDRIFLE",     
    "WEAPON_MG",                 
    "WEAPON_COMBATMG",         
    "WEAPON_COMBATMG_MK2",      
    "WEAPON_COMPACTRIFLE",          
    "WEAPON_SNIPERRIFLE",         
    "WEAPON_HEAVYSNIPER",      
    "WEAPON_HEAVYSNIPER_MK2",    
    "WEAPON_MARKSMANRIFLE",      
    "WEAPON_MARKSMANRIFLE_MK2"    
},
MUSKET = {
    "WEAPON_MUSKET"   
},
REVOLVER = {
    "WEAPON_REVOLVER"   
},
SHOTGUN = {
    "WEAPON_PUMPSHOTGUN",   
    "WEAPON_PUMPSHOTGUN_MK2",   
    "WEAPON_SAWNOFFSHOTGUN",      
    "WEAPON_BULLPUPSHOTGUN",     
    "WEAPON_ASSAULTSHOTGUN",     
    "WEAPON_HEAVYSHOTGUN"         
}
}

local weaponHashes = {}
for category, list in pairs(weaponCategories) do
    for _, weaponName in ipairs(list) do
        weaponHashes[GetHashKey(weaponName)] = category
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
        local ped = PlayerPedId()

        if IsPedArmed(ped, 4) then
            local weapon = GetSelectedPedWeapon(ped)
            local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
            local shotsFired = ammoCount - currentAmmo

            if shotsFired > 0 and weaponHashes[weapon] then
                local category = weaponHashes[weapon]
                local text = ""

                if category == "PISTOL" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " PÜSTOLI PADRUNID") or "-1 PÜSTOLI PADRUNID"
                elseif category == "SMG" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " SMG PADRUNID") or "-1 SMG PADRUNID"
                                    elseif category == "MUSKET" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " JAHIRELVA PADRUNID") or "-1 JAHIRELVA PADRUNID"
                                                        elseif category == "REVOLVER" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " .41 PADRUNID") or "-1 .41 PADRUNID"
                                    elseif category == "SHOTGUN" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " PUMPPÜSSI PADRUNID") or "-1 PUMPPÜSSI PADRUNID"
                elseif category == "RIFLE" then
                    text = shotsFired > 1 and ("-" .. shotsFired .. " AUTOMAADI PADRUNID") or "-1 AUTOMAADI PADRUNID"
                else
                    text = "-" .. shotsFired .. " PADRUNID"
                end

                addNotificationMessage(text)
            end

            ammoCount = currentAmmo
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local items = exports.ox_inventory:Items()
        if not items then goto continue end

        local changes = {}

        for itemName, data in pairs(items) do
            local oldCount = previousItems[itemName] and previousItems[itemName].count or 0
            local diff = data.count - oldCount
            if diff ~= 0 then
                table.insert(changes, {
                    name = itemName,
                    diff = diff,
                    label = data.label or itemName
                })
            end
        end

        for itemName, oldData in pairs(previousItems) do
            if not items[itemName] then
                table.insert(changes, {
                    name = itemName,
                    diff = -oldData.count,
                    label = oldData.label or itemName
                })
            end
        end

        for _, change in ipairs(changes) do
        local diff = tonumber(change.diff) or 0
        local symbol = diff > 0 and "+" or "-"
        local amount = math.floor(math.abs(diff) + 0.5)
        local label = tostring(change.label or "???")
        local text = ("%s%d %s"):format(symbol, amount, label)
        addNotificationMessage(text)


        end

        previousItems = items
        ::continue::
    end
end)

function addNotificationMessage(text)
    if #shotMessages >= maxMessages then
        table.remove(shotMessages, 1)
    end

    table.insert(shotMessages, {
        text = text,
        startTime = GetGameTimer()
    })
end

function DrawShotMessages()
    local x, y = 0.5, 0.035
    local validIndex = 0

    for i = 1, #shotMessages do
        local msg = shotMessages[i]
        if msg then
            local timePassed = GetGameTimer() - msg.startTime
            local alpha = 255 - (timePassed / messageLifetime) * 255

            if alpha <= 0 then
                shotMessages[i] = nil
            else
                validIndex = validIndex + 1
                local yOffset = (validIndex - 1) * 0.022

                SetTextFont(0)
                SetTextScale(0.29, 0.29)
                SetTextColour(255, 255, 255, math.floor(alpha))
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(msg.text)
                DrawText(x, y + yOffset)
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DrawShotMessages()
    end
end)
