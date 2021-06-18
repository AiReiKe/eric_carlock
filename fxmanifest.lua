fx_version 'adamant'

game 'gta5'

author 'AiReiKe'
description 'Eric Car Lock'
version '1.0.0'

client_script {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client.lua'
}

server_script {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/*.lua',
	'config.lua',
	'server.lua'
}
