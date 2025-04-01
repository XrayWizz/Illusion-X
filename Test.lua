-- Constants for configuration
local CONFIG = {
    UPDATE_INTERVAL = 0.1,
    THEMES = {
        DARK = {
            BACKGROUND_DARK = Color3.fromRGB(18, 18, 18),
            BACKGROUND_MEDIUM = Color3.fromRGB(24, 24, 24),
            BACKGROUND_LIGHT = Color3.fromRGB(30, 30, 30),
            ACCENT = Color3.fromRGB(70, 130, 240),
            ACCENT_HOVER = Color3.fromRGB(90, 150, 255),
            TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
            TEXT_SECONDARY = Color3.fromRGB(200, 200, 200),
            BORDER = Color3.fromRGB(40, 40, 40),
            BUTTON_HOVER = Color3.fromRGB(35, 35, 35),
            SHADOW = Color3.fromRGB(0, 0, 0),
        },
        LIGHT = {
            BACKGROUND_DARK = Color3.fromRGB(240, 242, 245),
            BACKGROUND_MEDIUM = Color3.fromRGB(248, 249, 251),
            BACKGROUND_LIGHT = Color3.fromRGB(255, 255, 255),
            ACCENT = Color3.fromRGB(45, 120, 255),
            ACCENT_HOVER = Color3.fromRGB(65, 140, 255),
            TEXT_PRIMARY = Color3.fromRGB(35, 42, 49),
            TEXT_SECONDARY = Color3.fromRGB(90, 100, 110),
            BORDER = Color3.fromRGB(225, 228, 232),
            BUTTON_HOVER = Color3.fromRGB(245, 246, 248),
            SHADOW = Color3.fromRGB(210, 215, 220),
        }
    },
    COLORS = {
        POSITIVE = Color3.fromRGB(50, 205, 50),
        NEGATIVE = Color3.fromRGB(220, 20, 60),
        WARNING = Color3.fromRGB(255, 185, 0),
    },
    SIZES = {
        SMALL = {
            WIDTH = 300,
            HEIGHT = 200
        },
        NORMAL = {
            WIDTH = 350,
            HEIGHT = 250
        },
        LARGE = {
            WIDTH = 400,
            HEIGHT = 300
        },
        EXTRA_LARGE = {
            WIDTH = 450,
            HEIGHT = 350
        }
    },
    PADDING = {
        SECTION = 6,
        ITEM = 4,
    },
    ANIMATION = {
        TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        HOVER_TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    },
    CORNER_RADIUS = 6,
}

-- Animation settings
local MINIMIZE_SETTINGS = {
    NORMAL = {
        Size = UDim2.new(0, CONFIG.SIZES.EXTRA_LARGE.WIDTH, 0, CONFIG.SIZES.EXTRA_LARGE.HEIGHT),
        Position = UDim2.new(0.5, -CONFIG.SIZES.EXTRA_LARGE.WIDTH/2, 0.5, -CONFIG.SIZES.EXTRA_LARGE.HEIGHT/2)
    },
    MINIMIZED = {
        Size = UDim2.new(0, CONFIG.SIZES.EXTRA_LARGE.WIDTH/2, 0, 24),
        Position = UDim2.new(0.5, -CONFIG.SIZES.EXTRA_LARGE.WIDTH/4, 0, 5)
    }
}

-- Services
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
local function safeGet(instance, ...)
    local current = instance
    for _, propertyName in ipairs({...}) do
        if not current then return nil end
        current = current:FindFirstChild(propertyName)
    end
    return current
end

local function getItemsWithProperty(container, propertyName)
    local items = {}
    if not container then return items end
    
    for _, item in ipairs(container:GetChildren()) do
        if item:FindFirstChild(propertyName) then
            table.insert(items, item.Name)
        end
    end
    return items
end

-- UI Creation Helpers
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = parent
    corner.CornerRadius = UDim.new(0, radius or 4)
    return corner
end

-- Create main components
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_MEDIUM
MainFrame.Size = MINIMIZE_SETTINGS.NORMAL.Size
MainFrame.Position = MINIMIZE_SETTINGS.NORMAL.Position
MainFrame.ClipsDescendants = true

local mainCorner = createCorner(MainFrame, CONFIG.CORNER_RADIUS)

-- Title Bar Setup
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_LIGHT
TitleBar.Size = UDim2.new(1, 0, 0, 24)

local titleBarCorner = createCorner(TitleBar, CONFIG.CORNER_RADIUS)

-- Title Text
local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Info"
Title.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = CONFIG.THEMES.DARK.BUTTON_HOVER
MinimizeButton.Position = UDim2.new(1, -44, 0.5, -7)
MinimizeButton.Size = UDim2.new(0, 14, 0, 14)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
MinimizeButton.TextSize = 14
MinimizeButton.AutoButtonColor = false

local minimizeCorner = createCorner(MinimizeButton, CONFIG.CORNER_RADIUS)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.Position = UDim2.new(1, -24, 0.5, -7)
CloseButton.Size = UDim2.new(0, 14, 0, 14)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = false

local closeCorner = createCorner(CloseButton, CONFIG.CORNER_RADIUS)

-- Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_LIGHT
MenuFrame.Position = UDim2.new(0, 0, 0, 24)
MenuFrame.Size = UDim2.new(0, 75, 1, -24)

local menuCorner = createCorner(MenuFrame, CONFIG.CORNER_RADIUS)

-- Add a frame to cover the top corners of MenuFrame
local menuTopCover = Instance.new("Frame")
menuTopCover.Name = "MenuTopCover"
menuTopCover.Parent = MenuFrame
menuTopCover.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_LIGHT
menuTopCover.BorderSizePixel = 0
menuTopCover.Position = UDim2.new(0, 0, 0, 0)
menuTopCover.Size = UDim2.new(1, 0, 0, 10)

-- Create scrolling frame for menu items
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Name = "MenuScroll"
MenuScroll.Parent = MenuFrame
MenuScroll.BackgroundTransparency = 1
MenuScroll.Position = UDim2.new(0, 0, 0, 0)
MenuScroll.Size = UDim2.new(1, 0, 1, 0)
MenuScroll.ScrollBarThickness = 2
MenuScroll.ScrollBarImageColor3 = CONFIG.THEMES.DARK.TEXT_SECONDARY
MenuScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

-- Add UIListLayout for automatic button positioning
local MenuList = Instance.new("UIListLayout")
MenuList.Parent = MenuScroll
MenuList.Padding = UDim.new(0, 4)
MenuList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MenuList.SortOrder = Enum.SortOrder.LayoutOrder

-- Menu button states
local selectedButton = nil

-- Create Menu Button
local function CreateMenuButton(text, order)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
    button.Size = UDim2.new(1, -8, 0, 28)
    button.Position = UDim2.new(0, 4, 0, 4 + (order * 32))
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
    button.TextSize = 11
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.Parent = MenuScroll
    
    local buttonCorner = createCorner(button, CONFIG.CORNER_RADIUS)
    
    -- Selected indicator
    local selectedIndicator = Instance.new("Frame")
    selectedIndicator.Name = "SelectedIndicator"
    selectedIndicator.Parent = button
    selectedIndicator.BackgroundColor3 = CONFIG.THEMES.DARK.ACCENT
    selectedIndicator.Position = UDim2.new(0, 0, 0.5, -1)
    selectedIndicator.Size = UDim2.new(0, 2, 0, 16)
    selectedIndicator.Visible = false
    createCorner(selectedIndicator, CONFIG.CORNER_RADIUS)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        if button ~= selectedButton then
            TweenService:Create(button, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEMES.DARK.BUTTON_HOVER
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= selectedButton then
            TweenService:Create(button, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
            }):Play()
        end
    end)
    
    return button
end

local function selectButton(button)
    if selectedButton then
        selectedButton.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
        selectedButton:FindFirstChild("SelectedIndicator").Visible = false
    end
    
    selectedButton = button
    button.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_LIGHT
    button:FindFirstChild("SelectedIndicator").Visible = true
end

-- Create Overview Button
local OverviewButton = CreateMenuButton("OVERVIEW", 0)
OverviewButton.Parent = MenuScroll

-- Select Overview by default
selectButton(OverviewButton)

-- Overview Button Handler
OverviewButton.MouseButton1Click:Connect(function()
    selectButton(OverviewButton)
    ContentContainer.Visible = true
    SettingsContainer.Visible = false
end)

-- Create Settings Button
local SettingsButton = CreateMenuButton("SETTINGS", 1)
SettingsButton.Parent = MenuScroll

-- Update MenuScroll canvas size when buttons are added
MenuList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MenuScroll.CanvasSize = UDim2.new(0, 0, 0, MenuList.AbsoluteContentSize.Y + 8)
end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 76, 0, 24)
ContentFrame.Size = UDim2.new(1, -76, 1, -24)
ContentFrame.ClipsDescendants = true

-- Content Container (make scrollable)
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = ContentFrame
ContentContainer.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
ContentContainer.Position = UDim2.new(0, 0, 0, 0)
ContentContainer.Size = UDim2.new(1, 0, 1, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = CONFIG.THEMES.DARK.TEXT_SECONDARY
ContentContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
ContentContainer.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
ContentContainer.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

-- Content Layout
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentContainer
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Padding
local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = ContentContainer
ContentPadding.PaddingLeft = UDim.new(0, 12)
ContentPadding.PaddingRight = UDim.new(0, 12)
ContentPadding.PaddingTop = UDim.new(0, 12)
ContentPadding.PaddingBottom = UDim.new(0, 12)

-- Settings Container (make scrollable)
local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Parent = ContentFrame
SettingsContainer.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
SettingsContainer.Position = UDim2.new(0, 0, 0, 0)
SettingsContainer.Size = UDim2.new(1, 0, 1, 0)
SettingsContainer.ScrollBarThickness = 3
SettingsContainer.ScrollBarImageColor3 = CONFIG.THEMES.DARK.TEXT_SECONDARY
SettingsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
SettingsContainer.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsContainer.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsContainer.Visible = false

-- Settings Layout
local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Parent = SettingsContainer
SettingsLayout.Padding = UDim.new(0, 8)
SettingsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Settings Padding
local SettingsPadding = Instance.new("UIPadding")
SettingsPadding.Parent = SettingsContainer
SettingsPadding.PaddingLeft = UDim.new(0, 12)
SettingsPadding.PaddingRight = UDim.new(0, 12)
SettingsPadding.PaddingTop = UDim.new(0, 12)
SettingsPadding.PaddingBottom = UDim.new(0, 12)

-- Update canvas sizes when content changes
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 24)
end)

SettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 24)
end)

-- Menu Divider
local MenuDivider = Instance.new("Frame")
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = CONFIG.THEMES.DARK.BORDER
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)

-- Stats Frame Setup
local StatsFrame = Instance.new("Frame")
StatsFrame.Name = "StatsFrame"
StatsFrame.Parent = ContentContainer
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
local LevelLabel, LevelValue = CreateInfoLabel("Level: 0")
LevelLabel.Parent = basicInfoSection
LevelLabel.LayoutOrder = 0

local RaceLabel, RaceValue = CreateInfoLabel("Race: Unknown")
RaceLabel.Parent = basicInfoSection
RaceLabel.LayoutOrder = 1

local BelliLabel, BelliValue = CreateInfoLabel("Beli: 0")
BelliLabel.Parent = basicInfoSection
BelliLabel.LayoutOrder = 2

local FragmentsLabel, FragmentsValue = CreateInfoLabel("Fragments: 0")
FragmentsLabel.Parent = basicInfoSection
FragmentsLabel.LayoutOrder = 3

local HealthLabel, HealthValue = CreateInfoLabel("Health: 0/0")
HealthLabel.Parent = combatSection
HealthLabel.LayoutOrder = 0

local FightingStyleLabel, FightingStyleValue = CreateInfoLabel("Fighting Style: None")
FightingStyleLabel.Parent = combatSection
FightingStyleLabel.LayoutOrder = 1

local DevilFruitLabel, DevilFruitValue = CreateInfoLabel("Devil Fruit: None")
DevilFruitLabel.Parent = combatSection
DevilFruitLabel.LayoutOrder = 2

local SwordLabel, SwordValue = CreateInfoLabel("Swords: None")
SwordLabel.Parent = equipmentSection
SwordLabel.LayoutOrder = 0

-- Update section sizes
local function updateSectionSizes()
    local function updateSection(section, list)
        local contentSize = list.AbsoluteContentSize
        section.Size = UDim2.new(1, 0, 0, contentSize.Y + CONFIG.PADDING.SECTION)
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
UIListLayout.Padding = UDim.new(0, CONFIG.PADDING.ITEM)

-- Minimize state
local isMinimized = false

-- Minimize animation function
local function toggleMinimize()
    isMinimized = not isMinimized
    local targetState = isMinimized and MINIMIZE_SETTINGS.MINIMIZED or MINIMIZE_SETTINGS.NORMAL
    
    -- Create smooth animations
    local sizeTween = TweenService:Create(
        MainFrame,
        CONFIG.ANIMATION.TWEEN_INFO,
        { Size = targetState.Size }
    )
    
    local positionTween = TweenService:Create(
        MainFrame,
        CONFIG.ANIMATION.TWEEN_INFO,
        { Position = targetState.Position }
    )
    
    -- Play animations
    sizeTween:Play()
    positionTween:Play()
    
    -- Update minimize button appearance
    MinimizeButton.Text = isMinimized and "+" or "-"
    
    -- Optional: Add rotation animation to the button text
    local rotation = isMinimized and 180 or 0
    TweenService:Create(
        MinimizeButton,
        CONFIG.ANIMATION.TWEEN_INFO,
        { Rotation = rotation }
    ):Play()
end

-- Connect minimize button
MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Make title bar draggable
local function enableDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            -- Create smooth drag animation
            TweenService:Create(
                MainFrame,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                }
            ):Play()
        end
    end)
end

-- Initialize dragging
enableDragging()

-- Update Function
local lastUpdate = 0
local function updateStats()
    -- Throttle updates
    local now = tick()
    if now - lastUpdate < CONFIG.UPDATE_INTERVAL then return end
    lastUpdate = now
    
    -- Get character safely
    local character = LocalPlayer.Character
    if not character then return end
    
    -- Update Basic Info
    local leaderstats = safeGet(LocalPlayer, "leaderstats")
    if leaderstats then
        local level = safeGet(leaderstats, "Level")
        local beli = safeGet(leaderstats, "Beli")
        local fragments = safeGet(leaderstats, "Fragments")
        
        if level then LevelValue.Text = tostring(level.Value) end
        if beli then BelliValue.Text = tostring(beli.Value) end
        if fragments then FragmentsValue.Text = tostring(fragments.Value) end
    end
    
    -- Update Race
    local race = safeGet(LocalPlayer, "Data", "Race")
    if race then
        RaceValue.Text = tostring(race.Value)
    else
        RaceValue.Text = "Unknown"
    end
    
    -- Update Health
    local humanoid = safeGet(character, "Humanoid")
    if humanoid then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local healthColor = healthPercent > 0.5 and CONFIG.COLORS.POSITIVE
            or healthPercent > 0.25 and CONFIG.COLORS.WARNING
            or CONFIG.COLORS.NEGATIVE
        
        HealthValue.TextColor3 = healthColor
        HealthValue.Text = string.format("%d/%d", humanoid.Health, humanoid.MaxHealth)
    end
    
    -- Get inventory items
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack and character then
        -- Update Fighting Styles
        local fightingStyles = {}
        for _, container in ipairs({backpack, character}) do
            for _, item in ipairs(getItemsWithProperty(container, "FightingStyle")) do
                table.insert(fightingStyles, item)
            end
        end
        FightingStyleValue.Text = #fightingStyles > 0 
            and table.concat(fightingStyles, ", ")
            or "None"
            
        -- Update Devil Fruits
        local devilFruits = {}
        for _, container in ipairs({backpack, character}) do
            for _, item in ipairs(getItemsWithProperty(container, "DevilFruit")) do
                table.insert(devilFruits, item)
            end
        end
        DevilFruitValue.Text = #devilFruits > 0
            and table.concat(devilFruits, ", ")
            or "None"
            
        -- Update Swords
        local swords = {}
        for _, container in ipairs({backpack, character}) do
            for _, item in ipairs(getItemsWithProperty(container, "SwordTool")) do
                table.insert(swords, item)
            end
        end
        SwordValue.Text = #swords > 0
            and table.concat(swords, ", ")
            or "None"
    end
end

-- Connect update loop with error handling
local function safeUpdate()
    local success, error = pcall(updateStats)
    if not success then
        warn("Error in update loop:", error)
    end
end

-- Start update loop
RunService.RenderStepped:Connect(safeUpdate)

-- Clean up on script end
local function cleanup()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end

ScreenGui.Destroying:Connect(cleanup)

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Create Settings Content
local function CreateSettingsSection(title)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_MEDIUM
    section.Size = UDim2.new(1, -16, 0, 80)
    section.Position = UDim2.new(0, 8, 0, 0)
    createCorner(section, CONFIG.CORNER_RADIUS)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = section
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.Size = UDim2.new(1, -16, 0, 24)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

-- Theme Section
local themeSection = CreateSettingsSection("Theme")
themeSection.Parent = SettingsContainer
themeSection.Position = UDim2.new(0, 8, 0, 8)

-- Theme Buttons
local function CreateThemeButton(themeName, position)
    local button = Instance.new("TextButton")
    button.Parent = themeSection
    button.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
    button.Position = position
    button.Size = UDim2.new(0.5, -12, 0, 32)
    button.Font = Enum.Font.GothamBold
    button.Text = themeName
    button.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
    button.TextSize = 11
    createCorner(button, CONFIG.CORNER_RADIUS)
    return button
end

local darkButton = CreateThemeButton("Dark Theme", UDim2.new(0, 8, 0, 36))
local lightButton = CreateThemeButton("Light Theme", UDim2.new(0.5, 4, 0, 36))

-- Size Section
local sizeSection = CreateSettingsSection("UI Size")
sizeSection.Parent = SettingsContainer
sizeSection.Position = UDim2.new(0, 8, 0, 96)

-- Size Buttons
local function CreateSizeButton(sizeName, position)
    local button = Instance.new("TextButton")
    button.Parent = sizeSection
    button.BackgroundColor3 = CONFIG.THEMES.DARK.BACKGROUND_DARK
    button.Position = position
    button.Size = UDim2.new(0.33, -10, 0, 32)
    button.Font = Enum.Font.GothamBold
    button.Text = sizeName
    button.TextColor3 = CONFIG.THEMES.DARK.TEXT_PRIMARY
    button.TextSize = 11
    createCorner(button, CONFIG.CORNER_RADIUS)
    return button
end

local smallButton = CreateSizeButton("Small", UDim2.new(0, 8, 0, 36))
local normalButton = CreateSizeButton("Normal", UDim2.new(0.33, 4, 0, 36))
local largeButton = CreateSizeButton("Large", UDim2.new(0.66, 4, 0, 36))
local extraLargeButton = CreateSizeButton("Extra Large", UDim2.new(0, 8, 0, 68))

-- Current theme and size
local currentTheme = "DARK"
local currentSize = "EXTRA_LARGE"

-- Theme switching function
local function switchTheme(themeName)
    local theme = CONFIG.THEMES[themeName]
    
    -- Apply theme to main components
    MainFrame.BackgroundColor3 = theme.BACKGROUND_MEDIUM
    TitleBar.BackgroundColor3 = theme.BACKGROUND_LIGHT
    MenuFrame.BackgroundColor3 = theme.BACKGROUND_LIGHT
    menuTopCover.BackgroundColor3 = theme.BACKGROUND_LIGHT
    MenuDivider.BackgroundColor3 = theme.BORDER
    
    -- Update text colors
    Title.TextColor3 = theme.TEXT_PRIMARY
    
    -- Update all buttons
    for _, button in ipairs(MainFrame:GetDescendants()) do
        if button:IsA("TextButton") then
            if button == MinimizeButton then
                button.BackgroundColor3 = theme.BUTTON_HOVER
            elseif button == CloseButton then
                button.BackgroundColor3 = CONFIG.COLORS.NEGATIVE
            else
                button.BackgroundColor3 = theme.BACKGROUND_DARK
            end
            button.TextColor3 = theme.TEXT_PRIMARY
        end
    end
    
    -- Update all text labels
    for _, label in ipairs(MainFrame:GetDescendants()) do
        if label:IsA("TextLabel") then
            if label:GetAttribute("IsSecondary") then
                label.TextColor3 = theme.TEXT_SECONDARY
            else
                label.TextColor3 = theme.TEXT_PRIMARY
            end
        end
    end
    
    -- Update content containers
    ContentContainer.BackgroundColor3 = theme.BACKGROUND_DARK
    SettingsContainer.BackgroundColor3 = theme.BACKGROUND_DARK
    
    -- Add subtle shadow effect
    local shadowFrame = MainFrame:FindFirstChild("Shadow") or Instance.new("Frame")
    if not shadowFrame.Parent then
        shadowFrame.Name = "Shadow"
        shadowFrame.BackgroundColor3 = theme.SHADOW
        shadowFrame.BackgroundTransparency = 0.7
        shadowFrame.Position = UDim2.new(0, 2, 0, 2)
        shadowFrame.Size = MainFrame.Size
        shadowFrame.ZIndex = -1
        createCorner(shadowFrame, CONFIG.CORNER_RADIUS)
        shadowFrame.Parent = MainFrame
    else
        shadowFrame.BackgroundColor3 = theme.SHADOW
    end
    
    -- Save theme preference
    if pcall(function()
        local success = writefile("theme_preference.txt", themeName)
        return success
    end) then
        print("Theme preference saved")
    end
end

-- Theme Button Handler
darkButton.MouseButton1Click:Connect(function()
    switchTheme("DARK")
end)

lightButton.MouseButton1Click:Connect(function()
    switchTheme("LIGHT")
end)

-- Size switching function
local function switchSize(sizeName)
    currentSize = sizeName
    local size = CONFIG.SIZES[sizeName]
    
    -- Only update if not minimized
    if not isMinimized then
        MINIMIZE_SETTINGS.NORMAL.Size = UDim2.new(0, size.WIDTH, 0, size.HEIGHT)
        MINIMIZE_SETTINGS.NORMAL.Position = UDim2.new(0.5, -size.WIDTH/2, 0.5, -size.HEIGHT/2)
        
        TweenService:Create(MainFrame, CONFIG.ANIMATION.TWEEN_INFO, {
            Size = MINIMIZE_SETTINGS.NORMAL.Size,
            Position = MINIMIZE_SETTINGS.NORMAL.Position
        }):Play()
    else
        -- Update minimized width if size changes while minimized
        MINIMIZE_SETTINGS.MINIMIZED.Size = UDim2.new(0, size.WIDTH/2, 0, 24)
        MINIMIZE_SETTINGS.MINIMIZED.Position = UDim2.new(0.5, -size.WIDTH/4, 0, 5)
        
        TweenService:Create(MainFrame, CONFIG.ANIMATION.TWEEN_INFO, {
            Size = MINIMIZE_SETTINGS.MINIMIZED.Size,
            Position = MINIMIZE_SETTINGS.MINIMIZED.Position
        }):Play()
    end
    
    -- Save size preference
    if pcall(function()
        local success = writefile("size_preference.txt", sizeName)
        return success
    end) then
        print("Size preference saved")
    end
end

-- Connect size buttons
smallButton.MouseButton1Click:Connect(function()
    switchSize("SMALL")
end)

normalButton.MouseButton1Click:Connect(function()
    switchSize("NORMAL")
end)

largeButton.MouseButton1Click:Connect(function()
    switchSize("LARGE")
end)

extraLargeButton.MouseButton1Click:Connect(function()
    switchSize("EXTRA_LARGE")
end)

-- Settings Button Handler
SettingsButton.MouseButton1Click:Connect(function()
    selectButton(SettingsButton)
    ContentContainer.Visible = false
    SettingsContainer.Visible = true
end)

-- Try to load saved theme preference
pcall(function()
    if isfile("theme_preference.txt") then
        local savedTheme = readfile("theme_preference.txt")
        if savedTheme == "DARK" or savedTheme == "LIGHT" then
            switchTheme(savedTheme)
            return
        end
    end
    -- Default to dark theme if no preference found
    switchTheme("DARK")
end)

-- Try to load saved size preference
pcall(function()
    if isfile("size_preference.txt") then
        local savedSize = readfile("size_preference.txt")
        if CONFIG.SIZES[savedSize] then
            switchSize(savedSize)
            return
        end
    end
    -- Default to extra large size if no preference found
    switchSize("EXTRA_LARGE")
end)
