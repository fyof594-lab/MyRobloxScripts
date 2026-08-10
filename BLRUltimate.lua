-- ============================================
-- 💀 BLUE LOCK ULTIMATE SCRIPT 💀
-- No Cooldown | Speed | Auto Dribble | Hitbox
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- 🔧 إعدادات
-- ============================================
local Settings = {
    HitboxSize = 20,
    SpeedAmount = 120,
    DribbleSpeed = 50,
}

-- ============================================
-- 🔍 العثور على الكرة
-- ============================================
local function findBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("BasePart") and child.Name:lower():find("ball") then
            return child
        end
    end
    return nil
end

-- ============================================
-- 🎨 الواجهة الرئيسية (مقسّمة لأقسام)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BLRUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 260, 0, 450)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 50, 50)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.3

-- العنوان
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -45, 0, 35)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 BLR ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 3)
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
            Size = UDim2.new(0, 260, 0, 450),
            Position = UDim2.new(0.5, -130, 0.5, -225),
            BackgroundTransparency = 0.1
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -36, 0, 3)
        Title.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end
CloseBtn.MouseButton1Click:Connect(toggleMinimize)

-- الخط الفاصل تحت العنوان
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 1.5)
Line.Position = UDim2.new(0.05, 0, 0, 38)
Line.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📜 إطار التمرير الرئيسي
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 44)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)

-- ============================================
-- 📦 دوال إنشاء الأقسام
-- ============================================
local yOffset = 0
local sectionSpacing = 15

function createSection(title, color)
    local section = Instance.new("Frame")
    section.Parent = ScrollFrame
    section.Size = UDim2.new(1, 0, 0, 0)
    section.Position = UDim2.new(0, 0, 0, yOffset)
    section.BackgroundTransparency = 1
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Parent = section
    sectionTitle.Size = UDim2.new(1, -10, 0, 25)
    sectionTitle.Position = UDim2.new(0, 5, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = color or Color3.fromRGB(255, 200, 0)
    sectionTitle.TextScaled = true
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local sectionLine = Instance.new("Frame")
    sectionLine.Parent = section
    sectionLine.Size = UDim2.new(0.95, 0, 0, 1.5)
    sectionLine.Position = UDim2.new(0.025, 0, 0, 28)
    sectionLine.BackgroundColor3 = color or Color3.fromRGB(255, 200, 0)
    sectionLine.BackgroundTransparency = 0.5
    sectionLine.BorderSizePixel = 0
    
    local btnContainer = Instance.new("Frame")
    btnContainer.Parent = section
    btnContainer.Size = UDim2.new(1, 0, 0, 0)
    btnContainer.Position = UDim2.new(0, 0, 0, 32)
    btnContainer.BackgroundTransparency = 1
    
    yOffset = yOffset + 10
    return section, btnContainer, sectionTitle
end

function addButton(container, text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = container
    btn.Size = UDim2.new(0.46, 0, 0, 35)
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
    return btn
end

function finishSection(container, count)
    local rows = math.ceil(count / 2)
    local height = rows * 40 + 5
    container.Size = UDim2.new(1, 0, 0, height)
    local section = container.Parent
    section.Size = UDim2.new(1, 0, 0, height + 35)
    
    -- ترتيب الأزرار في شبكة
    local children = {}
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(children, child)
        end
    end
    for i, btn in ipairs(children) do
        local row = math.floor((i-1) / 2)
        local col = (i-1) % 2
        btn.Position = UDim2.new(0.02 + col * 0.5, 0, 0, 3 + row * 40)
        btn.Size = UDim2.new(0.45, 0, 0, 35)
    end
    
    yOffset = yOffset + height + 40 + sectionSpacing
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)
end

-- ============================================
-- 🎯 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 50, 50)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- ⚙️ الميزات (متغيرات الحالة)
-- ============================================
local states = {
    noCD = false,
    speed = false,
    iframe = false,
    autoDribble = false,
    hitbox = false,
}
local connections = {}

-- ============================================
-- 🔥 1️⃣ No Cooldown
-- ============================================
function toggleNoCD()
    states.noCD = not states.noCD
    if states.noCD then
        -- طريقة No Cooldown من سكريبتات معروفة [citation:10]
        pcall(function()
            local C = require(game:GetService("ReplicatedStorage").Controllers.AbilityController)
            local o = C.AbilityCooldown
            C.AbilityCooldown = function(s, n, ...)
                return o(s, n, 0, ...)
            end
        end)
        showNotification("❄️ No Cooldown ON!", Color3.fromRGB(100, 200, 255))
    else
        showNotification("❄️ No Cooldown OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 2️⃣ Speed Hack
-- ============================================
function toggleSpeed()
    states.speed = not states.speed
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end
    
    if states.speed then
        h.WalkSpeed = Settings.SpeedAmount
        showNotification("⚡ Speed ON! (" .. Settings.SpeedAmount .. ")", Color3.fromRGB(0, 200, 255))
    else
        h.WalkSpeed = 16
        showNotification("⚡ Speed OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 3️⃣ Iframe (حماية من التصدي)
-- ============================================
function toggleIframe()
    states.iframe = not states.iframe
    if states.iframe then
        connections.iframe = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Transparency = 0.5
                end
            end
        end)
        showNotification("🛡️ Iframe ON!", Color3.fromRGB(200, 100, 255))
    else
        if connections.iframe then
            connections.iframe:Disconnect()
            connections.iframe = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
        showNotification("🛡️ Iframe OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 4️⃣ Auto Dribble
-- ============================================
function toggleAutoDribble()
    states.autoDribble = not states.autoDribble
    if states.autoDribble then
        connections.dribble = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if not char then return end
            local h = char:FindFirstChild("Humanoid")
            if not h then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            -- حركة مراوغة تلقائية [citation:11]
            if h.MoveDirection.Magnitude > 0 then
                local dir = h.MoveDirection
                root.CFrame = root.CFrame * CFrame.Angles(0, 0.02, 0)
                root.Velocity = dir * Settings.DribbleSpeed
            end
        end)
        showNotification("🚀 Auto Dribble ON!", Color3.fromRGB(0, 255, 200))
    else
        if connections.dribble then
            connections.dribble:Disconnect()
            connections.dribble = nil
        end
        showNotification("🚀 Auto Dribble OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 5️⃣ Hitbox Expander (20)
-- ============================================
function toggleHitbox()
    states.hitbox = not states.hitbox
    if states.hitbox then
        connections.hitbox = RunService.Heartbeat:Connect(function()
            local ball = findBall()
            if ball then
                -- تكبير الهيت بوكس للكرة [citation:3][citation:5]
                ball.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                ball.Transparency = 0.3
                ball.BrickColor = BrickColor.new("Bright red")
                
                -- تأثير بصري
                local glow = Instance.new("PointLight")
                glow.Color = Color3.fromRGB(255, 0, 0)
                glow.Range = Settings.HitboxSize * 2
                glow.Brightness = 3
                glow.Parent = ball
                game:GetService("Debris"):AddItem(glow, 0.1)
            end
        end)
        showNotification("🎯 Hitbox " .. Settings.HitboxSize .. " ON!", Color3.fromRGB(255, 200, 0))
    else
        if connections.hitbox then
            connections.hitbox:Disconnect()
            connections.hitbox = nil
        end
        local ball = findBall()
        if ball then
            ball.Size = Vector3.new(2, 2, 2)
            ball.Transparency = 0
        end
        showNotification("🎯 Hitbox OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 📋 إنشاء الأقسام والأزرار
-- ============================================

-- القسم 1: No Cooldown + Speed
local sec1, cont1 = createSection("⚡ القسم 1: No CD + Speed", Color3.fromRGB(100, 200, 255))
addButton(cont1, "❄️ No Cooldown", toggleNoCD, Color3.fromRGB(0, 150, 255))
addButton(cont1, "⚡ Speed Hack", toggleSpeed, Color3.fromRGB(255, 100, 255))
finishSection(cont1, 2)

-- القسم 2: Iframe + Auto Dribble
local sec2, cont2 = createSection("🛡️ القسم 2: Iframe + Dribble", Color3.fromRGB(200, 100, 255))
addButton(cont2, "🛡️ Iframe", toggleIframe, Color3.fromRGB(200, 100, 255))
addButton(cont2, "🚀 Auto Dribble", toggleAutoDribble, Color3.fromRGB(0, 255, 200))
finishSection(cont2, 2)

-- القسم 3: Hitbox + زر إضافي
local sec3, cont3 = createSection("🎯 القسم 3: Hitbox", Color3.fromRGB(255, 200, 0))
addButton(cont3, "🎯 Hitbox 20", toggleHitbox, Color3.fromRGB(255, 150, 50))
addButton(cont3, "🔄 إيقاف الكل", function()
    for name, conn in pairs(connections) do
        if conn then
            conn:Disconnect()
            connections[name] = nil
        end
    end
    for key in pairs(states) do
        states[key] = false
    end
    showNotification("⏹ تم إيقاف جميع الميزات!", Color3.fromRGB(255, 200, 0))
end, Color3.fromRGB(255, 50, 50))
finishSection(cont3, 2)

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    if input.KeyCode == Enum.KeyCode.G then
        toggleHitbox()
    end
    if input.KeyCode == Enum.KeyCode.H then
        toggleNoCD()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 BLR Ultimate Script Loaded!")
print("📌 F1 = Toggle GUI")
print("📌 G = Hitbox")
print("📌 H = No Cooldown")
showNotification("💀 BLR Ultimate جاهز!", Color3.fromRGB(255, 50, 50))
