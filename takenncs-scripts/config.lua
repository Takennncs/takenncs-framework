Config = {}

Config.Framework = 'takenncs'
Config.Debug = false

Config.Objects = {
    [1] = {
        model = 'prop_dumpster_01a',
        coords = vector3(100.0, 200.0, 50.0),
        length = 2.0,
        width = 3.0
    },
    [2] = {
        model = 'prop_dumpster_02a',
        coords = vector3(150.0, 250.0, 50.0),
        length = 2.5,
        width = 3.5
    }
}

Config.BlacklistedScenarios = {
    TYPES = {
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_BIKE",
        "PROP_HUMAN_SEAT_CHAIR_DRINKING",
        "WORLD_HUMAN_DRINKING",
        "WORLD_HUMAN_SMOKING",
    },
    GROUPS = {
        "AMBIENT_CAMP",
        "AMBIENT_POLICE",
        "AMBIENT_SMOKERS",
        "AMBIENT_DRINKERS",
    }
}