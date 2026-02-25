fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'Queue system for takenncs-fw'
version '1.0.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'takenncs-fw'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/main.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}