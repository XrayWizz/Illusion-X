-- Setrix UI Script for Fruit Blox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Check if device is touch-enabled
local isTouchDevice = UserInputService.TouchEnabled

-- Function to check if a touch/click is within a UI element
local function isWithinFrame(input, frame)
    local position = isTouchDevice and input.Position or UserInputService:GetMouseLocation()
    local framePos = frame.AbsolutePosition
    local frameSize = frame.AbsoluteSize
    
    return position.X >= framePos.X
        and position.X <= framePos.X + frameSize.X
        and position.Y >= framePos.Y
        and position.Y <= framePos.Y + frameSize.Y
end

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SetrixUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Round corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseButton.Text = ""
CloseButton.Parent = TitleBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 8)
CloseButtonCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MinimizeButton.Text = ""
MinimizeButton.Parent = TitleBar

local MinimizeButtonCorner = Instance.new("UICorner")
MinimizeButtonCorner.CornerRadius = UDim.new(0, 8)
MinimizeButtonCorner.Parent = MinimizeButton

-- Side Menu
local SideMenu = Instance.new("Frame")
SideMenu.Name = "SideMenu"
SideMenu.Size = UDim2.new(0, 150, 1, -40)
SideMenu.Position = UDim2.new(0, 0, 0, 40)
SideMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
SideMenu.BorderSizePixel = 0
SideMenu.Parent = MainFrame

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -150, 1, -40)
ContentArea.Position = UDim2.new(0, 150, 0, 40)
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Create Side Menu Buttons
local function CreateMenuButton(name, pos)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(0.9, 0, 0, 40)
    Button.Position = UDim2.new(0.05, 0, 0, pos)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Parent = SideMenu
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    return Button
end

-- Create menu buttons
local OverviewButton = CreateMenuButton("Overview", 10)
local SettingsButton = CreateMenuButton("Settings", 60)
local CreditsButton = CreateMenuButton("Credits", 110)

-- Minimized UI
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Size = UDim2.new(0, 50, 0, 50)
MinimizedButton.Position = UDim2.new(0, 20, 0, 20)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
MinimizedButton.Text = "S"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.TextSize = 20
MinimizedButton.Visible = false
MinimizedButton.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 12)
MinimizedCorner.Parent = MinimizedButton

-- Dragging functionality (modified for touch support)
local function EnableDragging(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    -- Touch/Mouse input began
    local function onInputBegan(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and 
            isWithinFrame(input, frame) then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
    
    -- Touch/Mouse movement
    local function onInputChanged(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end
    
    -- Update drag
    local function updateDrag()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                     startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    -- Connect events
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    game:GetService("RunService").RenderStepped:Connect(updateDrag)
end

-- Enable dragging for both states
EnableDragging(MainFrame)
EnableDragging(MinimizedButton)

-- Button functionality
local function connectButton(button, handler)
    button.MouseButton1Click:Connect(handler)
    button.TouchTap:Connect(handler)
end

connectButton(CloseButton, function()
    ScreenGui:Destroy()
end)

connectButton(MinimizeButton, function()
    MainFrame.Visible = false
    MinimizedButton.Visible = true
end)

connectButton(MinimizedButton, function()
    MainFrame.Visible = true
    MinimizedButton.Visible = false
end)

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

-- Function to get player stats
local function GetPlayerStats()
    local player = Players.LocalPlayer
    local stats = {}
    
    -- Get player's character
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Get Humanoid stats
    local humanoid = character:WaitForChild("Humanoid")
    stats.Health = math.floor(humanoid.Health)
    stats.MaxHealth = math.floor(humanoid.MaxHealth)
    
    -- Get Energy (assuming it's stored in a value)
    local energy = character:FindFirstChild("Energy") or player:FindFirstChild("Energy")
    stats.Energy = energy and math.floor(energy.Value) or "N/A"
    stats.MaxEnergy = energy and math.floor(energy.MaxValue) or "N/A"
    
    -- Get current fruit (assuming it's stored in a value)
    local fruit = player:FindFirstChild("Devil Fruit") or player:FindFirstChild("Fruit")
    stats.CurrentFruit = fruit and fruit.Value or "None"
    
    -- Get fighting style (assuming it's stored in a value)
    local fightingStyle = player:FindFirstChild("Fighting Style") or player:FindFirstChild("Combat")
    stats.FightingStyle = fightingStyle and fightingStyle.Value or "None"
    
    -- Get currencies (assuming they're stored in values)
    local beli = player:FindFirstChild("Beli") or player:FindFirstChild("Money")
    stats.Beli = beli and formatNumber(math.floor(beli.Value)) or "0"
    
    local fragments = player:FindFirstChild("Fragments")
    stats.Fragments = fragments and formatNumber(math.floor(fragments.Value)) or "0"
    
    return stats
end

-- Function to create stat label (modified to return the value label for updating)
local function CreateStatLabel(parent, text, value, posY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 30)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.6, -20, 1, 0)
    valueLabel.Position = UDim2.new(0.4, 10, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    return valueLabel
end

local function CreateOverviewContent()
    ClearContent()
    
    local stats = GetPlayerStats()
    local statLabels = {}
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Player Overview"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = ContentArea
    
    -- Create stat labels and store references
    statLabels.Health = CreateStatLabel(ContentArea, "Health", stats.Health .. "/" .. stats.MaxHealth, 50)
    statLabels.Energy = CreateStatLabel(ContentArea, "Energy", stats.Energy .. "/" .. stats.MaxEnergy, 90)
    statLabels.Fruit = CreateStatLabel(ContentArea, "Devil Fruit", stats.CurrentFruit, 130)
    statLabels.FightingStyle = CreateStatLabel(ContentArea, "Fighting Style", stats.FightingStyle, 170)
    statLabels.Beli = CreateStatLabel(ContentArea, "Beli", stats.Beli, 210)
    statLabels.Fragments = CreateStatLabel(ContentArea, "Fragments", stats.Fragments, 250)
    
    -- Real-time stat updates
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Update health in real-time
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.HealthChanged:Connect(function(health)
        if statLabels.Health then
            statLabels.Health.Text = math.floor(health) .. "/" .. math.floor(humanoid.MaxHealth)
        end
    end)
    
    -- Update energy in real-time
    local function connectEnergyChanges(char)
        local energy = char:FindFirstChild("Energy") or player:FindFirstChild("Energy")
        if energy then
            energy.Changed:Connect(function()
                if statLabels.Energy then
                    statLabels.Energy.Text = math.floor(energy.Value) .. "/" .. math.floor(energy.MaxValue)
                end
            end)
        end
    end
    
    -- Update fruit in real-time
    local function connectFruitChanges()
        local fruit = player:FindFirstChild("Devil Fruit") or player:FindFirstChild("Fruit")
        if fruit then
            fruit.Changed:Connect(function()
                if statLabels.Fruit then
                    statLabels.Fruit.Text = fruit.Value
                end
            end)
        end
    end
    
    -- Update fighting style in real-time
    local function connectFightingStyleChanges()
        local fightingStyle = player:FindFirstChild("Fighting Style") or player:FindFirstChild("Combat")
        if fightingStyle then
            fightingStyle.Changed:Connect(function()
                if statLabels.FightingStyle then
                    statLabels.FightingStyle.Text = fightingStyle.Value
                end
            end)
        end
    end
    
    -- Update currencies in real-time
    local function connectCurrencyChanges()
        local beli = player:FindFirstChild("Beli") or player:FindFirstChild("Money")
        if beli then
            beli.Changed:Connect(function()
                if statLabels.Beli then
                    statLabels.Beli.Text = formatNumber(math.floor(beli.Value))
                end
            end)
        end
        
        local fragments = player:FindFirstChild("Fragments")
        if fragments then
            fragments.Changed:Connect(function()
                if statLabels.Fragments then
                    statLabels.Fragments.Text = formatNumber(math.floor(fragments.Value))
                end
            end)
        end
    end
    
    -- Connect all real-time updates
    connectEnergyChanges(character)
    connectFruitChanges()
    connectFightingStyleChanges()
    connectCurrencyChanges()
    
    -- Handle character respawning
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
        
        -- Reconnect health changes
        humanoid.HealthChanged:Connect(function(health)
            if statLabels.Health then
                statLabels.Health.Text = math.floor(health) .. "/" .. math.floor(humanoid.MaxHealth)
            end
        end)
        
        -- Reconnect other stat changes
        connectEnergyChanges(newCharacter)
    end)
    
    -- Cleanup function
    local cleanup = Instance.new("BindableEvent")
    cleanup.Event:Connect(function()
        for _, label in pairs(statLabels) do
            label:Destroy()
        end
        table.clear(statLabels)
    end)
    
    return cleanup
end

-- UI Scale options
local UIScales = {
    Small = 0.8,
    Medium = 1.0,
    Large = 1.2,
    ["Extra Large"] = 1.4
}

local function CreateDropdown(parent, options, posY, currentScale)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, 35)
    container.Position = UDim2.new(0, 10, 0, posY)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    container.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "UI Scaling"
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Dropdown button (modified for touch)
    local dropButton = Instance.new("TextButton")
    dropButton.Size = UDim2.new(0.5, -20, 1, -10)
    dropButton.Position = UDim2.new(0.5, 10, 0, 5)
    dropButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    dropButton.Text = currentScale or "Medium"
    dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropButton.Font = Enum.Font.GothamBold
    dropButton.TextSize = 14
    dropButton.Parent = container
    
    -- Make button slightly larger on touch devices for better interaction
    if isTouchDevice then
        dropButton.Size = UDim2.new(0.5, -20, 1, -6)  -- Slightly taller
        dropButton.TextSize = 16  -- Larger text
    end
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropButton
    
    -- Dropdown list
    local dropList = Instance.new("Frame")
    dropList.Size = UDim2.new(0.5, -20, 0, 120)
    dropList.Position = UDim2.new(0.5, 10, 0, 40)
    dropList.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    dropList.Visible = false
    dropList.ZIndex = 10
    dropList.Parent = container
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = dropList
    
    -- Scrolling Frame for options
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -4, 1, -4)
    scrollFrame.Position = UDim2.new(0, 2, 0, 2)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
    scrollFrame.ZIndex = 10
    scrollFrame.Parent = dropList
    
    -- Add options
    local optionHeight = 30
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #options * optionHeight)
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, -8, 0, isTouchDevice and 35 or 30)  -- Larger on touch
        optionButton.Position = UDim2.new(0, 4, 0, (i-1) * (isTouchDevice and 35 or 30) + 2)
        optionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.ZIndex = 10
        optionButton.Parent = scrollFrame
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 4)
        optionCorner.Parent = optionButton
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            }):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(optionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            }):Play()
        end)
        
        -- Option click handler
        local function onOptionActivated()
            dropButton.Text = option
            dropList.Visible = false
            
            -- Apply scale
            local scale = UIScales[option]
            if scale then
                MainFrame.Size = UDim2.new(0, 600 * scale, 0, 350 * scale)
                MainFrame.Position = UDim2.new(0.5, -300 * scale, 0.5, -175 * scale)
            end
        end
        
        -- Connect both touch and mouse events
        optionButton.MouseButton1Click:Connect(onOptionActivated)
        optionButton.TouchTap:Connect(onOptionActivated)
    end
    
    -- Toggle dropdown
    local function toggleDropdown()
        dropList.Visible = not dropList.Visible
    end
    
    dropButton.MouseButton1Click:Connect(toggleDropdown)
    dropButton.TouchTap:Connect(toggleDropdown)
    
    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch) and
            dropList.Visible and
            not isWithinFrame(input, dropList) then
            dropList.Visible = false
        end
    end)
    
    return container
end

local function CreateSettingsContent()
    ClearContent()
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Settings"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = ContentArea
    
    -- Create UI Scale dropdown
    CreateDropdown(ContentArea, {"Small", "Medium", "Large", "Extra Large"}, 50)
end

local function CreateCreditsContent()
    ClearContent()
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Credits"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = ContentArea
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 1, -60)
    Content.Position = UDim2.new(0, 10, 0, 50)
    Content.BackgroundTransparency = 1
    Content.Text = "Created by: You\nUI Design: Setrix"
    Content.TextColor3 = Color3.fromRGB(200, 200, 200)
    Content.Font = Enum.Font.Gotham
    Content.TextSize = 14
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.TextWrapped = true
    Content.Parent = ContentArea
end

-- Button click handlers (modified for touch)
local currentCleanup
connectButton(OverviewButton, function()
    if currentCleanup then
        currentCleanup:Fire()
    end
    currentCleanup = CreateOverviewContent()
end)

connectButton(SettingsButton, function()
    if currentCleanup then
        currentCleanup:Fire()
    end
    CreateSettingsContent()
end)

connectButton(CreditsButton, function()
    if currentCleanup then
        currentCleanup:Fire()
    end
    CreateCreditsContent()
end)

-- Initial content with cleanup handling
currentCleanup = CreateOverviewContent()
