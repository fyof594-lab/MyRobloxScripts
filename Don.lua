-- ============================================
-- 💀 BLR DESTROYER SCRIPT 💀
-- قتل + تجميد + طيران + نوكليب + اختفاء
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- 🔍 Remote للتخريب
-- ============================================
local KillRemote = nil
for _, child in pairs(ReplicatedStorage:GetChildren()) do
    if child:IsA("RemoteEvent") and (child.Name:lower():find("kill") or child.Name:lower():find("damage") or child.Name:lower():find("health")) then
        KillRemote = child
        break
    end
end

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DestroyerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -175)
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
Stroke.Color = Color3.fromRGB(255, 0, 0)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -45, 0, 35)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 DESTROYER"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
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
            Size = UDim2.new(0, 220, 0, 350),
            Position = UDim2.new(0.5, -110, 0.5, -175),
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

-- خط فاصل
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 1.5)
Line.Position = UDim2.new(0.05, 0, 0, 38)
Line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 44)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)

function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 0, 0)
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
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {kill = false, freeze = false, fly = false, noclip = false, invisible = false}
local connections = {}

-- ============================================
-- 💀 1️⃣ قتل الكل (حقيقي)
-- ============================================
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local char = plr.Character
            if char then
                local h = char:FindFirstChild("Humanoid")
                if h then
                    -- الطريقة 1: خفض الصحة
                    h.Health = 0
                    -- الطريقة 2: عن طريق Remote
                    if KillRemote then
                        pcall(function()
                            KillRemote:FireServer(plr)
                            KillRemote:FireServer("Kill", plr)
                            KillRemote:FireServer(plr, "Die")
                        end)
                    end
                    -- الطريقة 3: تفجير
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local exp = Instance.new("Explosion")
                        exp.Position = root.Position
                        exp.BlastRadius = 10
                        exp.BlastPressure = 1000
                        exp.Parent = workspace
                        game:GetService("Debris"):AddItem(exp, 0.5)
                    end
                end
            end
        end
    end
    showNotification("💀 تم قتل جميع اللاعبين!", Color3.fromRGB(255, 0, 0))
end

-- ============================================
-- ❄️ 2️⃣ تجميد الكل (حقيقي)
-- ============================================
local function toggleFreeze()
    states.freeze = not states.freeze
    if states.freeze then
        connections.freeze = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local char = plr.Character
                    if char then
                        local h = char:FindFirstChild("Humanoid")
                        if h then
                            h.WalkSpeed = 0
                            h.JumpPower = 0
                            h.PlatformStand = true
                        end
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Anchored = true
                            end
                        end
                    end
                end
            end
        end)
        showNotification("❄️ تم تجميد جميع اللاعبين!", Color3.fromRGB(100, 200, 255))
    else
        if connections.freeze then
            connections.freeze:Disconnect()
            connections.freeze = nil
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local char = plr.Character
                if char then
                    local h = char:FindFirstChild("Humanoid")
                    if h then
                        h.WalkSpeed = 16
                        h.JumpPower = 50
                        h.PlatformStand = false
                    end
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                        end
                    end
                end
            end
        end
        showNotification("✅ تم إلغاء التجميد", Color3.fromRGB(0, 200, 100))
    end
end

-- ============================================
-- 🚀 3️⃣ الطيران (يتحرك مع الأنالونغ)
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
        showNotification("🚀 تم تفعيل الطيران!", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ تم إيقاف الطيران", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🧱 4️⃣ اختراق الجدران (Noclip)
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
        showNotification("🧱 تم تفعيل اختراق الجدران!", Color3.fromRGB(150, 100, 255))
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
        showNotification("⏹ تم إيقاف اختراق الجدران", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 👻 5️⃣ اختفاء (Invisible)
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
        -- تأثير إضافي للإخفاء التام
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 0
            char.Humanoid.NameDisplayDistance = 0
        end)
        showNotification("👻 تم التخفي!", Color3.fromRGB(200, 100, 255))
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
        showNotification("👁️ تم إلغاء التخفي", Color3.fromRGB(255, 200, 0))
    end
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

addButton("💀 قتل الكل", killAll, Color3.fromRGB(255, 0, 0))
addButton("❄️ تجميد الكل", toggleFreeze, Color3.fromRGB(100, 200, 255))
addButton("🚀 طيران", toggleFly, Color3.fromRGB(0, 150, 255))
addButton("🧱 اختراق الجدران", toggleNoclip, Color3.fromRGB(150, 100, 255))
addButton("👻 اختفاء", toggleInvisible, Color3.fromRGB(200, 100, 255))
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
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local char = plr.Character
            if char then
                local h = char:FindFirstChild("Humanoid")
                if h then
                    h.WalkSpeed = 16
                    h.JumpPower = 50
                    h.PlatformStand = false
                end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end
        end
    end
    showNotification("⏹ تم إيقاف جميع الميزات!", Color3.fromRGB(255, 200, 0))
end, Color3.fromRGB(200, 50, 50))

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    if input.KeyCode == Enum.KeyCode.G then
        toggleFreeze()
    end
    if input.KeyCode == Enum.KeyCode.H then
        toggleFly()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 BLR Destroyer Script Loaded!")
print("📌 F1 = Toggle GUI")
print("📌 G = Freeze All")
print("📌 H = Fly")
showNotification("💀 BLR Destroyer جاهز للتخريب!", Color3.fromRGB(255, 0, 0))
