-- StarterGui > ScreenGui > LocalScript

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local stats = player:WaitForChild("Data") -- Adjust if using different stat system

-- UI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "RhinoHub"
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainFrame"
mainFrame.Visible = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundTransparency = 0
mainFrame.ZIndex = 1
mainFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY
mainFrame:SetAttribute("UIScale", 1)

-- Corner
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("TextLabel", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 0.2
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Text = "Rhino Hub"
titleBar.Font = Enum.Font.GothamBold
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.TextSize = 20
titleBar.Name = "TitleBar"

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Close Button
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Name = "CloseBtn"

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Side Menu
local sideMenu = Instance.new("Frame", mainFrame)
sideMenu.Size = UDim2.new(0, 120, 1, -40)
sideMenu.Position = UDim2.new(0, 0, 0, 40)
sideMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", sideMenu).CornerRadius = UDim.new(0, 10)

-- Buttons
local overviewBtn = Instance.new("TextButton", sideMenu)
overviewBtn.Size = UDim2.new(1, -10, 0, 40)
overviewBtn.Position = UDim2.new(0, 5, 0, 10)
overviewBtn.Text = "Overview"
overviewBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
overviewBtn.TextColor3 = Color3.new(1, 1, 1)
overviewBtn.Font = Enum.Font.Gotham
overviewBtn.TextSize = 16
Instance.new("UICorner", overviewBtn).CornerRadius = UDim.new(0, 8)

local settingsBtn = overviewBtn:Clone()
settingsBtn.Text = "Settings"
settingsBtn.Position = UDim2.new(0, 5, 0, 60)
settingsBtn.Parent = sideMenu

-- Pages
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -130, 1, -50)
contentFrame.Position = UDim2.new(0, 130, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Name = "ContentFrame"

-- Overview Panel
local overviewPage = Instance.new("TextLabel", contentFrame)
overviewPage.Size = UDim2.new(1, 0, 1, 0)
overviewPage.BackgroundTransparency = 1
overviewPage.TextColor3 = Color3.new(1, 1, 1)
overviewPage.TextSize = 16
overviewPage.TextXAlignment = Enum.TextXAlignment.Left
overviewPage.TextYAlignment = Enum.TextYAlignment.Top
overviewPage.Font = Enum.Font.Gotham
overviewPage.TextWrapped = true
overviewPage.Text = ""
overviewPage.Name = "OverviewPage"

-- Settings Panel
local settingsPage = Instance.new("Frame", contentFrame)
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false

local sizeOptions = {"Small", "Medium", "Large"}
for i, name in ipairs(sizeOptions) do
	local sizeBtn = Instance.new("TextButton", settingsPage)
	sizeBtn.Size = UDim2.new(0, 120, 0, 35)
	sizeBtn.Position = UDim2.new(0, 10, 0, (i - 1) * 45)
	sizeBtn.Text = name
	sizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	sizeBtn.TextColor3 = Color3.new(1, 1, 1)
	sizeBtn.Font = Enum.Font.Gotham
	sizeBtn.TextSize = 16
	Instance.new("UICorner", sizeBtn).CornerRadius = UDim.new(0, 8)

	sizeBtn.MouseButton1Click:Connect(function()
		local scale = name == "Small" and 0.75 or name == "Large" and 1.25 or 1
		mainFrame:SetAttribute("UIScale", scale)
		mainFrame.Size = UDim2.new(0, 500 * scale, 0, 300 * scale)
	end)
end

-- Page switching
overviewBtn.MouseButton1Click:Connect(function()
	overviewPage.Visible = true
	settingsPage.Visible = false
end)

settingsBtn.MouseButton1Click:Connect(function()
	overviewPage.Visible = false
	settingsPage.Visible = true
end)

-- Live Updating Player Stats
local function updateStats()
	while overviewPage.Visible and mainFrame.Visible do
		local info = {}
		table.insert(info, "Name: " .. player.Name)
		table.insert(info, "Health: " .. math.floor(char:FindFirstChild("Humanoid") and char.Humanoid.Health or 0))
		table.insert(info, "Energy: " .. (stats:FindFirstChild("Energy") and stats.Energy.Value or "N/A"))
		table.insert(info, "Beli: " .. (stats:FindFirstChild("Beli") and stats.Beli.Value or "N/A"))
		table.insert(info, "Fragments: " .. (stats:FindFirstChild("Fragments") and stats.Fragments.Value or "N/A"))
		table.insert(info, "Fighting Style: " .. (stats:FindFirstChild("FightingStyle") and stats.FightingStyle.Value or "N/A"))
		table.insert(info, "Devil Fruit: " .. (stats:FindFirstChild("Fruit") and stats.Fruit.Value or "N/A"))

		overviewPage.Text = table.concat(info, "\n")
		wait(1)
	end
end

overviewBtn.MouseButton1Click:Connect(updateStats)

-- Optional: Toggle keybind (mobile tip: add a button in-game to show Rhino Hub)
-- local toggleKey = Enum.KeyCode.RightControl
-- game:GetService("UserInputService").InputBegan:Connect(function(input)
-- 	if input.KeyCode == toggleKey then
-- 		mainFrame.Visible = not mainFrame.Visible
-- 	end
-- end)