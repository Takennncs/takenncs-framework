Config = Config or {}  -- See rida peab olema KÕIGE ESIMENE

Config.Garage = Config.Garage or {}

Config.Garage = {
    -- Üldised seaded
    Debug = true,
    UseTarget = true,
    TargetDistance = 2.5,
    
    -- Garaaž
    Garages = {
        {
            id = 1,
            label = 'Kesklinna Garaaž',
            type = 'public',
            vehicle_type = 'car',  -- AUTO
            job = nil,
            ped = {
                model = 'a_m_y_business_01',
                coords = vec4(215.4334, -808.6323, 30.7586, 256.8733),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(215.4334, -808.6323, 30.7586),
            spawn = vec4(215.1553, -787.4595, 30.8380, 157.4077),
            parking = vec3(215.1553, -787.4595, 30.8380),
            camera = vec3(217.800, -795.500, 32.000),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'Kesklinna Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        {
            id = 2,
            label = 'Vespucci Ranna Garaaž',
            type = 'public',
            vehicle_type = 'car',
            job = nil,
            ped = {
                model = 'a_m_y_beach_01',
                coords = vec4(-741.3295, -1309.0985, 4.9997, 52.9527),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(-741.3295, -1309.0985, 4.9997),
            spawn = vec4(-741.3295, -1309.0985, 4.9997, 52.9527),
            parking = vec3(-741.3295, -1309.0985, 4.9997),
            camera = vec3(-745.0, -1300.0, 10.0),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'Vespucci Ranna Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        {
            id = 3,
            label = 'Little Seoul Garaaž',
            type = 'public',
            vehicle_type = 'car',
            job = nil,
            ped = {
                model = 'a_m_y_latino_01',
                coords = vec4(-996.4214, -789.5006, 16.3736, 156.2509),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(-996.4214, -789.5006, 16.3736),
            spawn = vec4(-996.4214, -789.5006, 16.3736, 156.2509),
            parking = vec3(-996.4214, -789.5006, 16.3736),
            camera = vec3(-1000.0, -780.0, 22.0),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'Little Seoul Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        {
            id = 4,
            label = 'Del Perro Garaaž',
            type = 'public',
            vehicle_type = 'car',
            job = nil,
            ped = {
                model = 'a_m_y_beach_02',
                coords = vec4(-1618.5209, -853.4584, 10.0665, 70.5279),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(-1618.5209, -853.4584, 10.0665),
            spawn = vec4(-1618.5209, -853.4584, 10.0665, 70.5279),
            parking = vec3(-1618.5209, -853.4584, 10.0665),
            camera = vec3(-1625.0, -845.0, 15.0),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'Del Perro Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        {
            id = 5,
            label = 'Vinewood Hills Garaaž',
            type = 'public',
            vehicle_type = 'car',
            job = nil,
            ped = {
                model = 'a_m_y_business_02',
                coords = vec4(335.9850, -210.2059, 54.0863, 78.8677),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(335.9850, -210.2059, 54.0863),
            spawn = vec4(335.9850, -210.2059, 54.0863, 78.8677),
            parking = vec3(335.9850, -210.2059, 54.0863),
            camera = vec3(330.0, -205.0, 60.0),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'Vinewood Hills Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        {
            id = 6,
            label = 'La Mesa Garaaž',
            type = 'public',
            vehicle_type = 'car',
            job = nil,
            ped = {
                model = 'a_m_y_mexthug_01',
                coords = vec4(813.4305, -1600.9855, 31.7351, 151.6312),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(813.4305, -1600.9855, 31.7351),
            spawn = vec4(813.4305, -1600.9855, 31.7351, 151.6312),
            parking = vec3(813.4305, -1600.9855, 31.7351),
            camera = vec3(820.0, -1605.0, 37.0),
            blip = {
                enabled = true,
                sprite = 357,
                color = 3,
                scale = 0.8,
                name = 'La Mesa Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 36,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.0, 1.0, 1.0),
                rotate = true
            }
        },
        -- HELIKOPTERITE GARAAŽ
        {
            id = 10,
            label = 'Helikopterite Garaaž',
            type = 'air',  -- Õhusõidukite tüüp
            vehicle_type = 'helicopter',
            job = nil,
            ped = {
                model = 's_m_m_pilot_01',
                coords = vec4(-1282.9950, -3341.8284, 13.9451, 246.9796),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(-1254.6930, -3338.9060, 13.9446),
            spawn = vec4(-1254.6930, -3338.9060, 13.9446, 336.9752),
            parking = vec3(-1254.6930, -3338.9060, 13.9446),
            camera = vec3(-1260.0, -3335.0, 20.0),
            blip = {
                enabled = true,
                sprite = 43,
                color = 3,
                scale = 0.8,
                name = 'Helikopterite Garaaž'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = true,
                type = 43,
                color = {r = 255, g = 200, b = 50, a = 150},
                scale = vec3(1.5, 1.5, 1.5),
                rotate = true
            }
        },
        -- HELIKOPTERITE IMPOUND
        {
            id = 11,
            label = 'Helikopterite Impound',
            type = 'air_impound',
            vehicle_type = 'helicopter',
            job = nil,
            ped = {
                model = 's_m_m_autoshop_01',
                coords = vec4(-1808.3757, -2810.0649, 13.9443, 153.0189),
                scenario = 'WORLD_HUMAN_CLIPBOARD'
            },
            coords = vec3(-1808.3757, -2810.0649, 13.9443),
            spawn = vec4(-1808.3757, -2810.0649, 13.9443, 153.0189),
            parking = vec3(-1808.3757, -2810.0649, 13.9443),
            camera = vec3(-1815.0, -2805.0, 20.0),
            blip = {
                enabled = true,
                sprite = 43,
                color = 1,
                scale = 0.8,
                name = 'Helikopterite Impound'
            },
            marker = { enabled = false },
            parkingMarker = {
                enabled = false
            }
        }
    },
    
    -- Parkimise seaded
    Parking = {
        DeleteVehicleAfterStore = true,
        CheckForPlayersNearby = true,
        StoreDistance = 10.0,
        MaxDistanceFromSpawn = 50.0,
        SaveFuel = true,
        SaveDamage = true,
        SaveMods = true
    },
    
    -- UI seaded
    UI = {
        UseOxLib = true,
        ShowVehicleStats = true,
        StatsToShow = {'fuel', 'damage'},
        ContextMenuId = 'garage_main_menu',
        VehicleMenuId = 'garage_vehicle_menu'
    },
    
    -- Notifikatsioonid
    Notify = {
        UseOx = true,
        Position = 'top-right'
    }
}