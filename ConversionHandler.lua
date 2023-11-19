--[[

	Author: @Conikku
	Start Date: August 15, 2023
	Last Updated: November 19, 2023
	
	Note:
	Credit Roblox user @Conikku if used.
	
]]

local ConversionHandler = {}

local FacesTable = require(script.FacesTable) -- Table for heads is in a seperate module to make it easier to edit and to make this script have less lines

local function CreateMesh(Head_Mesh, MatchHead, ParentTo) -- This is to make the mesh for the Head
	Head_Mesh = Instance.new("SpecialMesh")
	Head_Mesh.MeshId = "rbxassetid://"..MatchHead
	Head_Mesh.Parent = ParentTo
end

function ConversionHandler.ChangeFace(Character)
	
	if Character:IsA("Model") and Character:FindFirstChild("Humanoid") then
		
		local URL, ID, Face, MatchHead, IDofMesh -- Variables that will be used later
		local Head, Humanoid = Character:WaitForChild("Head", 10), Character:WaitForChild("Humanoid", 10)

		local Head_Mesh = Head:FindFirstChild("Mesh") -- Check if there's a specialmesh
		
		if Head_Mesh == nil then -- If nil then change Head_Mesh to the player's head and set URL to the TextureID of the head
			warn("Head_Mesh is nil")
			Head_Mesh = Head -- Set to head
			
			task.wait()
			
			URL = Head.MeshId -- Get URL of Mesh
			ID = tonumber(string.split(tostring(URL), "https://assetdelivery.roblox.com/v1/asset/?id=")[2]) -- Get ID from URL
			
			if not FacesTable[ID] then return end -- If can't find the MeshID of the head in the FacesTable, then end the script, if not then continue
			MatchHead = FacesTable[ID]
			
			local InsertHats = {} -- This is the table where we will be inserting the players hats
			local ClonedHead = Head_Mesh:Clone() -- This is to make it easier to get hat attachmenets and all that jazz

			for i, hat in pairs(Character:GetChildren()) do -- Get hats from player, clone them, and insert the cloned into the table
				
				if hat:IsA("Accessory") then
					table.insert(InsertHats, hat:Clone())
					task.wait()
					hat:Destroy()
				end
				
			end
			
			Humanoid.RequiresNeck = false -- Temporary set this to false so the character doesn't die when getting rid of the current head
			
			local NewHead = Instance.new("Part") -- Start making the new head. We wouldn't have to do if Roblox let you change MeshID's on MeshParts
			NewHead.Name = "Head"
			NewHead.Size = Vector3.new(2, 1, 1)
			NewHead.CFrame = Head.CFrame
			NewHead.BrickColor = Head.BrickColor
			
			CreateMesh(NewHead, MatchHead.Head, NewHead) -- Create mesh for the head
			
			local Motor -- This will be used to detect where the motor is located depending on if the player is in R6 or R15
			
			if Humanoid.RigType == Enum.HumanoidRigType.R15 then -- If in R15 change the parent of the current head's Neck Motor6D to the soon to be new head
				Head_Mesh.Neck.Parent = NewHead
			end
			
			NewHead.Parent = Character -- Parent new head to Character
			Head_Mesh:Destroy() -- very obvious what this should be, duh!
			
			Head_Mesh = Character.Head

			if Humanoid.RigType == Enum.HumanoidRigType.R15 then -- Now we set the Motor6D
				Motor = Head_Mesh.Neck
				Motor.Parent = Head_Mesh
			elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
				Motor = Character.Torso.Neck
			end

			Motor.Part1 = Head_Mesh -- Parent it to the head
			
			Face = Instance.new("Decal") -- Create new Face Texture
			Face.Name = "Face"
			Face.Face = Enum.NormalId.Front
			Face.ZIndex = 1
			Face.Parent = Head_Mesh
			
			for i, head in pairs(ClonedHead:GetChildren()) do -- Now we get the attachments from the ClonedHead and we set them to the current head of player
				
				if head:IsA("Attachment") or head:IsA("StringValue") then
					head.Parent = Head_Mesh
				end
				
			end
			
			task.wait()
			
			for i, hats in InsertHats do -- Now we set the hats back to the player
				hats.Parent = Character
			end
			
			Humanoid.RequiresNeck = true -- Now the character can die if the head or neck Motor6D is deleted, lol.
			ClonedHead:Destroy() -- Destroy this just in case
		elseif Head_Mesh.Name == "Mesh" then -- If not nil then set URL to specialmesh ID
			if not FacesTable[ID] then return end -- If can't find the MeshID of the head in the FacesTable, then end the script, if not then continue
			MatchHead = FacesTable[ID]
			
			URL = Head_Mesh.MeshId -- Get URL of Head_Mesh
			ID = tonumber(string.split(tostring(URL), "https://assetdelivery.roblox.com/v1/asset/?id=")[2]) -- Get ID from URL
			
			Head_Mesh:Destroy() -- Destroy Head_Mesh
			task.wait()
			CreateMesh(Head, MatchHead.Head, Head) -- Create mesh for the head
		end
		
		Face.Texture = "rbxassetid://"..MatchHead.Face -- Set face Texture
		
	end
	
end

return ConversionHandler
