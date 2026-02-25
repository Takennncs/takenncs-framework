fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'takenncs-multicharacter - Character selection and creation with HTML UI'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

dependencies {
    'ox_lib',
    'takenncs-fw'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
    'html/assets/*.png',
    'html/assets/*.jpg',
    'html/assets/*.svg'
}