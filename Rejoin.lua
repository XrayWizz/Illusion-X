local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId
local PrivateServerId = game.PrivateServerId

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 50)
Frame.Position = UDim2.new(0.5, -110, 0.05, 0) -- Centered at the top
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Dark Theme
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.ClipsDescendants = true

-- Round the corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12) -- Rounded edges
UICorner.Parent = Frame

-- Rejoin Button
local RejoinButton = Instance.new("TextButton")
RejoinButton.Parent = Frame
RejoinButton.Size = UDim2.new(0.7, 0, 1, 0) -- 70% of the Frame
RejoinButton.Position = UDim2.new(0.05, 0, 0, 0)
RejoinButton.Text = "Rejoin Server"
RejoinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Slightly lighter dark
RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinButton.Font = Enum.Font.GothamBold
RejoinButton.TextSize = 16
RejoinButton.AutoButtonColor = true

local UICornerButton = Instance.new("UICorner")
UICornerButton.CornerRadius = UDim.new(0, 10) -- Rounded button edges
UICornerButton.Parent = RejoinButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = Frame
CloseButton.Size = UDim2.new(0.2, 0, 1, 0) -- 20% of the Frame
CloseButton.Position = UDim2.new(0.75, 0, 0, 0) -- Aligned to the right
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red close button
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 10)
UICornerClose.Parent = CloseButton

-- Rejoin Function
RejoinButton.MouseButton1Click:Connect(function()
    if PrivateServerId ~= "" then
        -- Private Server Fix: Use Teleport instead of TeleportToPlaceInstance
        TeleportService:Teleport(PlaceId, LocalPlayer)
    elseif JobId ~= "" then
        -- Public Server: Rejoin the exact same server
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    else
        -- Fallback: Just teleport to the same game
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
end)

-- Close UI Function
CloseButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
end)
