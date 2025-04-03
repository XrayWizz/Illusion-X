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
Frame.Size = UDim2.new(0, 250, 0, 60)
Frame.Position = UDim2.new(0.5, -125, 0.05, 0) -- Centered at the top
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark Modern Theme
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true -- Makes it draggable

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15) -- More rounded for modern look
UICorner.Parent = Frame

-- Drag Handle
local DragHandle = Instance.new("Frame")
DragHandle.Parent = Frame
DragHandle.Size = UDim2.new(1, 0, 0, 10)
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DragHandle.BorderSizePixel = 0

local UICornerDrag = Instance.new("UICorner")
UICornerDrag.CornerRadius = UDim.new(0, 15)
UICornerDrag.Parent = DragHandle

-- Rejoin Button
local RejoinButton = Instance.new("TextButton")
RejoinButton.Parent = Frame
RejoinButton.Size = UDim2.new(0.7, 0, 0.7, 0) -- 70% width, 70% height
RejoinButton.Position = UDim2.new(0.05, 0, 0.2, 0)
RejoinButton.Text = "Rejoin"
RejoinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Slightly lighter dark
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextSize = 16

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 12)
UICornerButton.Parent = RejoinButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.2, 0, 0.7, 0) -- 20% width, 70% height
CloseButton.Position = UDim2.new(0.75, 0, 0.2, 0) -- Right side
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red close button
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 12)
UICornerClose.Parent = CloseButton

-- Rejoin Function
RejoinButton.MouseButton1Click:Connect(function()
    if PrivateServerId ~= "" then
        -- Private Server: Use Teleport instead of TeleportToPlaceInstance
        TeleportService:Teleport(PlaceId, LocalPlayer)
    elseif JobId ~= "" then
        -- Public Server: Rejoin exact server
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    else
        -- Fallback: Just teleport to the game
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
end)

-- Close UI Function
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)

-- Draggable Function
local dragging, dragInput, startPos, startInputPos

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
