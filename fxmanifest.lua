fx_version 'bodacious'
game 'gta5'

author 'Thomapp'
description 'ESX Reports System.'

shared_script '@es_extended/imports.lua'

server_script {
    'server/*.lua'
}

client_scripts {
    'src/RageUI.lua',
    'src/Menu.lua',
    'src/MenuController.lua',
    'src/components/*.lua',
    'src/elements/*.lua',
    'src/items/*.lua',
    'client/*.lua'
}

dependency 'es_extended'