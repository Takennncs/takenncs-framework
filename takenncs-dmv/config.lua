Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 6
Config.SpeedMultiplier = 3.6

Config.Price = 250
Config.Vehicle = 'premier'

Config.SpeedLimits = {
    town     = 80,
    country  = 125,
    freeway  = 999
}

Config.Zones = {
    DMVSchool = {
        Pos   = vector3(223.3977, 373.1673, 106.3738),
    },
    VehicleSpawnPoint = {
        Pos   = vector3(214.41, 378.8, 106.7),
    }
}

Config.PedList = {
    	{
		model = "s_f_m_fembarber",
        coords = vector3(223.1281, 373.1038, 106.3780),
		heading = 60.0,
		gender = "female",
	    isRendered = false,
        ped = nil,
    },	
}

Config.CheckPoints = {
    {
        Pos = {x = 199.03904724121, y = 377.93005371094, z = 106.47260284424},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            setCurrentZoneType('town')
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 174.73571777344, y = 368.12017822266, z = 107.80129241943},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 66.753929138184, y = 322.82574462891, z = 110.83164978027},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Anna teed ristuvale liiklusele.', 3000)
            PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
            FreezeEntityPosition(vehicle, true)
            Wait(4000)
            FreezeEntityPosition(vehicle, false)
            DrawMissionText('Kui liiklust pole, võid jätkata.', 3000)
        end
    },
    {
        Pos = {x = 38.728759765625, y = 287.56042480469, z = 108.645652771},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 12.449174880981, y = 269.49111938477, z = 108.2414855957},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -104.28547668457, y = 308.49670410156, z = 106.91606140137},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Vinewood on endiselt asulasisene ala, hoia kiirust kuni 80 km/h.', 5000)
        end
    },
    {
        Pos = {x = -127.75836181641, y = 387.44528198242, z = 111.78216552734},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -120.89459228516, y = 436.52755737305, z = 112.49867248535},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -243.57286071777, y = 421.87399291992, z = 107.68046569824},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -359.64401245117, y = 497.82037353516, z = 114.97492218018},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -500.58068847656, y = 609.72589111328, z = 126.23880767822},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Ole siinsetel kitsastel teedel ettevaatlik!', 5000)
        end
    },
    {
        Pos = {x = -501.00970458984, y = 659.259765625, z = 139.70812988281},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -140.94055175781, y = 602.17980957031, z = 203.16484069824},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -30.233863830566, y = 609.74737548828, z = 206.14724731445},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Vaata, et sa kuidagi üle ääre ei sõida..', 5000)
        end
    },
    {
        Pos = {x = 272.50079345703, y = 824.09686279297, z = 191.1369934082},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 312.43206787109, y = 848.34106445312, z = 192.04797363281},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 486.0544128418, y = 865.54425048828, z = 196.8851776123},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Oleme nüüd asulavälisel teel. Võid oma kiirust tõsta kuni 120 km/h.', 6000)
            setCurrentZoneType('country')
        end
    },
    {
        Pos = {x = 877.36016845703, y = 985.19964599609, z = 238.62098693848},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 960.85357666016, y = 644.65466308594, z = 165.93618774414},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 1104.1656494141, y = 751.92657470703, z = 150.7784576416},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 1085.0727539062, y = 550.08276367188, z = 94.392456054688},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 1035.5264892578, y = 502.45010375977, z = 95.167808532715},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 1033.9725341797, y = 477.55172729492, z = 94.168121337891},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 1057.6114501953, y = 447.14831542969, z = 91.220596313477},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Kiirteedel puudub kiiruspiirang, kuid ära oma võimeid üle hinda.', 5000)
            setCurrentZoneType('freeway')
        end
    },
    {
        Pos = {x = 1044.8194580078, y = 382.47320556641, z = 89.561790466309},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Kiirteedel puudub kiiruspiirang, kuid ära oma võimeid üle hinda.', 5000)
        end
    },
    {
        Pos = {x = 944.07281494141, y = 254.74659729004, z = 79.348243713379},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 637.19982910156, y = -211.02722167969, z = 42.931461334229},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Oleme sisenemas linna, võta hoogu maha.', 5000)
        end
    },
    {
        Pos = {x = 541.14721679688, y = -309.62936401367, z = 42.521049499512},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Järgime uuesti kiiruspiirangut 80 km/h.', 5000)
            setCurrentZoneType('town')
        end
    },
    {
        Pos = {x = 499.68569946289, y = -312.74807739258, z = 44.135986328125},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 380.61663818359, y = -267.8073425293, z = 52.584812164307},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 374.7668762207, y = -245.34010314941, z = 52.929916381836},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 390.5915222168, y = -181.72277832031, z = 60.445068359375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 394.70977783203, y = -149.67251586914, z = 63.436668395996},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 376.38131713867, y = -117.38967895508, z = 64.109268188477},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Ole kesklinna tihedas liikluses ettevaatlik.', 5000)
        end
    },
    {
        Pos = {x = 298.41781616211, y = -84.341346740723, z = 68.951293945312},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 259.69573974609, y = -71.271110534668, z = 68.760498046875},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 140.86372375488, y = -29.297929763794, z = 66.421348571777},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 105.60926055908, y = -16.189846038818, z = 66.762275695801},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -24.311513900757, y = 31.336267471313, z = 70.754257202148},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -63.655292510986, y = 46.580768585205, z = 70.896492004395},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -117.35091400146, y = 76.565162658691, z = 70.026260375977},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -120.92987060547, y = 101.9898223877, z = 70.788856506348},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -105.32515716553, y = 221.34620666504, z = 94.9599609375},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = -73.357177734375, y = 248.96936035156, z = 100.62619781494},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 9.0557632446289, y = 261.03201293945, z = 108.26989746094},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 58.948574066162, y = 304.21502685547, z = 109.66007995605},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Peaaegu kõik, ära valvsust kaota.', 5000)
        end
    },
    {
        Pos = {x = 126.6311416626, y = 351.36291503906, z = 110.92569732666},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 200.11915588379, y = 358.30804443359, z = 105.31285095215},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DrawMissionText('Jätka sõitu järgmisesse punkti.', 5000)
        end
    },
    {
        Pos = {x = 221.30209350586, y = 385.18957519531, z = 105.45408630371},
        Action = function(playerPed, vehicle, setCurrentZoneType)
            DeleteEntity(vehicle)
        end
    }
}