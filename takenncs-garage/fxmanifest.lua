fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'Professional Garage System with Impound'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/garage.lua',
    'client/impound.lua'  -- LISA SEE RIDA!
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/impound.lua'   -- LISA SEE RIDA!
}

dependencies {
    'ox_lib',
    'ox_target',
    'takenncs-fw'
}