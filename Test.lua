-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- User Customization
local CUSTOM = {
    THEME = {
        -- Main Colors
        BACKGROUND = Color3.fromRGB(15, 15, 20),         -- Darker background
        TITLE_BAR = Color3.fromRGB(20, 20, 25),         -- Slightly lighter than background
        ACCENT = Color3.fromRGB(90, 120, 255),          -- Bright blue accent
        
        -- Text Colors
        TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),   -- Pure white
        TEXT_SECONDARY = Color3.fromRGB(180, 180, 180), -- Light gray
        TEXT_ACCENT = Color3.fromRGB(90, 120, 255),     -- Matching accent
        
        -- Button Colors
        BUTTON_NORMAL = Color3.fromRGB(40, 40, 45),     -- Button background
        BUTTON_HOVER = Color3.fromRGB(50, 50, 55),      -- Button hover state
        BUTTON_PRESS = Color3.fromRGB(30, 30, 35),      -- Button press state
        CLOSE_BUTTON = Color3.fromRGB(255, 70, 70),     -- Red close button
        
        -- Transparency
        BACKGROUND_TRANSPARENCY = 0,                     -- Solid background
        TITLE_BAR_TRANSPARENCY = 0,                     -- Solid title bar
        BUTTON_TRANSPARENCY = 0.1,                      -- Slightly transparent buttons
        BUTTON_HOVER_TRANSPARENCY = 0,                  -- Solid on hover
    },
    
    SIZES = {
        Small = {
            WIDTH = 400,                                -- Smaller width
            HEIGHT = 280                                -- Smaller height
        },
        Normal = {
            WIDTH = 500,                                -- Normal width
            HEIGHT = 320                                -- Normal height
        },
        Large = {
            WIDTH = 600,                                -- Large width
            HEIGHT = 360                                -- Large height
        }
    },
    
    LAYOUT = {
        CORNER_RADIUS = 6,                              -- Smaller corners
        TITLE_HEIGHT = 28,                              -- Smaller title bar
        MENU_WIDTH = 140,                               -- Narrower menu
        BUTTON_HEIGHT = 28,                             -- Smaller buttons
        PADDING = 8,                                    -- Smaller padding
        SCROLL_BAR_THICKNESS = 3,                       -- Thin scrollbar
    },
    
    FONTS = {
        TITLE = Enum.Font.GothamBold,                   -- Modern, bold font for title
        TEXT = Enum.Font.Gotham,                        -- Clean, readable font for text
        BUTTON = Enum.Font.GothamMedium,                -- Medium weight for buttons
    },
    
    ANIMATION = {
        TWEEN_SPEED = 0.3,                             -- Animation duration
        TWEEN_STYLE = Enum.EasingStyle.Quad,           -- Smooth easing
        HOVER_SPEED = 0.2,                             -- Quick hover response
    }
}

-- Constants (using customization)
local CONFIG = {
    THEME = {
        BACKGROUND = CUSTOM.THEME.BACKGROUND,
        TITLE_BAR = CUSTOM.THEME.TITLE_BAR,
        TEXT = CUSTOM.THEME.TEXT_PRIMARY,
        TEXT_SECONDARY = CUSTOM.THEME.TEXT_SECONDARY,
        ACCENT = CUSTOM.THEME.ACCENT,
        CLOSE_BUTTON = CUSTOM.THEME.CLOSE_BUTTON,
        TEXT_PRIMARY = CUSTOM.THEME.TEXT_PRIMARY
    },
    CORNER_RADIUS = CUSTOM.LAYOUT.CORNER_RADIUS,
    MENU_WIDTH = CUSTOM.LAYOUT.MENU_WIDTH,
    TITLE_HEIGHT = CUSTOM.LAYOUT.TITLE_HEIGHT,
    SIZES = CUSTOM.SIZES
}

-- Menu items with icons
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

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- State management
local currentState = {
    size = "Normal",
    isMinimized = false,
    width = CONFIG.SIZES.Normal.WIDTH,
    height = CONFIG.SIZES.Normal.HEIGHT,
    isDragging = false,
    dragStart = nil,
    startPos = nil
}

-- Teleport state and settings
local isTeleportEnabled = false
local currentDestination = nil
local teleportSpeed = 350 -- Default speed

-- Speed options for dropdown
local SPEED_OPTIONS = {
    {name = "Very Slow", speed = 100},
    {name = "Slow", speed = 200},
    {name = "Normal", speed = 350},
    {name = "Fast", speed = 500},
    {name = "Very Fast", speed = 750},
    {name = "Ultra Fast", speed = 1000}
}

-- NPC Data
local NPCS = {
    ["First Sea"] = {
        {name = "Marine Recruiter", cframe = CFrame.new(-2573.3374, 6.88881969, 2046.99817)},
        {name = "Sword Dealer", cframe = CFrame.new(-1405.45728, 29.8778248, 4.69083405)},
        {name = "Doctor", cframe = CFrame.new(-909.119751, 21.7444172, 4484.35791)},
        {name = "Mysterious Man", cframe = CFrame.new(-2299.39551, 7.39675856, 2000.79639)},
        {name = "Reset Stats", cframe = CFrame.new(-1889.21765, 7.39424276, 2069.42847)}
    },
    ["Second Sea"] = {
        {name = "Bartender", cframe = CFrame.new(-385.250916, 73.0458984, 297.388397)},
        {name = "Mysterious Scientist", cframe = CFrame.new(-6437.87793, 250.645355, -4498.92773)},
        {name = "Race Reroller", cframe = CFrame.new(-1054.02344, 73.8750763, 1220.76477)},
        {name = "Manager", cframe = CFrame.new(-386.874695, 73.0458984, 280.255371)}
    },
    ["Third Sea"] = {
        {name = "Elite Hunter", cframe = CFrame.new(-5418.892578125, 313.74130249023, -2824.9157714844)},
        {name = "Player Hunter", cframe = CFrame.new(-5558.1123046875, 313.74130249023, -2838.4624023438)},
        {name = "Bone Trader", cframe = CFrame.new(-8725.3125, 142.130615, 6066.50684)},
        {name = "Random Fruit", cframe = CFrame.new(-12491.169921875, 374.94024658203, -7551.677734375)}
    }
}

-- Blox Fruits Island Data
local ISLANDS = {
    ["First Sea"] = {
        {name = "Starter Island", cframe = CFrame.new(1071.2832, 16.3085976, 1426.86792)},
        {name = "Marine Start", cframe = CFrame.new(-2573.3374, 6.88881969, 2046.99817)},
        {name = "Middle Town", cframe = CFrame.new(-655.824158, 7.88708115, 1436.67908)},
        {name = "Jungle", cframe = CFrame.new(-1249.77222, 11.8870859, 341.356476)},
        {name = "Pirate Village", cframe = CFrame.new(-1122.34998, 4.78708982, 3855.91992)},
        {name = "Desert", cframe = CFrame.new(1094.14587, 6.47350502, 4192.88721)},
        {name = "Frozen Village", cframe = CFrame.new(1198.00928, 27.0074959, -1211.73376)},
        {name = "MarineFord", cframe = CFrame.new(-4505.375, 20.687294, 4260.55908)},
        {name = "Colosseum", cframe = CFrame.new(-1428.35474, 7.38933945, -3014.37305)},
        {name = "Sky 1st Floor", cframe = CFrame.new(-4970.21875, 717.707275, -2622.35449)},
        {name = "Sky 2nd Floor", cframe = CFrame.new(-4813.0249, 903.708557, -1912.69055)},
        {name = "Sky 3rd Floor", cframe = CFrame.new(-7952.31006, 5545.52832, -320.704956)},
        {name = "Prison", cframe = CFrame.new(4854.16455, 5.68742752, 740.194641)},
        {name = "Magma Village", cframe = CFrame.new(-5231.75879, 8.61593437, 8467.87695)},
        {name = "Underwater City", cframe = CFrame.new(61163.8516, 11.7796879, 1819.78418)},
        {name = "Fountain City", cframe = CFrame.new(5132.7124, 4.53632832, 4037.8562)}
    },
    ["Second Sea"] = {
        {name = "First Spot", cframe = CFrame.new(-11.845, 29.3297, 2771.026)},
        {name = "Kingdom of Rose", cframe = CFrame.new(-390.096466, 321.886353, 869.049377)},
        {name = "Mansion", cframe = CFrame.new(-390.096466, 321.886353, 869.049377)},
        {name = "Flamingo Room", cframe = CFrame.new(2284.43335, 15.152359, 875.790771)},
        {name = "Green Zone", cframe = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344)},
        {name = "Cafe", cframe = CFrame.new(-385.250916, 73.0458984, 297.388397)},
        {name = "Factory", cframe = CFrame.new(430.42569, 210.019623, -432.504791)},
        {name = "Colosseum", cframe = CFrame.new(-1836.58191, 44.5890656, 1360.30652)},
        {name = "Ghost Island", cframe = CFrame.new(-5571.84424, 195.182297, -795.432922)},
        {name = "Ghost Island 2nd", cframe = CFrame.new(-5931.77979, 5.19706631, -1189.6908)},
        {name = "Snow Mountain", cframe = CFrame.new(1384.68298, 453.569031, -4990.09766)},
        {name = "Hot and Cold", cframe = CFrame.new(-6026.96484, 14.7461271, -5071.96338)},
        {name = "Magma Side", cframe = CFrame.new(-5478.39209, 15.9775667, -5246.9126)},
        {name = "Cursed Ship", cframe = CFrame.new(923.21252441406, 125.05712890625, 32885.875)},
        {name = "Ice Castle", cframe = CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188)},
        {name = "Forgotten Island", cframe = CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875)},
        {name = "Usoapp Island", cframe = CFrame.new(4748.78857, 8.35370827, 2849.57959)},
        {name = "Minisky Island", cframe = CFrame.new(-260.358917, 49325.7031, -35259.3008)}
    },
    ["Third Sea"] = {
        {name = "Port Town", cframe = CFrame.new(-610.309692, 57.8323097, 6436.33594)},
        {name = "Hydra Island", cframe = CFrame.new(5229.99561, 603.916565, 345.154022)},
        {name = "Great Tree", cframe = CFrame.new(2174.94873, 28.7312393, -6728.83154)},
        {name = "Castle on the Sea", cframe = CFrame.new(-5477.62842, 313.794739, -2808.4585)},
        {name = "Floating Turtle", cframe = CFrame.new(-10919.2998, 331.788452, -8637.57227)},
        {name = "Mansion", cframe = CFrame.new(-12553.8125, 332.403961, -7621.91748)},
        {name = "Secret Temple", cframe = CFrame.new(5217.35693, 6.56511116, 1100.88159)},
        {name = "Friendly Arena", cframe = CFrame.new(5220.28955, 72.8193436, -1450.86304)},
        {name = "Beautiful Pirate Domain", cframe = CFrame.new(5310.8095703125, 160.75230407715, 129.29544067383)},
        {name = "Tiki Outpost", cframe = CFrame.new(-11355.0557, 367.994995, -10225.1641)},
        {name = "Peanut Island", cframe = CFrame.new(-2062.67773, 38.1294556, -10287.752)},
        {name = "Ice Cream Island", cframe = CFrame.new(-880.894531, 118.245354, -11030.7607)},
        {name = "Cake Loaf", cframe = CFrame.new(-2099.33154, 37.8250542, -11892.959)}
    }
}

-- Function to change GUI size
local function changeGuiSize(sizeName)
    if currentState.isMinimized then return end
    
    local size = CONFIG.SIZES[sizeName]
    if not size then return end
    
    currentState.size = sizeName
    currentState.width = size.WIDTH
    currentState.height = size.HEIGHT
    
    TweenService:Create(MainFrame, TweenInfo.new(CUSTOM.ANIMATION.TWEEN_SPEED, CUSTOM.ANIMATION.TWEEN_STYLE), {
        Size = UDim2.new(0, size.WIDTH, 0, size.HEIGHT),
        Position = UDim2.new(0.5, -size.WIDTH/2, 0.5, -size.HEIGHT/2)
    }):Play()
end

-- Function to toggle minimize
local function toggleMinimize()
    currentState.isMinimized = not currentState.isMinimized
    
    local targetSize, targetPosition
    
    if currentState.isMinimized then
        targetSize = UDim2.new(0, currentState.width, 0, CONFIG.TITLE_HEIGHT)
    else
        targetSize = UDim2.new(0, currentState.width, 0, currentState.height)
    end
    
    targetPosition = UDim2.new(0.5, -targetSize.X.Offset/2, 0.5, -targetSize.Y.Offset/2)
    
    TweenService:Create(MainFrame, TweenInfo.new(CUSTOM.ANIMATION.TWEEN_SPEED, CUSTOM.ANIMATION.TWEEN_STYLE), {
        Size = targetSize,
        Position = targetPosition
    }):Play()
end

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, currentState.width, 0, currentState.height)
MainFrame.Position = UDim2.new(0.5, -currentState.width/2, 0.5, -currentState.height/2)
MainFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Add corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
Corner.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, CONFIG.TITLE_HEIGHT)
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
TitleText.Size = UDim2.new(0, 100, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Super"
TitleText.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
TitleText.TextSize = 16
TitleText.Font = CUSTOM.FONTS.TITLE
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Create minimize button (moved to right)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, CUSTOM.LAYOUT.BUTTON_HEIGHT, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
MinimizeButton.Position = UDim2.new(1, -CUSTOM.LAYOUT.BUTTON_HEIGHT*2, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
MinimizeButton.TextSize = 16
MinimizeButton.Font = CUSTOM.FONTS.BUTTON
MinimizeButton.Parent = TitleBar

MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, CUSTOM.LAYOUT.BUTTON_HEIGHT, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
CloseButton.Position = UDim2.new(1, -CUSTOM.LAYOUT.BUTTON_HEIGHT, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = CONFIG.THEME.CLOSE_BUTTON
CloseButton.TextSize = 20
CloseButton.Font = CUSTOM.FONTS.BUTTON
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Create ScrollingFrame for menu items
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Name = "MenuScroll"
MenuScroll.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 1, -CONFIG.TITLE_HEIGHT - CUSTOM.LAYOUT.PADDING)
MenuScroll.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, CONFIG.TITLE_HEIGHT + CUSTOM.LAYOUT.PADDING/2)
MenuScroll.BackgroundTransparency = 1
MenuScroll.ScrollBarThickness = CUSTOM.LAYOUT.SCROLL_BAR_THICKNESS
MenuScroll.ScrollBarImageColor3 = CUSTOM.THEME.ACCENT
MenuScroll.Parent = MainFrame

-- Create UIListLayout for menu items
local ListLayout = Instance.new("UIListLayout")
ListLayout.Name = "ListLayout"
ListLayout.Padding = UDim.new(0, CUSTOM.LAYOUT.PADDING/2)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = MenuScroll

-- Create content area
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -(CONFIG.MENU_WIDTH + CUSTOM.LAYOUT.PADDING * 3), 1, -(CONFIG.TITLE_HEIGHT + CUSTOM.LAYOUT.PADDING * 2))
ContentArea.Position = UDim2.new(0, CONFIG.MENU_WIDTH + CUSTOM.LAYOUT.PADDING * 2, 0, CONFIG.TITLE_HEIGHT + CUSTOM.LAYOUT.PADDING)
ContentArea.BackgroundColor3 = CUSTOM.THEME.BACKGROUND
ContentArea.BackgroundTransparency = 0.5
ContentArea.BorderSizePixel = 0
ContentArea.ScrollBarThickness = CUSTOM.LAYOUT.SCROLL_BAR_THICKNESS
ContentArea.ScrollBarImageColor3 = CUSTOM.THEME.ACCENT
ContentArea.Parent = MainFrame

-- Add corner rounding to content area
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
ContentCorner.Parent = ContentArea

-- Create content layout
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, CUSTOM.LAYOUT.PADDING)
ContentLayout.Parent = ContentArea

-- Function to clear content area
local function clearContentArea()
    for _, child in ipairs(ContentArea:GetChildren()) do
        if child:IsA("GuiObject") and child ~= ContentCorner and child ~= ContentLayout then
            child:Destroy()
        end
    end
end

-- Function to create section header
local function createSectionHeader(title)
    local headerContainer = Instance.new("Frame")
    headerContainer.Name = "SectionHeader"
    headerContainer.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    headerContainer.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.PADDING)
    headerContainer.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    headerContainer.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    headerContainer.BorderSizePixel = 0
    
    -- Add corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = headerContainer
    
    -- Add header text
    local headerText = Instance.new("TextLabel")
    headerText.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 1, 0)
    headerText.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, 0)
    headerText.BackgroundTransparency = 1
    headerText.Text = title
    headerText.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
    headerText.TextSize = 16
    headerText.Font = CUSTOM.FONTS.TITLE
    headerText.TextXAlignment = Enum.TextXAlignment.Left
    headerText.Parent = headerContainer
    
    return headerContainer
end

-- Function to create info label
local function createInfoLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    label.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = CUSTOM.FONTS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = ContentArea
    return label
end

-- Function to create toggle button
local function createToggle(text, posY, default)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    toggleContainer.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = ContentArea
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = CUSTOM.FONTS.TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.BackgroundColor3 = default and CUSTOM.THEME.ACCENT or CUSTOM.THEME.BUTTON_NORMAL
    toggle.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    toggle.Text = ""
    toggle.Parent = toggleContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = toggle
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8)
    circle.BackgroundColor3 = CUSTOM.THEME.TEXT_PRIMARY
    circle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    local enabled = default
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenService:Create(toggle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundColor3 = enabled and CUSTOM.THEME.ACCENT or CUSTOM.THEME.BUTTON_NORMAL
        }):Play()
        TweenService:Create(circle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end)
    
    return toggle, enabled
end

-- Function to create teleport toggle
local function createTeleportToggle()
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    toggleContainer.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT + CUSTOM.LAYOUT.PADDING*2)
    toggleContainer.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    toggleContainer.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    toggleContainer.Parent = ContentArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = toggleContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "🔒 Enable Teleport"
    label.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    label.TextSize = 14
    label.Font = CUSTOM.FONTS.BUTTON
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -45, 0.5, -10)
    toggle.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    toggle.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    toggle.Text = ""
    toggle.Parent = toggleContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = CUSTOM.THEME.TEXT_PRIMARY
    circle.Parent = toggle
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    -- Toggle functionality
    toggle.MouseButton1Click:Connect(function()
        isTeleportEnabled = not isTeleportEnabled
        label.Text = isTeleportEnabled and "🔓 Teleport Enabled" or "🔒 Enable Teleport"
        label.TextColor3 = isTeleportEnabled and CUSTOM.THEME.ACCENT or CUSTOM.THEME.TEXT_SECONDARY
        
        TweenService:Create(toggle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundColor3 = isTeleportEnabled and CUSTOM.THEME.ACCENT or CUSTOM.THEME.BUTTON_NORMAL
        }):Play()
        
        TweenService:Create(circle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            Position = isTeleportEnabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if not isTeleportEnabled then
            currentDestination = nil
        end
    end)
    
    return toggleContainer, function() 
        isTeleportEnabled = false
        label.Text = "🔒 Enable Teleport"
        label.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
        TweenService:Create(toggle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
        }):Play()
        TweenService:Create(circle, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            Position = UDim2.new(0, 2, 0.5, -8)
        }):Play()
    end
end

-- Function to create teleport button
local function createTeleportButton(island, posY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    button.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    button.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    button.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    button.Text = island.name
    button.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    button.TextSize = 14
    button.Font = CUSTOM.FONTS.BUTTON
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = ContentArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = button
    
    -- Add hover effect
    button.MouseEnter:Connect(function()
        if not isTeleportEnabled then return end
        TweenService:Create(button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundTransparency = CUSTOM.THEME.BUTTON_HOVER_TRANSPARENCY,
            TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if currentDestination ~= island then
            TweenService:Create(button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY,
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    -- Add click effect and teleport functionality
    button.MouseButton1Click:Connect(function()
        if not isTeleportEnabled then
            -- Visual feedback for disabled state
            for i = 1, 3 do
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.3
                }):Play()
                wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
                }):Play()
                wait(0.1)
            end
            return
        end
        
        -- Visual feedback
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = CUSTOM.THEME.ACCENT,
            TextColor3 = CUSTOM.THEME.TEXT_PRIMARY,
            BackgroundTransparency = 0
        }):Play()
        
        -- Attempt to teleport
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            currentDestination = island
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            -- Disable character movement during teleport
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
            
            -- Smooth teleport implementation
            local function smoothMoveToDestination(player, targetCFrame, speed)
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local humanoidRootPart = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                
                -- Disable character collision temporarily
                local oldCollisionGroup = humanoidRootPart.CollisionGroupId
                humanoidRootPart.CollisionGroupId = 0
                
                -- Store original values
                local originalGravity = workspace.Gravity
                local originalStateType = humanoid.StateChanged:Wait()
                
                -- Modify character state for smooth movement
                workspace.Gravity = 0
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                
                -- Create movement connection
                local moveConnection
                moveConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if not character or not character:FindFirstChild("HumanoidRootPart") then
                        moveConnection:Disconnect()
                        return
                    end
                    
                    local currentPos = humanoidRootPart.Position
                    local targetPos = targetCFrame.Position
                    local direction = (targetPos - currentPos).Unit
                    local distance = (targetPos - currentPos).Magnitude
                    
                    if distance < 5 then
                        -- Reached destination
                        humanoidRootPart.CFrame = targetCFrame
                        moveConnection:Disconnect()
                        
                        -- Restore original state
                        workspace.Gravity = originalGravity
                        humanoid:ChangeState(originalStateType)
                        humanoidRootPart.CollisionGroupId = oldCollisionGroup
                        
                        -- Re-enable character movement
                        if humanoid then
                            humanoid.PlatformStand = false
                        end
                        
                        return
                    end
                    
                    -- Move towards target
                    local moveStep = math.min(speed * game:GetService("RunService").Heartbeat:Wait(), distance)
                    humanoidRootPart.CFrame = CFrame.new(currentPos + direction * moveStep) * targetCFrame.Rotation
                end)
            end
            
            -- Start smooth movement to destination
            smoothMoveToDestination(player, island.cframe, teleportSpeed)
        end
    end)
    
    return button
end

-- Function to create a dropdown section
local function createDropdownSection(title, items, startY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    container.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, startY)
    container.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    container.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    container.Parent = ContentArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = container
    
    local titleButton = Instance.new("TextButton")
    titleButton.Size = UDim2.new(1, 0, 1, 0)
    titleButton.BackgroundTransparency = 1
    titleButton.Text = "▶ " .. title
    titleButton.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
    titleButton.TextSize = 14
    titleButton.Font = CUSTOM.FONTS.BUTTON
    titleButton.TextXAlignment = Enum.TextXAlignment.Left
    titleButton.Parent = container
    
    local itemsContainer = Instance.new("Frame")
    itemsContainer.Size = UDim2.new(1, 0, 0, 0)
    itemsContainer.Position = UDim2.new(0, 0, 1, 0)
    itemsContainer.BackgroundTransparency = 1
    itemsContainer.ClipsDescendants = true
    itemsContainer.Parent = container
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = itemsContainer
    
    local isExpanded = false
    local buttons = {}
    
    -- Create teleport buttons
    for i, island in ipairs(items) do
        local button = createTeleportButton(island, (i-1) * (CUSTOM.LAYOUT.BUTTON_HEIGHT + 2))
        button.Parent = itemsContainer
        button.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
        button.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, (i-1) * (CUSTOM.LAYOUT.BUTTON_HEIGHT + 2))
        table.insert(buttons, button)
    end
    
    -- Toggle dropdown
    titleButton.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        titleButton.Text = (isExpanded and "▼ " or "▶ ") .. title
        
        local targetSize = isExpanded and 
            UDim2.new(1, 0, 0, #items * (CUSTOM.LAYOUT.BUTTON_HEIGHT + 2)) or 
            UDim2.new(1, 0, 0, 0)
        
        TweenService:Create(itemsContainer, TweenInfo.new(0.3), {
            Size = targetSize
        }):Play()
    end)
    
    return container, CUSTOM.LAYOUT.BUTTON_HEIGHT + (isExpanded and #items * (CUSTOM.LAYOUT.BUTTON_HEIGHT + 2) or 0)
end

-- Function to create a scrollable frame
local function createScrollableFrame(parent, size, position)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = size
    scrollFrame.Position = position
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = CUSTOM.LAYOUT.SCROLL_BAR_THICKNESS
    scrollFrame.ScrollBarImageColor3 = CUSTOM.THEME.ACCENT
    scrollFrame.Parent = parent
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollFrame
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, CUSTOM.LAYOUT.PADDING)
    
    -- Auto-adjust canvas size
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end)
    
    return scrollFrame
end

-- Function to create a section heading
local function createSectionHeading(parent, text, posY)
    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    heading.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    heading.BackgroundColor3 = CUSTOM.THEME.TITLE_BAR
    heading.BackgroundTransparency = 0.5
    heading.Text = text
    heading.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
    heading.TextSize = 14
    heading.Font = CUSTOM.FONTS.TITLE
    heading.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = heading
    
    return heading
end

-- Function to create speed dropdown
local function createSpeedDropdown(parent, posY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    container.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 1, 0)
    dropdown.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    dropdown.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    dropdown.Text = "Speed: Normal (350)"
    dropdown.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    dropdown.TextSize = 14
    dropdown.Font = CUSTOM.FONTS.BUTTON
    dropdown.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = dropdown
    
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, #SPEED_OPTIONS * CUSTOM.LAYOUT.BUTTON_HEIGHT)
    optionsFrame.Position = UDim2.new(0, 0, 1, 2)
    optionsFrame.BackgroundColor3 = CUSTOM.THEME.BACKGROUND
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = container
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    optionsCorner.Parent = optionsFrame
    
    for i, option in ipairs(SPEED_OPTIONS) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * CUSTOM.LAYOUT.BUTTON_HEIGHT)
        optionButton.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
        optionButton.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
        optionButton.Text = option.name .. " (" .. option.speed .. ")"
        optionButton.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
        optionButton.TextSize = 14
        optionButton.Font = CUSTOM.FONTS.BUTTON
        optionButton.ZIndex = 10
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            teleportSpeed = option.speed
            dropdown.Text = "Speed: " .. option.name .. " (" .. option.speed .. ")"
            optionsFrame.Visible = false
        end)
        
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_HOVER_TRANSPARENCY,
                TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY,
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        optionsFrame.Visible = not optionsFrame.Visible
    end)
    
    return container
end

-- Function to create teleport content
local function createTeleportContent()
    -- Clear existing content
    for _, child in ipairs(ContentArea:GetChildren()) do
        child:Destroy()
    end
    
    -- Create main scrolling frame
    local mainScroll = createScrollableFrame(
        ContentArea,
        UDim2.new(1, 0, 1, 0),
        UDim2.new(0, 0, 0, 0)
    )
    
    -- Create enable/disable toggle
    local toggle = createTeleportToggle()
    toggle.Parent = mainScroll
    
    -- Create speed dropdown
    local speedDropdown = createSpeedDropdown(mainScroll, CUSTOM.LAYOUT.BUTTON_HEIGHT * 2)
    
    -- Create Island Teleport section
    local islandHeading = createSectionHeading(mainScroll, "🏝 Island Teleport", CUSTOM.LAYOUT.BUTTON_HEIGHT * 3)
    
    -- Create island teleport sections
    local currentY = CUSTOM.LAYOUT.BUTTON_HEIGHT * 4
    for sea, locations in pairs(ISLANDS) do
        local dropdown = createDropdownSection(sea, locations, currentY)
        dropdown.Parent = mainScroll
        currentY = currentY + CUSTOM.LAYOUT.BUTTON_HEIGHT + 
            (dropdown.Expanded and #locations * (CUSTOM.LAYOUT.BUTTON_HEIGHT + CUSTOM.LAYOUT.PADDING) or 0)
    end
    
    -- Create NPC Teleport section
    local npcHeading = createSectionHeading(mainScroll, "🧟‍♂️ NPC Teleport", currentY + CUSTOM.LAYOUT.BUTTON_HEIGHT)
    npcHeading.Parent = mainScroll
    currentY = currentY + CUSTOM.LAYOUT.BUTTON_HEIGHT * 2
    
    -- Create NPC teleport sections
    for sea, npcs in pairs(NPCS) do
        local dropdown = createDropdownSection(sea, npcs, currentY)
        dropdown.Parent = mainScroll
        currentY = currentY + CUSTOM.LAYOUT.BUTTON_HEIGHT +
            (dropdown.Expanded and #npcs * (CUSTOM.LAYOUT.BUTTON_HEIGHT + CUSTOM.LAYOUT.PADDING) or 0)
    end
end

-- Function to create teleport button
local function createTeleportButton(location, posY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    button.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, posY)
    button.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    button.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    button.Text = location.name
    button.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    button.TextSize = 14
    button.Font = CUSTOM.FONTS.BUTTON
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = ContentArea
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    corner.Parent = button
    
    -- Add hover effect
    button.MouseEnter:Connect(function()
        if not isTeleportEnabled then return end
        TweenService:Create(button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundTransparency = CUSTOM.THEME.BUTTON_HOVER_TRANSPARENCY,
            TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if currentDestination ~= location then
            TweenService:Create(button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY,
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    -- Add click effect and teleport functionality
    button.MouseButton1Click:Connect(function()
        if not isTeleportEnabled then
            -- Visual feedback for disabled state
            for i = 1, 3 do
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = 0.3
                }):Play()
                wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1), {
                    BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
                }):Play()
                wait(0.1)
            end
            return
        end
        
        -- Create confirmation dialog
        local confirmDialog = Instance.new("Frame")
        confirmDialog.Size = UDim2.new(0, 200, 0, 100)
        confirmDialog.Position = UDim2.new(0.5, -100, 0.5, -50)
        confirmDialog.BackgroundColor3 = CUSTOM.THEME.BACKGROUND
        confirmDialog.BorderSizePixel = 0
        confirmDialog.ZIndex = 100
        confirmDialog.Parent = ScreenGui
        
        local dialogCorner = Instance.new("UICorner")
        dialogCorner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
        dialogCorner.Parent = confirmDialog
        
        local message = Instance.new("TextLabel")
        message.Size = UDim2.new(1, 0, 0.5, 0)
        message.BackgroundTransparency = 1
        message.Text = "Teleport to " .. location.name .. "?"
        message.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        message.TextSize = 14
        message.Font = CUSTOM.FONTS.TEXT
        message.ZIndex = 100
        message.Parent = confirmDialog
        
        local confirmButton = Instance.new("TextButton")
        confirmButton.Size = UDim2.new(0.4, 0, 0.3, 0)
        confirmButton.Position = UDim2.new(0.1, 0, 0.6, 0)
        confirmButton.BackgroundColor3 = CUSTOM.THEME.ACCENT
        confirmButton.Text = "Confirm"
        confirmButton.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        confirmButton.TextSize = 14
        confirmButton.Font = CUSTOM.FONTS.BUTTON
        confirmButton.ZIndex = 100
        confirmButton.Parent = confirmDialog
        
        local cancelButton = Instance.new("TextButton")
        cancelButton.Size = UDim2.new(0.4, 0, 0.3, 0)
        cancelButton.Position = UDim2.new(0.5, 0, 0.6, 0)
        cancelButton.BackgroundColor3 = CUSTOM.THEME.CLOSE_BUTTON
        cancelButton.Text = "Cancel"
        cancelButton.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        cancelButton.TextSize = 14
        cancelButton.Font = CUSTOM.FONTS.BUTTON
        cancelButton.ZIndex = 100
        cancelButton.Parent = confirmDialog
        
        local function closeDialog()
            confirmDialog:Destroy()
        end
        
        confirmButton.MouseButton1Click:Connect(function()
            closeDialog()
            
            -- Visual feedback
            TweenService:Create(button, TweenInfo.new(0.1), {
                BackgroundColor3 = CUSTOM.THEME.ACCENT,
                TextColor3 = CUSTOM.THEME.TEXT_PRIMARY,
                BackgroundTransparency = 0
            }):Play()
            
            -- Attempt to teleport
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                currentDestination = location
                
                -- Disable character movement during teleport
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                end
                
                -- Smooth teleport implementation
                local function smoothMoveToDestination(player, targetCFrame, speed)
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                    
                    local humanoidRootPart = character.HumanoidRootPart
                    local humanoid = character:FindFirstChild("Humanoid")
                    
                    -- Disable character collision temporarily
                    local oldCollisionGroup = humanoidRootPart.CollisionGroupId
                    humanoidRootPart.CollisionGroupId = 0
                    
                    -- Store original values
                    local originalGravity = workspace.Gravity
                    local originalStateType = humanoid.StateChanged:Wait()
                    
                    -- Modify character state for smooth movement
                    workspace.Gravity = 0
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                    
                    -- Create movement connection
                    local moveConnection
                    moveConnection = game:GetService("RunService").Heartbeat:Connect(function()
                        if not character or not character:FindFirstChild("HumanoidRootPart") then
                            moveConnection:Disconnect()
                            return
                        end
                        
                        local currentPos = humanoidRootPart.Position
                        local targetPos = targetCFrame.Position
                        local direction = (targetPos - currentPos).Unit
                        local distance = (targetPos - currentPos).Magnitude
                        
                        if distance < 5 then
                            -- Reached destination
                            humanoidRootPart.CFrame = targetCFrame
                            moveConnection:Disconnect()
                            
                            -- Restore original state
                            workspace.Gravity = originalGravity
                            humanoid:ChangeState(originalStateType)
                            humanoidRootPart.CollisionGroupId = oldCollisionGroup
                            
                            -- Re-enable character movement
                            if humanoid then
                                humanoid.PlatformStand = false
                            end
                            
                            return
                        end
                        
                        -- Move towards target
                        local moveStep = math.min(speed * game:GetService("RunService").Heartbeat:Wait(), distance)
                        humanoidRootPart.CFrame = CFrame.new(currentPos + direction * moveStep) * targetCFrame.Rotation
                    end)
                end
                
                -- Start smooth movement to destination
                smoothMoveToDestination(player, location.cframe, teleportSpeed)
            end
        end)
        
        cancelButton.MouseButton1Click:Connect(closeDialog)
    end)
    
    return button
end

-- Create menu buttons
local selectedButton = nil
for _, item in ipairs(MENU_ITEMS) do
    local Button = Instance.new("TextButton")
    Button.Name = item.name .. "Button"
    Button.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
    Button.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
    Button.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
    Button.Text = ""
    Button.LayoutOrder = item.layoutOrder
    Button.Parent = MenuScroll
    
    -- Add corner rounding to button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
    ButtonCorner.Parent = Button
    
    -- Create icon
    local Icon = Instance.new("TextLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, CUSTOM.LAYOUT.BUTTON_HEIGHT, 1, 0)
    Icon.Position = UDim2.new(0, 0, 0, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = item.icon
    Icon.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    Icon.TextSize = 16
    Icon.Font = CUSTOM.FONTS.TEXT
    Icon.Parent = Button
    
    -- Create text label
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "Text"
    TextLabel.Size = UDim2.new(1, -CUSTOM.LAYOUT.BUTTON_HEIGHT - CUSTOM.LAYOUT.PADDING, 1, 0)
    TextLabel.Position = UDim2.new(0, CUSTOM.LAYOUT.BUTTON_HEIGHT + CUSTOM.LAYOUT.PADDING/2, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = item.name
    TextLabel.TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
    TextLabel.TextSize = 14
    TextLabel.Font = CUSTOM.FONTS.TEXT
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Button
    
    -- Button hover effect
    Button.MouseEnter:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_HOVER_TRANSPARENCY,
                BackgroundColor3 = CUSTOM.THEME.BUTTON_HOVER
            }):Play()
            TweenService:Create(Icon, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
            }):Play()
            TweenService:Create(TextLabel, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
            }):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY,
                BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
            }):Play()
            TweenService:Create(Icon, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
            TweenService:Create(TextLabel, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        if selectedButton then
            TweenService:Create(selectedButton, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY,
                BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
            }):Play()
            TweenService:Create(selectedButton:FindFirstChild("Icon"), TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
            TweenService:Create(selectedButton:FindFirstChild("Text"), TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
                TextColor3 = CUSTOM.THEME.TEXT_SECONDARY
            }):Play()
        end
        
        selectedButton = Button
        TweenService:Create(Button, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            BackgroundTransparency = 0,
            BackgroundColor3 = CUSTOM.THEME.ACCENT
        }):Play()
        TweenService:Create(Icon, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        }):Play()
        TweenService:Create(TextLabel, TweenInfo.new(CUSTOM.ANIMATION.HOVER_SPEED), {
            TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
        }):Play()
        
        clearContentArea()
        
        -- Handle content for each section
        if item.name == "Teleport" then
            createTeleportContent()
        elseif item.name == "Overview" then
            local header = createSectionHeader("Player Info")
            header.Parent = ContentArea
            
            local player = game.Players.LocalPlayer
            createInfoLabel("Username: " .. player.Name, 50)
            createInfoLabel("Display Name: " .. player.DisplayName, 90)
            createInfoLabel("Account Age: " .. player.AccountAge .. " days", 130)
            
        elseif item.name == "Settings" then
            local header = createSectionHeader("UI Settings")
            header.Parent = ContentArea
            
            createInfoLabel("GUI Size", 50)
            local sizeY = 90
            for _, size in ipairs({"Small", "Normal", "Large"}) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 80, 0, 30)
                btn.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING + (sizeY - 90), 0, sizeY)
                btn.BackgroundColor3 = currentState.size == size and CUSTOM.THEME.ACCENT or CUSTOM.THEME.BUTTON_NORMAL
                btn.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
                btn.Text = size
                btn.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
                btn.Font = CUSTOM.FONTS.BUTTON
                btn.Parent = ContentArea
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
                corner.Parent = btn
                
                btn.MouseButton1Click:Connect(function()
                    changeGuiSize(size)
                end)
                
                sizeY = sizeY + 40
            end
            
            local visualHeader = createSectionHeader("Visual Settings")
            visualHeader.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, sizeY + 20)
            visualHeader.Parent = ContentArea
            
            createToggle("Enable Animations", sizeY + 70, true)
            createToggle("Show Tooltips", sizeY + 110, true)
            
        else
            local header = createSectionHeader(item.name)
            header.Parent = ContentArea
            createInfoLabel("Coming soon...", 50)
        end
    end)
end

-- Update canvas size
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MenuScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end)

-- Update canvas size for content area
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + CUSTOM.LAYOUT.PADDING)
end)

-- Dragging functionality
local function updateDrag(input)
    if currentState.isDragging then
        local delta = input.Position - currentState.dragStart
        MainFrame.Position = UDim2.new(
            currentState.startPos.X.Scale,
            currentState.startPos.X.Offset + delta.X,
            currentState.startPos.Y.Scale,
            currentState.startPos.Y.Offset + delta.Y
        )
    end
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        currentState.isDragging = true
        currentState.dragStart = input.Position
        currentState.startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        currentState.isDragging = false
    end
end)

-- Clean up
game:BindToClose(function()
    if ScreenGui then
        ScreenGui:Destroy()
    end
end)
