--[[
    SHADOWED SHADOW UI + FIREBALL SYSTEM
    - Fire in both hands
    - Fireball throw with key (F)
    - Modern dark UI
    - Fire sounds + particle FX
]]

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInput = game:GetService("UserInputService")
local debris = game:GetService("Debris")

-- Screen UI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ShadedShadowUI"
screenGui.ResetOnSpawn = false

-- Main UI Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.ClipsDescendants = true
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.Visible = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Text = "Shaded Shadow"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Utility function
local function createButton(name, pos, txt)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = txt
	btn.Size = UDim2.new(0, 25, 0, 25)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.Parent = mainFrame
	return btn
end

-- Close & Minimize
local closeBtn = createButton("CloseBtn", UDim2.new(1, -30, 0, 5), "X")
local minimizeBtn = createButton("MinimizeBtn", UDim2.new(1, -60, 0, 5), "-")

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 250, 0, 50) or UDim2.new(0, 250, 0, 300)
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Fireball Button
local fireBtn = Instance.new("TextButton", mainFrame)
fireBtn.Size = UDim2.new(0.8, 0, 0, 40)
fireBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
fireBtn.Text = "Enable Fireball"
fireBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fireBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fireBtn.Font = Enum.Font.GothamBold
fireBtn.TextSize = 18
Instance.new("UICorner", fireBtn).CornerRadius = UDim.new(0, 10)

-- Fire system logic
local handFires = {}
local canThrow = false

local function addHandFire()
	local char = player.Character or player.CharacterAdded:Wait()
	local hands = {"LeftHand", "RightHand"}

	for _, handName in ipairs(hands) do
		local hand = char:FindFirstChild(handName)
		if hand then
			local att = Instance.new("Attachment", hand)

			local fire = Instance.new("ParticleEmitter", att)
			fire.Texture = "rbxassetid://244221613"
			fire.Lifetime = NumberRange.new(0.3, 0.6)
			fire.Speed = NumberRange.new(2, 5)
			fire.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 0)})
			fire.Rate = 100
			fire.LightEmission = 1
			fire.Color = ColorSequence.new(Color3.new(1, 0.3, 0), Color3.new(1, 1, 0))

			local light = Instance.new("PointLight", hand)
			light.Color = Color3.fromRGB(255, 100, 0)
			light.Range = 6
			light.Brightness = 2

			table.insert(handFires, att)
		end
	end

	canThrow = true
end

local function throwFireball()
	if not canThrow then return end
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:FindFirstChild("Head")
	if not head then return end

	local fireball = Instance.new("Part")
	fireball.Size = Vector3.new(2, 2, 2)
	fireball.Shape = Enum.PartType.Ball
	fireball.Material = Enum.Material.Neon
	fireball.BrickColor = BrickColor.new("Bright orange")
	fireball.CFrame = head.CFrame * CFrame.new(0, 0, -2)
	fireball.Velocity = head.CFrame.LookVector * 80
	fireball.CanCollide = false
	fireball.Anchored = false
	fireball.Parent = workspace

	local fire = Instance.new("ParticleEmitter", fireball)
	fire.Texture = "rbxassetid://244221613"
	fire.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 3), NumberSequenceKeypoint.new(1, 0)})
	fire.Lifetime = NumberRange.new(0.3, 0.5)
	fire.Rate = 150
	fire.LightEmission = 1
	fire.Color = ColorSequence.new(Color3.new(1, 0.5, 0), Color3.new(1, 1, 0))

	local sound = Instance.new("Sound", fireball)
	sound.SoundId = "rbxassetid://203691822"
	sound.Volume = 1
	sound:Play()

	debris:AddItem(fireball, 3)
end

-- Key bind: Press F to throw fireball
userInput.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		throwFireball()
	end
end)

-- Fire button clicked
local fireballSpawned = false
fireBtn.MouseButton1Click:Connect(function()
	if not fireballSpawned then
		addHandFire()
		fireBtn.Text = "Fire Ready - Press F"
		fireballSpawned = true
	end
end)