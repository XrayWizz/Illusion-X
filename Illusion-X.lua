local CONFIG = {
    MAIN_SIZE = UDim2.new(0, 450, 0, 300),
    SIDEBAR_WIDTH = 110,
    BUTTON_HEIGHT = 24,
    BUTTON_SPACING = 8, 
    SIDE_GAP = 5,
    TEXT_SIZES = { HEADER = 14, BODY = 12 },
    COLORS = {
        PRIMARY = Color3.fromRGB(18, 18, 18),
        SECONDARY = Color3.fromRGB(28, 28, 28),
        HOVER = Color3.fromRGB(45, 45, 45),
        SELECTED = Color3.fromRGB(60, 60, 60),
        SELECTED_BLUE = Color3.fromRGB(60, 65, 75), 
        TEXT = Color3.fromRGB(230, 230, 230),
        BORDER = Color3.fromRGB(40, 40, 40),
        VERSION_BLUE = Color3.fromRGB(0, 144, 255), 
        INDICATOR = Color3.fromRGB(0, 144, 255) 
    },
    TRANSPARENCY = 0.7,
    TWEEN_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Function to create UI elements with error handling
local function createUIElement(class, properties, parent)
    local success, element = pcall(function()
        local elem = Instance.new(class)
        for prop, value in pairs(properties) do
            elem[prop] = value
        end
        if parent then elem.Parent = parent end
        return elem
    end)
    
    if not success then
        warn("Failed to create UI element:", class, element)
        return nil
    end
    return element
end

-- Function to make an element draggable
local function makeDraggable(dragElement, dragTarget)
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart
    local startPos
    local dragInput

    -- Create a transparent overlay for dragging
    local dragOverlay = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = dragTarget
    })

    dragOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragOverlay.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Function to add hover effect with debounce
local function hoverEffect(element, normalColor, hoverColor)
    local debounce = false
    local function updateColor(color)
        if debounce then return end
        debounce = true
        element.BackgroundColor3 = color
        task.wait(0.1)
        debounce = false
    end
    
    element.MouseEnter:Connect(function() updateColor(hoverColor) end)
    element.MouseLeave:Connect(function() updateColor(normalColor) end)
end

-- Function to get player information
local function getPlayerInfo()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Get player stats
    local stats = {
        Money = player:WaitForChild("leaderstats"):WaitForChild("Beli").Value,
        Fragments = player:WaitForChild("Data"):WaitForChild("Fragments").Value,
        Health = humanoid.Health,
        MaxHealth = humanoid.MaxHealth,
        Level = player:WaitForChild("Data"):WaitForChild("Level").Value,
    }
    
    -- Get devil fruit info (if any)
    local devilFruit = ""
    if player:WaitForChild("Data"):FindFirstChild("DevilFruit") then
        devilFruit = player.Data.DevilFruit.Value
    end
    
    -- Get fighting style
    local fightingStyle = ""
    if player:WaitForChild("Data"):FindFirstChild("FightingStyle") then
        fightingStyle = player.Data.FightingStyle.Value
    end
    
    return stats, devilFruit, fightingStyle
end

-- Function to update player info display
local function updatePlayerInfoDisplay(contentFrame)
    -- Clear existing content
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local stats, devilFruit, fightingStyle = getPlayerInfo()
    
    -- Create info container with proper sizing and positioning
    local infoContainer = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    -- Create layout for info items
    local layout = createUIElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = infoContainer
    })
    
    -- Helper function to create info sections with improved styling
    local function createInfoSection(title, value, order)
        local section = createUIElement("Frame", {
            Size = UDim2.new(1, 0, 0, 35), 
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            LayoutOrder = order,
            Parent = infoContainer
        })
        
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }, section)
        
        createUIElement("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = title,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = section
        })
        
        createUIElement("TextLabel", {
            Size = UDim2.new(0.6, -20, 1, 0),
            Position = UDim2.new(0.4, 10, 0, 0),
            Text = tostring(value),
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = section
        })
        
        return section
    end
    
    -- Create info sections with proper error handling
    pcall(function()
        createInfoSection("Beli", string.format("%s", stats.Money), 1)
        createInfoSection("Fragments", string.format("%s", stats.Fragments), 2)
        createInfoSection("Health", string.format("%d/%d", stats.Health, stats.MaxHealth), 3)
        createInfoSection("Level", stats.Level, 4)
        createInfoSection("Devil Fruit", devilFruit ~= "" and devilFruit or "None", 5)
        createInfoSection("Fighting Style", fightingStyle ~= "" and fightingStyle or "None", 6)
    end)
end

-- Function to clear content
local function clearContent(contentFrame)
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

-- Function to display Help & Feedback content
local function showHelpAndFeedback(contentFrame)
    clearContent(contentFrame)
    
    local helpContent = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        Text = "Help & Feedback",
        TextColor3 = CONFIG.COLORS.TEXT,
        Font = Enum.Font.SourceSansBold,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        BackgroundTransparency = 1,
        Parent = helpContent
    })
end

-- Create popup notification function
local function createPopupNotification(text)
    local popup = createUIElement("Frame", {
        Size = UDim2.new(0, 200, 0, 40),
        Position = UDim2.new(1, -220, 0, 10),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = 0.1,
        Parent = MainFrame
    })
    
    createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, popup)
    
    local popupText = createUIElement("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = text,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        BackgroundTransparency = 1,
        Parent = popup
    })
    
    -- Animate in
    popup.Position = UDim2.new(1, 20, 0, 10)
    local tweenService = game:GetService("TweenService")
    local tweenIn = tweenService:Create(popup, CONFIG.TWEEN_INFO, {
        Position = UDim2.new(1, -220, 0, 10)
    })
    tweenIn:Play()
    
    -- Remove after 5 seconds
    task.delay(4.5, function()
        local tweenOut = tweenService:Create(popup, CONFIG.TWEEN_INFO, {
            Position = UDim2.new(1, 20, 0, 10)
        })
        tweenOut:Play()
        tweenOut.Completed:Wait()
        popup:Destroy()
    end)
end

-- Create ScreenGui with protection
local ScreenGui = createUIElement("ScreenGui", {
    Name = "BloxFruitsUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 9999
})

-- Protect against multiple instances
if game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("BloxFruitsUI") then
    game.Players.LocalPlayer.PlayerGui.BloxFruitsUI:Destroy()
end
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create main frame
local MainFrame = createUIElement("Frame", {
    Name = "MainFrame",
    Size = CONFIG.MAIN_SIZE,
    Position = UDim2.new(0.5, -CONFIG.MAIN_SIZE.X.Offset/2, 0, -15),
    BackgroundColor3 = CONFIG.COLORS.PRIMARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = ScreenGui
})
createUIElement("UICorner", { CornerRadius = UDim.new(0, 12) }, MainFrame)

-- Create title bar
local TitleBar = createUIElement("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- Create a drag handle that spans the entire minimized frame
local DragHandle = createUIElement("Frame", {
    Size = UDim2.new(1, -70, 0, 30), 
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Parent = TitleBar
})

-- Make both the title bar and the minimized frame draggable
makeDraggable(DragHandle, MainFrame)

-- Create title with glow effect
local TitleLabel = createUIElement("TextLabel", {
    Size = UDim2.new(1, -80, 0, 30),
    Position = UDim2.new(0, CONFIG.SIDE_GAP + 5, 0, 5),
    Text = " Ray'z Hub",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    Font = Enum.Font.SourceSansBold,
    TextSize = CONFIG.TEXT_SIZES.HEADER,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Parent = TitleBar
})

-- Add glow effect to title
local titleGlow = createUIElement("ImageLabel", {
    Size = UDim2.new(1, 20, 1, 20),
    Position = UDim2.new(0, -10, 0, -10),
    BackgroundTransparency = 1,
    Image = "rbxassetid://4996891970",
    ImageColor3 = CONFIG.COLORS.VERSION_BLUE,
    ImageTransparency = 0.9,
    Parent = TitleLabel
})

-- Create version bubble
local VersionBubble = createUIElement("TextButton", {
    Size = UDim2.new(0, 40, 0, 20),
    Position = UDim2.new(0, TitleLabel.Position.X.Offset + 75, 0, 10),
    Text = "v1.3",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    Font = Enum.Font.SourceSans,
    TextSize = CONFIG.TEXT_SIZES.BODY,
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 0.6,
    AutoButtonColor = false,
    Parent = MainFrame
})

createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, VersionBubble)

-- Create close button
local CloseButton = createUIElement("TextButton", {
    Size = UDim2.new(0, 24, 0, 20),
    Position = UDim2.new(1, -32, 0, 10),
    Text = "×",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    Font = Enum.Font.SourceSansBold,
    TextSize = CONFIG.TEXT_SIZES.BODY + 2,
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    AutoButtonColor = false,
    Parent = TitleBar
})

createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, CloseButton)

-- Add hover effect
hoverEffect(CloseButton, CONFIG.COLORS.SECONDARY, CONFIG.COLORS.HOVER)

-- Add close functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Create minimize button
local MinimizeButton = createUIElement("TextButton", {
    Size = UDim2.new(0, 24, 0, 20),
    Position = UDim2.new(1, -62, 0, 10),
    Text = "–",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    Font = Enum.Font.SourceSansBold,
    TextSize = CONFIG.TEXT_SIZES.BODY + 2,
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    AutoButtonColor = false,
    Parent = TitleBar
})

createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, MinimizeButton)

-- Add hover effect
hoverEffect(MinimizeButton, CONFIG.COLORS.SECONDARY, CONFIG.COLORS.HOVER)

-- Sidebar and Content Area (the main UI sections)
local Sidebar = createUIElement("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, CONFIG.SIDEBAR_WIDTH, 1, -CONFIG.SIDE_GAP*2 - 30),
    Position = UDim2.new(0, CONFIG.SIDE_GAP, 0, CONFIG.SIDE_GAP + 30),
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = MainFrame
})
createUIElement("UICorner", { CornerRadius = UDim.new(0, 12) }, Sidebar)

local ContentArea = createUIElement("Frame", {
    Size = UDim2.new(1, -CONFIG.SIDEBAR_WIDTH - CONFIG.SIDE_GAP*3, 1, -CONFIG.SIDE_GAP*2 - 30),
    Position = UDim2.new(0, CONFIG.SIDEBAR_WIDTH + CONFIG.SIDE_GAP*2, 0, CONFIG.SIDE_GAP + 30),
    BackgroundColor3 = CONFIG.COLORS.PRIMARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = MainFrame
})
createUIElement("UICorner", { CornerRadius = UDim.new(0, 12) }, ContentArea)

-- Function to create button context
local function createButtonContext(contentFrame, buttonName)
    -- Clear existing content
    clearContent(contentFrame)
    
    -- Create a container for the context
    local contextContainer = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    -- Add placeholder content based on button type
    if buttonName == "Player Info" then
        updatePlayerInfoDisplay(contentFrame)
    elseif buttonName == "Auto Farm" then
        local placeholder = createUIElement("Frame", {
            Size = UDim2.new(1, 0, 0, 200),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            Parent = contextContainer
        })
        
        createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, placeholder)
        createUIElement("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            Text = "Auto Farm Settings (Coming Soon)",
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            BackgroundTransparency = 1,
            Parent = placeholder
        })
    elseif buttonName == "Teleport" then
        local placeholder = createUIElement("Frame", {
            Size = UDim2.new(1, 0, 0, 200),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            Parent = contextContainer
        })
        
        createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, placeholder)
        createUIElement("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            Text = "Teleport Locations (Coming Soon)",
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            BackgroundTransparency = 1,
            Parent = placeholder
        })
    elseif buttonName == "Settings" then
        local placeholder = createUIElement("Frame", {
            Size = UDim2.new(1, 0, 0, 200),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            Parent = contextContainer
        })
        
        createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, placeholder)
        createUIElement("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            Text = "UI Settings (Coming Soon)",
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            BackgroundTransparency = 1,
            Parent = placeholder
        })
    end
end

-- Function to create sidebar buttons (context menu)
local selectedButton = nil
local function createSidebarButton(text, positionY, content, displayFunction)
    local Button = createUIElement("Frame", {
        Size = UDim2.new(1, -10, 0, CONFIG.BUTTON_HEIGHT),
        Position = UDim2.new(0, 5, 0, positionY),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
        Parent = Sidebar
    })

    -- Create indicator dot (initially invisible)
    local Indicator = createUIElement("Frame", {
        Size = UDim2.new(0, 4, 0, 4),
        Position = UDim2.new(0, -8, 0.5, -2),
        BackgroundColor3 = CONFIG.COLORS.INDICATOR,
        BackgroundTransparency = 1,
        Parent = Button
    })
    createUIElement("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, Indicator)

    local ButtonText = createUIElement("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = Button
    })

    createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, Button)

    -- Modified click handler to include blue tint and indicator
    ButtonText.MouseButton1Click:Connect(function()
        -- Reset all buttons
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("Frame") and child ~= Button then
                child.BackgroundColor3 = CONFIG.COLORS.SECONDARY
                -- Hide other indicators
                local otherIndicator = child:FindFirstChild("Frame")
                if otherIndicator then
                    otherIndicator.BackgroundTransparency = 1
                end
            end
        end
        
        -- Set selected state with blue tint
        Button.BackgroundColor3 = CONFIG.COLORS.SELECTED_BLUE
        Indicator.BackgroundTransparency = 0
        
        clearContent(ContentArea)

        -- Create header container
        local headerContainer = createUIElement("Frame", {
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            Parent = ContentArea
        })

        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }, headerContainer)

        -- Create glowing effect
        local glow = createUIElement("ImageLabel", {
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://4996891970", -- Blur effect
            ImageColor3 = CONFIG.COLORS.VERSION_BLUE,
            ImageTransparency = 0.9,
            Parent = headerContainer
        })

        -- Create description text
        local descriptionText = createUIElement("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = content,
            TextColor3 = CONFIG.COLORS.VERSION_BLUE,
            TextSize = CONFIG.TEXT_SIZES.HEADER,
            Font = Enum.Font.SourceSansBold,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = headerContainer
        })

        -- Create content container below header
        local contentContainer = createUIElement("Frame", {
            Size = UDim2.new(1, -20, 1, -55),
            Position = UDim2.new(0, 10, 0, 50),
            BackgroundTransparency = 1,
            Parent = ContentArea
        })

        if displayFunction then
            displayFunction(contentContainer)
        end
    end)

    -- Modified hover effect
    local function updateColor(isHover)
        if Button.BackgroundColor3 == CONFIG.COLORS.SELECTED_BLUE then return end
        Button.BackgroundColor3 = isHover and CONFIG.COLORS.HOVER or CONFIG.COLORS.SECONDARY
    end
    
    ButtonText.MouseEnter:Connect(function() updateColor(true) end)
    ButtonText.MouseLeave:Connect(function() updateColor(false) end)

    return Button
end

-- Function to display overview content (merged home and player info)
local function showOverviewContent(contentFrame)
    -- Clear existing content
    clearContent(contentFrame)
    
    -- Create main container
    local mainContainer = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    -- Welcome section
    local welcomeText = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 0),
        Text = "Welcome to Ray'z Hub",
        TextColor3 = CONFIG.COLORS.VERSION_BLUE,
        Font = Enum.Font.SourceSansBold,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        BackgroundTransparency = 1,
        Parent = mainContainer
    })
    
    -- Version info
    local versionText = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 35),
        Text = "Version 1.3",
        TextColor3 = CONFIG.COLORS.TEXT,
        Font = Enum.Font.SourceSans,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        BackgroundTransparency = 1,
        Parent = mainContainer
    })
    
    -- Player info section (starts below welcome section)
    local playerInfoContainer = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        Parent = mainContainer
    })
    
    -- Get player stats
    local stats, devilFruit, fightingStyle = getPlayerInfo()
    
    -- Helper function to create info sections
    local function createInfoSection(title, value, order)
        local section = createUIElement("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            Position = UDim2.new(0, 0, 0, order * 45),
            BackgroundColor3 = CONFIG.COLORS.SECONDARY,
            BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
            Parent = playerInfoContainer
        })
        
        createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 6),
        }, section)
        
        createUIElement("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = title,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = section
        })
        
        createUIElement("TextLabel", {
            Size = UDim2.new(0.6, -20, 1, 0),
            Position = UDim2.new(0.4, 10, 0, 0),
            Text = tostring(value),
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Parent = section
        })
    end
    
    -- Create info sections
    pcall(function()
        createInfoSection("Beli", string.format("%s", stats.Money), 0)
        createInfoSection("Fragments", string.format("%s", stats.Fragments), 1)
        createInfoSection("Health", string.format("%d/%d", stats.Health, stats.MaxHealth), 2)
        createInfoSection("Level", stats.Level, 3)
        if devilFruit ~= "" then
            createInfoSection("Devil Fruit", devilFruit, 4)
        end
        if fightingStyle ~= "" then
            createInfoSection("Fighting Style", fightingStyle, devilFruit ~= "" and 5 or 4)
        end
    end)
end

local buttonList = {
    { "Overview", "View your player information and hub status.", showOverviewContent },
    { "Auto Farm", "Configure and control auto-farming settings.", function(contentFrame)
        createButtonContext(contentFrame, "Auto Farm")
    end },
    { "Farming Tweaks", "Adjust farming settings and configurations.", function(contentFrame)
        createButtonContext(contentFrame, "Farming Tweaks")
    end },
    { "Sea Events", "Monitor and interact with sea-based events.", function(contentFrame)
        createButtonContext(contentFrame, "Sea Events")
    end },
    { "Teleport", "Teleport to various locations.", function(contentFrame)
        createButtonContext(contentFrame, "Teleport")
    end },
    { "Fruit Tweaks", "Customize fruit-related settings and tweaks.", function(contentFrame)
        createButtonContext(contentFrame, "Fruit Tweaks")
    end },
    { "Miscellaneous", "Access other features and tools.", function(contentFrame)
        createButtonContext(contentFrame, "Miscellaneous")
    end },
    { "UI Settings", "Modify and personalize the UI.", function(contentFrame)
        createButtonContext(contentFrame, "UI Settings")
    end },
    { "Settings", "General settings for the hub.", function(contentFrame)
        createButtonContext(contentFrame, "Settings")
    end },
    { "Help & Feedback", "Provide feedback or get help.", showHelpAndFeedback }
}

-- Create buttons and set Overview as default active
local buttons = {}
for i, btnInfo in ipairs(buttonList) do
    local button = createSidebarButton(btnInfo[1], (i-1)*(CONFIG.BUTTON_HEIGHT + CONFIG.BUTTON_SPACING), btnInfo[2], btnInfo[3])
    buttons[i] = button
    
    -- Activate Overview button by default
    if i == 1 then
        button.BackgroundColor3 = CONFIG.COLORS.SELECTED_BLUE
        if btnInfo[3] then
            btnInfo[3](ContentArea)
        end
    end
end

-- Toggle Minimize/Restore behavior with tweening
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        -- Restore (two-step animation)
        -- Step 1: Extend the minimized frame horizontally
        local extendTween = game:GetService("TweenService"):Create(MainFrame, CONFIG.TWEEN_INFO, {
            Size = UDim2.new(0, CONFIG.MAIN_SIZE.X.Offset, 0, 40)
        })
        extendTween:Play()
        extendTween.Completed:Wait()
        
        -- Step 2: Expand vertically and show content
        local restoreTween = game:GetService("TweenService"):Create(MainFrame, CONFIG.TWEEN_INFO, {
            Size = CONFIG.MAIN_SIZE
        })
        restoreTween:Play()
        restoreTween.Completed:Wait()
        Sidebar.Visible = true
        ContentArea.Visible = true
        MinimizeButton.Text = "–"
    else
        -- Minimize (two-step animation)
        -- Step 1: Collapse vertically
        Sidebar.Visible = false
        ContentArea.Visible = false
        local collapseTween = game:GetService("TweenService"):Create(MainFrame, CONFIG.TWEEN_INFO, {
            Size = UDim2.new(0, CONFIG.MAIN_SIZE.X.Offset, 0, 40)
        })
        collapseTween:Play()
        collapseTween.Completed:Wait()
        
        -- Step 2: Shrink horizontally
        local shrinkTween = game:GetService("TweenService"):Create(MainFrame, CONFIG.TWEEN_INFO, {
            Size = UDim2.new(0, CONFIG.MAIN_SIZE.X.Offset/2, 0, 40)
        })
        shrinkTween:Play()
        MinimizeButton.Text = "+"
    end
    minimized = not minimized
end)
