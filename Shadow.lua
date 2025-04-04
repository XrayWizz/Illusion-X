-- MOBILE FIREBALL & FLY SYSTEM - FINAL CLEAN VERSION -- Place this LocalScript into StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local Debris = game:GetService("Debris")

local player = Players.LocalPlayer repeat wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart") local character = player.Character local humanoidRootPart = character:WaitForChild("HumanoidRootPart") local playerGui = player:WaitForChild("PlayerGui")

-- UI SETUP local gui = Instance.new("ScreenGui") gui.Name = "ShadedShadowUI" gui.ResetOnSpawn = false gui.Parent = playerGui

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 250, 0, 180) frame.Position = UDim2.new(0, 20, 0.5, -90) frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) frame.BackgroundTransparency = 0.1 frame.Parent = gui Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel") title.Text = "Shaded Shadow" title.Size = UDim2.new(1, -20, 0, 40) title.Position = UDim2.new(0, 10, 0, 10) title.BackgroundTransparency = 1 title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.GothamBold title.TextSize = 22 title.TextXAlignment = Enum.TextXAlignment.Left title.Parent = frame

local function makeButton(name, text, pos) local btn = Instance.new("TextButton") btn.Name = name btn.Size = UDim2.new(0.8, 0, 0, 40) btn.Position = pos btn.Text = text btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.GothamBold btn.TextSize = 18 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12) btn.Parent = frame return btn end

local fireBtn = makeButton("FireBtn", "Enable Fire", UDim2.new(0.1, 0, 0.4, 0)) local throwBtn = makeButton("ThrowBtn", "Throw Fireball", UDim2.new(0.1, 0, 0.65, 0)) local flyBtn = makeButton("FlyBtn", "Toggle Fly", UDim2.new(0.1, 0, 0.88, 0)) throwBtn.Visible = false flyBtn.Visible = false

-- FX HELPERS local function twirlingFlames(att) local p = Instance.new("ParticleEmitter", att) p.Texture = "rbxassetid://4844380622" p.Lifetime = NumberRange.new(0.4, 0.7) p.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)}) p.Speed = NumberRange.new(2, 4) p.Rotation = NumberRange.new(0, 360) p.RotSpeed = NumberRange.new(80, 120) p.Rate = 120 p.Color = ColorSequence.new(Color3.new(1, 0.6, 0), Color3.new(1, 1, 0)) end

local function darkSmoke(att) local s = Instance.new("ParticleEmitter", att) s.Texture = "rbxassetid://771221224" s.Lifetime = NumberRange.new(0.6, 1.2) s.Size = NumberSequence.new(0.6) s.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1)}) s.Speed = NumberRange.new(0.3, 1) s.Rate = 30 s.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30)) end

local function attachHandFX() for _, limb in {"LeftHand", "RightHand"} do local part = character:FindFirstChild(limb) if part then local a = Instance.new("Attachment", part) twirlingFlames(a) darkSmoke(a) end end end

-- FIREBALL THROW local function throwFireball() local head = character:FindFirstChild("Head") if not head then return end

local ball = Instance.new("Part")
ball.Shape = Enum.PartType.Ball
ball.Size = Vector3.new(0.6, 0.6, 0.6)
ball.Material = Enum.Material.Neon
ball.BrickColor = BrickColor.new("Bright orange")
ball.CFrame = head.CFrame * CFrame.new(0, 0, -2)
ball.Velocity = head.CFrame.LookVector * 100
ball.CanCollide = false
ball.Parent = workspace

local a = Instance.new("Attachment", ball)
twirlingFlames(a)
darkSmoke(a)

local sound = Instance.new("Sound", ball)
sound.SoundId = "rbxassetid://1840882422"
sound.Volume = 0.6
sound:Play()

Debris:AddItem(ball, 3)

end

-- FLYING SYSTEM local flying = false local bv = nil

local function toggleFly(on) if on then bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(1e5,1e5,1e5) bv.Velocity = Vector3.zero bv.Parent = humanoidRootPart

RunService:BindToRenderStep("MobileFly", Enum.RenderPriority.Input.Value, function()
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Vector3.new(0,0,-1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir += Vector3.new(0,0,1) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		bv.Velocity = (humanoidRootPart.CFrame:VectorToWorldSpace(dir)).Unit * 50
	end)
else
	RunService:UnbindFromRenderStep("MobileFly")
	if bv then bv:Destroy() bv = nil end
end

end

-- BUTTON LOGIC local fireOn = false fireBtn.MouseButton1Click:Connect(function() if not fireOn then fireOn = true attachHandFX() fireBtn.Text = "Fire: ENABLED" throwBtn.Visible = true flyBtn.Visible = true end end)

throwBtn.MouseButton1Click:Connect(throwFireball)

flyBtn.MouseButton1Click:Connect(function() flying = not flying toggleFly(flying) flyBtn.Text = flying and "Flying: ON" or "Flying: OFF" end)

