-- One-file working fireball script for mobile
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Wait for character and PlayerGui
local function waitForCharacterAndGui()
	local char = player.Character or player.CharacterAdded:Wait()
	local gui = player:WaitForChild("PlayerGui")
	return char, gui
end

-- Setup buttons in PlayerGui
local function setupUI(gui)
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FireballUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = gui

	local function createButton(text, position, color)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 100, 0, 50)
		btn.Position = position
		btn.Text = text
		btn.BackgroundColor3 = color
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 20
		btn.AutoButtonColor = true
		btn.Parent = screenGui
		return btn
	end

	local igniteBtn = createButton("Ignite", UDim2.new(0.05, 0, 0.8, 0), Color3.fromRGB(255, 140, 0))
	local throwBtn = createButton("Throw", UDim2.new(0.2, 0, 0.8, 0), Color3.fromRGB(255, 50, 50))

	return igniteBtn, throwBtn
end

local function main()
	local character, gui = waitForCharacterAndGui()
	local fireTemplate = ReplicatedStorage:WaitForChild("FireEffect")
	local igniteBtn, throwBtn = setupUI(gui)
	local currentFireball = nil

	igniteBtn.MouseButton1Click:Connect(function()
		character = player.Character or player.CharacterAdded:Wait()
		local hand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
		if not hand or currentFireball then return end

		local fire = fireTemplate:Clone()
		fire.Name = "Fireball"
		fire:SetPrimaryPartCFrame(hand.CFrame)
		fire.PrimaryPart.Anchored = false
		fire.Parent = hand

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = fire.PrimaryPart
		weld.Part1 = hand
		weld.Parent = fire.PrimaryPart

		currentFireball = fire
	end)

	throwBtn.MouseButton1Click:Connect(function()
		if not currentFireball or not currentFireball.PrimaryPart then return end
		character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then return end

		-- Detach from hand
		for _, weld in pairs(currentFireball:GetDescendants()) do
			if weld:IsA("WeldConstraint") then
				weld:Destroy()
			end
		end

		currentFireball.Parent = workspace
		currentFireball:PivotTo(root.CFrame * CFrame.new(0, 0, -1))

		local bodyVel = Instance.new("BodyVelocity")
		bodyVel.Velocity = root.CFrame.LookVector * 50
		bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bodyVel.Parent = currentFireball.PrimaryPart

		Debris:AddItem(currentFireball, 3)
		currentFireball = nil
	end)
end

-- Run everything
main()