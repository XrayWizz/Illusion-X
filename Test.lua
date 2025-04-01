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
        BackgroundTransparency = 1,
        Parent = parent
    })

    createUIElement("TextLabel", {
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = label,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = container
    })

    createUIElement("TextLabel", {
        Size = UDim2.new(0.6, -10, 1, 0),
        Position = UDim2.new(0.4, 5, 0, 0),
        Text = tostring(value),
        TextColor3 = CONFIG.COLORS.VERSION_BLUE,
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

local function createSidebarButton(text, icon, description, positionY, content, displayFunction)
    local Button = createUIElement("Frame", {
        Size = UDim2.new(1, -10, 0, CONFIG.BUTTON_HEIGHT),
        Position = UDim2.new(0, 5, 0, positionY),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BorderSizePixel = 0,
        Name = text .. "Button"
    })

    -- Create icon
    local Icon = createUIElement("TextLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 5, 0, 2),
        Text = icon,
        TextSize = 16,
        BackgroundTransparency = 1,
        TextColor3 = CONFIG.COLORS.TEXT,
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
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Button
    })

    -- Create hover effect
    local function updateBackgroundColor(color)
        Button.BackgroundColor3 = color
    end

    Button.MouseEnter:Connect(function()
        updateBackgroundColor(CONFIG.COLORS.HOVER)
        -- Show tooltip with description
        local tooltip = createUIElement("TextLabel", {
            Size = UDim2.new(0, 200, 0, 20),
            Position = UDim2.new(1, 10, 0, 0),
            Text = description,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextWrapped = true,
            Parent = Button
        })
    end)

    Button.MouseLeave:Connect(function()
        updateBackgroundColor(CONFIG.COLORS.SECONDARY)
        -- Remove tooltip
        for _, child in pairs(Button:GetChildren()) do
            if child:IsA("TextLabel") and child.Text == description then
                child:Destroy()
            end
        end
    end)

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            displayFunction(content)
        end
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
