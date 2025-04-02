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

-- Constants for configuration
local CONFIG = {
    UPDATE_INTERVAL = 0.1,
    THEME = {
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

-- Current states
local isMinimized = false
local currentSize = "EXTRA_LARGE"

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

-- Utility Functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = parent
    corner.CornerRadius = UDim.new(0, radius or CONFIG.CORNER_RADIUS)
    return corner
end

-- Create main components
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsInfo"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND_MEDIUM
MainFrame.Size = MINIMIZE_SETTINGS.NORMAL.Size
MainFrame.Position = MINIMIZE_SETTINGS.NORMAL.Position
MainFrame.ClipsDescendants = true
createCorner(MainFrame, CONFIG.CORNER_RADIUS)

-- Title Bar Setup
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = CONFIG.THEME.BACKGROUND_LIGHT
TitleBar.Size = UDim2.new(1, 0, 0, 24)
createCorner(TitleBar, CONFIG.CORNER_RADIUS)

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Blox Fruits Info"
Title.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Parent = MainFrame
MenuFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND_LIGHT
MenuFrame.Position = UDim2.new(0, 0, 0, 24)
MenuFrame.Size = UDim2.new(0, 75, 1, -24)
createCorner(MenuFrame, CONFIG.CORNER_RADIUS)

-- Menu Scroll
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Name = "MenuScroll"
MenuScroll.Parent = MenuFrame
MenuScroll.BackgroundTransparency = 1
MenuScroll.Position = UDim2.new(0, 0, 0, 0)
MenuScroll.Size = UDim2.new(1, 0, 1, 0)
MenuScroll.ScrollBarThickness = 2
MenuScroll.ScrollBarImageColor3 = CONFIG.THEME.TEXT_SECONDARY
MenuScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

-- Menu List Layout
local MenuList = Instance.new("UIListLayout")
MenuList.Parent = MenuScroll
MenuList.Padding = UDim.new(0, 4)
MenuList.HorizontalAlignment = Enum.HorizontalAlignment.Center
MenuList.SortOrder = Enum.SortOrder.LayoutOrder

-- Menu Divider
local MenuDivider = Instance.new("Frame")
MenuDivider.Parent = MainFrame
MenuDivider.BackgroundColor3 = CONFIG.THEME.BORDER
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)

-- Buttons
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = CONFIG.THEME.BUTTON_HOVER
MinimizeButton.Position = UDim2.new(1, -44, 0.5, -7)
MinimizeButton.Size = UDim2.new(0, 14, 0, 14)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
MinimizeButton.TextSize = 14
MinimizeButton.AutoButtonColor = false
createCorner(MinimizeButton, CONFIG.CORNER_RADIUS)

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = CONFIG.COLORS.NEGATIVE
CloseButton.Position = UDim2.new(1, -24, 0.5, -7)
CloseButton.Size = UDim2.new(0, 14, 0, 14)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
CloseButton.TextSize = 14
CloseButton.AutoButtonColor = false
createCorner(CloseButton, CONFIG.CORNER_RADIUS)

-- Size switching function
local function switchSize(sizeName)
    currentSize = sizeName
    local size = CONFIG.SIZES[sizeName]
    
    -- Update minimize settings for current size
    MINIMIZE_SETTINGS.NORMAL = {
        Size = UDim2.new(0, size.WIDTH, 0, size.HEIGHT),
        Position = UDim2.new(0.5, -size.WIDTH/2, 0.5, -size.HEIGHT/2)
    }
    MINIMIZE_SETTINGS.MINIMIZED = {
        Size = UDim2.new(0, size.WIDTH/2, 0, 24),
        Position = UDim2.new(0.5, -size.WIDTH/4, 0, 5)
    }
    
    -- Only update if not minimized
    if not isMinimized then
        TweenService:Create(MainFrame, CONFIG.ANIMATION.TWEEN_INFO, {
            Size = MINIMIZE_SETTINGS.NORMAL.Size,
            Position = MINIMIZE_SETTINGS.NORMAL.Position
        }):Play()
    end
    
    -- Save size preference
    pcall(function()
        writefile("size_preference.txt", sizeName)
    end)
end

-- Minimize button handler
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local targetState = isMinimized and MINIMIZE_SETTINGS.MINIMIZED or MINIMIZE_SETTINGS.NORMAL
    
    -- Hide content immediately when minimizing
    if isMinimized then
        ContentContainer.Visible = false
        MenuFrame.Visible = false
        MenuDivider.Visible = false
    end
    
    -- Create single smooth animation
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            Size = targetState.Size,
            Position = targetState.Position
        }
    )
    
    -- Show content after animation completes when maximizing
    if not isMinimized then
        tween.Completed:Connect(function()
            ContentContainer.Visible = true
            MenuFrame.Visible = true
            MenuDivider.Visible = true
        end)
    end
    
    tween:Play()
end)

-- Create containers
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 76, 0, 24)
ContentContainer.Size = UDim2.new(1, -76, 1, -24)
ContentContainer.Visible = true

local SettingsContainer = Instance.new("Frame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Parent = MainFrame
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Position = UDim2.new(0, 76, 0, 24)
SettingsContainer.Size = UDim2.new(1, -76, 1, -24)
SettingsContainer.Visible = false

-- Create scrolling frames for content
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Parent = ContentContainer
ContentScroll.BackgroundTransparency = 1
ContentScroll.Position = UDim2.new(0, 8, 0, 8)
ContentScroll.Size = UDim2.new(1, -16, 1, -16)
ContentScroll.ScrollBarThickness = 2
ContentScroll.ScrollBarImageColor3 = CONFIG.THEME.TEXT_SECONDARY
ContentScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Name = "SettingsScroll"
SettingsScroll.Parent = SettingsContainer
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.Position = UDim2.new(0, 8, 0, 8)
SettingsScroll.Size = UDim2.new(1, -16, 1, -16)
SettingsScroll.ScrollBarThickness = 2
SettingsScroll.ScrollBarImageColor3 = CONFIG.THEME.TEXT_SECONDARY
SettingsScroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

-- Add list layouts
local ContentList = Instance.new("UIListLayout")
ContentList.Parent = ContentScroll
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, CONFIG.PADDING.SECTION)

local SettingsList = Instance.new("UIListLayout")
SettingsList.Parent = SettingsScroll
SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
SettingsList.Padding = UDim.new(0, CONFIG.PADDING.SECTION)

-- Menu button states
local selectedButton = nil

-- Button selection function
local function selectButton(button)
    if selectedButton then
        TweenService:Create(selectedButton, CONFIG.ANIMATION.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
        }):Play()
        selectedButton:FindFirstChild("SelectedIndicator").Visible = false
    end
    
    selectedButton = button
    TweenService:Create(button, CONFIG.ANIMATION.TWEEN_INFO, {
        BackgroundColor3 = CONFIG.THEME.ACCENT
    }):Play()
    button:FindFirstChild("SelectedIndicator").Visible = true
end

-- Create Menu Button
local function CreateMenuButton(text, order)
    local button = Instance.new("TextButton")
    button.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
    button.Size = UDim2.new(1, -8, 0, 28)
    button.Position = UDim2.new(0, 4, 0, 4 + (order * 32))
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    button.TextSize = 11
    button.AutoButtonColor = false
    button.LayoutOrder = order
    button.Parent = MenuScroll
    
    local buttonCorner = createCorner(button, CONFIG.CORNER_RADIUS)
    
    -- Selected indicator
    local selectedIndicator = Instance.new("Frame")
    selectedIndicator.Name = "SelectedIndicator"
    selectedIndicator.Parent = button
    selectedIndicator.BackgroundColor3 = CONFIG.THEME.ACCENT
    selectedIndicator.Position = UDim2.new(0, 0, 0.5, -1)
    selectedIndicator.Size = UDim2.new(0, 2, 0, 16)
    selectedIndicator.Visible = false
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        if button ~= selectedButton then
            TweenService:Create(button, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEME.BUTTON_HOVER
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= selectedButton then
            TweenService:Create(button, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
            }):Play()
        end
    end)
    
    return button
end

-- Create menu buttons
local OverviewButton = CreateMenuButton("Overview", 0)
local SettingsButton = CreateMenuButton("Settings", 1)

-- Button click handlers
OverviewButton.MouseButton1Click:Connect(function()
    selectButton(OverviewButton)
    ContentContainer.Visible = true
    SettingsContainer.Visible = false
end)

SettingsButton.MouseButton1Click:Connect(function()
    selectButton(SettingsButton)
    ContentContainer.Visible = false
    SettingsContainer.Visible = true
end)

-- Update MenuScroll canvas size
MenuList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MenuScroll.CanvasSize = UDim2.new(0, 0, 0, MenuList.AbsoluteContentSize.Y + 8)
end)

-- Select Overview by default after a short delay to ensure everything is loaded
task.spawn(function()
    task.wait(0.1)
    selectButton(OverviewButton)
end)

-- Initialize UI
ContentContainer.Visible = true
SettingsContainer.Visible = false
MenuFrame.Visible = true
MenuDivider.Visible = true

-- Update canvas sizes when content changes
ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 16)
end)

SettingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, SettingsList.AbsoluteContentSize.Y + 16)
end)

-- Create Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = ContentScroll
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 0)
ContentFrame.Size = UDim2.new(1, 0, 1, 0)

-- Create Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = ContentFrame
ContentContainer.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
ContentContainer.Position = UDim2.new(0, 0, 0, 0)
ContentContainer.Size = UDim2.new(1, 0, 1, 0)
ContentContainer.ScrollBarThickness = 3
ContentContainer.ScrollBarImageColor3 = CONFIG.THEME.TEXT_SECONDARY
ContentContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
ContentContainer.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
ContentContainer.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

-- Create Settings Container
local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Parent = ContentFrame
SettingsContainer.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
SettingsContainer.Position = UDim2.new(0, 0, 0, 0)
SettingsContainer.Size = UDim2.new(1, 0, 1, 0)
SettingsContainer.ScrollBarThickness = 3
SettingsContainer.ScrollBarImageColor3 = CONFIG.THEME.TEXT_SECONDARY
SettingsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
SettingsContainer.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsContainer.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
SettingsContainer.Visible = false

-- Create UIListLayout for Content Container
local ContentList = Instance.new("UIListLayout")
ContentList.Parent = ContentContainer
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Padding = UDim.new(0, CONFIG.PADDING.SECTION)

-- Create UIListLayout for Settings Container
local SettingsList = Instance.new("UIListLayout")
SettingsList.Parent = SettingsContainer
SettingsList.SortOrder = Enum.SortOrder.LayoutOrder
SettingsList.Padding = UDim.new(0, CONFIG.PADDING.SECTION)

-- Create Section Header
local function CreateSectionHeader(text)
    local header = Instance.new("Frame")
    header.BackgroundColor3 = CONFIG.THEME.BACKGROUND_LIGHT
    header.Size = UDim2.new(1, -24, 0, 32)
    
    local headerContent = Instance.new("Frame")
    headerContent.Name = "Content"
    headerContent.Parent = header
    headerContent.BackgroundTransparency = 1
    headerContent.Size = UDim2.new(1, 0, 1, 0)
    
    local headerLabel = Instance.new("TextLabel")
    headerLabel.Parent = headerContent
    headerLabel.BackgroundTransparency = 1
    headerLabel.Position = UDim2.new(0, 12, 0, 0)
    headerLabel.Size = UDim2.new(1, -24, 1, 0)
    headerLabel.Font = Enum.Font.GothamBlack
    headerLabel.Text = text
    headerLabel.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    headerLabel.TextSize = 12
    headerLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Parent = header
    accent.BackgroundColor3 = CONFIG.THEME.ACCENT
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.Size = UDim2.new(0, 2, 1, 0)
    
    createCorner(header, CONFIG.CORNER_RADIUS)
    
    return header
end

-- Create Info Label
local function CreateInfoLabel(text, valueColor)
    local container = Instance.new("Frame")
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -24, 0, 24)
    
    local label = Instance.new("TextLabel")
    label.Parent = container
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0.4, -8, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text:match("^(.-):") or text
    label.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local value = Instance.new("TextLabel")
    value.Parent = container
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0.4, 8, 0, 0)
    value.Size = UDim2.new(0.6, -16, 1, 0)
    value.Font = Enum.Font.GothamBold
    value.Text = text:match(": (.+)$") or "None"
    value.TextColor3 = valueColor or CONFIG.THEME.TEXT_PRIMARY
    value.TextSize = 11
    value.TextXAlignment = Enum.TextXAlignment.Right
    
    return container, value
end

-- Create Section
local function CreateSection()
    local section = Instance.new("Frame")
    section.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
    section.Size = UDim2.new(1, -24, 0, 0)
    section.Position = UDim2.new(0, 12, 0, 0)
    section.AutomaticSize = Enum.AutomaticSize.Y
    section.ClipsDescendants = true
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = section
    contentPadding.PaddingTop = UDim.new(0, CONFIG.PADDING.SECTION)
    contentPadding.PaddingBottom = UDim.new(0, CONFIG.PADDING.SECTION)
    contentPadding.PaddingLeft = UDim.new(0, CONFIG.PADDING.SECTION)
    contentPadding.PaddingRight = UDim.new(0, CONFIG.PADDING.SECTION)
    
    local contentList = Instance.new("UIListLayout")
    contentList.Parent = section
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, CONFIG.PADDING.ITEM)
    
    createCorner(section, CONFIG.CORNER_RADIUS)
    
    -- Auto-adjust section height based on content
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, -24, 0, contentList.AbsoluteContentSize.Y + CONFIG.PADDING.SECTION * 2)
    end)
    
    return section, contentList
end

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

-- Create Settings Content
local function CreateSettingsSection(title)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = CONFIG.THEME.BACKGROUND_MEDIUM
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
    titleLabel.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

-- Size Section
local sizeSection = CreateSettingsSection("UI Size")
sizeSection.Parent = SettingsContainer
sizeSection.Position = UDim2.new(0, 8, 0, 8)

-- Create Dropdown
local function CreateDropdown(options, defaultOption, position)
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "DropdownContainer"
    dropdownContainer.Parent = sizeSection
    dropdownContainer.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
    dropdownContainer.Position = position
    dropdownContainer.Size = UDim2.new(1, -16, 0, 32)
    createCorner(dropdownContainer, CONFIG.CORNER_RADIUS)
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Parent = dropdownContainer
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Font = Enum.Font.GothamBold
    dropdownButton.Text = defaultOption
    dropdownButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    dropdownButton.TextSize = 11
    
    local dropdownArrow = Instance.new("TextLabel")
    dropdownArrow.Name = "DropdownArrow"
    dropdownArrow.Parent = dropdownContainer
    dropdownArrow.BackgroundTransparency = 1
    dropdownArrow.Position = UDim2.new(1, -24, 0, 0)
    dropdownArrow.Size = UDim2.new(0, 24, 1, 0)
    dropdownArrow.Font = Enum.Font.GothamBold
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    dropdownArrow.TextSize = 11
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Parent = dropdownContainer
    optionsFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
    optionsFrame.Position = UDim2.new(0, 0, 1, 4)
    optionsFrame.Size = UDim2.new(1, 0, 0, #options * 32)
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    createCorner(optionsFrame, CONFIG.CORNER_RADIUS)
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.Parent = optionsFrame
    optionsList.SortOrder = Enum.SortOrder.LayoutOrder
    optionsList.Padding = UDim.new(0, 0)
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = option
        optionButton.Parent = optionsFrame
        optionButton.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
        optionButton.Size = UDim2.new(1, 0, 0, 32)
        optionButton.Font = Enum.Font.GothamBold
        optionButton.Text = option
        optionButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
        optionButton.TextSize = 11
        optionButton.ZIndex = 10
        optionButton.LayoutOrder = i
        
        -- Add hover effect
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEME.BUTTON_HOVER
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
            }):Play()
        end)
    end
    
    -- Toggle dropdown
    local isOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        dropdownArrow.Text = isOpen and "▲" or "▼"
        
        if isOpen then
            optionsFrame:TweenSize(
                UDim2.new(1, 0, 0, #options * 32),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.2,
                true
            )
        end
    end)
    
    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local position = input.Position
            local inDropdown = position.X >= dropdownContainer.AbsolutePosition.X
                and position.X <= dropdownContainer.AbsolutePosition.X + dropdownContainer.AbsoluteSize.X
                and position.Y >= dropdownContainer.AbsolutePosition.Y
                and position.Y <= dropdownContainer.AbsolutePosition.Y + dropdownContainer.AbsoluteSize.Y
            
            if not inDropdown and isOpen then
                isOpen = false
                optionsFrame.Visible = false
                dropdownArrow.Text = "▼"
            end
        end
    end)
    
    return dropdownContainer
end

-- Create size dropdown
local sizeDropdown = CreateDropdown(
    {"Small", "Normal", "Large", "Extra Large"},
    "Extra Large",
    UDim2.new(0, 8, 0, 36)
)

-- Connect size dropdown options
for _, optionButton in ipairs(sizeDropdown.OptionsFrame:GetChildren()) do
    if optionButton:IsA("TextButton") then
        optionButton.MouseButton1Click:Connect(function()
            local sizeName = string.upper(optionButton.Text):gsub(" ", "_")
            switchSize(sizeName)
            sizeDropdown.DropdownButton.Text = optionButton.Text
            sizeDropdown.OptionsFrame.Visible = false
        end)
    end
end

-- Try to load saved size preference
pcall(function()
    if isfile("size_preference.txt") then
        local savedSize = readfile("size_preference.txt")
        if CONFIG.SIZES[savedSize] then
            switchSize(savedSize)
            -- Update dropdown text to match
            local displayText = savedSize:gsub("_", " "):gsub("^%l", string.upper)
            sizeDropdown.DropdownButton.Text = displayText
            return
        end
    end
    -- Default to extra large size if no preference found
    switchSize("EXTRA_LARGE")
end)

-- Update canvas sizes when content changes
ContentContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local totalHeight = 0
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
        end
    end
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 24)
end)

SettingsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, SettingsList.AbsoluteContentSize.Y + 24)
end)

-- Stats update function
local function updateStats()
    -- Only update if containers exist
    if not ContentScroll then return end
    
    -- Get player containers
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if not character or not backpack then return end
    
    -- Update stats here if needed
    -- For now, we'll just update the canvas size
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 16)
    SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, SettingsList.AbsoluteContentSize.Y + 16)
end

-- Connect update loop with error handling
local function safeUpdate()
    local success, error = pcall(updateStats)
    if not success then
        warn("Error in update loop:", error)
    end
end

-- Start update loop with a lower frequency
task.spawn(function()
    while true do
        safeUpdate()
        task.wait(0.5) -- Update every 0.5 seconds instead of every frame
    end
end)

-- Clean up on script end
local function cleanup()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end

game:BindToClose(cleanup)

-- Close Button Handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make title bar draggable
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
        dragStart = nil
        startPos = nil
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

-- Initialize dragging
-- enableDragging()

return ScreenGui
