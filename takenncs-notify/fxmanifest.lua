fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'Notify Web Example UI for breakingsf.ee'
version '2.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua'
}

client_script 'client.lua'

files {
    'web/**'
}

lua54 'yes'