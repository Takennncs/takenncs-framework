fx_version 'cerulean'
game 'gta5'

description 'takenncs Documents'
author 'takenncs'
version '1.0.0'

ui_page 'ui/index.html'

shared_scripts {
    '@ox_lib/init.lua'
} 

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

files {
    'ui/css/style.css',
    'ui/js/main.js',
    'ui/images/idcard.png',
    'ui/index.html'
}

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'ox_inventory',
    'takenncs-fw'
}