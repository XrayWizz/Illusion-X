-- Full mobile fireball script in one file
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create UI buttons
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FireballUI"

local function createButton(text, position, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 50)
	btn.Position = position
	btn.Text = text
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.Parent = screenGui
	return btn
end

local igniteBtn = createButton("Ignite", UDim2.new(0.05, 0, 0.8, 0), Color3.fromRGB(255, 140, 0))
local throwBtn = createButton("Throw", UDim2.new(0.2, 0, 0.8, 0), Color3.fromRGB(255, 50, 50))

-- Reference to FireEffect model
local fireTemplate = ReplicatedStorage:WaitForChild("FireEffect")

-- Keep track of fireball in hand
local currentFireball = nil

igniteBtn.MouseButton1Click:Connect(function()
	character = player.Character or player.CharacterAdded:Wait()
	local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
	if not hand then return end

	if not currentFireball then
		local fire = fireTemplate:Clone()
		fire.Name = "Fireball"
		fire:SetPrimaryPartCFrame(hand.CFrame)
		fire.PrimaryPart.Anchored = false
		fire.Parent = hand

		-- Weld to hand
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = fire.PrimaryPart
		weld.Part1 = hand
		weld.Parent = fire.PrimaryPart

		currentFireball = fire
	end
end)

throwBtn.MouseButton1Click:Connect(function()
	if not currentFireball or not currentFireball.PrimaryPart then return end
	character = player.Character or player.CharacterAdded:Wait()
	local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart or not hand then return end

	-- Unweld and move fireball to workspace
	for _, weld in pairs(currentFireball:GetDescendants()) do
		if weld:IsA("WeldConstraint") then
			weld:Destroy()
		end
	end

	currentFireball.Parent = workspace
	currentFireball:PivotTo(hand.CFrame * CFrame.new(0, 0, -1))

	-- Launch forward
	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.Velocity = rootPart.CFrame.LookVector * 50
	bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVel.Parent = currentFireball.PrimaryPart

	Debris:AddItem(currentFireball, 3)
	currentFireball = nil
end)