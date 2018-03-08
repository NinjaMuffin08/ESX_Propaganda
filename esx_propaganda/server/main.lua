ESX              = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'reporter', "~b~Uutisvinkki ~w~", true, true)

RegisterServerEvent('esx_propaganda:getPaid')
AddEventHandler('esx_propaganda:getPaid', function(data)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.fetchAll(
	'SELECT * FROM paychecks WHERE receiver = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
	
		local topay = rows
		if #topay > 0 then 
			
			MySQL.Async.execute(
			'DELETE FROM paychecks WHERE receiver = @identifier', 
			{
			  ['@identifier'] = xPlayer.identifier
			}, function(rowschanged)
				
				local amount = 0
				
				for i=1, #topay, 1 do
					amount = amount + rows[i].amount
				end
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~ Sait palkkaa " .. amount)
				xPlayer.addMoney(amount)
			end
			)
			
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~ Kukaan ei ole tykännyt artikkeleistasi :(")
		end
	end
	)

end)

RegisterServerEvent('esx_propaganda:postArticle')
AddEventHandler('esx_propaganda:postArticle', function(dataTemp)
	
	local data = dataTemp
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	MySQL.Async.fetchAll(
	'SELECT * FROM users WHERE identifier = @identifier', 
	{
      ['@identifier'] = xPlayer.identifier
    }, 
	function(rows)
		
		local _name = "Matti Meikäläinen"
		
		for i = 1, #rows, 1 do
			_name = rows[i].firstname .. ' ' .. rows[i].lastname
		end
		
		MySQL.Async.fetchAll(
		'INSERT INTO news_main (title, bait_title, content, author_name, author_id, news_type, imgurl) VALUES (@title, @bait, @content, @author_name, @uid, @type, @url); SELECT LAST_INSERT_ID();',
		{ 
		  ['@title'] = data.title,
		  ['@bait'] = data.bait_title,
		  ['@content'] = data.content,
		  ['@author_name'] = _name,
		  ['@uid'] = xPlayer.identifier,
		  ['@type'] = data.type,
		  ['@url'] = data.imgurl,
		},
		function (id)
		--[[
		 local n = 0
		 for k,v in pairs(id[1]) do
		    n=n+1
		    Citizen.Trace('key: ' .. k .. "\n")
		    Citizen.Trace('value: ' .. id[1][k] .. "\n")
		  end 
		  Citizen.Trace(id[1]["LAST_INSERT_ID()"]) ]]--
		  TriggerEvent('esx_news:articlePosted', data, id[1]["LAST_INSERT_ID()"], _name, xPlayer.identifier)
		  TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~ Artikkeli lisätty!")
		end
		)
	end
	)
	
	MySQL.Async.execute(
	'DELETE FROM news_main WHERE id NOT IN (SELECT id FROM (SELECT id FROM news_main ORDER BY id DESC LIMIT 9 ) foo)', 
	{},
	function(rows2)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~w~ Vanhat artikkelit ~r~poistettu~w~!")
	end
	)
	
	--[[ Uncomment if you want old likes to be removed
	MySQL.Async.execute(
	'DELETE FROM news_likes WHERE news_id NOT IN (SELECT id FROM (SELECT id FROM news_main ORDER BY id DESC LIMIT 10 ) foo)',
	{},
	function(rows3)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~ Vanhat artikkelit poistettu!")
	end
	)
	]]--
end)


