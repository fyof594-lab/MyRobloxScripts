-- ============================================
-- ⚽ BLUE LOCK RIVALS SCRIPT ⚽
-- نسخة تخريبية + أوامر قوية
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🎨 إنشاء الواجهة الرئيسية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLockGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (Glassmorphism)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- زوايا مدورة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

-- إطار متوهج
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 50, 100)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

-- ============================================
-- 📌 شريط العنوان
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 BLUE LOCK DESTROYER"
Title.TextColor3 = Color3.fromRGB(255, 50, 100)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

local isVisible = true
CloseBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    MainFrame.Visible = isVisible
    CloseBtn.Text = isVisible and "✕" or "⊕"
end)

-- خط فاصل
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 2)
Line.Position = UDim2.new(0.05, 0, 0, 55)
Line.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📜 إطار التمرير
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
ScrollFrame.Position = UDim2.new(0, 10, 0, 60)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)

-- ============================================
-- 💀 أوامر تخريبية قوية
-- ============================================

-- متغيرات لتخزين الحالات
local freezeConnections = {}
local flyConnections = {}
local sinkConnections = {}

-- دالة الإشعارات
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 350, 0, 45)
    notif.Position = UDim2.new(0.5, -175, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 50, 100)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 3)
end

-- 1️⃣ تجميد جميع اللاعبين
local function freezeAllPlayers()
    local isFrozen = false
    
    return function()
        isFrozen = not isFrozen
        
        if isFrozen then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local char = plr.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local h = char.Humanoid
                        h.WalkSpeed = 0
                        h.JumpPower = 0
                        h.PlatformStand = true
                        
                        -- تجميد الجسم بالكامل
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Anchored = true
                            end
                        end
                    end
                end
            end
            showNotification("❄️ تم تجميد جميع اللاعبين!", Color3.fromRGB(100, 200, 255))
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local char = plr.Character
                    if char and char:FindFirstChild("Humanoid") then
                        local h = char.Humanoid
                        h.WalkSpeed = 16
                        h.JumpPower = 50
                        h.PlatformStand = false
                        
                        for _, part in pairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Anchored = false
                            end
                        end
                    end
                end
            end
            showNotification("✅ تم إلغاء التجميد!", Color3.fromRGB(0, 200, 100))
        end
    end
end

-- 2️⃣ إغراق اللاعبين تحت الأرض
local function sinkPlayers()
    local isSinking = false
    local sinkConnection = nil
    
    return function()
        isSinking = not isSinking
        
        if isSinking then
            sinkConnection = RunService.Heartbeat:Connect(function()
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = root.CFrame + Vector3.new(0, -0.5, 0)
                        end
                    end
                end
            end)
            showNotification("⬇️ يتم إغراق اللاعبين تحت الأرض!", Color3.fromRGB(255, 150, 0))
        else
            if sinkConnection then
                sinkConnection:Disconnect()
                sinkConnection = nil
            end
            showNotification("✅ تم إيقاف الإغراق!", Color3.fromRGB(0, 200, 100))
        end
    end
end

-- 3️⃣ طيران جميع اللاعبين
local function flyAllPlayers()
    local isFlying = false
    local flyData = {}
    
    return function()
        isFlying = not isFlying
        
        if isFlying then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local bv = Instance.new("BodyVelocity")
                        bv.Velocity = Vector3.new(0, 100, 0)
                        bv.MaxForce = Vector3.new(0, 4000, 0)
                        bv.Parent = root
                        table.insert(flyData, bv)
                    end
                end
            end
            showNotification("🚀 تم إطلاق جميع اللاعبين في الهواء!", Color3.fromRGB(0, 150, 255))
        else
            for _, bv in pairs(flyData) do
                if bv and bv.Parent then bv:Destroy() end
            end
            flyData = {}
            showNotification("✅ تم إيقاف الطيران!", Color3.fromRGB(0, 200, 100))
        end
    end
end

-- 4️⃣ تفجير جميع اللاعبين
local function explodeAllPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local exp = Instance.new("Explosion")
                exp.Position = root.Position
                exp.BlastRadius = 20
                exp.BlastPressure = 1000
                exp.Parent = workspace
            end
        end
    end
    showNotification("💥 تم تفجير جميع اللاعبين!", Color3.fromRGB(255, 100, 0))
end

-- 5️⃣ سحب جميع اللاعبين إليك
local function pullAllPlayers()
    local isPulling = false
    local pullConnection = nil
    
    return function()
        isPulling = not isPulling
        
        if isPulling then
            pullConnection = RunService.Heartbeat:Connect(function()
                local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local direction = (myRoot.Position - root.Position).Unit * 10
                            root.CFrame = root.CFrame + direction
                        end
                    end
                end
            end)
            showNotification("🔄 يتم سحب جميع اللاعبين إليك!", Color3.fromRGB(200, 100, 255))
        else
            if pullConnection then
                pullConnection:Disconnect()
                pullConnection = nil
            end
            showNotification("✅ تم إيقاف السحب!", Color3.fromRGB(0, 200, 100))
        end
    end
end

-- 6️⃣ شل حركة الخصم (نوب)
local function noobEnemy()
    local isNoob = false
    local noobConnection = nil
    
    return function()
        isNoob = not isNoob
        
        if isNoob then
            noobConnection = RunService.Heartbeat:Connect(function()
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
                        if h then
                            h.WalkSpeed = 5
                            h.JumpPower = 0
                            h.PlatformStand = true
                        end
                    end
                end
            end)
            showNotification("🤡 تم تحويل الخصوم إلى نوب!", Color3.fromRGB(255, 200, 0))
        else
            if noobConnection then
                noobConnection:Disconnect()
                noobConnection = nil
            end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
                    if h then
                        h.WalkSpeed = 16
                        h.JumpPower = 50
                        h.PlatformStand = false
                    end
                end
            end
            showNotification("✅ تم إلغاء النوب!", Color3.fromRGB(0, 200, 100))
        end
    end
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "❄️ تجميد الكل", Color = Color3.fromRGB(100, 200, 255), Callback = freezeAllPlayers()},
    {Text = "⬇️ إغراق الكل", Color = Color3.fromRGB(255, 150, 0), Callback = sinkPlayers()},
    {Text = "🚀 طيران الكل", Color = Color3.fromRGB(0, 150, 255), Callback = flyAllPlayers()},
    {Text = "💥 تفجير الكل", Color = Color3.fromRGB(255, 100, 0), Callback = explodeAllPlayers},
    {Text = "🔄 سحب الكل", Color = Color3.fromRGB(200, 100, 255), Callback = pullAllPlayers()},
    {Text = "🤡 نوب الخصوم", Color = Color3.fromRGB(255, 200, 0), Callback = noobEnemy()},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 55
local spacing = 8
local canvasHeight = #Commands * (buttonHeight + spacing) + 20

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollFrame
    Button.Size = UDim2.new(1, 0, 0, buttonHeight)
    Button.Position = UDim2.new(0, 0, 0, 5 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = cmdData.Color or Color3.fromRGB(40, 40, 70)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.2
    end)
    
    Button.MouseButton1Click:Connect(cmdData.Callback)
end

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
        CloseBtn.Text = isVisible and "✕" or "⊕"
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 Blue Lock Destroyer Script Loaded!")
print("📌 Press F1 to toggle GUI")
showNotification("🔥 تم تحميل سكربت التخريب!", Color3.fromRGB(255, 50, 100))
