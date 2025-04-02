-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Constants for configuration
local CONFIG = {
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

-- State variables
local currentSize = "NORMAL"
local isMinimized = false
local selectedButton = nil
local stats = {}
local containers = {}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Create main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, CONFIG.SIZES[currentSize].WIDTH, 0, CONFIG.SIZES[currentSize].HEIGHT)
MainFrame.Position = UDim2.new(0.5, -CONFIG.SIZES[currentSize].WIDTH/2, 0.5, -CONFIG.SIZES[currentSize].HEIGHT/2)
MainFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND_DARK
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Add corner rounding
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
Corner.Parent = MainFrame

-- Create title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 24)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = CONFIG.THEME.BACKGROUND_MEDIUM
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
TitleCorner.Parent = TitleBar

-- Create title text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 8, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Super"
TitleText.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextSize = 14
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Parent = TitleBar

-- Create minimize button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 24, 0, 24)
MinimizeButton.Position = UDim2.new(1, -48, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Parent = TitleBar

-- Create close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -24, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "×"
CloseButton.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = TitleBar

-- Create menu bar
local MenuBar = Instance.new("Frame")
MenuBar.Name = "MenuBar"
MenuBar.Size = UDim2.new(0, 75, 1, 0)
MenuBar.Position = UDim2.new(0, 0, 0, 0)
MenuBar.BackgroundColor3 = CONFIG.THEME.BACKGROUND_MEDIUM
MenuBar.BorderSizePixel = 0
MenuBar.Parent = MainFrame

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
MenuCorner.Parent = MenuBar

-- Create menu divider
local MenuDivider = Instance.new("Frame")
MenuDivider.Name = "MenuDivider"
MenuDivider.BackgroundColor3 = CONFIG.THEME.BORDER
MenuDivider.BorderSizePixel = 0
MenuDivider.Position = UDim2.new(0, 75, 0, 24)
MenuDivider.Size = UDim2.new(0, 1, 1, -24)
MenuDivider.Parent = MainFrame

-- Create containers
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -76, 1, -25)
ContentContainer.Position = UDim2.new(0, 76, 0, 25)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame
containers.Content = ContentContainer

local SettingsContainer = Instance.new("Frame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Size = UDim2.new(1, -76, 1, -25)
SettingsContainer.Position = UDim2.new(0, 76, 0, 25)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.Visible = false
SettingsContainer.Parent = MainFrame
containers.Settings = SettingsContainer

-- Create scrolling frames for containers
local function createScrollingFrame(parent)
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
    ScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
    ScrollingFrame.Parent = parent
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, CONFIG.PADDING.SECTION)
    UIListLayout.Parent = ScrollingFrame
    
    return ScrollingFrame
end

local ContentScroll = createScrollingFrame(ContentContainer)
local SettingsScroll = createScrollingFrame(SettingsContainer)

-- Create settings UI
local function createSettingsUI()
    -- Size dropdown
    local SizeFrame = Instance.new("Frame")
    SizeFrame.Size = UDim2.new(1, 0, 0, 70)
    SizeFrame.BackgroundTransparency = 1
    SizeFrame.Parent = SettingsScroll
    
    local SizeLabel = Instance.new("TextLabel")
    SizeLabel.Size = UDim2.new(1, 0, 0, 20)
    SizeLabel.BackgroundTransparency = 1
    SizeLabel.Text = "Window Size"
    SizeLabel.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
    SizeLabel.TextSize = 14
    SizeLabel.Font = Enum.Font.SourceSansBold
    SizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    SizeLabel.Parent = SizeFrame
    
    local SizeDropdown = Instance.new("Frame")
    SizeDropdown.Size = UDim2.new(1, 0, 0, 30)
    SizeDropdown.Position = UDim2.new(0, 0, 0, 25)
    SizeDropdown.BackgroundColor3 = CONFIG.THEME.BACKGROUND_MEDIUM
    SizeDropdown.BorderSizePixel = 0
    SizeDropdown.Parent = SizeFrame
    
    local SizeCorner = Instance.new("UICorner")
    SizeCorner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
    SizeCorner.Parent = SizeDropdown
    
    local SizeOptions = {"SMALL", "NORMAL", "LARGE", "EXTRA_LARGE"}
    local OptionButtons = {}
    
    for i, size in ipairs(SizeOptions) do
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.25, -2, 1, -4)
        Button.Position = UDim2.new(0.25 * (i-1), 1, 0, 2)
        Button.BackgroundColor3 = size == currentSize and CONFIG.THEME.ACCENT or CONFIG.THEME.BACKGROUND_LIGHT
        Button.Text = size
        Button.TextColor3 = CONFIG.THEME.TEXT_PRIMARY
        Button.TextSize = 12
        Button.Font = Enum.Font.SourceSans
        Button.Parent = SizeDropdown
        Button.BorderSizePixel = 0
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
        ButtonCorner.Parent = Button
        
        OptionButtons[size] = Button
        
        Button.MouseButton1Click:Connect(function()
            for _, btn in pairs(OptionButtons) do
                btn.BackgroundColor3 = CONFIG.THEME.BACKGROUND_LIGHT
            end
            Button.BackgroundColor3 = CONFIG.THEME.ACCENT
            switchSize(size)
        end)
    end
end

createSettingsUI()

-- Minimize settings
local MINIMIZE_SETTINGS = {
    NORMAL = {
        Size = UDim2.new(0, CONFIG.SIZES[currentSize].WIDTH, 0, CONFIG.SIZES[currentSize].HEIGHT),
        Position = UDim2.new(0.5, -CONFIG.SIZES[currentSize].WIDTH/2, 0.5, -CONFIG.SIZES[currentSize].HEIGHT/2)
    },
    MINIMIZED = {
        Size = UDim2.new(0, 200, 0, 24),
        Position = UDim2.new(1, -210, 1, -34)
    }
}

-- Function to switch window size
local function switchSize(sizeName)
    currentSize = sizeName
    local size = CONFIG.SIZES[sizeName]
    -- Update minimize settings for current size
    MINIMIZE_SETTINGS.NORMAL = {
        Size = UDim2.new(0, size.WIDTH, 0, size.HEIGHT),
        Position = UDim2.new(0.5, -size.WIDTH/2, 0.5, -size.HEIGHT/2)
    }
    
    if not isMinimized then
        TweenService:Create(MainFrame, CONFIG.ANIMATION.TWEEN_INFO, {
            Size = MINIMIZE_SETTINGS.NORMAL.Size,
            Position = MINIMIZE_SETTINGS.NORMAL.Position
        }):Play()
    end
end

-- Function to toggle minimize
local function toggleMinimize()
    isMinimized = not isMinimized
    local targetState = isMinimized and MINIMIZE_SETTINGS.MINIMIZED or MINIMIZE_SETTINGS.NORMAL
    TweenService:Create(MainFrame, CONFIG.ANIMATION.TWEEN_INFO, {
        Size = targetState.Size,
        Position = targetState.Position
    }):Play()
end

-- Function to create menu button
local function createMenuButton(name, icon, container)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = MenuBar
    
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = icon
    IconLabel.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    IconLabel.TextSize = 16
    IconLabel.Font = Enum.Font.SourceSansBold
    IconLabel.Parent = Button
    
    local SelectedIndicator = Instance.new("Frame")
    SelectedIndicator.Name = "SelectedIndicator"
    SelectedIndicator.Size = UDim2.new(0, 2, 1, -16)
    SelectedIndicator.Position = UDim2.new(0, 0, 0, 8)
    SelectedIndicator.BackgroundColor3 = CONFIG.THEME.ACCENT
    SelectedIndicator.BorderSizePixel = 0
    SelectedIndicator.Visible = false
    SelectedIndicator.Parent = Button
    
    Button.MouseEnter:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(IconLabel, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                TextColor3 = CONFIG.THEME.TEXT_PRIMARY
            }):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(IconLabel, CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        if selectedButton then
            selectedButton.SelectedIndicator.Visible = false
            TweenService:Create(selectedButton:FindFirstChild("TextLabel"), CONFIG.ANIMATION.HOVER_TWEEN_INFO, {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
        
        selectedButton = Button
        Button.SelectedIndicator.Visible = true
        IconLabel.TextColor3 = CONFIG.THEME.ACCENT
        
        for name, cont in pairs(containers) do
            cont.Visible = (cont == container)
        end
    end)
    
    return Button
end

-- Create menu buttons
local StatsButton = createMenuButton("Stats", "📊", ContentContainer)
local SettingsButton = createMenuButton("Settings", "⚙️", SettingsContainer)

-- Select default button
StatsButton:FindFirstChild("TextLabel").TextColor3 = CONFIG.THEME.ACCENT
StatsButton.SelectedIndicator.Visible = true
selectedButton = StatsButton

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

-- Button handlers
MinimizeButton.MouseButton1Click:Connect(toggleMinimize)

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

-- Stats tracking
local function updateStats()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            -- Update stats here safely
            -- Example: Position, Health, etc.
        end
    end)
end

-- Start update loop with performance optimization
local lastUpdate = 0
game:GetService("RunService").RenderStepped:Connect(function()
    local now = tick()
    if now - lastUpdate >= 0.1 then  -- Update every 0.1 seconds instead of every frame
        lastUpdate = now
        updateStats()
    end
end)

return ScreenGui
