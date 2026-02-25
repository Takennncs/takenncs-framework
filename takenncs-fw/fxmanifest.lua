fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'takenncs-fw framework'
version '1.2.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    'shared/main.lua',
    'shared/callbacks.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/callbacks.lua',
    'server/main.lua',
    'server/players.lua',
    'server/characters.lua',
    'server/jobs.lua',
    'server/factions.lua'
}

client_scripts {
    'client/main.lua',
    'client/characters.lua',
    'client/job.lua'
}