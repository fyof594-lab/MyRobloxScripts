-- ============================================
-- ⚽ BALL CONTROL SCRIPT ⚽
-- تتحكم بالكرة بنفسك وتطير فيها
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🎯 إعدادات التحكم
-- ============================================
local Settings = {
    ControlSpeed = 1.5,     -- سرعة تحرك الكرة
    FollowMouse = true,     -- تتبع الفأرة
    FlyHeight = 15,         -- ارتفاع الطيران
}

-- ============================================
-- 🔍 إيجاد الكرة
-- ============================================
local Ball = nil

local function findBall()
    local ballNames = {"Ball", "ball", "Football", "SoccerBall"}
    for _, name in ipairs(ballNames) do
        local found = workspace:FindFirstChild(name)
        if found then
            return found
        end
    end
    -- البحث العميق
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Part") and child.Name:lower():find("ball") then
            return child
        end
    end
    return nil
end

Ball = findBall()

-- ============================================
-- 🎨 إنشاء الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallControlGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚽ BALL CONTROL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
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

local isVisible = true
CloseBtn.MouseButton1Click:Connect(function()
    isVisible = not isVisible
    if isVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 280),
            BackgroundTransparency = 0.2
        }):Play()
        CloseBtn.Text = "✕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = true end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 45, 0, 45),
            BackgroundTransparency = 0.4
        }):Play()
        CloseBtn.Text = "⊕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = false end
        end
    end
end)

local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.85, 0, 0, 1.5)
Line.Position = UDim2.new(0.075, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📜 إطار التمرير
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

-- ============================================
-- 💀 دوال الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255)
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
-- 🎯 التحكم بالكرة (الميزة الرئيسية)
-- ============================================

local isControlling = false
local controlConnection = nil

-- دالة جلب الكرة وتثبيتها عندك
local function grabBall()
    if not Ball then
        Ball = findBall()
        if not Ball then
            showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 0, 0))
            return false
        end
    end
    
    -- ننسخ الكرة عشان نتحكم فيها (نخليها تتبعنا)
    local newBall = Ball:Clone()
    newBall.Parent = workspace
    newBall.Name = "ControlledBall"
    newBall.Anchored = false
    newBall.CanCollide = true
    
    -- نضيف BodyVelocity عشان تتحرك معانا
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Parent = newBall
    
    return newBall, bv
end

local function startControl()
    if isControlling then
        return
    end
    
    local controlledBall, bv = grabBall()
    if not controlledBall then
        return
    end
    
    isControlling = true
    showNotification("⚽ جاري التحكم بالكرة! حرك الماوس", Color3.fromRGB(0, 200, 255))
    
    controlConnection = RunService.Heartbeat:Connect(function()
        if not isControlling or not controlledBall or not controlledBall.Parent then
            return
        end
        
        -- تحديث موقع الكرة لتتبع الفأرة
        local targetPos
        if Settings.FollowMouse then
            -- الكرة تتبع الفأرة مع ارتفاع ثابت
            targetPos = Mouse.Hit.Position + Vector3.new(0, Settings.FlyHeight, 0)
        else
            -- الكرة تتبع شخصيتك
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                targetPos = char.HumanoidRootPart.Position + Vector3.new(0, Settings.FlyHeight, 0)
            end
        end
        
        if targetPos then
            -- تحريك الكرة بسلاسة
            local direction = (targetPos - controlledBall.Position)
            local velocity = direction.Unit * math.min(direction.Magnitude * Settings.ControlSpeed, 150)
            bv.Velocity = velocity
            
            -- تدوير الكرة
            controlledBall.CFrame = CFrame.new(controlledBall.Position, targetPos)
        end
    end)
end

local function stopControl()
    isControlling = false
    if controlConnection then
        controlConnection:Disconnect()
        controlConnection = nil
    end
    
    -- حذف الكرة المسيطر عليها
    local controlledBall = workspace:FindFirstChild("ControlledBall")
    if controlledBall then
        controlledBall:Destroy()
    end
    
    showNotification("⏹ تم إيقاف التحكم بالكرة", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "⚽ بدء التحكم بالكرة", Callback = function()
        if isControlling then
            stopControl()
        else
            startControl()
        end
    end},
    {Text = "🔍 البحث عن الكرة", Callback = function()
        Ball = findBall()
        if Ball then
            showNotification("✅ تم العثور على الكرة!", Color3.fromRGB(0, 200, 100))
        else
            showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 0, 0))
        end
    end},
    {Text = "🔄 تبديل وضع المتابعة", Callback = function()
        Settings.FollowMouse = not Settings.FollowMouse
        showNotification("🔄 وضع المتابعة: " .. (Settings.FollowMouse and "الفأرة" or "الشخصية"), Color3.fromRGB(0, 200, 255))
    end},
    {Text = "⬆️ زيادة سرعة التحكم", Callback = function()
        Settings.ControlSpeed = Settings.ControlSpeed + 0.5
        showNotification("⚡ سرعة التحكم: " .. Settings.ControlSpeed, Color3.fromRGB(0, 200, 255))
    end},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 38
local spacing = 5
local canvasHeight = #Commands * (buttonHeight + spacing) + 10

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollFrame
    Button.Size = UDim2.new(1, -10, 0, buttonHeight)
    Button.Position = UDim2.new(0, 5, 0, 2 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
    Button.BackgroundTransparency = 0.3
    Button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.3
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
        if isVisible then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 280),
                BackgroundTransparency = 0.2
            }):Play()
            CloseBtn.Text = "✕"
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then child.Visible = true end
            end
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundTransparency = 0.4
            }):Play()
            CloseBtn.Text = "⊕"
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then child.Visible = false end
            end
        end
    end
    
    -- زر Space للتحكم بالكرة
    if input.KeyCode == Enum.KeyCode.Space then
        if isControlling then
            stopControl()
        else
            startControl()
        end
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
Ball = findBall()
if Ball then
    print("⚽ Ball Control Script Loaded! Ball found: " .. Ball.Name)
    showNotification("✅ تم العثور على الكرة! اضغط Space للتحكم", Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Control Script Loaded! Ball not found.")
    showNotification("⚠️ لم يتم العثور على الكرة! استخدم 'البحث عن الكرة'", Color3.fromRGB(255, 200, 0))
end
print("📌 Press F1 to toggle GUI")
print("📌 Press SPACE to start/stop controlling the ball")
