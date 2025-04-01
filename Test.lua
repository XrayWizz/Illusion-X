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

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)

-- Create Section Header
local function CreateSectionHeader(text)
    local header = Instance.new("Frame")
    header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    header.Size = UDim2.new(1, 0, 0, 24)
    
    local headerLabel = Instance.new("TextLabel")
    headerLabel.Parent = header
    headerLabel.BackgroundTransparency = 1
    headerLabel.Position = UDim2.new(0, 8, 0, 0)
    headerLabel.Size = UDim2.new(1, -16, 1, 0)
    headerLabel.Font = Enum.Font.GothamBold
    headerLabel.Text = text
    headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerLabel.TextSize = 11
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.Parent = header
    headerCorner.CornerRadius = UDim.new(0, 4)
    
    return header
end

-- Create Section Content
local function CreateSection()
    local section = Instance.new("Frame")
    section.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    section.Size = UDim2.new(1, 0, 0, 0) -- Will be set dynamically
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.Parent = section
    sectionCorner.CornerRadius = UDim.new(0, 4)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = section
    contentPadding.PaddingTop = UDim.new(0, 4)
    contentPadding.PaddingBottom = UDim.new(0, 4)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)
    
    local contentList = Instance.new("UIListLayout")
    contentList.Parent = section
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 2)
    
    return section, contentList
end

-- Create Info Label
local function CreateInfoLabel(text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Stats Frame Setup
local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = ContentFrame
StatsFrame.BackgroundTransparency = 1
StatsFrame.Size = UDim2.new(1, -8, 1, 0)

-- Create sections
local basicInfoHeader = CreateSectionHeader("Basic Info")
basicInfoHeader.Parent = StatsFrame
basicInfoHeader.LayoutOrder = 0

local basicInfoSection, basicInfoList = CreateSection()
basicInfoSection.Parent = StatsFrame
basicInfoSection.LayoutOrder = 1

local combatHeader = CreateSectionHeader("Combat")
combatHeader.Parent = StatsFrame
combatHeader.LayoutOrder = 2

local combatSection, combatList = CreateSection()
combatSection.Parent = StatsFrame
combatSection.LayoutOrder = 3

local equipmentHeader = CreateSectionHeader("Equipment")
equipmentHeader.Parent = StatsFrame
equipmentHeader.LayoutOrder = 4

local equipmentSection, equipmentList = CreateSection()
equipmentSection.Parent = StatsFrame
equipmentSection.LayoutOrder = 5

-- Create and organize labels
local LevelLabel = CreateInfoLabel("Level: 0")
LevelLabel.Parent = basicInfoSection
LevelLabel.LayoutOrder = 0

local RaceLabel = CreateInfoLabel("Race: Unknown")
RaceLabel.Parent = basicInfoSection
RaceLabel.LayoutOrder = 1

local BelliLabel = CreateInfoLabel("Beli: 0")
BelliLabel.Parent = basicInfoSection
BelliLabel.LayoutOrder = 2

local FragmentsLabel = CreateInfoLabel("Fragments: 0")
FragmentsLabel.Parent = basicInfoSection
FragmentsLabel.LayoutOrder = 3

local HealthLabel = CreateInfoLabel("Health: 0/0")
HealthLabel.Parent = combatSection
HealthLabel.LayoutOrder = 0

local FightingStyleLabel = CreateInfoLabel("Fighting Style: None")
FightingStyleLabel.Parent = combatSection
FightingStyleLabel.LayoutOrder = 1

local DevilFruitLabel = CreateInfoLabel("Devil Fruit: None")
DevilFruitLabel.Parent = combatSection
DevilFruitLabel.LayoutOrder = 2

local SwordLabel = CreateInfoLabel("Swords: None")
SwordLabel.Parent = equipmentSection
SwordLabel.LayoutOrder = 0

-- Update section sizes
local function updateSectionSizes()
    local function updateSection(section, list)
        local contentSize = list.AbsoluteContentSize
        section.Size = UDim2.new(1, 0, 0, contentSize.Y + 8)
    end
    
    updateSection(basicInfoSection, basicInfoList)
    updateSection(combatSection, combatList)
    updateSection(equipmentSection, equipmentList)
end

-- Connect size updates
basicInfoList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)
combatList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)
equipmentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)

-- Update spacing
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = StatsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

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
