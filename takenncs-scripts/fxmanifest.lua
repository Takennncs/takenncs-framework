fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'Advanced FiveM Script Collection'
version '1.0.0'

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'takenncs-fw'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}
