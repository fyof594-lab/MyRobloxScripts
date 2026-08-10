-- ============================================
-- 💀 BLR MOBILITY (عصري 2026) 💀
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Mouse = Player:GetMouse()

-- ============================================
-- 🎨 الواجهة الزجاجية الفخمة (عصري 2026)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobilityGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (مستطيل صغير)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 520, 0, 170)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- زوايا مدورة ناعمة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

-- تأثير الزجاج (Glassmorphism)
local Blur = Instance.new("BlurEffect")
Blur.Parent = game.Lighting
Blur.Size = 18

-- إطار متوهج (Neon Stroke)
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(100, 150, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3

-- ============================================
-- 📌 شريط عنوان فخم
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 20)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 MOBILITY • 2026"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر X دائري أنيق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- ============================================
-- 🔄 تصغير القائمة لدائرة
-- ============================================
local isMinimized = false
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 55, 0, 55),
            Position = UDim2.new(0, 10, 0.5, -27),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        CloseBtn.Size = UDim2.new(0, 45, 0, 45)
        CloseBtn.Position = UDim2.new(0, 5, 0, 5)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar and child ~= CloseBtn then
                child.Visible = false
            end
        end
        Title.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 520, 0, 170),
            Position = UDim2.new(0.5, -260, 0.5, -85),
            BackgroundTransparency = 0.2
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 32, 0, 32)
        CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        Title.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end
CloseBtn.MouseButton1Click:Connect(toggleMinimize)

-- خط فاصل أنيق
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 1.5)
Line.Position = UDim2.new(0.05, 0, 0, 42)
Line.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📦 حاوية الأزرار (أفقية)
-- ============================================
local container = Instance.new("Frame")
container.Parent = MainFrame
container.Size = UDim2.new(1, -10, 0, 110)
container.Position = UDim2.new(0, 5, 0, 48)
container.BackgroundTransparency = 1

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {fly = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120

function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 320, 0, 40)
    notif.Position = UDim2.new(0.5, -160, 0.05, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- 🚀 الطيران
-- ============================================
local function toggleFly()
    states.fly = not states.fly
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly then
        h.PlatformStand = true
        connections.fly = RunService.Heartbeat:Connect(function()
            if not states.fly then return end
            local move = h.MoveDirection
            if move.Magnitude > 0 then
                root.Velocity = move * 80 + Vector3.new(0, 10, 0)
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        showNotification("🚀 الطيران ON", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ الطيران OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🧱 نوكليب
-- ============================================
local function toggleNoclip()
    states.noclip = not states.noclip
    if states.noclip then
        connections.noclip = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        showNotification("🧱 نوكليب ON", Color3.fromRGB(150, 100, 255))
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        showNotification("⏹ نوكليب OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 👻 اختفاء
-- ============================================
local function toggleInvisible()
    states.invisible = not states.invisible
    local char = Player.Character
    if not char then return end

    if states.invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 0
            char.Humanoid.NameDisplayDistance = 0
        end)
        showNotification("👻 اختفاء ON", Color3.fromRGB(200, 100, 255))
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 50
            char.Humanoid.NameDisplayDistance = 50
        end)
        showNotification("👁️ اختفاء OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- ⚡ السرعة
-- ============================================
local function toggleSpeed()
    states.speed = not states.speed
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        showNotification("⚡ سرعة " .. speedAmount, Color3.fromRGB(0, 255, 200))
    else
        h.WalkSpeed = 16
        showNotification("⏹ سرعة OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function increaseSpeed()
    speedAmount = speedAmount + 10
    if speedAmount > 500 then speedAmount = 500 end
    if states.speed then
        local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = speedAmount end
    end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

local function decreaseSpeed()
    speedAmount = speedAmount - 10
    if speedAmount < 20 then speedAmount = 20 end
    if states.speed then
        local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = speedAmount end
    end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

-- ============================================
-- 🌐 تيليبورت للاعبين (قائمة منبثقة)
-- ============================================
local TeleportFrame = nil

local function showTeleportMenu()
    if TeleportFrame and TeleportFrame.Visible then
        TeleportFrame.Visible = false
        return
    end
    
    if not TeleportFrame then
        TeleportFrame = Instance.new("Frame")
        TeleportFrame.Parent = MainFrame
        TeleportFrame.Size = UDim2.new(0.9, 0, 0, 120)
        TeleportFrame.Position = UDim2.new(0.05, 0, 0, 45)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TeleportFrame.BackgroundTransparency = 0.3
        TeleportFrame.BorderSizePixel = 0
        TeleportFrame.ClipsDescendants = true
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 12)
        TCorner.Parent = TeleportFrame
        
        local TScroll = Instance.new("ScrollingFrame")
        TScroll.Parent = TeleportFrame
        TScroll.Size = UDim2.new(1, -10, 1, -10)
        TScroll.Position = UDim2.new(0, 5, 0, 5)
        TScroll.BackgroundTransparency = 1
        TScroll.BorderSizePixel = 0
        TScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        TScroll.ScrollBarThickness = 3
        TScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
        
        local yOff = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local btn = Instance.new("TextButton")
                btn.Parent = TScroll
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.Position = UDim2.new(0, 0, 0, yOff)
                btn.Text = "🌐 " .. plr.Name
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextScaled = true
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseEnter:Connect(function()
                    btn.BackgroundTransparency = 0
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundTransparency = 0.3
                end)
                
                btn.MouseButton1Click:Connect(function()
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                            showNotification("✅ تم التليفورت إلى " .. plr.Name, Color3.fromRGB(0, 200, 100))
                        end
                    else
                        showNotification("❌ اللاعب غير موجود!", Color3.fromRGB(255, 0, 0))
                    end
                    TeleportFrame.Visible = false
                end)
                yOff = yOff + 33
            end
        end
        TScroll.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)
        
        local closeT = Instance.new("TextButton")
        closeT.Parent = TeleportFrame
        closeT.Size = UDim2.new(0, 28, 0, 28)
        closeT.Position = UDim2.new(1, -34, 0, 2)
        closeT.Text = "✕"
        closeT.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeT.TextScaled = true
        closeT.Font = Enum.Font.GothamBold
        closeT.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        closeT.BackgroundTransparency = 0.3
        closeT.BorderSizePixel = 0
        
        local closeTCorner = Instance.new("UICorner")
        closeTCorner.CornerRadius = UDim.new(1, 0)
        closeTCorner.Parent = closeT
        
        closeT.MouseButton1Click:Connect(function()
            TeleportFrame.Visible = false
        end)
    end
    
    TeleportFrame.Visible = true
end

-- ============================================
-- 🗺️ تيليبورت للخريطة
-- ============================================
local MapFrame = nil

local function showMapTeleport()
    if MapFrame and MapFrame.Visible then
        MapFrame.Visible = false
        return
    end
    
    if not MapFrame then
        MapFrame = Instance.new("Frame")
        MapFrame.Parent = MainFrame
        MapFrame.Size = UDim2.new(0.9, 0, 0, 120)
        MapFrame.Position = UDim2.new(0.05, 0, 0, 45)
        MapFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MapFrame.BackgroundTransparency = 0.3
        MapFrame.BorderSizePixel = 0
        MapFrame.ClipsDescendants = true
        
        local MCorner = Instance.new("UICorner")
        MCorner.CornerRadius = UDim.new(0, 12)
        MCorner.Parent = MapFrame
        
        -- خريطة مبسطة
        local MapImage = Instance.new("ImageLabel")
        MapImage.Parent = MapFrame
        MapImage.Size = UDim2.new(1, -10, 1, -10)
        MapImage.Position = UDim2.new(0, 5, 0, 5)
        MapImage.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        MapImage.BackgroundTransparency = 0.3
        MapImage.Image = "rbxassetid://" 
        
        local MCorner2 = Instance.new("UICorner")
        MCorner2.CornerRadius = UDim.new(0, 8)
        MCorner2.Parent = MapImage
        
        -- زر إغلاق
        local closeMap = Instance.new("TextButton")
        closeMap.Parent = MapFrame
        closeMap.Size = UDim2.new(0, 28, 0, 28)
        closeMap.Position = UDim2.new(1, -34, 0, 2)
        closeMap.Text = "✕"
        closeMap.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeMap.TextScaled = true
        closeMap.Font = Enum.Font.GothamBold
        closeMap.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        closeMap.BackgroundTransparency = 0.3
        closeMap.BorderSizePixel = 0
        
        local closeMapCorner = Instance.new("UICorner")
        closeMapCorner.CornerRadius = UDim.new(1, 0)
        closeMapCorner.Parent = closeMap
        
        closeMap.MouseButton1Click:Connect(function()
            MapFrame.Visible = false
        end)
        
        -- الضغط على الخريطة
        MapImage.MouseButton1Click:Connect(function(x, y)
            local absSize = MapImage.AbsoluteSize
            local absPos = MapImage.AbsolutePosition
            
            local relX = (x - absPos.X) / absSize.X
            local relY = (y - absPos.Y) / absSize.Y
            
            local worldSize = 200
            local targetPos = Vector3.new((relX - 0.5) * worldSize, 5, (relY - 0.5) * worldSize)
            
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(targetPos)
                showNotification("✅ تم التليفورت!", Color3.fromRGB(0, 200, 100))
                MapFrame.Visible = false
            end
        end)
    end
    
    MapFrame.Visible = true
end

-- ============================================
-- 📋 الأزرار (مصفوفة بشكل مستطيل أنيق)
-- ============================================
local buttons = {
    {Text = "🚀 طيران", Callback = toggleFly, Color = Color3.fromRGB(0, 150, 255)},
    {Text = "🧱 نوكليب", Callback = toggleNoclip, Color = Color3.fromRGB(150, 100, 255)},
    {Text = "👻 اختفاء", Callback = toggleInvisible, Color = Color3.fromRGB(200, 100, 255)},
    {Text = "⚡ سرعة", Callback = toggleSpeed, Color = Color3.fromRGB(0, 255, 200)},
    {Text = "⬆️ +10", Callback = increaseSpeed, Color = Color3.fromRGB(50, 200, 100)},
    {Text = "⬇️ -10", Callback = decreaseSpeed, Color = Color3.fromRGB(200, 150, 50)},
    {Text = "🌐 لاعب", Callback = showTeleportMenu, Color = Color3.fromRGB(100, 150, 255)},
    {Text = "🗺️ خريطة", Callback = showMapTeleport, Color = Color3.fromRGB(255, 200, 50)},
    {Text = "🔄 إيقاف", Callback = function()
        for _, conn in pairs(connections) do
            if conn then
                conn:Disconnect()
            end
        end
        connections = {}
        for key in pairs(states) do
            states[key] = false
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
                if part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = 0
                end
            end
            local h = char:FindFirstChild("Humanoid")
            if h then
                h.PlatformStand = false
                h.WalkSpeed = 16
                h.JumpPower = 50
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end
        if TeleportFrame then
            TeleportFrame.Visible = false
        end
        if MapFrame then
            MapFrame.Visible = false
        end
        showNotification("⏹ تم الإيقاف", Color3.fromRGB(255, 200, 0))
    end, Color = Color3.fromRGB(200, 50, 50)},
}

-- إنشاء الأزرار (3 صفوف × 3 أعمدة)
for i, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Parent = container
    local row = math.floor((i-1) / 3)
    local col = (i-1) % 3
    btn.Size = UDim2.new(0.31, 0, 0, 32)
    btn.Position = UDim2.new(0.01 + col * 0.33, 0, 0.03 + row * 37, 0)
    btn.Text = btnData.Text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = btnData.Color or Color3.fromRGB(40, 40, 70)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- تأثير الإضاءة عند التمرير
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.3
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = btnData.Color or Color3.fromRGB(40, 40, 70)
        }):Play()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn.MouseButton1Click:Connect(btnData.Callback)
end

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    if input.KeyCode == Enum.KeyCode.H then
        toggleFly()
    end
    if input.KeyCode == Enum.KeyCode.G then
        toggleNoclip()
    end
    if input.KeyCode == Enum.KeyCode.V then
        toggleInvisible()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 BLR Mobility 2026 Loaded!")
print("📌 F1 = Toggle GUI")
print("📌 H = Fly")
print("📌 G = Noclip")
print("📌 V = Invisible")
showNotification("💀 MOBILITY 2026 جاهزة!", Color3.fromRGB(100, 150, 255))
