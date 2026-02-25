Config = {
    Debug = false,
    Framework = 'auto',
    Language = 'en',
    
    DealershipPed = {
        model = 'a_m_y_business_01',
        coords = vec4(-56.6543, -1098.7123, 26.4223, 36.2842),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        freeze = true,
        invincible = true,
        blockEvents = true,
    },
    
    HelicopterDealershipPed = {
        model = 'a_m_y_business_01',
        coords = vec4(-1031.2837, -3014.3396, 13.9472, 31.5708),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        freeze = true,
        invincible = true,
        blockEvents = true,
    },
    
    VehicleSpawn = {
        coords = vec4(-17.7089, -1104.1586, 26.6720, 159.7968),
        heading = 159.7968,
    },
    
    HelicopterPreviewSpawn = {
        coords = vec4(-1036.4442, -3003.0486, 13.9458, 45.9403),
        heading = 45.9403,
    },
    
    HelicopterSpawn = {
        coords = vec4(-995.3276, -2930.9194, 13.9461, 329.9728),
        heading = 329.9728,
    },
    
    DealershipBlip = {
        enabled = true,
        coords = vec3(-56.6543, -1098.7123, 26.4223),
        sprite = 810,
        color = 6,
        scale = 0.8,
        name = 'Autopood',
    },
    
    HelicopterDealershipBlip = {
        enabled = true,
        coords = vec3(-1031.2837, -3014.3396, 13.9472),
        sprite = 43,
        color = 6,
        scale = 0.8,
        name = 'Kopteripood',
    },
    
    DealershipVehicles = {
        { model = 'adder', label = 'Truffade Adder', price = 1000000, category = 'Sports' },
        { model = 'sultanrs', label = 'Benefactor Sultan RS', price = 420000, category = 'Sports' },
        { model = 'coquette', label = 'Invetero Coquette', price = 120000, category = 'Sports' },
        { model = 'fugitive', label = 'Annis Fugitive', price = 185000, category = 'Sedan' },
        { model = 'baller', label = 'Gallivanter Baller', price = 95000, category = 'SUV' },
        { model = 'granger', label = 'Declasse Granger', price = 75000, category = 'SUV' },
        { model = 'oracle', label = 'Enus Oracle', price = 80000, category = 'Sedan' },
        { model = 'felon', label = 'Benefactor Felon', price = 150000, category = 'Sedan' },
        { model = 'blista', label = 'Dinka Blista', price = 50000, category = 'Compact' },
        { model = 'dilettante', label = 'Enus Dilettante', price = 55000, category = 'Compact' },
    },
    
    HelicopterVehicles = {
        { model = 'buzzard', label = 'Buzzard Attack Helicopter', price = 1500000, category = 'Military' },
        { model = 'maverick', label = 'Maverick', price = 800000, category = 'Civil' },
        { model = 'frogger', label = 'Frogger', price = 750000, category = 'Civil' },
        { model = 'swift', label = 'Swift', price = 1200000, category = 'Luxury' },
        { model = 'volatus', label = 'Volatus', price = 1800000, category = 'Luxury' },
        { model = 'savage', label = 'Savage', price = 2000000, category = 'Military' },
        { model = 'annihilator', label = 'Annihilator', price = 1700000, category = 'Military' },
        { model = 'seasparrow', label = 'Sea Sparrow', price = 950000, category = 'Water' },
        { model = 'valkyrie', label = 'Valkyrie', price = 2200000, category = 'Military' },
        { model = 'havok', label = 'Havok', price = 600000, category = 'Sport' },
    },

    TestDrive = {
        enabled = true,
        duration = 120,
        spawnRadius = 10.0,
        price = 0,
    },

    Payment = {
        account = 'bank',
        allowInstallments = false,
        installmentMultiplier = 1.2,
    },

    Notify = {
        useOx = true,
        position = 'top-right',
    }
}