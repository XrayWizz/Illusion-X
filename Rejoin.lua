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
Frame.Visible
