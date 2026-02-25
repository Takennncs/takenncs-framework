fx_version 'cerulean'
game 'gta5'

description 'takenncs Dispatch'
author 'takenncs'
version '1.0.0'

ui_page 'ui/index.html'

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

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'takenncs-fw'
}