fx_version 'cerulean'
game 'gta5'

description 'takenncs Image System'
author 'takenncs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/scripts.js'
}

dependencies {
    'ox_lib',
    'oxmysql',
    'takenncs-fw',
    'screenshot-basic'
}

lua54 'yes'