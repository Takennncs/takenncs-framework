fx_version 'cerulean'
game 'gta5'

description 'takenncs Autokool'
author 'takenncs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/scripts.js',
    'html/debounce.min.js'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

lua54 'yes'

dependencies {
    'ox_lib',
    'oxmysql',
    'takenncs-fw'
}