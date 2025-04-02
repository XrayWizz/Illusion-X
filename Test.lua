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

-- Teleport state
local isTeleportEnabled = false
local currentDestination = nil

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
            player.Character.HumanoidRootPart.CFrame = island.cframe
            
            -- Check if player reached destination
            local function checkDestination()
                wait(0.5) -- Wait for teleport
                local distance = (player.Character.HumanoidRootPart.Position - island.cframe.Position).Magnitude
                if distance < 50 then -- If player is within 50 studs of destination
                    disableTeleport()
                end
            end
            coroutine.wrap(checkDestination)()
        end
    end)
    
    return button
end

-- Blox Fruits Island Data
local ISLANDS = {
    {name = "Starter Island", cframe = CFrame.new(1071.2832, 16.3085976, 1426.86792)},
    {name = "Marine Fortress", cframe = CFrame.new(-4984.47461, 20.6520348, 4305.39795)},
    {name = "Middle Town", cframe = CFrame.new(-655.824158, 7.88708115, 1436.67908)},
    {name = "Jungle", cframe = CFrame.new(-1249.77222, 11.8870859, 341.356476)},
    {name = "Pirate Village", cframe = CFrame.new(-1122.34998, 4.78708982, 3855.91992)},
    {name = "Desert", cframe = CFrame.new(1094.14587, 6.47350502, 4192.88721)},
    {name = "Frozen Village", cframe = CFrame.new(1198.00928, 27.0074959, -1211.73376)},
    {name = "MarineFord", cframe = CFrame.new(-4882.8623, 22.6520386, 4255.53516)},
    {name = "Colosseum", cframe = CFrame.new(-1836.58191, 44.8870926, 1360.30652)},
    {name = "Sky Island 1", cframe = CFrame.new(-4970.21875, 717.707275, -2622.35449)},
    {name = "Prison", cframe = CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656)},
    {name = "Magma Village", cframe = CFrame.new(-5231.75879, 8.61593437, 8467.87695)},
    {name = "Sky Island 2", cframe = CFrame.new(-7894.6176757813, 5545.6416015625, -380.29119873047)},
    {name = "Sky Island 3", cframe = CFrame.new(-7994.48389, 5756.22461, -1088.39246)},
    {name = "Snow Island", cframe = CFrame.new(-4706.36768, 20.8098927, -2635.82104)},
    {name = "Sea Restaurant", cframe = CFrame.new(-1839.63574, 40.6520386, -2971.47314)},
    {name = "Fishman Island", cframe = CFrame.new(3893.953125, 5.3989524841309, -1893.4851074219)},
    {name = "Fountain City", cframe = CFrame.new(5244.7124, 38.526943, 4073.3413)},
    {name = "Green Zone", cframe = CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344)},
    {name = "Cafe", cframe = CFrame.new(-385.250916, 73.0458984, 297.388397)},
    {name = "Mansion", cframe = CFrame.new(-390.096313, 331.886475, 673.464966)}
}

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
            local header = createSectionHeader("🏝️ Blox Fruits Islands")
            header.Parent = ContentArea
            
            -- Create teleport toggle
            local toggleContainer, disableTeleport = createTeleportToggle()
            toggleContainer.Parent = ContentArea
            
            -- Create search bar
            local searchBox = Instance.new("TextBox")
            searchBox.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT)
            searchBox.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT*2 + CUSTOM.LAYOUT.PADDING*3)
            searchBox.BackgroundColor3 = CUSTOM.THEME.BUTTON_NORMAL
            searchBox.BackgroundTransparency = CUSTOM.THEME.BUTTON_TRANSPARENCY
            searchBox.PlaceholderText = "🔍 Search islands..."
            searchBox.Text = ""
            searchBox.TextColor3 = CUSTOM.THEME.TEXT_PRIMARY
            searchBox.PlaceholderColor3 = CUSTOM.THEME.TEXT_SECONDARY
            searchBox.TextSize = 14
            searchBox.Font = CUSTOM.FONTS.TEXT
            searchBox.Parent = ContentArea
            
            local searchCorner = Instance.new("UICorner")
            searchCorner.CornerRadius = UDim.new(0, CUSTOM.LAYOUT.CORNER_RADIUS)
            searchCorner.Parent = searchBox
            
            -- Create island buttons container
            local islandContainer = Instance.new("Frame")
            islandContainer.Name = "IslandContainer"
            islandContainer.Size = UDim2.new(1, -CUSTOM.LAYOUT.PADDING*2, 0, 0)
            islandContainer.Position = UDim2.new(0, CUSTOM.LAYOUT.PADDING, 0, CUSTOM.LAYOUT.BUTTON_HEIGHT*3 + CUSTOM.LAYOUT.PADDING*4)
            islandContainer.BackgroundTransparency = 1
            islandContainer.AutomaticSize = Enum.AutomaticSize.Y
            islandContainer.Parent = ContentArea
            
            -- Create and add island buttons
            local function updateIslands(filter)
                -- Clear existing buttons
                for _, child in ipairs(islandContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Add filtered buttons
                local posY = 0
                for _, island in ipairs(ISLANDS) do
                    if not filter or string.find(string.lower(island.name), string.lower(filter)) then
                        local button = createTeleportButton(island, posY)
                        button.Parent = islandContainer
                        posY = posY + CUSTOM.LAYOUT.BUTTON_HEIGHT + CUSTOM.LAYOUT.PADDING
                    end
                end
            end
            
            -- Initial island list
            updateIslands()
            
            -- Search functionality
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                updateIslands(searchBox.Text)
            end)
            
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
