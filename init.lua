-- !strict

--[[

	Author: @Conikku
	Date: August, 15, 2023

	Place in ServerScriptStorage or Workspace
	
	Note:
	Credit Roblox user @Conikku if used.
	Will be updated when more dynamic faces are made, module will auto update live in servers so be aware it could break stuff depending on how you coded it.
	If you are modifying it yourself grab the module here: https://www.roblox.com/library/14449877379/
	Just make sure to check back every now and then to see if I updated the module so new dynamic heads will work

]]

-- Services
local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")

-- Modules
local Module

-- Constants
local MODULE_UPDATE_TIME = 60
local MODULE_ID = 14449877379

-- Variables
local moduleLastId
local moduleLoaded = false


function getLatestModule()
	local latest = InsertService:GetLatestAssetVersionAsync(MODULE_ID)
	if moduleLastId ~= latest then
		moduleLoaded = false
		moduleLastId = latest
		local module = InsertService:LoadAssetVersion(moduleLastId):GetChildren()[1]
		
		if script:FindFirstChild("MainModule") then
			script.MainModule:Destroy()
		end
		
		Module = require(module)
		moduleLoaded = true
		print("Module has been updated")
	else
		print("Module is already up to date")
	end
end

do
	spawn(function()
		while true do
			getLatestModule()
			wait(MODULE_UPDATE_TIME)
		end
	end)
end

Players.PlayerAdded:Connect(function(plr)
	repeat task.wait() until Module ~= nil
	Module.ChangeFace(plr)
end)
