--- ESX RELATED ---
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('PoliceDotsServer:OnDuty')
AddEventHandler('PoliceDotsServer:OnDuty', function(player, callsign)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerName = xPlayer.getName()
    TriggerClientEvent('PoliceDots:NewOfficer', -1, player, xPlayerName, callsign)
end)