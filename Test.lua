local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")

-- Create main components
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")
local MenuDivider = Instance.new("Frame")

-- Stats Frame Components
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
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = MainFrame
mainCorner.CornerRadius = UDim.new(0, 8)

-- Title Bar Setup
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.Parent = TitleBar
titleBarCorner.CornerRadius = UDim.new(0, 8)

-- Make title bar draggable
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragStart then
        update(input)
    end
end)

-- Title Setup
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Info"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -25, 0.5, -8)
CloseButton.Size = UDim2.new(0, 16, 0, 16)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = true

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = CloseButton
closeCorner.CornerRadius = UDim.new(0, 4)

-- Menu Frame (Left side)
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MenuFrame.Position = UDim2.new(0, 0, 0, 30)
MenuFrame.Size = UDim2.new(0, 100, 1, -30)

local menuLayout = Instance.new("UIListLayout")
menuLayout.Parent = MenuFrame
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0, 5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 100, 0, 30)
MenuDivider.Size = UDim2.new(0, 1, 1, -30)

-- Content Frame (Right side)
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 110, 0, 35)
ContentFrame.Size = UDim2.new(1, -120, 1, -45)

-- Create Menu Button
local function CreateMenuButton(name)
    local button = Instance.new("TextButton")
    button.Name = name.."Button"
    button.Parent = MenuFrame
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    return button
end

-- Add padding to menu
local menuPadding = Instance.new("UIPadding")
menuPadding.Parent = MenuFrame
menuPadding.PaddingTop = UDim.new(0, 10)

-- Create menu buttons
local menuButtons = {
    CreateMenuButton("Stats"),
    CreateMenuButton("Inventory"),
    CreateMenuButton("Settings")
}

-- Stats Frame Setup
StatsFrame.Parent = ContentFrame
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

-- Menu Button Handlers
menuButtons[1].BackgroundColor3 = Color3.fromRGB(65, 65, 65)  -- Active button
menuButtons[1].MouseButton1Click:Connect(function()
    StatsFrame.Visible = true
    menuButtons[1].BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    menuButtons[2].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    menuButtons[3].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
end)

menuButtons[2].MouseButton1Click:Connect(function()
    StatsFrame.Visible = false
    menuButtons[1].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    menuButtons[2].BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    menuButtons[3].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    -- Add inventory frame logic here
end)

menuButtons[3].MouseButton1Click:Connect(function()
    StatsFrame.Visible = false
    menuButtons[1].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    menuButtons[2].BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    menuButtons[3].BackgroundColor3 = Color3.fromRGB(65, 65, 65)
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
