local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId
local PrivateServerId = game.PrivateServerId
local UIS = game:GetService("UserInputService")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 60) -- Slightly larger for a modern look
Frame.Position = UDim2.new(0.5, -110, 0.1, 0) -- Centered at the top
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark Gray Background
Frame.BackgroundTransparency = 0.2 -- Glassmorphism effect
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true -- Allows dragging

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

-- Draggable Handle (Top Bar)
local DragHandle = Instance.new("Frame")
DragHandle.Parent = Frame
DragHandle.Size = UDim2.new(1, 0, 0.3, 0) -- Thin top section
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DragHandle.BorderSizePixel = 0

local UICornerDrag = Instance.new("UICorner")
UICornerDrag.CornerRadius = UDim.new(0, 12)
UICornerDrag.Parent = DragHandle

-- Rejoin Button
local RejoinButton = Instance.new("TextButton")
RejoinButton.Parent = Frame
RejoinButton.Size = UDim2.new(0.75, 0, 0.55, 0) -- 75% width, clean design
RejoinButton.Position = UDim2.new(0.05, 0, 0.4, 0)
RejoinButton.Text = "↻ Rejoin Server"
RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextSize = 15

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 10)
UICornerButton.Parent = RejoinButton

-- Hover effect for button
RejoinButton.MouseEnter:Connect(function()
    RejoinButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

RejoinButton.MouseLeave:Connect(function()
    RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

-- Close Button (Small Red Icon)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.18, 0, 0.55, 0) -- Small size
CloseButton.Position = UDim2.new(0.8, 0, 0.4, 0)
CloseButton.Text = "✕"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 8)
UICornerClose.Parent = CloseButton

-- Hover effect for close button
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
end)

-- 🚀 **Final Fixed Rejoin Function**
RejoinButton.MouseButton1Click:Connect(function()
    if PrivateServerId ~= "" then
        -- 🚀 **Private Server Fix: Roblox blocks rejoining private servers, so force a new instance!**
        TeleportService:Teleport(PlaceId, LocalPlayer)
    else
        -- ✅ **Public Servers: Rejoin exact server**
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    end
end)

-- Close UI Function
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Draggable Function
local dragging, startPos, startInputPos

DragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = Frame.Position
        startInputPos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startInputPos
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
