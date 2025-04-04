-- UI Setup
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "ShadedShadowUI"
screenGui.ResetOnSpawn = false

-- Main Frame
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
mainFrame.AutomaticSize = Enum.AutomaticSize.None
mainFrame.Visible = true
mainFrame.Parent = screenGui
mainFrame:TweenSize(mainFrame.Size, "Out", "Sine", 0.3)

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

-- Minimize & Close
local function createButton(name, pos, txt)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = txt
	btn.Size = UDim2.new(0, 25, 0, 25)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Parent = mainFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local closeBtn = createButton("CloseBtn", UDim2.new(1, -30, 0, 5), "X")
local minimizeBtn = createButton("MinimizeBtn", UDim2.new(1, -60, 0, 5), "-")

-- Toggle visibility
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

-- Fireball Setup
local function createFireball()
	local char = player.Character or player.CharacterAdded:Wait()
	local fireball = Instance.new("Part")
	fireball.Size = Vector3.new(1.5, 1.5, 1.5)
	fireball.Shape = Enum.PartType.Ball
	fireball.Material = Enum.Material.Neon
	fireball.Color = Color3.fromRGB(255, 80, 0)
	fireball.Anchored = false
	fireball.CanCollide = false

	local att = Instance.new("Attachment", fireball)
	local fire = Instance.new("ParticleEmitter", att)
	fire.Texture = "rbxassetid://244221613"
	fire.Lifetime = NumberRange.new(0.4, 0.6)
	fire.Speed = NumberRange.new(0, 0)
	fire.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(1, 0)})
	fire.Rate = 30
	fire.LightEmission = 1
	fire.Color = ColorSequence.new(Color3.new(1, 0.4, 0))

	local sound = Instance.new("Sound", fireball)
	sound.SoundId = "rbxassetid://203691822" -- Fire loop
	sound.Volume = 0.5
	sound.Looped = true
	sound:Play()

	fireball.Parent = workspace

	local alignPos = Instance.new("AlignPosition", fireball)
	alignPos.MaxForce = 20000
	alignPos.Responsiveness = 100
	alignPos.RigidityEnabled = false

	local attach0 = Instance.new("Attachment", fireball)
	local attach1 = Instance.new("Attachment", char:WaitForChild("Head"))
	alignPos.Attachment0 = attach0
	alignPos.Attachment1 = attach1
	alignPos.Position = Vector3.new(1.5, 1.5, 0)

	return fireball
end

local fireballSpawned = false
fireBtn.MouseButton1Click:Connect(function()
	if not fireballSpawned then
		createFireball()
		fireBtn.Text = "Fireball Enabled"
		fireballSpawned = true
	end
end)