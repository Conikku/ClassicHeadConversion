--[[
This is a server script.
An example script that uses the module to convert all players faces into dynamic ones (if possible).
]]

local Players = game:GetService("Players")

-- Don't forget to require module from wherever you put it!
local ClassicHeadConversion = require("@path/to/ClassicHeadConversion")

local function onPlayerCharacterAppearenceLoaded(character: Model)
	ClassicHeadConversion.ChangeFace(character) --try to change face to classic
end

local function onPlayerAdded(player: Player)
	player.CharacterAppearanceLoaded:Connect(onPlayerCharacterAppearenceLoaded)
	if player:HasAppearanceLoaded() then --checks if all the accessories has been loaded already
		onPlayerCharacterAppearenceLoaded(player.Character)
	end
end

-- Initalize
Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
	onPlayerAdded(player)
end
