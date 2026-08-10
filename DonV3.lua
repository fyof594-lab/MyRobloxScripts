-- ============================================
-- 💀 BLR ULTIMATE MOBILITY 💀
-- طيران + سرعة + تيليبورت + نوكليب + اختفاء
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- 🎨 الواجهة الزجاجية (مستطيلة)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobilityGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Blur = Instance.new("BlurEffect")
Blur.Parent = game.Lighting
Blur.Size = 12

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 MOBILITY"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 4)
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

local isMinimized = false
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 10, 0.5, -25),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        CloseBtn.Size = UDim2.new(0, 40, 0, 40)
        CloseBtn.Position = UDim2.new(0, 5, 0, 5)
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = false
            end
        end
        Title.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 280, 0, 380),
            Position = UDim2.new(0.5, -140, 0.5, -190),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 32, 0, 32)
        CloseBtn.Position = UDim2.new(1, -38, 0, 4)
        Title.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end
CloseBtn.MouseButton1Click:Connect(toggleMinimize)

local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 1.5)
Line.Position = UDim2.new(0.05, 0, 0, 43)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -15, 1, -55)
ScrollFrame.Position = UDim2.new(0, 7, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(100, 150, 255)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2.5)
end

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {fly = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120

-- ============================================
-- 🚀 1️⃣ الطيران
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
        showNotification("🚀 الطيران ON!", Color3.fromRGB(0, 150, 255))
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
-- 🧱 2️⃣ اختراق الجدران
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
        showNotification("🧱 نوكليب ON!", Color3.fromRGB(150, 100, 255))
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
-- 👻 3️⃣ اختفاء
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
        showNotification("👻 اختفاء ON!", Color3.fromRGB(200, 100, 255))
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
-- ⚡ 4️⃣ السرعة (قابلة للتحكم)
-- ============================================
local function toggleSpeed()
    states.speed = not states.speed
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        showNotification("⚡ سرعة " .. speedAmount .. " ON!", Color3.fromRGB(0, 255, 200))
    else
        h.WalkSpeed = 16
        showNotification("⚡ سرعة OFF", Color3.fromRGB(255, 200, 0))
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
-- 🌐 5️⃣ تيليبورت للاعبين (قائمة)
-- ============================================
local TeleportFrame = nil
local TeleportList = nil

local function showTeleportMenu()
    if TeleportFrame then
        TeleportFrame.Visible = not TeleportFrame.Visible
        return
    end
    
    TeleportFrame = Instance.new("Frame")
    TeleportFrame.Parent = MainFrame
    TeleportFrame.Size = UDim2.new(0.9, 0, 0, 200)
    TeleportFrame.Position = UDim2.new(0.05, 0, 0, 55)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TeleportFrame.BackgroundTransparency = 0.2
    TeleportFrame.BorderSizePixel = 0
    TeleportFrame.ClipsDescendants = true
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 10)
    TCorner.Parent = TeleportFrame
    
    local TScroll = Instance.new("ScrollingFrame")
    TScroll.Parent = TeleportFrame
    TScroll.Size = UDim2.new(1, -10, 1, -10)
    TScroll.Position = UDim2.new(0, 5, 0, 5)
    TScroll.BackgroundTransparency = 1
    TScroll.BorderSizePixel = 0
    TScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TScroll.ScrollBarThickness = 3
    TScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local yOff = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = Instance.new("TextButton")
            btn.Parent = TScroll
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yOff)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
            btn.BackgroundTransparency = 0.2
            btn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundTransparency = 0
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundTransparency = 0.2
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
            yOff = yOff + 35
        end
    end
    TScroll.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)
    
    -- زر إغلاق القائمة
    local closeT = Instance.new("TextButton")
    closeT.Parent = TeleportFrame
    closeT.Size = UDim2.new(0, 30, 0, 30)
    closeT.Position = UDim2.new(1, -35, 0, 2)
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

-- ============================================
-- 📋 إنشاء الأزرار
-- ============================================
local yOffset = 5
local function addButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    btn.MouseButton1Click:Connect(callback)
    yOffset = yOffset + 47
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    return btn
end

addButton("🚀 طيران", toggleFly, Color3.fromRGB(0, 150, 255))
addButton("🧱 اختراق الجدران", toggleNoclip, Color3.fromRGB(150, 100, 255))
addButton("👻 اختفاء", toggleInvisible, Color3.fromRGB(200, 100, 255))
addButton("⚡ تفعيل السرعة", toggleSpeed, Color3.fromRGB(0, 255, 200))
addButton("⬆️ زيادة السرعة +10", increaseSpeed, Color3.fromRGB(50, 200, 100))
addButton("⬇️ خفض السرعة -10", decreaseSpeed, Color3.fromRGB(200, 150, 50))
addButton("🌐 تيليبورت للاعبين", showTeleportMenu, Color3.fromRGB(100, 150, 255))
addButton("🔄 إيقاف الكل", function()
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
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end, Color3.fromRGB(200, 50, 50))

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
print("💀 BLR Mobility Script Loaded!")
print("📌 F1 = Toggle GUI")
print("📌 H = Fly")
print("📌 G = Noclip")
print("📌 V = Invisible")
showNotification("💀 BLR Mobility جاهز!", Color3.fromRGB(100, 150, 255))
