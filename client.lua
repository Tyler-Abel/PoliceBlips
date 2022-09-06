ESX = nil
local callsign = ''
local OnDuty = false
local policeBlips = {}

-- ESX BASE --
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- COMMANDS --
RegisterCommand('callsign', function(source, args)
	callsign = args[1]
end, false)

RegisterCommand('ToggleDuty', function()
	if OnDuty then
		OnDuty = false
	else
        local player = PlayerPedId()
		TriggerServerEvent('PoliceDotsServer:OnDuty', player, callsign)
		OnDuty = true
	end
end, false)

-- EVENTS --
RegisterNetEvent('PoliceDots:NewOfficer')
AddEventHandler('PoliceDots:NewOfficer', function(playerID, playerName, callsign)
    if OnDuty then
        PoliceDot = AddBlipForEntity(playerID)
	    SetBlipScale(PoliceDot, 1.0)
	    SetBlipSprite(PoliceDot, 1)
	    SetBlipColour(PoliceDot, 2)
	    AddTextEntry('PoPoDot', playerName .. ' (' .. callsign .. ')')
	    BeginTextCommandSetBlipName('PoPoDot')
	    EndTextCommandSetBlipName(PoliceDot)
        table.insert(policeBlips,
            {
                blipID = PoliceDot,
                name = playerName,
                id = playerID,
                unit = callsign
            }
        )
    end
end)

RegisterNetEvent('PoliceDots:RemoveOfficer')
AddEventHandler('PoliceDots:RemoveOfficer', function(playerID)
    for k,v in pairs(policeBlips) do
        if v.id == playerID then
            RemoveBlip(v.blipID)
        end
    end
end)

-- FUNCTIONS --
function success(str)
    TriggerEvent("swt_notifications:Success", 'Police Dots', str, 'top', 5000, true)
end

function error(str)
    TriggerEvent("swt_notifications:Negative", 'Police Dots', str, 'top', 5000, true)
end