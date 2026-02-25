fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'Professional vehicle dealership system with ped'
version '1.0.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'ox_target',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',  -- Change this from mysql-async
    'server/main.lua',
}