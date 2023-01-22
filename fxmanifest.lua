fx_version 'cerulean'
game 'gta5'

name 'boppe-creator'
description 'boppe-creator'
author 'boppe'
version '1.1'

lua54 'yes'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/config.lua',
    'server/util.lua',
    'server/*.lua'
}

dependencies {
    'qb-core',
    'qb-input'
}