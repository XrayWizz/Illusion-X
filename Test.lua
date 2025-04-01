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
    TEXT_SIZES = { HEADER = 14, BODY = 12, SMALL = 10 },
    COLORS = {
        PRIMARY = Color3.fromRGB(18, 18, 18),
        SECONDARY = Color3.fromRGB(28, 28, 28),
        HOVER = Color3.fromRGB(45, 45, 45),
        SELECTED = Color3.fromRGB(60, 60, 60),
        SELECTED_BLUE = Color3.fromRGB(60, 65, 75), 
        TEXT = Color3.fromRGB(230, 230, 230),
        BORDER = Color3.fromRGB(40, 40, 40),
        VERSION_BLUE = Color3.fromRGB(0, 144, 255), 
        INDICATOR = Color3.fromRGB(0, 144, 255),
        DROPDOWN_BG = Color3.fromRGB(35, 35, 35)
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
    
    -- Create info container with proper styling
    local infoContainer = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    -- Create layout for info items
    local layout = createUIElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = infoContainer
    })
    
    -- Helper function to create info sections with glow effect
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
        
        -- Add subtle glow effect
        local glow = createUIElement("ImageLabel", {
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0, -10, 0, -10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://4996891970",
            ImageColor3 = CONFIG.COLORS.VERSION_BLUE,
            ImageTransparency = 0.95,
            Parent = section
        })
        
        local titleLabel = createUIElement("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            Text = title,
            TextColor3 = CONFIG.COLORS.VERSION_BLUE,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            Font = Enum.Font.SourceSansBold,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section
        })
        
        local valueLabel = createUIElement("TextLabel", {
            Size = UDim2.new(0.6, -20, 1, 0),
            Position = UDim2.new(0.4, 10, 0, 0),
            Text = value,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            Font = Enum.Font.SourceSans,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section
        })
        
        -- Initial state for animation
        section.Position = UDim2.new(1, 0, 0, 0)
        return section
    end
    
    -- Create sections with sequential animations
    local function animateSection(section, index)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, index * 0.1)
        local tween = game:GetService("TweenService"):Create(section, tweenInfo, {
            Position = UDim2.new(0, 0, 0, 0)
        })
        tween:Play()
    end
    
    -- Add stats with animations
    local sections = {}
    for i, stat in ipairs(stats) do
        local section = createInfoSection(stat.name, tostring(stat.value), i)
        table.insert(sections, {section = section, index = i})
    end
    
    -- Add devil fruit info
    if devilFruit then
        local section = createInfoSection("Devil Fruit", devilFruit, #stats + 1)
        table.insert(sections, {section = section, index = #stats + 1})
    end
    
    -- Add fighting style
    if fightingStyle then
        local section = createInfoSection("Fighting Style", fightingStyle, #stats + 2)
        table.insert(sections, {section = section, index = #stats + 2})
    end
    
    -- Animate all sections
    for _, item in ipairs(sections) do
        animateSection(item.section, item.index)
    end
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
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    Text = " Ray'z Hub",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    TextSize = CONFIG.TEXT_SIZES.HEADER,
    Font = Enum.Font.SourceSansBold,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
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

-- Create version label
local VersionLabel = createUIElement("TextLabel", {
    Size = UDim2.new(0, 60, 1, 0),
    Position = UDim2.new(1, -120, 0, 0),
    Text = "v1.0.0",
    TextColor3 = CONFIG.COLORS.VERSION_BLUE,
    TextSize = CONFIG.TEXT_SIZES.SMALL,
    Font = Enum.Font.SourceSans,
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = TitleBar
})

-- Create close button
local CloseButton = createUIElement("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -30, 0, 0),
    Text = "×",
    TextColor3 = CONFIG.COLORS.TEXT,
    TextSize = CONFIG.TEXT_SIZES.HEADER + 4,
    Font = Enum.Font.SourceSansBold,
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = TitleBar
})
createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, CloseButton)

-- Add hover effect to close button
hoverEffect(CloseButton, CONFIG.COLORS.SECONDARY, CONFIG.COLORS.HOVER)

-- Add close functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Create minimize button
local MinimizeButton = createUIElement("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -65, 0, 0),
    Text = "–",
    TextColor3 = CONFIG.COLORS.TEXT,
    TextSize = CONFIG.TEXT_SIZES.HEADER,
    Font = Enum.Font.SourceSansBold,
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = TitleBar
})
createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, MinimizeButton)

-- Add hover effect to minimize button
hoverEffect(MinimizeButton, CONFIG.COLORS.SECONDARY, CONFIG.COLORS.HOVER)

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

-- Create sidebar with proper styling
local Sidebar = createUIElement("Frame", {
    Size = UDim2.new(0, CONFIG.SIDEBAR_WIDTH, 1, -30),
    Position = UDim2.new(0, 0, 0, 30),
    BackgroundColor3 = CONFIG.COLORS.SECONDARY,
    BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
    Parent = MainFrame
})
createUIElement("UICorner", { 
    CornerRadius = UDim.new(0, 8)
}, Sidebar)

-- Create content area
local ContentArea = createUIElement("Frame", {
    Size = UDim2.new(1, -(CONFIG.SIDEBAR_WIDTH + 10), 1, -40),
    Position = UDim2.new(0, CONFIG.SIDEBAR_WIDTH + 5, 0, 35),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

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
local function createSidebarButton(text, positionY, content, displayFunction, iconId)
    local Button = createUIElement("Frame", {
        Size = UDim2.new(1, -10, 0, CONFIG.BUTTON_HEIGHT),
        Position = UDim2.new(0, 5, 0, positionY),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
        Parent = Sidebar
    })

    -- Create indicator (pill shape) (initially invisible)
    local Indicator = createUIElement("Frame", {
        Size = UDim2.new(0, 3, 0, 16),
        Position = UDim2.new(0, -6, 0.5, -8),
        BackgroundColor3 = CONFIG.COLORS.INDICATOR,
        BackgroundTransparency = 1,
        Parent = Button
    })
    createUIElement("UICorner", {
        CornerRadius = UDim.new(1, 0),
    }, Indicator)

    -- Create icon
    local Icon = createUIElement("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = iconId,
        ImageColor3 = CONFIG.COLORS.TEXT,
        Parent = Button
    })

    local ButtonText = createUIElement("TextButton", {
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.COLORS.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Button
    })

    createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, Button)

    -- Click handler
    ButtonText.MouseButton1Click:Connect(function()
        -- Reset previous button if it exists
        if selectedButton and selectedButton ~= Button then
            selectedButton.BackgroundColor3 = CONFIG.COLORS.SECONDARY
            local prevIndicator = selectedButton:FindFirstChild("Frame")
            if prevIndicator then
                prevIndicator.BackgroundTransparency = 1
            end
            -- Reset previous icon color
            local prevIcon = selectedButton:FindFirstChild("ImageLabel")
            if prevIcon then
                prevIcon.ImageColor3 = CONFIG.COLORS.TEXT
            end
        end

        -- Update current button
        Button.BackgroundColor3 = CONFIG.COLORS.SELECTED_BLUE
        Indicator.BackgroundTransparency = 0
        Icon.ImageColor3 = CONFIG.COLORS.VERSION_BLUE
        selectedButton = Button

        -- Clear and update content area
        clearContent(ContentArea)
        if displayFunction then
            displayFunction(ContentArea)
        end
    end)

    -- Hover effects
    ButtonText.MouseEnter:Connect(function()
        if Button ~= selectedButton then
            Button.BackgroundColor3 = CONFIG.COLORS.HOVER
            Icon.ImageColor3 = CONFIG.COLORS.VERSION_BLUE
        end
    end)

    ButtonText.MouseLeave:Connect(function()
        if Button ~= selectedButton then
            Button.BackgroundColor3 = CONFIG.COLORS.SECONDARY
            Icon.ImageColor3 = CONFIG.COLORS.TEXT
        end
    end)

    return Button
end

-- Function to display overview content (merged home and player info)
local function showOverviewContent(contentFrame)
    -- Clear existing content
    clearContent(contentFrame)
    
    -- Create main container with glow effect
    local container = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Parent = contentFrame
    })
    
    -- Create header with glow
    local headerContainer = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
        Parent = container
    })
    createUIElement("UICorner", { CornerRadius = UDim.new(0, 6) }, headerContainer)
    
    -- Add glow effect to header
    local headerGlow = createUIElement("ImageLabel", {
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://4996891970",
        ImageColor3 = CONFIG.COLORS.VERSION_BLUE,
        ImageTransparency = 0.9,
        Parent = headerContainer
    })
    
    -- Create welcome text with animation
    local welcomeText = createUIElement("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = "Welcome to Ray'z Hub",
        TextColor3 = CONFIG.COLORS.VERSION_BLUE,
        TextSize = CONFIG.TEXT_SIZES.HEADER,
        Font = Enum.Font.SourceSansBold,
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = headerContainer
    })
    
    -- Create player info container
    local playerInfoContainer = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = container
    })
    
    -- Update player info display with animations
    updatePlayerInfoDisplay(playerInfoContainer)
end

-- Function to update UI size
local function updateUISize(width, height)
    local newSize = UDim2.new(0, width, 0, height)
    local sizeTween = game:GetService("TweenService"):Create(MainFrame, CONFIG.TWEEN_INFO, {
        Size = newSize
    })
    sizeTween:Play()
    CONFIG.MAIN_SIZE = newSize
end

-- Function to create dropdown menu
local function createDropdown(parent, options, callback)
    local isOpen = false
    local dropdownHeight = #options * CONFIG.BUTTON_HEIGHT
    
    local dropdownButton = createUIElement("TextButton", {
        Size = UDim2.new(1, -20, 0, CONFIG.BUTTON_HEIGHT),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = CONFIG.COLORS.SECONDARY,
        BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
        Text = "Select Size",
        TextColor3 = CONFIG.COLORS.TEXT,
        TextSize = CONFIG.TEXT_SIZES.BODY,
        Font = Enum.Font.SourceSans,
        Parent = parent
    })
    
    createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, dropdownButton)
    
    local dropdownContainer = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, CONFIG.BUTTON_HEIGHT),
        BackgroundColor3 = CONFIG.COLORS.DROPDOWN_BG,
        BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
        ClipsDescendants = true,
        Visible = false,
        Parent = parent
    })
    
    createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6),
    }, dropdownContainer)
    
    for i, option in ipairs(options) do
        local optionButton = createUIElement("TextButton", {
            Size = UDim2.new(1, 0, 0, CONFIG.BUTTON_HEIGHT),
            Position = UDim2.new(0, 0, 0, (i-1) * CONFIG.BUTTON_HEIGHT),
            BackgroundTransparency = 1,
            Text = option,
            TextColor3 = CONFIG.COLORS.TEXT,
            TextSize = CONFIG.TEXT_SIZES.BODY,
            Font = Enum.Font.SourceSans,
            Parent = dropdownContainer
        })
        
        optionButton.MouseButton1Click:Connect(function()
            callback(option)
            dropdownButton.Text = option
            isOpen = false
            dropdownContainer.Visible = false
        end)
        
        optionButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(optionButton, CONFIG.TWEEN_INFO, {
                BackgroundTransparency = 1 - CONFIG.TRANSPARENCY,
                BackgroundColor3 = CONFIG.COLORS.HOVER
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(optionButton, CONFIG.TWEEN_INFO, {
                BackgroundTransparency = 1
            }):Play()
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropdownContainer.Visible = isOpen
    end)
    
    return dropdownButton
end

local buttonList = {
    { "Overview", "View your player information and hub status.", showOverviewContent, "rbxassetid://3926305904", Vector2.new(964, 204) }, -- User icon
    { "Auto Farm", "Configure and control auto-farming settings.", function(contentFrame)
        -- Auto farm content
    end, "rbxassetid://3926307971", Vector2.new(964, 4) }, -- Target/farming icon
    { "Teleport", "Quick access to various locations.", function(contentFrame)
        -- Teleport content
    end, "rbxassetid://3926305904", Vector2.new(924, 684) }, -- Navigation icon
    { "UI Settings", "Customize the interface appearance.", function(contentFrame)
        -- Settings content
    end, "rbxassetid://3926307971", Vector2.new(84, 44) }, -- Gear icon
    { "Help", "Get help and provide feedback.", function(contentFrame)
        -- Help content
    end, "rbxassetid://3926305904", Vector2.new(204, 644) }  -- Question mark icon
}

-- Create buttons and set Overview as default active
local buttons = {}
for i, btnInfo in ipairs(buttonList) do
    local button = createSidebarButton(btnInfo[1], (i-1)*(CONFIG.BUTTON_HEIGHT + CONFIG.BUTTON_SPACING), btnInfo[2], btnInfo[3], btnInfo[4])
    buttons[i] = button
    
    -- Activate Overview button by default
    if i == 1 then
        selectedButton = button
        button.BackgroundColor3 = CONFIG.COLORS.SELECTED_BLUE
        local indicator = button:FindFirstChild("Frame")
        if indicator then
            indicator.BackgroundTransparency = 0
        end
        local icon = button:FindFirstChild("ImageLabel")
        if icon then
            icon.ImageColor3 = CONFIG.COLORS.VERSION_BLUE
        end
        if btnInfo[3] then
            btnInfo[3](ContentArea)
        end
    end
end
