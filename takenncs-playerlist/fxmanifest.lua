fx_version 'cerulean'
game 'gta5'

description 'takenncs Playerlist'
author 'takenncs'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

ui_page 'ui/index.html'

client_scripts {
    'client/main.lua'
} 

server_scripts {
    'server/main.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

lua54 'yes'

dependencies {
    'ox_lib',
    'takenncs-fw'
}