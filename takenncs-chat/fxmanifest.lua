
fx_version 'cerulean'
game 'gta5'
lua54 'yes'
ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua'
}

client_script 'client.lua'
server_script 'server.lua'

files {
    'web/**'
}