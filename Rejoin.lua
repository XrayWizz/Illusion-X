local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

-- Create UI Button
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.8, 0)
Button.Text = "Rejoin Server"
Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.SourceSansBold
Button.TextSize = 20
Button.BorderSizePixel = 2
Button.BorderColor3 = Color3.fromRGB(0, 0, 0)

-- Rejoin Function
Button.MouseButton1Click:Connect(function()
    if JobId ~= "" then
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    else
        TeleportService:Teleport(PlaceId, LocalPlayer)
    end
end)
