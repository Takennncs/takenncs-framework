Config = {}

Config.FrameworkName = 'takenncs-fw'
Config.Locale = 'et'
Config.StartingJob = 'unemployed'
Config.MaxCharacters = 5
Config.Debug = true

Config.Server = {
    SaveInterval = 300000
}

Config.Server.UnemployedPayInterval = 60000
Config.Server.UnemployedSalary = 250
Config.Server.EmployedPayInterval = 60000

Config.Server.NeedsUpdateInterval = 60000
Config.Server.HungerDecreaseRate = 2
Config.Server.ThirstDecreaseRate = 3
Config.Server.StressDecreaseRate = 1
Config.Server.StressIncreaseRate = 2

Config.Client = {
    SpawnAfterLoad = true,
    DefaultSpawn = vector4(1121.9330, -3195.7354, -40.4010, 81.3755),
    EnableCharCommand = true,
    Notifications = true,
    RespawnAfterDeath = true,
    AutoShowCharSelect = false,
    FadeDuration = 1000,
    SpawnCooldown = 1000,
    EnableLastLocation = true
}

Config.Character = {
    MinAge = 16,
    MaxAge = 100,
    MinHeight = 150,
    MaxHeight = 210,
    DefaultHeight = 180,
    StartingMoney = 5000,
    StartingBank = 10000
}

Config.Database = {
    CharactersTable = 'characters'
}

Config.Appearance = {
    Enable = true,
    ResourceName = 'takenncs-appearance',
    AutoOpenForNewChars = true,
    SaveKey = 'F5'
}