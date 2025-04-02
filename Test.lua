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
    TITLE_HEIGHT = 30
}

-- Menu items
local MENU_ITEMS = {
    "Overview",
    "Farming",
    "Sea Events",
    "Islands",
    "Quests/Raids",
    "Fruit",
    "Teleport",
    "Status",
    "Visual",
    "Shop",
    "Misc.",
    "Settings",
    "Feedback"
}

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

-- Create side menu container
local MenuContainer = Instance.new("Frame")
MenuContainer.Name = "MenuContainer"
MenuContainer.Size = UDim2.new(0, CONFIG.MENU_WIDTH, 1, -CONFIG.TITLE_HEIGHT)
MenuContainer.Position = UDim2.new(0, 0, 0, CONFIG.TITLE_HEIGHT)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Parent = MainFrame

-- Create scrolling frame for menu items
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Name = "MenuScroll"
MenuScroll.Size = UDim2.new(1, -5, 1, -5)
MenuScroll.Position = UDim2.new(0, 5, 0, 5)
MenuScroll.BackgroundTransparency = 1
MenuScroll.BorderSizePixel = 0
MenuScroll.ScrollBarThickness = 2
MenuScroll.ScrollBarImageColor3 = CONFIG.THEME.ACCENT
MenuScroll.Parent = MenuContainer

-- Add list layout for menu items
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = MenuScroll

-- Create menu buttons
local selectedButton = nil
for _, itemName in ipairs(MENU_ITEMS) do
    local Button = Instance.new("TextButton")
    Button.Name = itemName .. "Button"
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.BackgroundTransparency = 1
    Button.Text = itemName
    Button.TextColor3 = CONFIG.THEME.TEXT_SECONDARY
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Parent = MenuScroll
    
    Button.MouseEnter:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Button, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT
            }):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        if Button ~= selectedButton then
            TweenService:Create(Button, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
    end)
    
    Button.MouseButton1Click:Connect(function()
        if selectedButton then
            TweenService:Create(selectedButton, TweenInfo.new(0.2), {
                TextColor3 = CONFIG.THEME.TEXT_SECONDARY
            }):Play()
        end
        selectedButton = Button
        Button.TextColor3 = CONFIG.THEME.ACCENT
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
