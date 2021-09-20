--[[
	This script will pick a map every 10 seconds if there isn't a party starting

]]

local mapImage = script.Parent.Parent:WaitForChild("Screen"):WaitForChild("Part"):WaitForChild("gui"):WaitForChild("image")
local pickMap = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("pickMap"))
local backScreenText = script.Parent.Parent:WaitForChild("BackScreen"):WaitForChild("surface"):WaitForChild("text")
local playersInParty = script.Parent.Parent:WaitForChild("PlayersInParty")
local currentNumParty = playersInParty:WaitForChild("currentNumParty")
local maxParty = playersInParty:WaitForChild("maxParty")
local teleportService = game:GetService("TeleportService")


local enoughPlayers = false
local showLetter = false

--Place teleportion stuff in this function to make it less messy

local function teleportPlayer(placeId)
	for i, player in ipairs(playersInParty:GetChildren()) do
		if player.Value ~= "currentNumParty" or player.Value ~= "maxParty" then
			if game.Workspace:FindFirstChild(player.Value) then
				local playerInWorkSpace = game.Workspace:FindFirstChild(player.Value)
				teleportService:Teleport(placeId, game:GetService("Players"):GetPlayerFromCharacter(playerInWorkSpace))
			end
			
			--local teleportResult = TeleportModule.teleportWithRetry(placeId, {game:GetService("Players"):FindFirstChild(player.Value)})
		end
	end
	
end



while true do
	--Table will be structured like {imageId, MaxNumOfPlayers, minNumOfPlayers, placeId}
	local tableWithMapChoice = pickMap.randomMap()
	mapImage.Image = tableWithMapChoice[1]
	maxParty.Value = tableWithMapChoice[2]
	local minNumOfPlayers = tableWithMapChoice[3]
	
	
	currentNumParty.Changed:Connect(function()
		if (currentNumParty.Value >= minNumOfPlayers) and (currentNumParty.Value <= maxParty.Value) then
			if enoughPlayers == false then
				enoughPlayers = true
				while enoughPlayers do
					for i = 10, 1, -1 do
						backScreenText.Text = "Countdown..."..i
						if enoughPlayers then
							wait(1)
						else
							backScreenText.Text = "Countdown"
							break
						end
					end
					teleportPlayer(tableWithMapChoice[4])			
				end
			end
		else
			enoughPlayers = false
			backScreenText.Text = "Countdown"
		end
	end)
	
	wait(10)
	
end



