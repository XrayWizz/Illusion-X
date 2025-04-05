local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- UI Sound
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 0.7
clickSound.Parent = workspace

-- Main GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "RhinoHub"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 420, 0, 260)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 1
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Fade-in effect
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()

-- Drag support
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Title Bar
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Rhino Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local closeBtn = Instance.new("ImageButton", mainFrame)
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -30, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
closeBtn.Image = "rbxassetid://6031094678"
closeBtn.ImageColor3 = Color3.new(1, 1, 1)
closeBtn.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
local uiStroke = Instance.new("UIStroke", closeBtn)
uiStroke.Thickness = 1.2
uiStroke.Color = Color3.fromRGB(255, 0, 0)

-- Sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

-- Overview Button
local overviewBtn = Instance.new("TextButton", sidebar)
overviewBtn.Size = UDim2.new(1, -10, 0, 36)
overviewBtn.Position = UDim2.new(0, 5, 0, 10)
overviewBtn.Text = "Overview"
overviewBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
overviewBtn.Font = Enum.Font.Gotham
overviewBtn.TextSize = 15
overviewBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", overviewBtn).CornerRadius = UDim.new(0, 8)

-- Content Frame
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -100, 1, -40)
contentFrame.Position = UDim2.new(0, 100, 0, 40)
contentFrame.BackgroundTransparency = 1

-- Overview Tab
local overviewTab = Instance.new("Frame", contentFrame)
overviewTab.Size = UDim2.new(1, 0, 1, 0)
overviewTab.BackgroundTransparency = 1

local healthLabel = Instance.new("TextLabel", overviewTab)
healthLabel.Size = UDim2.new(1, -20, 0, 30)
healthLabel.Position = UDim2.new(0, 10, 0, 10)
healthLabel.BackgroundTransparency = 1
healthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
healthLabel.Font = Enum.Font.Gotham
healthLabel.TextSize = 16
healthLabel.TextXAlignment = Enum.TextXAlignment.Left

local energyLabel = healthLabel:Clone()
energyLabel.Parent = overviewTab
energyLabel.Position = UDim2.new(0, 10, 0, 50)

local statusLabel = healthLabel:Clone()
statusLabel.Parent = overviewTab
statusLabel.Position = UDim2.new(0, 10, 0, 90)

-- Tab System
local function switchTab(tab)
	for _, child in pairs(contentFrame:GetChildren()) do
		if child:IsA("Frame") then
			child.Visible = false
		end
	end
	tab.Visible = true
end

overviewBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
	energyLabel.Text = "Energy: " .. tostring(player:GetAttribute("Energy") or "N/A")
	statusLabel.Text = "Status: " .. (player:GetAttribute("InGame") and "In Game" or "Idle")
	switchTab(overviewTab)
end)

closeBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	mainFrame.Visible = false
end)

-- Show default tab
switchTab(overviewTab)