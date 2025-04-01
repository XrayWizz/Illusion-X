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

-- Bubble components
local BubbleButton = Instance.new("ImageButton")
local BubbleIcon = Instance.new("ImageLabel")

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

-- Bubble Setup
BubbleButton.Name = "BubbleButton"
BubbleButton.Parent = ScreenGui
BubbleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
BubbleButton.Position = UDim2.new(0.85, 0, 0.5, 0)
BubbleButton.Size = UDim2.new(0, 50, 0, 50)
BubbleButton.Visible = false
BubbleButton.AutoButtonColor = true

local bubbleCorner = Instance.new("UICorner")
bubbleCorner.Parent = BubbleButton
bubbleCorner.CornerRadius = UDim.new(1, 0)  -- Makes it perfectly circular

BubbleIcon.Parent = BubbleButton
BubbleIcon.BackgroundTransparency = 1
BubbleIcon.Position = UDim2.new(0.5, -15, 0.5, -15)
BubbleIcon.Size = UDim2.new(0, 30, 0, 30)
BubbleIcon.Image = "rbxassetid://6034983772"  -- Pirate flag icon
BubbleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

-- Animation settings
local minimizeInfo = TweenInfo.new(
    0.3,  -- Time
    Enum.EasingStyle.Back,  -- Style
    Enum.EasingDirection.In  -- Direction
)

local expandInfo = TweenInfo.new(
    0.3,  -- Time
    Enum.EasingStyle.Back,  -- Style
    Enum.EasingDirection.Out  -- Direction
)

-- Main Frame Setup
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.ClipsDescendants = true  -- Prevent content from overflowing

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = MainFrame
mainCorner.CornerRadius = UDim.new(0, 8)

-- Title Bar Setup
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.Size = UDim2.new(1, 0, 0, 24)  -- Smaller height

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.Parent = TitleBar
titleBarCorner.CornerRadius = UDim.new(0, 8)

-- Title Setup
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 0)  -- Less padding
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Info"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12  -- Smaller text
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 185, 0)  -- Yellow color
MinimizeButton.Position = UDim2.new(1, -38, 0.5, -6)  -- Adjusted position
MinimizeButton.Size = UDim2.new(0, 12, 0, 12)  -- Smaller button
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 12  -- Smaller text
MinimizeButton.AutoButtonColor = true

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.Parent = MinimizeButton
minimizeCorner.CornerRadius = UDim.new(0, 4)

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -20, 0.5, -6)  -- Adjusted position
CloseButton.Size = UDim2.new(0, 12, 0, 12)  -- Smaller button
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12  -- Smaller text
CloseButton.AutoButtonColor = true

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = CloseButton
closeCorner.CornerRadius = UDim.new(0, 4)

-- Content Frame Setup
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 80, 0, 28)
ContentFrame.Size = UDim2.new(1, -85, 1, -32)
ContentFrame.ClipsDescendants = true

-- Create Scrolling Frame for Content
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Parent = ContentFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Size = UDim2.new(1, -4, 1, 0)  -- Slightly smaller width for scrollbar
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Will be updated dynamically
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.ScrollBarImageTransparency = 0.7
ScrollingFrame.BorderSizePixel = 0

-- Stats Frame now goes inside ScrollingFrame
StatsFrame.Parent = ScrollingFrame
StatsFrame.Size = UDim2.new(1, -8, 1, 0)  -- Add padding for scrollbar

-- Make only title bar draggable
local function makeTitleBarDraggable()
    local dragToggle = nil
    local dragSpeed = 0.1
    local dragStart = nil
    local startPos = nil

    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        -- Create smooth drag animation
        local tweenInfo = TweenInfo.new(dragSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(MainFrame, tweenInfo, {Position = position}):Play()
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

-- Function to update ScrollingFrame canvas size
local function updateCanvasSize()
    local contentSize = UIListLayout.AbsoluteContentSize
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 8)  -- Add padding
end

-- Connect the canvas size update
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

-- Initialize dragging
makeTitleBarDraggable()

-- Menu Frame (Left side)
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

-- Create Info Item Function
local function CreateInfoItem(label, defaultValue)
    local container = Instance.new("Frame")
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    container.Size = UDim2.new(1, 0, 0, 28)
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.Parent = container
    containerCorner.CornerRadius = UDim.new(0, 4)
    
    -- Label
    local labelText = Instance.new("TextLabel")
    labelText.Parent = container
    labelText.BackgroundTransparency = 1
    labelText.Position = UDim2.new(0, 8, 0, 0)
    labelText.Size = UDim2.new(0.4, -8, 1, 0)
    labelText.Font = Enum.Font.GothamMedium
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(200, 200, 200)
    labelText.TextSize = 11
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Value
    local valueText = Instance.new("TextLabel")
    valueText.Parent = container
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(0.4, 4, 0, 0)
    valueText.Size = UDim2.new(0.6, -12, 1, 0)
    valueText.Font = Enum.Font.GothamSemibold
    valueText.Text = defaultValue or "Loading..."
    valueText.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueText.TextSize = 11
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    
    return container, valueText
end

-- Create Section Header Function
local function CreateSectionHeader(text)
    local header = Instance.new("Frame")
    header.BackgroundTransparency = 1
    header.Size = UDim2.new(1, 0, 0, 30)
    
    local headerLabel = Instance.new("TextLabel")
    headerLabel.Parent = header
    headerLabel.BackgroundTransparency = 1
    headerLabel.Position = UDim2.new(0, 0, 0, 0)
    headerLabel.Size = UDim2.new(1, 0, 1, 0)
    headerLabel.Font = Enum.Font.GothamBlack
    headerLabel.Text = text
    headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerLabel.TextSize = 12
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local underline = Instance.new("Frame")
    underline.Parent = header
    underline.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    underline.BorderSizePixel = 0
    underline.Position = UDim2.new(0, 0, 1, -1)
    underline.Size = UDim2.new(1, 0, 0, 1)
    
    return header
end

-- Create Section Function
local function CreateSection()
    local section = Instance.new("Frame")
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, 0)
    
    local sectionList = Instance.new("UIListLayout")
    sectionList.Parent = section
    sectionList.SortOrder = Enum.SortOrder.LayoutOrder
    sectionList.Padding = UDim.new(0, 4)
    
    return section, sectionList
end

-- Create sections and items
local basicInfoSection, basicInfoList = CreateSection()
basicInfoSection.Parent = StatsFrame
basicInfoSection.LayoutOrder = 1

local basicHeader = CreateSectionHeader("BASIC INFORMATION")
basicHeader.Parent = basicInfoSection
basicHeader.LayoutOrder = 0

local levelContainer, LevelLabel = CreateInfoItem("Level")
levelContainer.Parent = basicInfoSection
levelContainer.LayoutOrder = 1

local raceContainer, RaceLabel = CreateInfoItem("Race")
raceContainer.Parent = basicInfoSection
raceContainer.LayoutOrder = 2

local belliContainer, BelliLabel = CreateInfoItem("Beli")
belliContainer.Parent = basicInfoSection
belliContainer.LayoutOrder = 3

local fragmentsContainer, FragmentsLabel = CreateInfoItem("Fragments")
fragmentsContainer.Parent = basicInfoSection
fragmentsContainer.LayoutOrder = 4

local combatSection, combatList = CreateSection()
combatSection.Parent = StatsFrame
combatSection.LayoutOrder = 3

local combatHeader = CreateSectionHeader("COMBAT STATS")
combatHeader.Parent = combatSection
combatHeader.LayoutOrder = 0

local healthContainer, HealthLabel = CreateInfoItem("Health")
healthContainer.Parent = combatSection
healthContainer.LayoutOrder = 1

local fightingStyleContainer, FightingStyleLabel = CreateInfoItem("Fighting Style")
fightingStyleContainer.Parent = combatSection
fightingStyleContainer.LayoutOrder = 2

local devilFruitContainer, DevilFruitLabel = CreateInfoItem("Devil Fruit")
devilFruitContainer.Parent = combatSection
devilFruitContainer.LayoutOrder = 3

local equipmentSection, equipmentList = CreateSection()
equipmentSection.Parent = StatsFrame
equipmentSection.LayoutOrder = 5

local equipmentHeader = CreateSectionHeader("EQUIPMENT")
equipmentHeader.Parent = equipmentSection
equipmentHeader.LayoutOrder = 0

local swordsContainer, SwordLabel = CreateInfoItem("Swords")
swordsContainer.Parent = equipmentSection
swordsContainer.LayoutOrder = 1

-- Section spacing
UIListLayout.Parent = StatsFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 16)  -- More space between major sections

-- Update function
local function updateSectionSizes()
    local function updateSection(section, list)
        local contentSize = list.AbsoluteContentSize
        section.Size = UDim2.new(1, 0, 0, contentSize.Y)
    end
    
    updateSection(basicInfoSection, basicInfoList)
    updateSection(combatSection, combatList)
    updateSection(equipmentSection, equipmentList)
    
    local totalSize = UIListLayout.AbsoluteContentSize
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalSize.Y + 16)
end

-- Connect size updates
basicInfoList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)
combatList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)
equipmentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionSizes)

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
    
    -- Get race info
    local race = LocalPlayer:FindFirstChild("Race")
    if race then
        RaceLabel.Text = string.format("Race: %s", race.Value)
    else
        RaceLabel.Text = "Race: Unknown"
    end
end

-- Update loop
game:GetService("RunService").RenderStepped:Connect(updateStats)

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

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)
