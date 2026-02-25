local gecerliarac = 0
local sabitAktif, kemerAktif = false, false
local playerPed = nil
local inair = 0

local aracbilgileri = {
    kemervarmi = false,
    sabitlemevarmi = false,
    aracgecerlirpm = 0.0,
    gecerlihiz = 0.0,
    sabithiz = 0.0,
    prevVelocity = {x = 0.0, y = 0.0, z = 0.0},
}

-- Siin saad soovi korral Configis ka muuta, aga panen otse koodi sisse
local KEMER_TUSU = 0x5A -- Z klahv (Controls.Inputs['Z'] = 0x5A)

Citizen.CreateThread(function()
    while true do
        if gecerliarac ~= 0 then
            SendNUIMessage({
                message = 'aracupdate',
                arachiz = math.floor(aracbilgileri['gecerlihiz'] * 3.6),
                aracrpm = aracbilgileri['aracgecerlirpm'],
                aracbenzin = math.floor(GetVehicleFuelLevel(gecerliarac))
            })
        end

        Citizen.Wait(gecerliarac == 0 and 500 or 60)
    end
end)

Citizen.CreateThread(function()
    while true do
        if gecerliarac ~= 0 then
            -- playerPed = PlayerPedId()  -- parem panna tsüklisse, mitte siia (vt alumine thread)

            if IsControlJustReleased(0, KEMER_TUSU) and aracbilgileri['kemervarmi'] then
                kemerAktif = not kemerAktif

                SendNUIMessage({
                    message = 'kemertetikle',
                    Kemervarmi = aracbilgileri['kemervarmi'],
                    KemerAktif = kemerAktif
                })
            end

            local prevSpeed = aracbilgileri['gecerlihiz']
            aracbilgileri['gecerlihiz'] = GetEntitySpeed(gecerliarac)
            aracbilgileri['aracgecerlirpm'] = GetVehicleCurrentRpm(gecerliarac)

            -- ────────────────────────────────────────────────
            --   TURVAVÖÖ FÜÜSILINE EFEKT ON VÄLJA LÜLITATUD
            --   ainult ikoon töötab edasi
            -- ────────────────────────────────────────────────

            --[[
            if not aracbilgileri['kemervarmi'] or not kemerAktif then
                kemerAktif = false
                local vehIsMovingFwd = GetEntitySpeedVector(gecerliarac, true).y > 1.0
                local vehAcc = (prevSpeed - aracbilgileri['gecerlihiz']) / GetFrameTime()

                if vehIsMovingFwd 
                and prevSpeed > (Config['kemercikartmahizi']/2.237) 
                and vehAcc > (Config['kemeroyuncuatma']*9.81) then
                    
                    local position = GetEntityCoords(playerPed)
                    SetEntityCoords(playerPed, position.x, position.y, position.z - 0.47, true, true, true)
                    SetEntityVelocity(playerPed, aracbilgileri['prevVelocity'].x, aracbilgileri['prevVelocity'].y, aracbilgileri['prevVelocity'].z)
                    Citizen.Wait(1)
                    SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
                else
                    aracbilgileri['prevVelocity'] = GetEntityVelocity(gecerliarac)
                end
            --]]
            -- elseif kemerAktif then
            --     DisableControlAction(0, 75)   -- exit vehicle disabled when belt on
            -- end

            -- cruise control osa jääb samaks
            local isDriver = (GetPedInVehicleSeat(gecerliarac, -1) == playerPed)

            if isDriver then
                if isDriver ~= aracbilgileri['sabitlemevarmi'] then
                    aracbilgileri['sabitlemevarmi'] = isDriver
                    SendNUIMessage({
                        message = 'sabittetikle',
                        Sabitvarmi = aracbilgileri['sabitlemevarmi'],
                        SabitAktif = sabitAktif
                    })
                end

                if IsControlJustReleased(0, Config['sabitlemetusu']) then
                    sabitAktif = not sabitAktif
                    SendNUIMessage({
                        message = 'sabittetikle',
                        Sabitvarmi = isDriver,
                        SabitAktif = sabitAktif
                    })
                    aracbilgileri['sabithiz'] = aracbilgileri['gecerlihiz']
                    cruiseSpeeding = aracbilgileri['sabithiz']
                end

                local maxSpeed = sabitAktif and aracbilgileri['sabithiz'] or GetVehicleHandlingFloat(gecerliarac, "CHandlingData", "fInitialDriveMaxFlatVel")
                SetEntityMaxSpeed(gecerliarac, maxSpeed)

                local roll = GetEntityRoll(gecerliarac)

                if sabitAktif and not IsEntityInAir(gecerliarac) and inair >= 100 and not (roll > 75.0 or roll < -75.0) then
                    if cruiseSpeeding < maxSpeed then
                        cruiseSpeeding = cruiseSpeeding + 0.15
                    end
                    SetVehicleForwardSpeed(gecerliarac, cruiseSpeeding)
                elseif sabitAktif and not IsEntityInAir(gecerliarac) then
                    inair = inair + 1
                    cruiseSpeeding = aracbilgileri['gecerlihiz']
                elseif sabitAktif then
                    inair = 0
                end
            else
                sabitAktif = false
            end
        end

        Citizen.Wait(gecerliarac == 0 and 500 or 5)
    end
end)

function kemerivarmiaracin(class)
    if not class then return false end
    local hasBelt = Config.kemersiniflari[class]
    if not hasBelt or hasBelt == nil then return false end
    return hasBelt
end

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed, false)

        local position = GetEntityCoords(playerPed)
        local heading = Config['Yonler'][math.floor((GetEntityHeading(playerPed) + 45.0) / 90.0)]
        local zoneNameFull = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))

        SendNUIMessage({
            message = 'sokakinfo',
            sokakisim = zoneNameFull,
            sokakyon = heading
        })

        if veh ~= gecerliarac then
            gecerliarac = veh

            SendNUIMessage({
                message = 'arachud',
                hudaktif = veh ~= 0
            })

            if veh == 0 then
                kemerAktif = false
                sabitAktif = false
                aracbilgileri['sabitlemevarmi'] = false
                aracbilgileri['gecerlihiz'] = 0.0

                SendNUIMessage({
                    message = 'sabittetikle',
                    Sabitvarmi = false,
                    SabitAktif = false
                })

                SendNUIMessage({
                    message = 'kemertetikle',
                    Kemervarmi = false,
                    KemerAktif = false
                })
            else
                local vehicleClass = GetVehicleClass(veh)
                aracbilgileri['kemervarmi'] = kemerivarmiaracin(vehicleClass)

                -- saad siia ka kohe kemerAktif sisse lülitada kui tahad auto-sisseistumisel automaatselt panna
                -- kemerAktif = true   ← uncomment kui tahad
                SendNUIMessage({
                    message = 'kemertetikle',
                    Kemervarmi = aracbilgileri['kemervarmi'],
                    KemerAktif = kemerAktif
                })
            end
        end

        Citizen.Wait(800) -- 1000 → 800, pisut kiirem reageerimine
    end
end)

-- SCREEN POSITION – alla vasakule (bottom-left)
-- SCREEN POSITION – alla vasakule (bottom-left)
local screenPosX = 0.195 -- vasak serv, väike vahe
local screenPosY = 0.95 -- alt veidi üles, et jääks ruumi

-- Värv tekstile (valge)
local textColor = {255, 255, 255, 255}  -- lisa alpha 255 kindluse mõttes

-- Suundade tabel (muutmata)
local directions = {
    [0] = 'N', [1] = 'NW', [2] = 'W', [3] = 'SW',
    [4] = 'S', [5] = 'SE', [6] = 'E', [7] = 'NE', [8] = 'N'
}

-- Tsoonide tabel (lisa rohkem kui tahad)
local zones = {
    ['KOREAT'] = "Little Seoul",
    ['ROCKF'] = "Rockford Hills",
    ['AIRP'] = "Los Santos International Airport",
    ['ZP_ORT'] = "Port of South Los Santos",
    ['ZQ_UAR'] = "Davis Quartz",
    -- lisa vajadusel rohkem, nt:
    -- ['BANHAMC'] = "Banham Canyon Dr",
}

-- Kompassi thread
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        if IsPedInAnyVehicle(playerPed, false) then
            local position = GetEntityCoords(playerPed)

            -- Suund (heading)
            local heading = GetEntityHeading(playerPed)
            local dirIndex = math.floor((heading + 22.5) / 45.0) % 8  -- %8 väldib üleindeksit
            local headingText = directions[dirIndex] or "?"

            -- Tänav (OLULINE: hash → string!)
            local streetHash, crossingHash = GetStreetNameAtCoord(position.x, position.y, position.z)
            local streetName = GetStreetNameFromHashKey(streetHash) or ""
            local crossingName = GetStreetNameFromHashKey(crossingHash) or ""

            -- Tsoon
            local zoneHash = GetNameOfZone(position.x, position.y, position.z)
            local zoneName = zones[zoneHash] or zoneHash or ""  -- fallback lühendile

            -- Koosta tekst (nt: N | South Rockford Dr | Little Seoul)
            local fullText = headingText
            if streetName ~= "" then
                fullText = fullText .. " | " .. streetName
            end
            if crossingName ~= "" and crossingName ~= streetName then
                fullText = fullText .. " / " .. crossingName
            end
            if zoneName ~= "" then
                fullText = fullText .. " | " .. zoneName
            end

            -- Joonista (kasuta lihtsamat ja kindlat drawTxt)
            drawTxt(fullText, 4, textColor, 0.40, screenPosX, screenPosY)
        end

        Citizen.Wait(IsPedInAnyVehicle(playerPed, false) and 0 or 500)
    end
end)

-- Parandatud drawTxt (eemaldatud topelt DropShadow, lihtsam outline)
function drawTxt(text, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(colour[1], colour[2], colour[3], colour[4] or 255)
    SetTextEntry("STRING")
    SetTextCentre(false)           -- vasak joondus
    SetTextOutline()               -- must ääris (kõige olulisem nähtavuseks)
    AddTextComponentString(text)
    DrawText(x, y)
end


-- REALISTLIKUM KIIRENDUS – autod ei lähe enam kohe top speedini
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)  -- iga frame, et väärtus püsiks

        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)

        if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
            -- ────────────────────────────────────────────────
            -- Seaded – kohanda neid vastavalt soovile
            -- ────────────────────────────────────────────────
            local torqueMult   = 0.45   -- 0.3–0.6 vahemik: väiksem = aeglasem algkiirendus (rohkem "tõmmet" madalal)
            local powerMult    = 0.70   -- 0.5–1.0 vahemik: väiksem = üldiselt aeglasem, top speedi jõudmine võtab kauem
            local maxSpeedKmh  = nil    -- kui tahad top speedi piirata, pane nt 180 (km/h), muidu nil

            -- Rakenda multiplier'id
            SetVehicleEngineTorqueMultiplier(vehicle, torqueMult)
            SetVehicleEnginePowerMultiplier(vehicle, powerMult)

            -- Valikuline: top speedi piirang (kui multiplier'idest ei piisa)
            if maxSpeedKmh then
                local maxSpeedMs = maxSpeedKmh / 3.6
                SetVehicleMaxSpeed(vehicle, maxSpeedMs)
            end
        end
    end
end)