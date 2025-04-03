-- Function to format time
local function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Add spawn timer information
local function addSpawnInfo(parent)
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "SpawnInfo"
    infoFrame.Size = UDim2.new(0.9, 0, 0, 60)
    infoFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
    infoFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = parent

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, 0, 1, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Fruits spawn naturally every 1-4 hours\nRare fruits have lower spawn chances"
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = infoFrame
end

-- Create the sections
local normalGachaSection = createSection("Normal Gacha Fruits", UDim2.new(0.05, 0, 0.05, 0))
local mirageGachaSection = createSection("Mirage Island Fruits", UDim2.new(0.05, 0, 0.55, 0))

-- Add spawn information
addSpawnInfo(MainFrame)
