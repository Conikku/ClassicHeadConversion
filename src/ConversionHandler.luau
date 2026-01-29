--[[
    Author: @Conikku (Updated for HumanoidDescription + HttpService)
    Original Date: August 15, 2023
    Updated: January 29, 2026
    
    Note:
	Detects ID via MeshURL -> Fetches FacesTable from web -> Applies conversion
    Head shape for now defaults to the regular roblox one, I will work on a fix soon
]]

local ConversionHandler = {}
local HttpService = game:GetService("HttpService")

-- Cache for the faces table to avoid repeated HTTP requests
local FacesTableCache = nil
local FACES_TABLE_URL = "https://raw.githubusercontent.com/Conikku/ClassicHeadConversion/refs/heads/main/Faces.json"

-- Helper function to extract the numeric ID from a Roblox URL string
local function GetIDFromURL(url)
	if not url or url == "" then return nil end
	local idString = string.match(url, "id=(%d+)")
	return tonumber(idString)
end

-- Function to fetch and cache the faces table
local function GetFacesTable()
	if FacesTableCache then
		return FacesTableCache
	end

	local success, result = pcall(function()
		local jsonData = HttpService:GetAsync(FACES_TABLE_URL)
		local decodedData = HttpService:JSONDecode(jsonData)
		return decodedData
	end)

	if success and result then
		FacesTableCache = result
		print("Successfully loaded FacesTable from web")
		return result
	else
		warn("Failed to load FacesTable from web:", result)
		return nil
	end
end

function ConversionHandler.ChangeFace(Character)
	local Humanoid = Character:FindFirstChild("Humanoid")
	local Head = Character:FindFirstChild("Head")

	if not Character:IsA("Model") or not Humanoid or not Head then return end

	-- 1. DETECT THE ID
	local searchId = nil
	local mesh = Head:FindFirstChild("Mesh")

	if mesh and mesh:IsA("SpecialMesh") then
		searchId = GetIDFromURL(mesh.MeshId)
	elseif Head:IsA("MeshPart") then
		searchId = GetIDFromURL(Head.MeshId)
	end

	print("Detected Mesh ID from URL:", searchId)

	if not searchId then return end

	-- 2. FETCH FACES TABLE FROM WEB
	local FacesTable = GetFacesTable()

	if not FacesTable then
		warn("Could not load FacesTable - conversion aborted")
		return
	end

	-- Convert searchId to string since JSON keys are strings
	local matchData = FacesTable[tostring(searchId)]

	if matchData then
		local targetHeadId = tonumber(matchData.Head)
		local targetFaceId = tonumber(matchData.Face)
		
		print("Target Head ID:", targetHeadId)
		print("Target Face ID:", targetFaceId)
		
		-- 3. APPLY HEAD MESH CHANGE DIRECTLY
		if targetHeadId then
			local mesh = Head:FindFirstChild("Mesh")
			
			if Head:IsA("MeshPart") then
				-- For MeshPart heads, change the MeshId directly
				Head.MeshId = "rbxassetid://" .. targetHeadId
				print("Changed MeshPart.MeshId to:", targetHeadId)
			elseif mesh and mesh:IsA("SpecialMesh") then
				-- For SpecialMesh heads, change the MeshId
				mesh.MeshId = "rbxassetid://" .. targetHeadId
				print("Changed SpecialMesh.MeshId to:", targetHeadId)
			else
				warn("Head doesn't have a MeshPart or SpecialMesh - cannot change head mesh")
			end
		end

		-- 4. Small wait for mesh to update
		task.wait(0.1)

		-- 5. NOW apply the face decal
		if targetFaceId then
			-- Remove any existing face decals first
			for _, child in ipairs(Head:GetChildren()) do
				if child:IsA("Decal") and child.Name:lower() == "face" then
					child:Destroy()
				end
			end

			-- Create new face decal
			local faceDecal = Instance.new("Decal")
			faceDecal.Name = "face"
			faceDecal.Face = Enum.NormalId.Front
			faceDecal.Texture = "rbxassetid://" .. targetFaceId
			faceDecal.Parent = Head

			print("Successfully set face decal texture to:", targetFaceId)
		end

		print("Successfully converted head for ID:", searchId)
	else
		print("No match found in FacesTable for Mesh ID:", searchId)
	end
end

-- Optional: Function to refresh the cache
function ConversionHandler.RefreshCache()
	FacesTableCache = nil
	print("FacesTable cache cleared")
end

return ConversionHandler