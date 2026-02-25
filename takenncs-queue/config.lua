Config = Config or {}

Config.Queue = {
    Enabled = true,
    MaxPlayers = 32,            
    PriorityGroups = {  
        ['meeskond'] = {
            roleId = '1234567890', 
            priority = 1,         
            slots = 5            
        },
        ['annetaja'] = {
            roleId = '0987654321',
            priority = 2,
            slots = 10
        },
        ['ucpbuyer'] = {
            roleId = '1122334455',
            priority = 3,
            slots = 5
        }
    },
    
    QueuePositionUpdate = 5000,
    QueueCheckInterval = 1000,
    Timeout = 60000,
    
    Locale = 'et',
    Messages = {
        ['et'] = {
            connecting = 'Ühendamine...',
            inQueue = 'Oled järjekorras. Positsioon: {position}/{total}',
            connectingPriority = 'Prioriteetne ühendamine...',
            queueFull = 'Järjekord on täis. Proovi hiljem uuesti.',
            disconnected = 'Ühendus katkestati.',
            timeout = 'Ühendamise aeg sai läbi. Proovi uuesti.',
            connectingFailed = 'Ühendamine ebaõnnestus. Proovi uuesti.',
            serverFull = 'Server on täis. Järjekorras: {queue} mängijat',
            priorityConnected = 'Tere tulemast! (Prioriteetne mängija)'
        },
        ['en'] = {
            connecting = 'Connecting...',
            inQueue = 'You are in queue. Position: {position}/{total}',
            connectingPriority = 'Priority connecting...',
            queueFull = 'Queue is full. Try again later.',
            disconnected = 'Disconnected.',
            timeout = 'Connection timeout. Try again.',
            connectingFailed = 'Connection failed. Try again.',
            serverFull = 'Server is full. In queue: {queue} players',
            priorityConnected = 'Welcome! (Priority player)'
        }
    },
    
    UI = {
        Title = '📋 Järjekord',
        ShowPosition = true,
        ShowEstimatedTime = true,
        PositionFormat = 'Positsioon: {current}/{total}',
        EstimatedTimeFormat = 'Eeldatav aeg: {time} sekundit',
        ProgressBarColor = { r = 52, g = 152, b = 219 },
        BackgroundColor = { r = 30, g = 30, b = 30, alpha = 200 }
    },
    
    Debug = false
}

Config.Queue.Messages = Config.Queue.Messages[Config.Queue.Locale] or Config.Queue.Messages['en']