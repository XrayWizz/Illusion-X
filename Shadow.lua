-- Mobile + Elite Fireball by ChatGPT
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local userInput = game:GetService("UserInputService")
local debris = game:GetService("Debris")

-- Screen GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ShadedShadowUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main UI
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Title
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, -10, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.Text = "Shaded Shadow"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Buttons
local function createButton(name, pos, txt, parent)
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
	btn.Parent = parent
	return btn
end

local closeBtn = createButton("CloseBtn", UDim2.new(1, -30, 0, 5), "X", mainFrame)
local minimizeBtn = createButton("MinimizeBtn", UDim2.new(1, -60, 0, 5), "-", mainFrame)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 250, 0, 50) or UDim2.new(0, 250, 0, 300)
end)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Enable Button
local fireBtn = Instance.new("TextButton", mainFrame)
fireBtn.Size = UDim2.new(0.8, 0, 0, 40)
fireBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
fireBtn.Text = "Enable Fireball"
fireBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fireBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fireBtn.Font = Enum.Font.GothamBold
fireBtn.TextSize = 18
Instance.new("UICorner", fireBtn).CornerRadius = UDim.new(0, 10)

-- Mobile Throw Button
local throwBtn = Instance.new("TextButton", screenGui)
throwBtn.Size = UDim2.new(0, 120, 0, 50)
throwBtn.Position = UDim2.new(1, -140, 1, -70)
throwBtn.AnchorPoint = Vector2.new(0, 0)
throwBtn.Text = "THROW"
throwBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
throwBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
throwBtn.Font = Enum.Font.GothamBold
throwBtn.TextSize = 20
Instance.new("UICorner", throwBtn).CornerRadius = UDim.new(0, 16)
throwBtn.Visible = false

-- Fire logic
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
			fire.Lifetime = NumberRange.new(0.2, 0.3)
			fire.Speed = NumberRange.new(1, 3)
			fire.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
			fire.Rate = 100
			fire.LightEmission = 1
			fire.Color = ColorSequence.new(Color3.new(1, 0.4, 0), Color3.new(1, 1, 0))

			local light = Instance.new("PointLight", hand)
			light.Color = Color3.fromRGB(255, 100, 0)
			light.Range = 6
			light.Brightness = 2

			table.insert(handFires, att)
		end
	end

	canThrow = true
	throwBtn.Visible = true
end

local function throwFireball()
	if not canThrow then return end
	local char = player.Character or player.CharacterAdded:Wait()
	local head = char:FindFirstChild("Head")
	if not head then return end

	local fireball = Instance.new("Part")
	fireball.Size = Vector3.new(1.5, 1.5, 1.5)
	fireball.Shape = Enum.PartType.Ball
	fireball.Material = Enum.Material.Neon
	fireball.BrickColor = BrickColor.new("Bright orange")
	fireball.CFrame = head.CFrame * CFrame.new(0, 0, -2)
	fireball.Velocity = head.CFrame.LookVector * 80
	fireball.CanCollide = false
	fireball.Anchored = false
	fireball.Parent = workspace

	-- Fire
	local fire = Instance.new("ParticleEmitter", fireball)
	fire.Texture = "rbxassetid://244221613"
	fire.Lifetime = NumberRange.new(0.2, 0.4)
	fire.Speed = NumberRange.new(2, 5)
	fire.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0)})
	fire.Rate = 150
	fire.LightEmission = 1
	fire.Color = ColorSequence.new(Color3.new(1, 0.5, 0), Color3.new(1, 1, 0))

	-- Smoke
	local smoke = Instance.new("ParticleEmitter", fireball)
	smoke.Texture = "rbxassetid://771221224"
	smoke.Lifetime = NumberRange.new(0.5, 1)
	smoke.Rate = 20
	smoke.Size = NumberSequence.new(1.5)
	smoke.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1)})
	smoke.Speed = NumberRange.new(0, 0.5)
	smoke.Color = ColorSequence.new(Color3.new(0.1, 0.1, 0.1))
	smoke.Rotation = NumberRange.new(0, 360)

	-- Fireball sound
	local sound = Instance.new("Sound", fireball)
	sound.SoundId = "rbxassetid://1840882422" -- looping fire crackle
	sound.Volume = 0.7
	sound.Looped = true
	sound:Play()

	debris:AddItem(fireball, 3)
end

-- Button actions
local fireballSpawned = false
fireBtn.MouseButton1Click:Connect(function()
	if not fireballSpawned then
		addHandFire()
		fireBtn.Text = "Fire Ready!"
		fireballSpawned = true
	end
end)

throwBtn.MouseButton1Click:Connect(function()
	throwFireball()
end)