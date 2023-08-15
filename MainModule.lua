-- !scrict

--[[

	Author: @Conikku
	Start Date: August, 15, 2023
	Last Updated	: August, 15, 2023
	
	Note:
	Credit Roblox user @Conikku if used.
	
]]

local module = {}

local Char_Faces = {
	_13976201768 = {  -- Stevie/Default Smile
		Face = "144080495",
		Head = "5591363797",
	},
	_12788914510 = { -- Freckles
		Face = "12145059",
		Head = "8635368421",
	},
	_12938732889 = { -- Chill
		Face = "7074749",
		Head = "5591363797",
	},
	_12859107436 = { -- Classic Male
		Face = "3994344171",
		Head = "5591363797",
	},
	_12937157169 = { -- Laughing Fun
		Face = "226216895",
		Head = "8635368421",
	},
	_12732384881 = { -- Classic Female
		Face = "3994345447",
		Head = "8635368421",
	},
	_12930419371 = {  -- Winning Smile
		Face = "616395480",
		Head = "5591363797",
	},
	_12945471762 = { -- Yawn
		Face = "161124757",
		Head = "5591363797",
	},
	_12859980784 = { -- Err
		Face = "20418518",
		Head = "5591363797",
	},
	_12788528296 = { -- Squiggle
		Face = "25165947",
		Head = "8635368421",
	},
	_12991510818 = { -- Whistle
		Face = "22877700",
		Head = "8635368421",
	},
	_12726021129 = { -- Woman
		Face = "83022608",
		Head = "8635368421",
	},
	_12936896604 = { -- Big Grin
		Face = "7987146198",
		Head = "8635368421",
	},
	_12939027752 = { -- Know It All Grin
		Face = "26424652",
		Head = "5591363797",
	},
	_12936580274 = { -- Cat Eye
		Face = "7893435035",
		Head = "8635368421",
	},
	_12945371172 = { -- Braces
		Face = "30394483",
		Head = "5591363797",
	},
	_12733073232 = { -- Man Face
		Face = "83017053",
		Head = "8635368147",
	},
	_12954195093 = { -- Joyful
		Face = "209713384",
		Head = "5591363797",
	},
	_12937029385 = { -- :]
		Face = "18151722",
		Head = "5591363797",
	},
	_11308920969 = { -- Check It
		Face = "7074780",
		Head = "5591363797",
	},
}

function module.ChangeFace(plr: Player)
	local Character = plr.Character or plr.CharacterAdded:Wait()
	local Head, Humanoid = Character:WaitForChild("Head", 10), Character:WaitForChild("Humanoid", 10)

	if Humanoid.RigType == Enum.HumanoidRigType.R6 then
		local Head_Mesh = Head:WaitForChild("Mesh", 10)

		local url = Head_Mesh.TextureId

		local ID

		if url ~= "" then
			ID = string.match(url, '%d+')
		end

		if ID ~= nil and Char_Faces["_"..tostring(ID)] then
			Head_Mesh:Destroy()
			wait()
			Head_Mesh = Instance.new("SpecialMesh", Head)
			local MatchFace = Char_Faces["_"..tostring(ID)]
			local Face = Head:FindFirstChild("Face") or Head:FindFirstChild("face")

			Head_Mesh.TextureId = ""
			Head_Mesh.MeshId = "rbxassetid://"..MatchFace.Head
			Face.Texture = "rbxassetid://"..MatchFace.Face
		end
	else
		--TODO: GET THIS TO WORK WITH R15
	end
end

return module
