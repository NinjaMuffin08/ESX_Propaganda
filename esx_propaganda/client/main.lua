
local playerData			  = nil
ESX                           = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded') --get xPlayer
AddEventHandler('esx:playerLoaded', function(xPlayer)
  playerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)	
  playerData.job = job												
end)


function DisplayHelpText(str) --global function
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentScaleform(str)
	EndTextCommandDisplayHelp(0, 0, 1, -1)
end

-- Create Blips
Citizen.CreateThread(function()
		
    local blip = AddBlipForCoord(-1116.89, -502.78, 35.01)

    SetBlipSprite (blip, 184)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 1)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Journalistin toimisto")
    EndTextCommandSetBlipName(blip)

end)


Citizen.CreateThread(function ()
  
  while true do
  
		Citizen.Wait(1)
		
		if CurrentAction ~= nil then
			
			local _job = tostring(exports['esx_policejob']:getJob())
			
			if(_job == "reporter") then 
				DisplayHelpText("Paina ~INPUT_CONTEXT~ lunastaaksesi palkka")

			  if IsControlJustReleased(0, 38) then
				
				TriggerServerEvent('esx_propaganda:getPaid', "ok")
				CurrentAction = nil
			  end
			end
			
		end
	
	end
	
end)

AddEventHandler('esx_propaganda:hasEnteredMarker', function (zone)
	CurrentAction = 'pay_menu'
end)

AddEventHandler('esx_propaganda:hasExitedMarker', function (zone)
	CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		
		Wait(5)
		
		local playerPed = GetPlayerPed(-1)
		local coords    = GetEntityCoords(playerPed)

		if(GetDistanceBetweenCoords(coords, -1116.89, -502.78, 35.01, true) < 100 ) then
			DrawMarker(1, -1116.89, -502.78, 35.01, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 5, 100, false, true, 2, false, false, false, false)
		end	

	end
end)


-- Enter / Exit marker events
Citizen.CreateThread(function ()
  while true do
    Wait(5)

    local coords      = GetEntityCoords(GetPlayerPed(-1))
    local isInMarker  = false
	
		if(GetDistanceBetweenCoords(coords, -1116.89, -502.78, 35.01, true) < 1.0) then
	      isInMarker  = true
		end


		if (isInMarker and not HasAlreadyEnteredMarker) then
		  HasAlreadyEnteredMarker = true
		  TriggerEvent('esx_propaganda:hasEnteredMarker', 'not in use')
		end

		if not isInMarker and HasAlreadyEnteredMarker then
		  HasAlreadyEnteredMarker = false
		  TriggerEvent('esx_propaganda:hasExitedMarker', 'not in use')
		end
  end
end)


-- Open Gui and Focus NUI
function openGui()
  SendNUIMessage({openPropaganda = true})
  Citizen.CreateThread(function()
	Citizen.Wait(500)
	SetNuiFocus(true, true)
  end)
end

-- Close Gui and disable NUI

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openPropaganda = false})
end

-- NUI Callback Methods
RegisterNUICallback('closePropaganda', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNUICallback('postArticle', function(data, cb)
  
  TriggerServerEvent('esx_propaganda:postArticle', data)
  
  cb('ok')
end)

function openPropaganda ()
	openGui()
end


