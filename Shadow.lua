-- FULL SCRIPT: Mobile Elite Fireball + Flying + Modern UI -- Place this as a LocalScript in StarterPlayerScripts

-- SERVICES local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local Debris = game:GetService("Debris")

local player = Players.LocalPlayer local playerGui = player:WaitForChild("PlayerGui")

-- MAIN UI local screenGui = Instance.new("ScreenGui", playerGui) screenGui.Name = "ShadedShadowUI" screenGui.ResetOnSpawn = false screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- UI FRAME local uiFrame = Instance.new("Frame", screenGui) uiFrame.Size = UDim2.new(0, 260, 0, 200) uiFrame.Position = UDim2.new(0, 20, 0.5, -100) uiFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) uiFrame.BackgroundTransparency = 0.1 uiFrame.BorderSizePixel = 0 uiFrame.ClipsDescendants = true uiFrame.Active = true uiFrame.Draggable = true local corner = Instance.new("UICorner", uiFrame) corner.CornerRadius = UDim.new(0, 16)

-- TITLE local title = Instance.new("TextLabel", uiFrame) title.Size = UDim2.new(1, -20, 0, 40) title.Position = UDim2.new(0, 10, 0, 10) title.Text = "Shaded Shadow" title.TextColor3 = Color3.fromRGB(255, 255, 255) title.Font = Enum.Font.GothamBold title.TextSize = 22 title.BackgroundTransparency = 1 title.TextXAlignment = Enum.TextXAlignment.Left

-- UI BUTTON TEMPLATE local function makeButton(name, text, position) local button = Instance.new("TextButton") button.Name = name button.Size = UDim2.new(0.8, 0, 0, 40) button.Position = position button.Text = text button.BackgroundColor3 = Color3.fromRGB(50, 50, 50) button.TextColor3 = Color3.new(1,1,1) button.Font = Enum.Font.GothamBold button.TextSize = 18 button.AutoButtonColor = true local corner = Instance.new("UICorner", button) corner.CornerRadius = UDim.new(0, 12) return button end

-- FIRE BUTTONS local fireBtn = makeButton("FireBtn", "Enable Fire Power", UDim2.new(0.1, 0, 0.4, 0)) fireBtn.Parent = uiFrame

local throwBtn = makeButton("ThrowBtn", "Throw Fireball", UDim2.new(0.1, 0, 0.65, 0)) throwBtn.Parent = uiFrame throwBtn.Visible = false

local flyBtn = makeButton("FlyBtn", "Toggle Fly", UDim2.new(0.1, 0, 0.88, 0)) flyBtn.Parent = uiFrame flyBtn.Visible = false

-- FIRE MECHANICS local canUseFire = false local isFlying = false local bodyVelocity = nil

-- FIRE PARTICLE HELPERS local function createTwirlingFlame(attachment) local p = Instance.new("ParticleEmitter", attachment) p.Texture = "rbxassetid://4844380622" -- realistic fire swirl p.Lifetime = NumberRange.new(0.3, 0.5) p.Speed = NumberRange.new(2, 4) p.Rate = 120 p.Rotation = NumberRange.new(0, 360) p.RotSpeed = NumberRange.new(50, 80) p.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 0.1)}) p.Color = ColorSequence.new(Color3.new(1, 0.5, 0), Color3.new(1, 1, 0)) end

local function createSmokeTrail(attachment) local smoke = Instance.new("ParticleEmitter", attachment) smoke.Texture = "rbxassetid://771221224" smoke.Lifetime = NumberRange.new(0.6, 1.2) smoke.Size = NumberSequence.new(1) smoke.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1)}) smoke.Speed = NumberRange.new(0.5, 1) smoke.Rate = 30 smoke.Color = ColorSequence.new(Color3.new(0.1,0.1,0.1)) end

local function applyHandFX() local char = player.Character or player.CharacterAdded:Wait() for _, handName in {"LeftHand", "RightHand"} do local hand = char:FindFirstChild(handName) if hand then local attach = Instance.new("Attachment", hand) createTwirlingFlame(attach) createSmokeTrail(attach) end end end

local function throwFireball() if not canUseFire then return end local char = player.Character or player.CharacterAdded:Wait() local head = char:FindFirstChild("Head") if not head then return end

local fireball = Instance.new("Part")
fireball.Size = Vector3.new(1,1,1)
fireball.Shape = Enum.PartType.Ball
fireball.Material = Enum.Material.Neon
fireball.BrickColor = BrickColor.new("Bright orange")
fireball.CFrame = head.CFrame * CFrame.new(0, 0, -2)
fireball.Velocity = head.CFrame.LookVector * 100
fireball.CanCollide = false
fireball.Anchored = false
fireball.Parent = workspace

local a = Instance.new("Attachment", fireball)
createTwirlingFlame(a)
createSmokeTrail(a)

local sound = Instance.new("Sound", fireball)
sound.SoundId = "rbxassetid://1840882422"
sound.Volume = 0.8
sound.Looped = true
sound:Play()

Debris:AddItem(fireball, 3)

end

local function enableFly() local char = player.Character or player.CharacterAdded:Wait() local root = char:WaitForChild("HumanoidRootPart") if not bodyVelocity then bodyVelocity = Instance.new("BodyVelocity") bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5) bodyVelocity.Velocity = Vector3.new(0,0,0) bodyVelocity.Parent = root end RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Input.Value, function() local move = Vector3.zero if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Vector3.new(0,0,-1) end if UserInputService:IsKeyDown(Enum.KeyCode.S) then move += Vector3.new(0,0,1) end if UserInputService:IsKeyDown(Enum.KeyCode.A) then move += Vector3.new(-1,0,0) end if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Vector3.new(1,0,0) end if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end bodyVelocity.Velocity = (char.HumanoidRootPart.CFrame:VectorToWorldSpace(move)) * 50 end) end

local function disableFly() RunService:UnbindFromRenderStep("FlyControl") if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end end

-- BUTTON CONNECTIONS fireBtn.MouseButton1Click:Connect(function() if not canUseFire then canUseFire = true throwBtn.Visible = true flyBtn.Visible = true applyHandFX() fireBtn.Text = "Fire Power: ENABLED" end end)

throwBtn.MouseButton1Click:Connect(throwFireball)

flyBtn.MouseButton1Click:Connect(function() isFlying = not isFlying if isFlying then enableFly() flyBtn.Text = "Flying: ON" else disableFly() flyBtn.Text = "Flying: OFF" end end)

