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

-- Fruit spawning configuration
local FruitConfig = {
    SpawnHeight = 5, -- Height above player
    RotationSpeed = 1, -- How fast the fruit rotates
    BobSpeed = 1, -- How fast the fruit moves up and down
    BobHeight = 0.5 -- How far the fruit moves up and down
}

-- Function to spawn fruit at player location
local function spawnFruitAtPlayer(fruitName)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create the fruit model
    local fruit = Instance.new("Part")
    fruit.Name = fruitName .. "Fruit"
    fruit.Anchored = true
    fruit.CanCollide = false
    fruit.Size = Vector3.new(2, 2, 2)
    fruit.Position = humanoidRootPart.Position + Vector3.new(0, FruitConfig.SpawnHeight, 0)
    fruit.BrickColor = BrickColor.Random() -- Random color for each fruit
    
    -- Add mesh to make it look like a fruit
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Parent = fruit
    
    -- Add glow effect
    local glow = Instance.new("PointLight")
    glow.Color = fruit.Color
    glow.Range = 8
    glow.Parent = fruit
    
    -- Add spinning animation
    local spinningAnimation = coroutine.create(function()
        local startTime = tick()
        while fruit.Parent do
            local timePassed = tick() - startTime
            -- Rotate the fruit
            fruit.CFrame = CFrame.new(
                fruit.Position
            ) * CFrame.Angles(0, timePassed * FruitConfig.RotationSpeed, 0)
            
            -- Bob up and down
            local bobOffset = math.sin(timePassed * FruitConfig.BobSpeed) * FruitConfig.BobHeight
            fruit.Position = humanoidRootPart.Position + 
                Vector3.new(0, FruitConfig.SpawnHeight + bobOffset, 0)
            
            wait()
        end
    end)
    
    -- Add click detection
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.Parent = fruit
    clickDetector.MouseClick:Connect(function(player)
        -- Add your collection logic here
        fruit:Destroy()
    end)
    
    -- Parent the fruit to workspace
    fruit.Parent = workspace
    
    -- Start the animation
    coroutine.resume(spinningAnimation)
end

-- Modify the existing GUI to add spawn buttons
local function addFruitButton(fruitName, parent)
    local button = Instance.new("TextButton")
    button.Name = fruitName .. "Button"
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 35)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = "Spawn " .. fruitName
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    button.MouseButton1Click:Connect(function()
        spawnFruitAtPlayer(fruitName)
    end)
end

-- Define mythical fruits (most expensive/rare fruits)
local MYTHICAL_FRUITS = {
    "Dragon",
    "Kitsune",
    "Leopard",
    "Spirit",
    "Venom",
    "Dough",
    "Shadow"
}

-- Function to generate random mythical fruit drops
local function generateMythicalFruits()
    -- Generate 5-7 random mythical fruits
    local numFruits = math.random(5, 7)
    for i = 1, numFruits do
        local randomIndex = math.random(1, #MYTHICAL_FRUITS)
        local selectedFruit = MYTHICAL_FRUITS[randomIndex]
        
        -- Call the game's fruit spawn function
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy", selectedFruit)
    end
end

-- Add mythical spawn button to GUI
local mythicalButton = Instance.new("TextButton")
mythicalButton.Name = "GenerateMythicalFruits"
mythicalButton.Size = UDim2.new(0.9, 0, 0, 40)
mythicalButton.Position = UDim2.new(0.05, 0, 0.75, 0)
mythicalButton.BackgroundColor3 = Color3.fromRGB(170, 85, 127) -- Purple-ish color for mythical
mythicalButton.BorderSizePixel = 0
mythicalButton.Text = "Generate Mythical Fruits"
mythicalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mythicalButton.TextSize = 16
mythicalButton.Font = Enum.Font.GothamBold
mythicalButton.Parent = MainFrame

-- Add click handler for mythical button
mythicalButton.MouseButton1Click:Connect(function()
    generateMythicalFruits()
end)

-- Add spawn buttons for each fruit
for fruitName, _ in pairs(FRUIT_PRICES) do
    addFruitButton(fruitName, normalGachaSection)
end

-- Add spawn information
addSpawnInfo(MainFrame)
