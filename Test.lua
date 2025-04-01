-- UI Configuration
local Config = {
    Colors = {
        Background = Color3.fromRGB(25, 25, 35),
        Sidebar = Color3.fromRGB(30, 30, 40),
        Button = Color3.fromRGB(35, 35, 45),
        ButtonHover = Color3.fromRGB(45, 45, 55),
        ButtonSelected = Color3.fromRGB(55, 95, 155),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(65, 125, 255),
        Content = Color3.fromRGB(32, 32, 42)
    },
    Transparency = {
        Background = 0.1,
        Sidebar = 0.05,
        Button = 0.1,
        Content = 0.05
    },
    Size = {
        Width = 500,
        Height = 350
    }
}

-- Create the main UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, Config.Size.Width, 0, Config.Size.Height)
MainFrame.Position = UDim2.new(0.5, -Config.Size.Width/2, 0.5, -Config.Size.Height/2)
MainFrame.BackgroundColor3 = Config.Colors.Background
MainFrame.BackgroundTransparency = Config.Transparency.Background
MainFrame.Parent = ScreenGui

-- Add corner radius to main frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Add a subtle border
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Create sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Config.Colors.Sidebar
Sidebar.BackgroundTransparency = Config.Transparency.Sidebar
Sidebar.Parent = MainFrame

-- Add corner radius to sidebar
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

-- Create content frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -130, 1, -20)
ContentFrame.Position = UDim2.new(0, 125, 0, 10)
ContentFrame.BackgroundColor3 = Config.Colors.Content
ContentFrame.BackgroundTransparency = Config.Transparency.Content
ContentFrame.Parent = MainFrame

-- Add corner radius to content frame
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Config.Colors.Button
CloseButton.BackgroundTransparency = Config.Transparency.Button
CloseButton.Text = "×"
CloseButton.TextColor3 = Config.Colors.Text
CloseButton.TextSize = 24
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

-- Add corner radius to close button
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Create button list with icons
local Buttons = {
    {Name = "Overview", Icon = "", Description = "View general information"},
    {Name = "Farm", Icon = "", Description = "Farming settings and controls"},
    {Name = "Sea", Icon = "", Description = "Sea-related features"},
    {Name = "Islands", Icon = "", Description = "Island navigation"},
    {Name = "Quests", Icon = "", Description = "Available quests"},
    {Name = "Fruit", Icon = "", Description = "Fruit management"},
    {Name = "Teleport", Icon = "", Description = "Quick teleportation"},
    {Name = "Status", Icon = "", Description = "Current status"},
    {Name = "Visual", Icon = "", Description = "Visual settings"},
    {Name = "Shop", Icon = "", Description = "Shop items"},
    {Name = "Misc", Icon = "", Description = "Miscellaneous options"},
    {Name = "Settings", Icon = "", Description = "Configure settings"}
}

local currentSelectedButton = nil

-- Function to create a button
local function CreateButton(name, icon, description, position)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.Position = position
    Button.BackgroundColor3 = Config.Colors.Button
    Button.BackgroundTransparency = Config.Transparency.Button
    Button.Text = icon .. " " .. name
    Button.TextColor3 = Config.Colors.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamMedium
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = Sidebar
    
    -- Add padding to text
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.Parent = Button
    
    -- Add corner radius
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Add subtle stroke
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(60, 60, 70)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button
    
    -- Hover and click effects
    Button.MouseEnter:Connect(function()
        if Button ~= currentSelectedButton then
            Button.BackgroundColor3 = Config.Colors.ButtonHover
        end
        
        -- Create tooltip
        local Tooltip = Instance.new("Frame")
        Tooltip.Name = "Tooltip"
        Tooltip.Size = UDim2.new(0, 150, 0, 30)
        Tooltip.Position = UDim2.new(1, 10, 0, 0)
        Tooltip.BackgroundColor3 = Config.Colors.Background
        Tooltip.BackgroundTransparency = 0.1
        Tooltip.Parent = Button
        
        local TooltipCorner = Instance.new("UICorner")
        TooltipCorner.CornerRadius = UDim.new(0, 6)
        TooltipCorner.Parent = Tooltip
        
        local TooltipText = Instance.new("TextLabel")
        TooltipText.Size = UDim2.new(1, -10, 1, 0)
        TooltipText.Position = UDim2.new(0, 5, 0, 0)
        TooltipText.BackgroundTransparency = 1
        TooltipText.Text = description
        TooltipText.TextColor3 = Config.Colors.Text
        TooltipText.TextSize = 12
        TooltipText.Font = Enum.Font.GothamMedium
        TooltipText.TextWrapped = true
        TooltipText.Parent = Tooltip
    end)
    
    Button.MouseLeave:Connect(function()
        if Button ~= currentSelectedButton then
            Button.BackgroundColor3 = Config.Colors.Button
        end
        
        -- Remove tooltip
        local tooltip = Button:FindFirstChild("Tooltip")
        if tooltip then
            tooltip:Destroy()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        -- Deselect previous button
        if currentSelectedButton then
            currentSelectedButton.BackgroundColor3 = Config.Colors.Button
        end
        
        -- Select new button
        currentSelectedButton = Button
        Button.BackgroundColor3 = Config.Colors.ButtonSelected
        
        -- Clear content frame
        for _, child in pairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        
        -- Add new content
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -20, 0, 30)
        Title.Position = UDim2.new(0, 10, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = icon .. " " .. name
        Title.TextColor3 = Config.Colors.Text
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = ContentFrame
        
        local Subtitle = Instance.new("TextLabel")
        Subtitle.Size = UDim2.new(1, -20, 0, 20)
        Subtitle.Position = UDim2.new(0, 10, 0, 40)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = description
        Subtitle.TextColor3 = Config.Colors.Text
        Subtitle.TextTransparency = 0.3
        Subtitle.TextSize = 14
        Subtitle.Font = Enum.Font.GothamMedium
        Subtitle.TextXAlignment = Enum.TextXAlignment.Left
        Subtitle.Parent = ContentFrame
    end)
    
    return Button
end

-- Create scrolling frame for buttons
local ButtonScroll = Instance.new("ScrollingFrame")
ButtonScroll.Name = "ButtonScroll"
ButtonScroll.Size = UDim2.new(1, 0, 1, -20)
ButtonScroll.Position = UDim2.new(0, 0, 0, 10)
ButtonScroll.BackgroundTransparency = 1
ButtonScroll.ScrollBarThickness = 2
ButtonScroll.Parent = Sidebar

-- Create buttons
for i, buttonInfo in ipairs(Buttons) do
    local yPos = (i-1) * 35  -- 35 pixels between buttons
    local button = CreateButton(
        buttonInfo.Name,
        buttonInfo.Icon,
        buttonInfo.Description,
        UDim2.new(0, 10, 0, yPos)
    )
    button.Parent = ButtonScroll
end

-- Update scrolling frame canvas size
ButtonScroll.CanvasSize = UDim2.new(0, 0, 0, #Buttons * 35 + 10)

-- Close button functionality with fade out
CloseButton.MouseButton1Click:Connect(function()
    -- Fade out animation
    local fadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local function fadeOut(object)
        if object:IsA("GuiObject") then
            local fadeProperties = {
                BackgroundTransparency = 1,
                TextTransparency = 1
            }
            local tween = game:GetService("TweenService"):Create(object, fadeInfo, fadeProperties)
            tween:Play()
        end
        for _, child in pairs(object:GetChildren()) do
            fadeOut(child)
        end
    end
    
    fadeOut(MainFrame)
    wait(0.2)
    ScreenGui:Destroy()
end)

-- Close button hover effect
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Config.Colors.Button
end)

-- Make the frame draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Parent the ScreenGui to PlayerGui
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- Select Overview by default
local overviewButton = ButtonScroll:FindFirstChild("OverviewButton")
if overviewButton then
    overviewButton:MouseButton1Click:Fire()
end
