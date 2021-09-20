--[[

	This script will deal with the player wanting to join the party

]]

local player = game:GetService("Players").LocalPlayer
repeat wait() until player.Character
local char = player.Character
local humRoot = char:WaitForChild("HumanoidRootPart")
local button = script.Parent
local party = button:WaitForChild("Party")
local debris = game:GetService("Debris")
local debounceYes = true
local debounceNo = true
local originalText = "Would you like to join the party?"
local verifyText = "Are you sure you want to join the party?"
local yes = button:WaitForChild("yes")
local no = button:WaitForChild("no")
local moduleElevator = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("elevatorGuiAndParty"))
local eventCallModule = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("addRemovePlayer")
local tweenService = game:GetService("TweenService")
local removeElevatorGuiEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("removeElevatorGui")
local addGui = script.Parent:WaitForChild("event")



local function letterByLetterString(stringName)
	for i = 1, string.len(stringName) do
		button.Text = string.sub(stringName, 1, i)
		wait()
	end
	repeat wait() until string.len(button.Text) == string.len(stringName) --just so the rest of the code doesn't run before it finishes displaying text
end

local function tweenGui(buttons, axis)
	local tweenService = game:GetService("TweenService")
	local goal = {
		Position = UDim2.new(0.5, 0, axis, 0)
	}
	local tweenInfo = TweenInfo.new(0.5)
	local tween = tweenService:Create(buttons, tweenInfo, goal)
	tween:Play()
end

local function createSound() 
	local sound = Instance.new("Sound")
	sound.Name = "Click"
	sound.SoundId = "rbxassetid://421058925"
	sound.Volume = 2
	sound.Parent = button
end


yes.MouseButton1Down:Connect(function()
	if debounceYes then
		debounceYes = false
		createSound()
		wait(1)
		debris:AddItem(button:FindFirstChild("Click"))
		if game.Workspace:WaitForChild("Elevators"):WaitForChild(party.Value):WaitForChild("PlayersInParty"):WaitForChild("maxParty").Value >= game.Workspace:WaitForChild("Elevators"):WaitForChild(party.Value):WaitForChild("PlayersInParty"):WaitForChild("currentNumParty").Value then
			humRoot.CFrame = game.Workspace:WaitForChild("Elevators"):WaitForChild(party.Value):WaitForChild("elevatorFloor").CFrame + Vector3.new(0, 3, 0)

			eventCallModule:FireServer(party.Value, "join")
			--moduleElevator.addPlayerToElevator(player.Name, party.Value)

			local goal = {
				Position = UDim2.new(0.5, 0, -1, 0)
			}
			local tweenInfo = TweenInfo.new(0.5)
			local tween = tweenService:Create(button, tweenInfo, goal)
			tween:Play()	
			tween.Completed:Connect(function()
				addGui:FireServer(party.Value)
				repeat wait() until player:WaitForChild("PlayerGui"):FindFirstChild("LeaveParty")
				removeElevatorGuiEvent:FireServer("JoinParty")
			end)
		else
			local text = "The party is at a maximum."
			for i = 1, string.len(text) do
				button.Text = string.sub(text, 1, i)
				wait()
			end
			repeat wait() until string.len(button.Text) == string.len(text) 
			local goal = {
				Position = UDim2.new(0.5, 0, -1, 0)
			}
			local tweenInfo = TweenInfo.new(0.5)
			local tween = tweenService:Create(button, tweenInfo, goal)
			tween:Play()	
			tween.Completed:Connect(function()
				moduleElevator.createGuiForLeaveElevator(player.Name, party.Value)
				repeat wait() until player:WaitForChild("PlayerGui"):FindFirstChild("LeaveParty")
				removeElevatorGuiEvent:FireServer("JoinParty")
			end)
		end
		wait(1)
		debounceYes = true
	end
	
end)

no.MouseButton1Down:Connect(function()
	if debounceNo then
		debounceNo = false
		createSound()
		wait(1)
		debris:AddItem(button:FindFirstChild("Click"))
		letterByLetterString("Not joining party.")
		wait(1)
		local goal = {
			Position = UDim2.new(0.5, 0, -1, 0)
		}
		local tweenInfo = TweenInfo.new(0.5)
		local tween = tweenService:Create(button, tweenInfo, goal)
		tween:Play()	
		tween.Completed:Connect(function()
			removeElevatorGuiEvent:FireServer("JoinParty")
		end)
	end
end)
