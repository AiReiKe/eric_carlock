ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

ESX.RegisterServerCallback("eric_carlock:getOwnedVehicle", function(source, cb)
    local identifier = GetPlayerIdentifier(source, 0)

	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = identifier
	}, function(result)

		if result then
            cb(result)
		end
		
	end)
end)

RegisterNetEvent("eric_carlock:givecarkey")
AddEventHandler("eric_carlock:givecarkey", function(player, plate)
	local _source = source
    TriggerClientEvent("eric_carlock:addcarkey", player, plate)
	TriggerClientEvent("esx:showNotification", player, _U("get_key_from", GetPlayerName(_source), plate))
end)


print(\nThis script is made by AiReiKe\nThank you for using eric_carlock\n)
