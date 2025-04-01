local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ContentArea = Instance.new("Frame")

-- Side Menu Components
local SideMenu = Instance.new("Frame")
local SideMenuLayout = Instance.new("UIListLayout")
local MenuDivider = Instance.new("Frame")

-- Content Frames
local StatsFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local LevelLabel = Instance.new("TextLabel")
local HealthLabel = Instance.new("TextLabel")
local BelliLabel = Instance.new("TextLabel")

-- GUI Setup
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame Setup
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)  -- Centered
MainFrame.Size = UDim2.new(0, 400, 0, 300)  -- Wider to accommodate side menu
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)

-- Title Bar
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(1, -45, 0, 25)
Title.Font = Enum.Font.GothamBold
Title.Text = "Player Info"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = true

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.Parent = CloseButton
closeButtonCorner.CornerRadius = UDim.new(0, 4)

-- Side Menu (Left side of main frame)
SideMenu.Name = "SideMenu"
SideMenu.Parent = MainFrame
SideMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SideMenu.Position = UDim2.new(0, 0, 0, 35)
SideMenu.Size = UDim2.new(0, 120, 1, -35)

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 120, 0, 35)
MenuDivider.Size = UDim2.new(0, 1, 1, -35)

-- Content Area (Right side of main frame)
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 130, 0, 35)
ContentArea.Size = UDim2.new(1, -140, 1, -45)

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

-- Stats Frame Setup
StatsFrame.Parent = ContentArea
StatsFrame.BackgroundTransparency = 1
StatsFrame.Size = UDim2.new(1, 0, 1, 0)
StatsFrame.Visible = true

UIListLayout.Parent = StatsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Stats Labels
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

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

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
