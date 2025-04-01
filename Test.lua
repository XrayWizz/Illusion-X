local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local StatsFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local LevelLabel = Instance.new("TextLabel")
local HealthLabel = Instance.new("TextLabel")
local BelliLabel = Instance.new("TextLabel")

-- Side Menu
local SideMenu = Instance.new("Frame")
local SideMenuUICorner = Instance.new("UICorner")
local SideMenuLayout = Instance.new("UIListLayout")
local Button1 = Instance.new("TextButton")
local Button2 = Instance.new("TextButton")
local Button3 = Instance.new("TextButton")

-- GUI Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Side Menu Setup
SideMenu.Name = "SideMenu"
SideMenu.Parent = ScreenGui
SideMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SideMenu.Position = UDim2.new(0, 10, 0.3, 0)
SideMenu.Size = UDim2.new(0, 120, 0, 200)
SideMenu.Active = true
SideMenu.Draggable = true

SideMenuUICorner.Parent = SideMenu
SideMenuUICorner.CornerRadius = UDim.new(0, 8)

SideMenuLayout.Parent = SideMenu
SideMenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideMenuLayout.Padding = UDim.new(0, 5)
SideMenuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Create Side Menu Buttons
local function CreateMenuButton(name)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = SideMenu
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    return button
end

-- Add buttons with padding at the top
local padding = Instance.new("UIPadding")
padding.Parent = SideMenu
padding.PaddingTop = UDim.new(0, 10)

local menuButtons = {
    CreateMenuButton("Stats"),
    CreateMenuButton("Inventory"),
    CreateMenuButton("Settings")
}

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)

Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, -25, 0, 25)  -- Adjusted for close button
Title.Font = Enum.Font.GothamBold
Title.Text = "Player Info"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = true

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.Parent = CloseButton
closeButtonCorner.CornerRadius = UDim.new(0, 4)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

StatsFrame.Parent = MainFrame
StatsFrame.BackgroundTransparency = 1
StatsFrame.Position = UDim2.new(0, 10, 0, 35)
StatsFrame.Size = UDim2.new(1, -20, 1, -45)

UIListLayout.Parent = StatsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

LevelLabel.Parent = StatsFrame
LevelLabel.BackgroundTransparency = 1
LevelLabel.Size = UDim2.new(1, 0, 0, 25)
LevelLabel.Font = Enum.Font.Gotham
LevelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelLabel.TextSize = 14
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left

HealthLabel.Parent = StatsFrame
HealthLabel.BackgroundTransparency = 1
HealthLabel.Size = UDim2.new(1, 0, 0, 25)
HealthLabel.Font = Enum.Font.Gotham
HealthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HealthLabel.TextSize = 14
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left

BelliLabel.Parent = StatsFrame
BelliLabel.BackgroundTransparency = 1
BelliLabel.Size = UDim2.new(1, 0, 0, 25)
BelliLabel.Font = Enum.Font.Gotham
BelliLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BelliLabel.TextSize = 14
BelliLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Button Click Handlers
menuButtons[1].MouseButton1Click:Connect(function()
    StatsFrame.Visible = true
    -- Add other visibility toggles here for future frames
end)

menuButtons[2].MouseButton1Click:Connect(function()
    StatsFrame.Visible = false
    -- Add inventory frame logic here
end)

menuButtons[3].MouseButton1Click:Connect(function()
    StatsFrame.Visible = false
    -- Add settings frame logic here
end)

-- Update Function
local function updateStats()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            HealthLabel.Text = string.format("Health: %d/%d", humanoid.Health, humanoid.MaxHealth)
        end
    end
    
    -- Get player level and beli from leaderstats if available
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local level = leaderstats:FindFirstChild("Level")
        local beli = leaderstats:FindFirstChild("Beli")
        
        if level then
            LevelLabel.Text = string.format("Level: %s", level.Value)
        end
        if beli then
            BelliLabel.Text = string.format("Beli: %s", beli.Value)
        end
    end
end

-- Update loop
game:GetService("RunService").RenderStepped:Connect(updateStats)
