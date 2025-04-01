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
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)  -- Smaller centered position
MainFrame.Size = UDim2.new(0, 300, 0, 200)  -- More compact size

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

-- Make frame draggable function
local function makeDraggable(frame)
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
        TweenService:Create(frame, tweenInfo, {Position = position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
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

-- Make both frames draggable
makeDraggable(MainFrame)
makeDraggable(BubbleButton)

-- Minimize and Expand Functions
local function minimizeUI()
    local currentPos = MainFrame.Position
    local targetPos = BubbleButton.Position
    
    -- Create and play the minimize animation
    local minimizeTween = TweenService:Create(MainFrame, minimizeInfo, {
        Size = UDim2.new(0, 50, 0, 50),
        Position = targetPos
    })
    
    minimizeTween.Completed:Connect(function()
        MainFrame.Visible = false
        BubbleButton.Position = targetPos
        BubbleButton.Visible = true
    end)
    
    minimizeTween:Play()
end

local function expandUI()
    local currentPos = BubbleButton.Position
    BubbleButton.Visible = false
    MainFrame.Position = currentPos
    MainFrame.Size = UDim2.new(0, 50, 0, 50)
    MainFrame.Visible = true
    
    -- Create and play the expand animation
    local expandTween = TweenService:Create(MainFrame, expandInfo, {
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0.5, -100)
    })
    
    expandTween:Play()
end

-- Connect minimize and expand buttons
MinimizeButton.MouseButton1Click:Connect(minimizeUI)
BubbleButton.MouseButton1Click:Connect(expandUI)

-- Menu Frame (Left side)
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MenuFrame.Position = UDim2.new(0, 0, 0, 24)  -- Align with smaller title bar
MenuFrame.Size = UDim2.new(0, 80, 1, -24)  -- Narrower menu

local menuLayout = Instance.new("UIListLayout")
menuLayout.Parent = MenuFrame
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder
menuLayout.Padding = UDim.new(0, 5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Menu Padding
local menuPadding = Instance.new("UIPadding")
menuPadding.Parent = MenuFrame
menuPadding.PaddingTop = UDim.new(0, 6)  -- Less top padding

-- Menu Divider
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MenuDivider.Position = UDim2.new(0, 80, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)

-- Content Frame (Right side)
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 85, 0, 28)  -- Adjusted for new menu width
ContentFrame.Size = UDim2.new(1, -90, 1, -32)  -- Adjusted for new spacing

-- Create Menu Button
local function CreateMenuButton(name)
    local button = Instance.new("TextButton")
    button.Name = name.."Button"
    button.Parent = MenuFrame
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.Size = UDim2.new(0.9, 0, 0, 24)  -- Smaller height
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11  -- Smaller text
    button.AutoButtonColor = true
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 4)  -- Smaller corners
    
    return button
end

-- Create menu buttons
local menuButtons = {
    CreateMenuButton("Overview"),
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
UIListLayout.Padding = UDim.new(0, 4)  -- Less spacing between items

-- Create Label Function
local function CreateInfoLabel()
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)  -- Smaller height
    label.Font = Enum.Font.Gotham
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11  -- Smaller text
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Stats Labels
LevelLabel = CreateInfoLabel()
LevelLabel.Parent = StatsFrame
LevelLabel.LayoutOrder = 1

HealthLabel = CreateInfoLabel()
HealthLabel.Parent = StatsFrame
HealthLabel.LayoutOrder = 2

BelliLabel = CreateInfoLabel()
BelliLabel.Parent = StatsFrame
BelliLabel.LayoutOrder = 3

FragmentsLabel = CreateInfoLabel()
FragmentsLabel.Parent = StatsFrame
FragmentsLabel.LayoutOrder = 4

FightingStyleLabel = CreateInfoLabel()
FightingStyleLabel.Parent = StatsFrame
FightingStyleLabel.LayoutOrder = 5

DevilFruitLabel = CreateInfoLabel()
DevilFruitLabel.Parent = StatsFrame
DevilFruitLabel.LayoutOrder = 6

RaceLabel = CreateInfoLabel()
RaceLabel.Parent = StatsFrame
RaceLabel.LayoutOrder = 7

SwordLabel = CreateInfoLabel()
SwordLabel.Parent = StatsFrame
SwordLabel.LayoutOrder = 8

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
