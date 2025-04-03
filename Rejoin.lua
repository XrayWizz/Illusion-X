local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId
local PrivateServerId = game.PrivateServerId
local PrivateServerOwnerId = game.PrivateServerOwnerId
local UIS = game:GetService("UserInputService")

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 180, 0, 40) -- Slim design
Frame.Position = UDim2.new(0.5, -90, 0.05, 0) -- Centered at the top
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Dark Modern Theme
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Active = true -- Allows dragging

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Drag Handle (Thin Top Bar)
local DragHandle = Instance.new("Frame")
DragHandle.Parent = Frame
DragHandle.Size = UDim2.new(1, 0, 0.2, 0) -- Thin bar at the top
DragHandle.Position = UDim2.new(0, 0, 0, 0)
DragHandle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DragHandle.BorderSizePixel = 0

local UICornerDrag = Instance.new("UICorner")
UICornerDrag.CornerRadius = UDim.new(0, 10)
UICornerDrag.Parent = DragHandle

-- Rejoin Button
local RejoinButton = Instance.new("TextButton")
RejoinButton.Parent = Frame
RejoinButton.Size = UDim2.new(0.8, 0, 0.7, 0) -- 80% width
RejoinButton.Position = UDim2.new(0.05, 0, 0.25, 0)
RejoinButton.Text = "↻ Rejoin"
RejoinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextSize = 14

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 8)
UICornerButton.Parent = RejoinButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.15, 0, 0.7, 0) -- Small size
CloseButton.Position = UDim2.new(0.85, 0, 0.25, 0)
CloseButton.Text = "✕"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red close button
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 8)
UICornerClose.Parent = CloseButton

-- Rejoin Function (FIXED for Private Servers)
RejoinButton.MouseButton1Click:Connect(function()
    if PrivateServerId ~= "" then
        -- 🔥 Fix for Private Servers (Force new instance)
        if PrivateServerOwnerId == 0 then
            -- VIP Servers: Create a new one
            TeleportService:Teleport(PlaceId, LocalPlayer)
        else
            -- Roblox Reserved Server: Rejoin via PrivateServerId
            TeleportService:Teleport(PlaceId, LocalPlayer, {PrivateServerId})
        end
    elseif JobId ~= "" then
        -- Public Servers: Rejoin exact same server
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
