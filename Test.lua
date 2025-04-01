local buttonList = {
    { "Overview", "", "View your player information and hub status.", showOverviewContent },
    { "Farm", "", "Configure and control farming settings.", showFarmContent },
    { "Sea", "", "Access sea-related features.", showSeaContent },
    { "Islands", "", "Navigate and manage islands.", showIslandsContent },
    { "Quests", "", "View and track available quests.", showQuestsContent },
    { "Fruit", "", "Manage fruit-related features.", showFruitContent },
    { "Teleport", "", "Quick teleportation options.", showTeleportContent },
    { "Status", "", "Check player and game status.", showStatusContent },
    { "Visual", "", "Adjust visual settings and effects.", showVisualContent },
    { "Shop", "", "Access the in-game shop.", showShopContent },
    { "Misc.", "", "Access other features and tools.", showMiscContent },
    { "Settings", "", "Configure UI and game settings.", showSettingsContent }
}

-- Function to format numbers with commas
local function formatNumber(number)
    local formatted = tostring(number)
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- Function to get player information
local function getPlayerInfo()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    return {
        Name = player.Name,
        DisplayName = player.DisplayName,
        Level = player.Level and player.Level.Value or 0,
        Beli = player.Data and player.Data.Beli and formatNumber(player.Data.Beli.Value) or "0",
        Fragments = player.Data and player.Data.Fragments and formatNumber(player.Data.Fragments.Value) or "0",
        Health = humanoid and math.floor(humanoid.Health) or 0,
        MaxHealth = humanoid and math.floor(humanoid.MaxHealth) or 0,
        Defense = player.Data and player.Data.Defense and player.Data.Defense.Value or 0,
        Melee = player.Data and player.Data.Melee and player.Data.Melee.Value or 0,
        Sword = player.Data and player.Data.Sword and player.Data.Sword.Value or 0,
        DevilFruit = player.Data and player.Data.DevilFruit and player.Data.DevilFruit.Value or "None",
        Bounty = player.Data and player.Data.Bounty and formatNumber(player.Data.Bounty.Value) or "0"
    }
end

-- Function to create a stat row
local function createStatRow(parent, label, value, yPosition)
    local container = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, yPosition),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = CONFIG.TRANSPARENCY.BUTTON,
        Parent = parent
    })
    makeRounded(container)

    createUIElement("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = label,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = container
    })

    createUIElement("TextLabel", {
        Size = UDim2.new(0.6, -20, 1, 0),
        Position = UDim2.new(0.4, 5, 0, 0),
        Text = tostring(value),
        TextColor3 = CONFIG.COLORS.VERSION_BLUE,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = container
    })

    return container
end

-- Update the Overview content function
local function showOverviewContent(contentFrame)
    -- Clear existing content
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Create header
    local header = createUIElement("TextLabel", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        Text = "Player Information",
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = contentFrame
    })

    -- Get player info
    local info = getPlayerInfo()
    
    -- Create scrolling frame for stats
    local statsFrame = createUIElement("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        Parent = contentFrame
    })

    -- Create stat rows
    local yOffset = 0
    local spacing = 30
    
    createStatRow(statsFrame, "Name", info.Name, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Display Name", info.DisplayName, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Level", info.Level, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Beli", info.Beli, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Fragments", info.Fragments, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Health", info.Health .. "/" .. info.MaxHealth, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Defense", info.Defense, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Melee", info.Melee, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Sword", info.Sword, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Devil Fruit", info.DevilFruit, yOffset)
    yOffset = yOffset + spacing
    createStatRow(statsFrame, "Bounty", info.Bounty, yOffset)
    
    -- Update ScrollingFrame canvas size
    statsFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + spacing)
end

local function showFarmContent(contentFrame)
    -- Placeholder for farm content
    createUIElement("TextLabel", {
        Text = "Farm Settings",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        TextXAlignment = Enum.TextXAlignment.Left
    }, contentFrame)
end

local function showSeaContent(contentFrame)
    -- Similar structure for sea content
    createUIElement("TextLabel", {
        Text = "Sea Features",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        TextXAlignment = Enum.TextXAlignment.Left
    }, contentFrame)
end

-- Create similar placeholder functions for other sections
local function showIslandsContent(contentFrame) end
local function showQuestsContent(contentFrame) end
local function showFruitContent(contentFrame) end
local function showTeleportContent(contentFrame) end
local function showStatusContent(contentFrame) end
local function showVisualContent(contentFrame) end
local function showShopContent(contentFrame) end
local function showSettingsContent(contentFrame) end

local CONFIG = {
    MAIN_SIZE = UDim2.new(0, 450, 0, 300),
    SIZE_PRESETS = {
        SMALL = { width = 400, height = 250 },
        MEDIUM = { width = 450, height = 300 },
        LARGE = { width = 550, height = 400 }
    },
    SIDEBAR_WIDTH = 110,
    BUTTON_HEIGHT = 24,
    BUTTON_SPACING = 8,
    SIDE_GAP = 5,
    TEXT_SIZES = { HEADER = 14, BODY = 12 },
    CORNER_RADIUS = 8,
    COLORS = {
        PRIMARY = Color3.fromRGB(17, 17, 23),
        SECONDARY = Color3.fromRGB(24, 24, 32),
        HOVER = Color3.fromRGB(35, 35, 45),
        SELECTED = Color3.fromRGB(45, 45, 60),
        SELECTED_BLUE = Color3.fromRGB(45, 70, 100),
        TEXT = Color3.fromRGB(230, 230, 240),
        BORDER = Color3.fromRGB(40, 40, 50),
        VERSION_BLUE = Color3.fromRGB(65, 175, 255),
        INDICATOR = Color3.fromRGB(65, 175, 255),
        DROPDOWN_BG = Color3.fromRGB(28, 28, 36),
        ACCENT = Color3.fromRGB(90, 120, 255)
    },
    TRANSPARENCY = {
        BACKGROUND = 0.1,
        SIDEBAR = 0.05,
        BUTTON = 0.1,
        CONTENT = 0.1,
        TEXT = 0
    }
}

-- Function to create a rounded corner UI element
local function makeRounded(element, radius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, radius or CONFIG.CORNER_RADIUS)
    uiCorner.Parent = element
    return element
end

-- Update the MainFrame
MainFrame.BackgroundColor3 = CONFIG.COLORS.PRIMARY
MainFrame.BackgroundTransparency = CONFIG.TRANSPARENCY.BACKGROUND
makeRounded(MainFrame)

-- Add a subtle border
local border = Instance.new("UIStroke")
border.Color = CONFIG.COLORS.BORDER
border.Thickness = 1
border.Transparency = 0.7
border.Parent = MainFrame

-- Update sidebar
local SidebarFrame = MainFrame.SidebarFrame
SidebarFrame.BackgroundColor3 = CONFIG.COLORS.SECONDARY
SidebarFrame.BackgroundTransparency = CONFIG.TRANSPARENCY.SIDEBAR
makeRounded(SidebarFrame)

-- Update content frame
local ContentFrame = MainFrame.ContentFrame
ContentFrame.BackgroundColor3 = CONFIG.COLORS.SECONDARY
ContentFrame.BackgroundTransparency = CONFIG.TRANSPARENCY.CONTENT
makeRounded(ContentFrame)

-- Update the createSidebarButton function
local function createSidebarButton(text, icon, description, positionY, content, displayFunction)
    local Button = createUIElement("Frame", {
        Size = UDim2.new(1, -10, 0, CONFIG.BUTTON_HEIGHT),
        Position = UDim2.new(0, 5, 0, positionY),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = CONFIG.TRANSPARENCY.BUTTON,
        BorderSizePixel = 0,
        Name = text .. "Button"
    })
    makeRounded(Button, CONFIG.CORNER_RADIUS - 2)

    -- Add subtle button border
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = CONFIG.COLORS.BORDER
    buttonBorder.Thickness = 1
    buttonBorder.Transparency = 0.8
    buttonBorder.Parent = Button

    -- Create icon
    local Icon = createUIElement("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 5, 0, 2),
        Text = icon,
        TextSize = 16,
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        Parent = Button
    })

    -- Create text label
    local TextLabel = createUIElement("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        Text = text,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Button
    })

    -- Update hover and selection effects
    local function updateStyle(isHovered, isSelected)
        local targetColor = isSelected and CONFIG.COLORS.SELECTED or (isHovered and CONFIG.COLORS.HOVER or CONFIG.COLORS.SECONDARY)
        local targetTransparency = isSelected and (CONFIG.TRANSPARENCY.BUTTON - 0.1) or (isHovered and (CONFIG.TRANSPARENCY.BUTTON - 0.05) or CONFIG.TRANSPARENCY.BUTTON)
        
        game:GetService("TweenService"):Create(Button, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = targetColor,
            BackgroundTransparency = targetTransparency
        }):Play()
    end

    Button.MouseEnter:Connect(function()
        updateStyle(true, Button == currentActiveButton)
        -- Show tooltip with description
        local tooltip = createUIElement("Frame", {
            Size = UDim2.new(0, 200, 0, 30),
            Position = UDim2.new(1, 10, 0, 0),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = CONFIG.TRANSPARENCY.BACKGROUND,
            Parent = Button
        })
        makeRounded(tooltip)
        
        createUIElement("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            Text = description,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextTransparency = CONFIG.TRANSPARENCY.TEXT,
            BackgroundTransparency = 1,
            TextWrapped = true,
            Parent = tooltip
        })
    end)

    Button.MouseLeave:Connect(function()
        updateStyle(false, Button == currentActiveButton)
        -- Remove tooltip
        for _, child in pairs(Button:GetChildren()) do
            if child:IsA("Frame") and child.Size.X.Offset == 200 then
                child:Destroy()
            end
        end
    end)

    -- Update close button
    local CloseButton = createUIElement("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0, 5),
        Text = "×",
        TextColor3 = CONFIG.COLORS.TEXT,
        TextTransparency = CONFIG.TRANSPARENCY.TEXT,
        TextSize = 20,
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = CONFIG.TRANSPARENCY.BUTTON,
        Parent = MainFrame
    })
    makeRounded(CloseButton, CONFIG.CORNER_RADIUS)

    CloseButton.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(CloseButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = Color3.fromRGB(255, 70, 70),
            BackgroundTransparency = CONFIG.TRANSPARENCY.BUTTON - 0.1
        }):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(CloseButton, CONFIG.TWEEN_INFO, {
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = CONFIG.TRANSPARENCY.BUTTON
        }):Play()
    end)

    return Button
end

-- Create buttons and set Overview as default active
local buttons = {}
local contentFrame = MainFrame.ContentFrame
local currentActiveButton = nil

for i, btnInfo in ipairs(buttonList) do
    local yPos = (i - 1) * (CONFIG.BUTTON_HEIGHT + CONFIG.BUTTON_SPACING)
    local button = createSidebarButton(
        btnInfo[1],  -- text
        btnInfo[2],  -- icon
        btnInfo[3],  -- description
        yPos,
        contentFrame,
        btnInfo[4]   -- display function
    )
    button.Parent = MainFrame.SidebarFrame
    table.insert(buttons, button)
    
    -- Set Overview as default active
    if btnInfo[1] == "Overview" then
        currentActiveButton = button
        button.BackgroundColor3 = CONFIG.COLORS.SELECTED
        btnInfo[4](contentFrame)  -- Call display function
    end
end

-- Add close button functionality
local CloseButton = createUIElement("TextButton", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, -25, 0, 5),
    Text = "×",
    TextColor3 = CONFIG.COLORS.TEXT,
    TextSize = 20,
    BackgroundTransparency = 1,
    Parent = MainFrame
})

CloseButton.MouseButton1Click:Connect(function()
    -- Fade out animation
    local fadeOut = game:GetService("TweenService"):Create(
        MainFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    
    -- Fade out all children
    local function fadeOutRecursive(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("GuiObject") then
                game:GetService("TweenService"):Create(
                    child,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {BackgroundTransparency = 1, TextTransparency = 1}
                ):Play()
            end
            fadeOutRecursive(child)
        end
    end
    
    fadeOutRecursive(MainFrame)
    fadeOut:Play()
    
    -- Destroy the GUI after animation
    fadeOut.Completed:Connect(function()
        MainFrame.Parent:Destroy()
    end)
end)

CloseButton.MouseEnter:Connect(function()
    CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.TextColor3 = CONFIG.COLORS.TEXT
end)
