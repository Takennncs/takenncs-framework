local zones = {}

function addBoxZone(zoneData)
    local zoneId = exports.ox_target:addBoxZone(zoneData)
    table.insert(zones, { name = zoneData.options[1].name, id = zoneId })
end


-- setupZones() will add all box zones and model targets
local function setupZones()
    addBoxZone({
        coords = vector3(1183.3, 2635.37, 37.82),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'mosleyscraft',
                event = 'takenncs-mosleys:client:openCraftingMenu',
                icon = 'fa-solid fa-wrench',
                label = 'Ava töölaud',
                groups = 'mosleys',
            }
        }
    })
    addBoxZone({
        coords = vector3(-1407.27, -447.53, 36.06),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'hayesscraft',
                event = 'takenncs-hayes:client:openCraftingMenu',
                icon = 'fa-solid fa-wrench',
                label = 'Ava töölaud',
                groups = 'hayes',
            }
        }
    })

    addBoxZone({
        coords = vector3(126.1066, -3028.2075, 5.8905),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'tunershopcraft',
                event = 'takenncs-tablet:client:openCraftingMenu',
                icon = 'fa-solid fa-wrench',
                label = 'Ava töölaud',
                groups = 'tunershop',
            }
        }
    })

 
addBoxZone({
    coords = vector3(452.5213, -993.3670, 30.6833),
    size = vec3(2, 2, 2),
    rotation = 0,
    debug = drawZones,
    options = {
        {
            name = 'riidekapppolice1',
            event = "wardrobe:clothingShop",  -- SEE PEAB OLEMA TÄPSELT SELLINE
            icon = "fa-solid fa-shirt",
            label = "Vaheta riideid",
            groups = 'police',
        }
    }
})

        addBoxZone({
        coords = vector3(-846.3011, -1124.5131, 7.0623), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppolice1',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'wigwamburger',
            }
        }
    })

    addBoxZone({
        coords = vector3(1245.5253, -354.6658, 69.0821), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppolice1',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'hornysburger',
            }
        }
    })

    -- pandimaja
    addBoxZone({
        coords = vector3(-786.1671, -614.5568, 30.2791), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppawnshop',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'pawnshop',
            }
        }
    })


    addBoxZone({
        coords = vector3(891.5052, -1029.9343, 35.2422), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppiljardiklubi',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'piljardiklubi',
            }
        }
    })


         addBoxZone({
        coords = vector3(-229.6584, -1320.1680, 31.3005), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekappbennys',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'bennys',
            }
        }
    })

            addBoxZone({
        coords = vector3(841.7585, -824.4246, 26.3326), -- Davis
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppttps',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'ottos',
            }
        }
    })
    addBoxZone({
        coords = vector3(1842.5535, 3680.8164, 34.4166), -- Sandy
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppolice2',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'police',
            }
        }
    })

    addBoxZone({
        coords = vector3(-437.9680, 6007.5322, 37.1694), -- Paleto
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapppolice3',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'police',
            }
        }
    })
    addBoxZone({
        coords = vector3(149.97, -1041.31, 29.4),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank1',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(314.098663, -279.657318, 54.378822),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank2',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(259.500702, 226.330322, 106.448341),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank3',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(-351.184296, -50.648582, 49.300148),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank4',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(-1212.173462, -331.033691, 38.162632),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank5',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(-2961.729004, 482.818268, 15.852033),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank6',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(1175.296631, 2707.717773, 38.250557),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank7',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(-112.479866, 6470.421387, 31.921621),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'bank8',
                event = "takenncs-banking:client:open", 
                icon = "fas fa-money-bill-wave",
                label = "Ava pank",
            }
        }
    })
    addBoxZone({
        coords = vector3(-1425.53, -458.18, 36.39),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapphayes',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'hayes',
            }
        }
    })
    addBoxZone({
        coords = vector3(1151.2731, -1583.2542, 35.2918),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekappambulance1', -- Viceroy EMS
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'ambulance',
            }
        }
    })

        addBoxZone({
        coords = vector3(1151.2871, -1589.5862, 35.2918),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekappambulance1', -- Viceroy EMS
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'ambulance',
            }
        }
    })

        addBoxZone({
        coords = vector3(-203.9126, -1331.4293, 34.8926),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekappambulance1', -- Bennys
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'bennysmechanic',
            }
        }
    })
    addBoxZone({
        coords = vector3(893.53, -162.86, 76.89),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapptaxi',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'taxi',
            }
        }
    })
    addBoxZone({
        coords = vector3(2.01, -1658.39, 29.96),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapp6',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'mosley',
            }
        }
    })
    addBoxZone({
        coords = vector3(153.92, -3011.39, 7.04),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'riidekapp8',
                event = "wardrobe:clothingShop",
                icon = "fa-solid fa-shirt",
                label = "Vaheta riideid",
                groups = 'tunershop',
            }
        }
    })
    addBoxZone({
        coords = vector3(-542.92, -197.55, 38.23),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'tootukassa',
                event = "takenncs-tootukassa:client:openJobCentre", 
                icon = "fas fa-business-time",
                label = "Töötukassa",
            }
        }
    })
    addBoxZone({
        coords = vector3(450.43, -981.81, 31.00),
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = drawZones,
        options = {
            {
                name = 'lspdavaldus',
                event = "takenncs-leo:client:sendMessageToOfficers", 
                icon = "far fa-clipboard",
                label = "Esita avaldus",
            },
            {
                name = 'lspdmot',
                event = "takenncs-leo:client:motivatsioonikiri", 
                icon = "far fa-clipboard",
                label = "Esita motivatsioonikiri",
            }
        }
    })
--    addBoxZone({
--        coords = vector3(1147.9648, -1552.3434, 35.3805),
--        size = vec3(2, 2, 2),
--        rotation = 0,
--        debug = drawZones,
 --       options = {
  --          {
   --             name = 'emsamot',
    --            event = "takenncs-ems:client:motivatsioonikiri", 
    --          icon = "far fa-clipboard",
     --           label = "Esita motivatsioonikiri",
--            }
--        }
--    })
    ----------------------------------------------------
    -------------------- Haigla ------------------------
	addBoxZone({
        name = 'ems-op-1',
		coords = vec3(1147.9124, -1566.0768, 35.3806),
		size = vec3(2.25, 0.8, 0.5),
        rotation = 70.0,
        options = {
            {
				onSelect = function(entity)
                    exports['takenncs-scripts']:putIntoBed(vector3(1147.9124, -1566.0768, 35.3806), 339.36)
                end,
                icon = 'fas fa-bed',
                label = 'Aseta',
                canInteract = function(entity, distance, coords, name)
                    return distance < 1.5 and exports['takenncs-carry']:isCarrying()
                end,
            }
        }
    })

	addBoxZone({
        name = 'ems-op-2',
		coords = vec3(1147.9498, -1563.1625, 35.3805),
		size = vec3(2.4, 0.9, 0.5),
		rotation = 70.25,
        options = {
            {
				onSelect = function(entity)
                    exports['takenncs-scripts']:putIntoBed(vector3(1147.9498, -1563.1625, 35.3805), 339.136)
                end,
                icon = 'fas fa-bed',
                label = 'Aseta',
                canInteract = function(entity, distance, coords, name)
                    return distance < 1.5 and exports['takenncs-scripts']:isCarrying()
                end,
            }
        }
    })

	addBoxZone({
        name = 'ems-op-3',
		coords = vec3(1146.9879, -1575.4177, 35.3399),
		size = vec3(2.0, 1, 0.6),
		rotation = 70.0,
        options = {
            {
				onSelect = function(entity)
                    exports['takenncs-scripts']:putIntoBed(vector3(1146.9879, -1575.4177, 35.3399), 339.136)
                end,
                icon = 'fas fa-bed',
                label = 'Aseta',
                canInteract = function(entity, distance, coords, name)
                    return distance < 1.5 and exports['takenncs-scripts']:isCarrying()
                end,
            }
        }
    })
    ----------------------------------------------------
    local modelIds = {-742198632, 1926087217, 384625750, 90130747, 844145437, -525238304, -1527269738, 1506123827, -1358251024, 2084853348, -2046364835, -1619027728}
    local modelTargetId = exports.ox_target:addModel(modelIds, {
        {
            event = "takenncs-leo:client:cleanHands",
            icon = "fas fa-hands-wash",
            label = "Pese käsi",
        }
    }, 2) -- distance as third parameter
    table.insert(zones, { name = 'cleanHandsModel', id = modelTargetId })

end

-- Register to add zones when character loads or resource starts
RegisterNetEvent('takenncs:characterLoaded', function()
    setupZones()
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        setupZones()
    end
end)

function removeAllZones()
    for _, zone in ipairs(zones) do
        exports.ox_target:removeZone(zone.id)
    end
    zones = {}
end

RegisterNetEvent('takenncs:characterUnloaded', function()
    removeAllZones()
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        removeAllZones()
    end
end)
