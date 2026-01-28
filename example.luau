-- Services
local Players = game:GetService("Players")
local Module = require(script.ConversionHandler)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAppearanceLoaded:Connect(function(chr)
		Module.ChangeFace(chr)
	end)
end)

for i, v in Players:GetPlayers() do
	local chr = v.Character
	if chr then
		Module.ChangeFace(chr)
	end
end