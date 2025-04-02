-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Constants
local CONFIG = {
    THEME = {
        BACKGROUND = Color3.fromRGB(20, 20, 20),
        TITLE_BAR = Color3.fromRGB(30, 30, 30),
        TEXT = Color3.fromRGB(255, 255, 255),
        TEXT_SECONDARY = Color3.fromRGB(180, 180, 180),
        ACCENT = Color3.fromRGB(70, 130, 240),
        CLOSE_BUTTON = Color3.fromRGB(220, 20, 60)
    },
    CORNER_RADIUS = 6,
    MENU_WIDTH = 150,
    WINDOW_SIZE = {
        WIDTH = 600,
        HEIGHT = 350
    },
    TITLE_HEIGHT = 30,
    SIZES = {
        Small = {
            WIDTH = 400,
            HEIGHT = 300
        },
        Normal = {
            WIDTH = 500,
            HEIGHT = 350
        },
        Large = {
            WIDTH = 600,
            HEIGHT = 400
        }
    }
}

-- Menu items with icons and layout order
local MENU_ITEMS = {
    {layoutOrder = 1, name = "Overview", icon = "👤"},     -- Profile
    {layoutOrder = 2, name = "Farming", icon = "🏰"},      -- Castle
    {layoutOrder = 3, name = "Sea Events", icon = "🌊"},   -- Wave
    {layoutOrder = 4, name = "Islands", icon = "🏝️"},     -- Island
    {layoutOrder = 5, name = "Quests/Raids", icon = "⚔️"}, -- Crossed swords
    {layoutOrder = 6, name = "Fruit", icon = "🍒"},        -- Cherry
    {layoutOrder = 7, name = "Teleport", icon = "⚡"},     -- Lightning
    {layoutOrder = 8, name = "Status", icon = "📜"},       -- Scroll
    {layoutOrder = 9, name = "Visual", icon = "👁️"},       -- Eye
    {layoutOrder = 10, name = "Shop", icon = "🛒"},        -- Shopping cart
    {layoutOrder = 11, name = "Misc.", icon = "🔩"},       -- Nut and bolt
    {layoutOrder = 12, name = "Settings", icon = "⚙️"},    -- Gear
    {layoutOrder = 13, name = "Feedback", icon = "💬"}     -- Speech bubble
}

-- Function to get wireframe version of text
local function getWireframeIcon(icon)
    -- Map regular icons to wireframe versions where possible
    local wireframeMap = {
        ["👤"] = "󰀄",  -- Person wireframe
        ["🏠"] = "󱃾",  -- Simple house wireframe (just outline and door)
        ["⚔️"] = "󰢤",  -- Sword wireframe
        ["🧭"] = "󰑣",  -- Compass wireframe
        ["📜"] = "󰈙",  -- Scroll/document wireframe
        ["👁️"] = "󰈈",  -- Eye wireframe
        ["🛒"] = "󰒋",  -- Cart wireframe
        ["🔧"] = "󰖷",  -- Tools wireframe
        ["⚙️"] = "󰒓",  -- Gear wireframe
        ["💬"] = "󰍩",  -- Chat wireframe
    }
    return wireframeMap[icon] or icon
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, CONFIG.WINDOW_SIZE.WIDTH, 0, CONFIG.WINDOW_SIZE.HEIGHT)
MainFrame.Position = UDim2.new(0.5, -CONFIG.WINDOW_SIZE.WIDTH/2, 0.5, -CONFIG.WINDOW_SIZE.HEIGHT/2)
MainFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
Corner.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, CONFIG.TITLE_HEIGHT)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = CONFIG.THEME.TITLE_BAR
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

-- Add corner rounding to title bar
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
TitleCorner.Parent = TitleBar

-- Create title text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Super"
TitleText.TextColor3 = CONFIG.THEME.TEXT
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextSize = 16
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Parent = TitleBar

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, CONFIG.TITLE_HEIGHT, 0, CONFIG.TITLE_HEIGHT)
CloseButton.Position = UDim2.new(1, -CONFIG.TITLE_HEIGHT, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = CONFIG.THEME.TEXT
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- Create ScrollingFrame for menu items
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Name = "MenuScroll"
MenuScroll.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 1, -50)
MenuScroll.Position = UDim2.new(0, 5, 0, 45)
MenuScroll.BackgroundTransparency = 1
MenuScroll.ScrollBarThickness = 0
MenuScroll.Parent = MainFrame

-- Create UIListLayout
local ListLayout = Instance.new("UIListLayout")
ListLayout.Name = "ListLayout"
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = MenuScroll

-- Create content area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -CONFIG.MENU_WIDTH - 10, 1, -CONFIG.TITLE_HEIGHT - 10)
ContentArea.Position = UDim2.new(0, CONFIG.MENU_WIDTH + 5, 0, CONFIG.TITLE_HEIGHT + 5)
ContentArea.BackgroundTransparency = 0.9
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Function to clear content area
local function clearContentArea()
    for _, child in ipairs(ContentArea:GetChildren()) do
        child:Destroy()
    end
end

-- Function to create section header
local function createSectionHeader(title)
    local header = Instance.new("TextLabel")
    header.Name = "SectionHeader"
    header.Size = UDim2.new(1, -20, 0, 30)
    header.Position = UDim2.new(0, 10, 0, 10)
    header.BackgroundTransparency = 1
    header.Text = title
    header.TextColor3 = CONFIG.THEME.ACCENT
    header.TextSize = 18
    header.Font = Enum.Font.SourceSansBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    return header
end

-- Function to create info label
local function createInfoLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 25)
    label.Position = UDim2.new(0, 20, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

-- Create dropdown menu
local function createDropdown(options, defaultOption, callback, posY)
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Size = UDim2.new(1, -40, 0, 30)
    dropdownContainer.Position = UDim2.new(0, 20, 0, posY)
    dropdownContainer.BackgroundTransparency = 0.9
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownContainer.BorderSizePixel = 0

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = defaultOption
    dropdownButton.TextColor3 = CONFIG.THEME.TEXT
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.Parent = dropdownContainer

    local optionsList = Instance.new("Frame")
    optionsList.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsList.Position = UDim2.new(0, 0, 1, 0)
    optionsList.BackgroundTransparency = 0.9
    optionsList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    optionsList.BorderSizePixel = 0
    optionsList.Visible = false
    optionsList.ZIndex = 2
    optionsList.Parent = dropdownContainer

    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optionButton.BackgroundTransparency = 1
        optionButton.Text = option
        optionButton.TextColor3 = CONFIG.THEME.TEXT
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.SourceSans
        optionButton.ZIndex = 2
        optionButton.Parent = optionsList

        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            optionsList.Visible = false
            callback(option)
        end)

        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.8
            }):Play()
        end)

        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 1
            }):Play()
        end)
    end

    dropdownButton.MouseButton1Click:Connect(function()
        optionsList.Visible = not optionsList.Visible
    end)

    return dropdownContainer
end

-- Function to change GUI size
local function changeGuiSize(sizeName)
    local size = CONFIG.SIZES[sizeName]
    local newSize = UDim2.new(0, size.WIDTH, 0, size.HEIGHT)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = newSize,
        Position = UDim2.new(0.5, -size.WIDTH/2, 0.5, -size.HEIGHT/2)
    }):Play()
end

-- Create menu buttons
local selectedButton = nil
for _, item in ipairs(MENU_ITEMS) do
    local Button = Instance.new("TextButton")
    Button.Name = item.name .. "Button"
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.LayoutOrder = item.layoutOrder
    Button.Parent = MenuScroll
    
    -- Create icon
    local Icon = Instance.new("TextLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 30, 1, 0)
    Icon.Position = UDim2.new(0, 0, 0, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = item.icon
    Icon.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    Icon.TextSize = 16
    Icon.Font = Enum.Font.SourceSansBold
    Icon.Parent = Button
    
    -- Create text label
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.Size = UDim2.new(1, -40, 1, 0)
    TextLabel.Position = UDim2.new(0, 35, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = item.name
    TextLabel.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    -- Button hover effect
    Button.MouseEnter:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Icon, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT
            }):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT
            }):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Icon, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
            TweenService:Create(TextLabel, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        if selectedButton then
            TweenService:Create(selectedButton:FindFirstChild("Icon"), TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
            TweenService:Create(selectedButton:FindFirstChild("Text"), TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
        selectedButton = Button
        Icon.TextColor3 = CONFIG.THEME.ACCENT
        TextLabel.TextColor3 = CONFIG.THEME.ACCENT
        
        -- Handle button functionality
        clearContentArea()
        
        if item.name == "Overview" then
            -- Create Player Info section
            local header = createSectionHeader("Player Info")
            header.Parent = ContentArea
            
            -- Get player info
            local player = game.Players.LocalPlayer
            local playerName = createInfoLabel("Name: " .. player.Name, 50)
            playerName.Parent = ContentArea
            
            local playerDisplayName = createInfoLabel("Display Name: " .. player.DisplayName, 80)
            playerDisplayName.Parent = ContentArea
        elseif item.name == "Settings" then
            -- Create UI Settings section
            local header = createSectionHeader("UI Settings")
            header.Parent = ContentArea
            
            -- Create size dropdown
            local sizeLabel = createInfoLabel("GUI Size:", 50)
            sizeLabel.Parent = ContentArea
            
            local sizeOptions = {"Small", "Normal", "Large"}
            local sizeDropdown = createDropdown(sizeOptions, "Normal", function(selected)
                changeGuiSize(selected)
            end, 80)
            sizeDropdown.Parent = ContentArea
        end
    end)
end

-- Update canvas size
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MenuScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Dragging functionality
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

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

UserInputService.InputChanged:Connect(updateDrag)

-- Close button handler
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Clean up
game:BindToClose(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)
