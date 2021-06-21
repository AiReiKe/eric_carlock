ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local carkeys = {}
local lockDisable = false

AddEventHandler('onClientResourceStart', function()
    carkeys = {}

    ESX.TriggerServerCallback("eric_carlock:getOwnedVehicle", function(vehicles)
        carkeys = vehicles
    end)
end)

Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, Config.key) then
            TriggerEvent("eric_carlock:searchcar")
        end
        Citizen.Wait(5)
    end
end)

RegisterNetEvent("eric_carlock:searchcar")
AddEventHandler("eric_carlock:searchcar", function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local vehicle

    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    else
        vehicle = ESX.Game.GetClosestVehicle(coords, 1.0, 0, 1.5)
    end

    if DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)

        for k, v in pairs(carkeys)do
            if v == plate then
                TriggerEvent("eric_carlock:lockcar", vehicle)
            end
        end
    end
end)

RegisterNetEvent("eric_carlock:lockcar")
AddEventHandler("eric_carlock:lockcar", function(vehicle)
    print('\nThis script is made by AiReiKe\n')
    local dict = "anim@mp_player_intmenu@key_fob@"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    if lockStatus == 1 then
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
        ESX.ShowNotification(_U('car_locked', GetVehicleNumberPlateText(vehicle)))
        PlayVehicleDoorCloseSound(vehicle, 1)
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
        end
        hasToggledLock()
    elseif lockStatus == 2 then
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ESX.ShowNotification(_U('car_unlocked', GetVehicleNumberPlateText(vehicle)))
        PlayVehicleDoorOpenSound(vehicle, 0)
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
        end
        hasToggledLock()
    else
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDoorsLockedForAllPlayers(vehicle, true)
        ESX.ShowNotification(_U('car_locked', GetVehicleNumberPlateText(vehicle)))
        PlayVehicleDoorCloseSound(vehicle, 1)
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
        end
        hasToggledLock()
    end
    if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
        Wait(500)
        local flickers = 0
        while flickers < 2 do
            SetVehicleLights(vehicle, 2)
            Wait(170)
            SetVehicleLights(vehicle, 0)
            flickers = flickers + 1
            Wait(170)
        end
    end
end)

RegisterNetEvent("eric_carlock:addcarkey")
AddEventHandler("eric_carlock:addcarkey", function(plate)
    table.insert(carkeys, plate)
end)

function hasToggledLock()
    lockDisable = true
    Wait(100)
    lockDisable = false
end

function OpenCarKeysMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}

    for a,b in pairs(carkeys) do
        table.insert(elements, {label = b, value = b})
    end

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'owned_carkeys',
    {
        label = _U('owned_keys'),
        elements = elements
    }, function(data, menu)
        local carkey = data.current.value
        local elements2 = {}

        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        local foundPlayer = false
        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                foundPlayer = true
                table.insert(elements2, {label = GetPlayerName(players[i]), value = players[i]})
            end
        end

        if foundPlayer then
            ESX.UI.Menu.Open("default", GetCurrentResourceName(), 'nearby_players',
            {
                label = _U('nearby_players'),
                elements = elements2
            }, function(data2, menu2)
                menu.close()
                menu2.close()
                TriggerServerEvent("eric_carlock:givecarkey", GetPlayerServerId(data2.current.value), carkey)
            end, function(data2, menu2)
                menu2.close()
            end)
        else
            ESX.ShowNotification(_U('no_player_nearby'))
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterCommand("refreshcarkey", function()
    carkeys = {}

    ESX.TriggerServerCallback("eric_carlock:getOwnedVehicle", function(vehicles)
        carkeys = vehicles
    end)
    ESX.ShowNotification(_U("refreshed_key"))
end)

RegisterCommand("carkey", function()
    OpenCarKeysMenu()
end)
