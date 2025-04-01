local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")

-- Create main components
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")
local MenuDivider = Instance.new("Frame")

-- Stats Frame Components
local StatsFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local LevelLabel = Instance.new("TextLabel")
local HealthLabel = Instance.new("TextLabel")
local BelliLabel = Instance.new("TextLabel")
local FragmentsLabel = Instance.new("TextLabel")
local FightingStyleLabel = Instance.new("TextLabel")
local DevilFruitLabel = Instance.new("TextLabel")
local RaceLabel = Instance.new("TextLabel")
local SwordLabel = Instance.new("TextLabel")

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
TitleBar.Size = UDim2.new(1, 0, 0, 24)

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.Parent = TitleBar
titleBarCorner.CornerRadius = UDim.new(0, 8)

-- Title Text
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Info"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 185, 0)
MinimizeButton.Position = UDim2.new(1, -38, 0.5, -6)
MinimizeButton.Size = UDim2.new(0, 12, 0, 12)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 12
MinimizeButton.AutoButtonColor = true

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.Parent = MinimizeButton
minimizeCorner.CornerRadius = UDim.new(0, 4)

-- Close Button
CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -20, 0.5, -6)
CloseButton.Size = UDim2.new(0, 12, 0, 12)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.AutoButtonColor = true

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = CloseButton
closeCorner.CornerRadius = UDim.new(0, 4)

-- Menu Frame
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MenuFrame.Position = UDim2.new(0, 0, 0, 24)
MenuFrame.Size = UDim2.new(0, 75, 1, -24)

-- Add corner radius to MenuFrame
local menuCorner = Instance.new("UICorner")
menuCorner.Parent = MenuFrame
menuCorner.CornerRadius = UDim.new(0, 8)

-- Add a frame to cover the top corners of MenuFrame
local menuTopCover = Instance.new("Frame")
menuTopCover.Name = "MenuTopCover"
menuTopCover.Parent = MenuFrame
menuTopCover.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
menuTopCover.BorderSizePixel = 0
menuTopCover.Position = UDim2.new(0, 0, 0, 0)
menuTopCover.Size = UDim2.new(1, 0, 0, 10)

-- Content Frame
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ContentFrame.Position = UDim2.new(0, 75, 0, 24)
ContentFrame.Size = UDim2.new(1, -75, 1, -24)

-- Stats Frame
StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = ContentFrame
StatsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
StatsFrame.Size = UDim2.new(1, 0, 1, 0)

-- UI List Layout
UIListLayout.Parent = StatsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

-- Level Label
LevelLabel.Name = "LevelLabel"
LevelLabel.Parent = StatsFrame
LevelLabel.BackgroundTransparency = 1
LevelLabel.Position = UDim2.new(0, 0, 0, 0)
LevelLabel.Size = UDim2.new(1, 0, 0, 30)
LevelLabel.Font = Enum.Font.GothamMedium
LevelLabel.Text = "Level: 0"
LevelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
LevelLabel.TextSize = 12
LevelLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Health Label
HealthLabel.Name = "HealthLabel"
HealthLabel.Parent = StatsFrame
HealthLabel.BackgroundTransparency = 1
HealthLabel.Position = UDim2.new(0, 0, 0, 30)
HealthLabel.Size = UDim2.new(1, 0, 0, 30)
HealthLabel.Font = Enum.Font.GothamMedium
HealthLabel.Text = "Health: 0/0"
HealthLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
HealthLabel.TextSize = 12
HealthLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Belli Label
BelliLabel.Name = "BelliLabel"
BelliLabel.Parent = StatsFrame
BelliLabel.BackgroundTransparency = 1
BelliLabel.Position = UDim2.new(0, 0, 0, 60)
BelliLabel.Size = UDim2.new(1, 0, 0, 30)
BelliLabel.Font = Enum.Font.GothamMedium
BelliLabel.Text = "Beli: 0"
BelliLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
BelliLabel.TextSize = 12
BelliLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Fragments Label
FragmentsLabel.Name = "FragmentsLabel"
FragmentsLabel.Parent = StatsFrame
FragmentsLabel.BackgroundTransparency = 1
FragmentsLabel.Position = UDim2.new(0, 0, 0, 90)
FragmentsLabel.Size = UDim2.new(1, 0, 0, 30)
FragmentsLabel.Font = Enum.Font.GothamMedium
FragmentsLabel.Text = "Fragments: 0"
FragmentsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FragmentsLabel.TextSize = 12
FragmentsLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Fighting Style Label
FightingStyleLabel.Name = "FightingStyleLabel"
FightingStyleLabel.Parent = StatsFrame
FightingStyleLabel.BackgroundTransparency = 1
FightingStyleLabel.Position = UDim2.new(0, 0, 0, 120)
FightingStyleLabel.Size = UDim2.new(1, 0, 0, 30)
FightingStyleLabel.Font = Enum.Font.GothamMedium
FightingStyleLabel.Text = "Fighting Style: None"
FightingStyleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FightingStyleLabel.TextSize = 12
FightingStyleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Devil Fruit Label
DevilFruitLabel.Name = "DevilFruitLabel"
DevilFruitLabel.Parent = StatsFrame
DevilFruitLabel.BackgroundTransparency = 1
DevilFruitLabel.Position = UDim2.new(0, 0, 0, 150)
DevilFruitLabel.Size = UDim2.new(1, 0, 0, 30)
DevilFruitLabel.Font = Enum.Font.GothamMedium
DevilFruitLabel.Text = "Devil Fruit: None"
DevilFruitLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DevilFruitLabel.TextSize = 12
DevilFruitLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Race Label
RaceLabel.Name = "RaceLabel"
RaceLabel.Parent = StatsFrame
RaceLabel.BackgroundTransparency = 1
RaceLabel.Position = UDim2.new(0, 0, 0, 180)
RaceLabel.Size = UDim2.new(1, 0, 0, 30)
RaceLabel.Font = Enum.Font.GothamMedium
RaceLabel.Text = "Race: Unknown"
RaceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RaceLabel.TextSize = 12
RaceLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Sword Label
SwordLabel.Name = "SwordLabel"
SwordLabel.Parent = StatsFrame
SwordLabel.BackgroundTransparency = 1
SwordLabel.Position = UDim2.new(0, 0, 0, 210)
SwordLabel.Size = UDim2.new(1, 0, 0, 30)
SwordLabel.Font = Enum.Font.GothamMedium
SwordLabel.Text = "Swords: None"
SwordLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SwordLabel.TextSize = 12
SwordLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)

-- Update Function
local function updateStats()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            HealthLabel.Text = string.format("Health: %d/%d", humanoid.Health, humanoid.MaxHealth)
        end
    end
    
    -- Get player stats from leaderstats
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local level = leaderstats:FindFirstChild("Level")
        local beli = leaderstats:FindFirstChild("Beli")
        local fragments = leaderstats:FindFirstChild("Fragments")
        
        if level then
            LevelLabel.Text = string.format("Level: %s", level.Value)
        end
        if beli then
            BelliLabel.Text = string.format("Beli: %s", beli.Value)
        end
        if fragments then
            FragmentsLabel.Text = string.format("Fragments: %s", fragments.Value)
        end
    end
    
    -- Get race info
    local race = LocalPlayer:FindFirstChild("Race")
    if race then
        RaceLabel.Text = string.format("Race: %s", race.Value)
    else
        RaceLabel.Text = "Race: Unknown"
    end
    
    -- Get fighting style info
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if backpack and character then
        -- Check for fighting styles
        local fightingStyles = {}
        for _, item in pairs(backpack:GetChildren()) do
            if item:FindFirstChild("FightingStyle") then
                table.insert(fightingStyles, item.Name)
            end
        end
        for _, item in pairs(character:GetChildren()) do
            if item:FindFirstChild("FightingStyle") then
                table.insert(fightingStyles, item.Name)
            end
        end
        if #fightingStyles > 0 then
            FightingStyleLabel.Text = string.format("Fighting Style: %s", table.concat(fightingStyles, ", "))
        else
            FightingStyleLabel.Text = "Fighting Style: None"
        end
        
        -- Check for devil fruits
        local devilFruits = {}
        for _, item in pairs(backpack:GetChildren()) do
            if item:FindFirstChild("DevilFruit") then
                table.insert(devilFruits, item.Name)
            end
        end
        for _, item in pairs(character:GetChildren()) do
            if item:FindFirstChild("DevilFruit") then
                table.insert(devilFruits, item.Name)
            end
        end
        if #devilFruits > 0 then
            DevilFruitLabel.Text = string.format("Devil Fruit: %s", table.concat(devilFruits, ", "))
        else
            DevilFruitLabel.Text = "Devil Fruit: None"
        end
        
        -- Check for swords
        local swords = {}
        for _, item in pairs(backpack:GetChildren()) do
            if item:FindFirstChild("SwordTool") then
                table.insert(swords, item.Name)
            end
        end
        for _, item in pairs(character:GetChildren()) do
            if item:FindFirstChild("SwordTool") then
                table.insert(swords, item.Name)
            end
        end
        if #swords > 0 then
            SwordLabel.Text = string.format("Swords: %s", table.concat(swords, ", "))
        else
            SwordLabel.Text = "Swords: None"
        end
    end
end

-- Update loop
game:GetService("RunService").RenderStepped:Connect(updateStats)

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
