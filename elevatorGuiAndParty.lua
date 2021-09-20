local elevatorGuiAndParty = {}

--This will create string value with player's name



local function createPlayerValueForPartyFolder(playerName, elevatorName)
	local stringValue = Instance.new("StringValue")
	stringValue.Name = "Player"
	stringValue.Value = playerName
	local currentNum = game.Workspace:WaitForChild("Elevators"):WaitForChild(elevatorName):WaitForChild("PlayersInParty"):WaitForChild("currentNumParty")
	local playerCount = 0
	for i, players in ipairs(game.Workspace:WaitForChild("Elevators"):WaitForChild(elevatorName):WaitForChild("PlayersInParty"):GetChildren()) do
		playerCount = playerCount + 1
	end
	playerCount = playerCount + 1 --It won't count the player yet bc the value hasn't been parented into it yet
	playerCount = playerCount - 2 --We are not counting the other two values that are maxParty and currentNumParty 
	currentNum.Value = playerCount
	return stringValue
end

--This function will remove player from elevator party

function elevatorGuiAndParty.removePlayerFromElevator(playerName, elevatorName)
	local elevators = game.Workspace:WaitForChild("Elevators")
	local playerParty = elevators:WaitForChild(elevatorName):WaitForChild("PlayersInParty")
	local currentNum = playerParty:WaitForChild("currentNumParty")
	
	for i, player in ipairs(playerParty:GetChildren()) do
		if player.Value == playerName then
			player:Destroy()
		end
	end
	local playerCount = 0
	for i, players in ipairs(elevators:WaitForChild(elevatorName):WaitForChild("PlayersInParty"):GetChildren()) do
		playerCount = playerCount + 1
	end
	print(playerCount)
	playerCount = playerCount - 2 --We are not counting the other two values that are maxParty and currentNumParty and then removing the player count
	currentNum.Value = playerCount
	if game:GetService("Players")[playerName]:WaitForChild("PlayerGui"):FindFirstChild("LeaveParty") then
		game:GetService("Players")[playerName]:WaitForChild("PlayerGui"):FindFirstChild("LeaveParty"):Destroy()
	end
end

--This function will add player to elevator party

function elevatorGuiAndParty.addPlayerToElevator(playerName, elevatorName)
	local playerString = createPlayerValueForPartyFolder(playerName, elevatorName)
	playerString.Parent = game.Workspace:WaitForChild("Elevators"):WaitForChild(elevatorName):WaitForChild("PlayersInParty")
end

--This will tween the gui
local function tweenGui(button)
	local tweenService = game:GetService("TweenService")
	local goal = {
		Position = UDim2.new(0.5, 0, 0.7, 0)
	}
	local tweenInfo = TweenInfo.new(1)
	local tween = tweenService:Create(button, tweenInfo, goal)
	tween:Play()
end

--This will make gui for asking player to leave elevator party

function elevatorGuiAndParty.createGuiForLeaveElevator(playerName, elevatorName)
	if game:GetService("Players")[playerName]:WaitForChild("PlayerGui"):FindFirstChild("LeaveParty") == nil then
		local guiClone = game:GetService("ReplicatedStorage"):WaitForChild("Guis"):WaitForChild("LeaveParty"):Clone()
		guiClone:WaitForChild("leave"):WaitForChild("Party").Value = elevatorName
		guiClone.Parent = game:GetService("Players")[playerName]:WaitForChild("PlayerGui")
		tweenGui(guiClone:WaitForChild("leave"))
	end
end

--This will make the gui for asking player to join elevator party

function elevatorGuiAndParty.createGuiForJoinElevator(playerName, elevatorName)
	if game:GetService("Players")[playerName]:WaitForChild("PlayerGui"):FindFirstChild("JoinParty") == nil then
		local guiClone = game:GetService("ReplicatedStorage"):WaitForChild("Guis"):WaitForChild("JoinParty"):Clone()
		guiClone:WaitForChild("join"):WaitForChild("Party").Value = elevatorName
		guiClone.Parent = game:GetService("Players")[playerName]:WaitForChild("PlayerGui")
		tweenGui(guiClone:WaitForChild("join"))
	end
end

return elevatorGuiAndParty
