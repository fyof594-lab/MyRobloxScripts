-- ============================================
-- ⚽ BALL CONTROL SCRIPT v3 ⚽
-- تتحكم بالكرة بنفسك وتطير فيها
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- ============================================
-- 🎯 إعدادات التحكم
-- ============================================
local Settings = {
    ControlSpeed = 50,      -- سرعة تحرك الكرة
    FlyHeight = 10,         -- ارتفاع الطيران
}

-- ============================================
-- 🔍 إيجاد الكرة
-- ============================================
local Ball = nil

local function findBall()
    -- أسماء محتملة للكرة
    local ballNames = {"Ball", "ball", "Football", "SoccerBall", "BALL"}
    for _, name in ipairs(ballNames) do
        local found = Workspace:FindFirstChild(name)
        if found and found:IsA("BasePart") then
            return found
        end
    end
    
    -- البحث العميق
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("BasePart") and child.Name:lower():find("ball") then
            return child
        end
    end
    return nil
end

Ball = findBall()

-- ============================================
-- 🎨 إنشاء الواجهة الزجاجية
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
-- 🎯 التحكم بالكرة (تتحكم فيها بنفسك)
-- ============================================

local isControlling = false
local controlConnection = nil
local originalBallPosition = nil
local originalBallParent = nil
local playerRoot = nil
local playerHumanoid = nil

-- دالة جلب الكرة وتثبيتها على اللاعب (تخليها تتبعك)
local function grabBall()
    if not Ball then
        Ball = findBall()
        if not Ball then
            showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 0, 0))
            return false
        end
    end
    
    -- حفظ موقع الكرة الأصلي
    originalBallPosition = Ball.Position
    originalBallParent = Ball.Parent
    
    -- نقل الكرة إلى اللاعب
    Ball.Parent = workspace
    Ball.Anchored = false
    Ball.CanCollide = true
    
    -- نجيب الـ HumanoidRootPart حق اللاعب
    local char = Player.Character
    if char then
        playerRoot = char:FindFirstChild("HumanoidRootPart")
        playerHumanoid = char:FindFirstChild("Humanoid")
    end
    
    return true
end

-- دالة بدء التحكم
local function startControl()
    if isControlling then
        return
    end
    
    if not grabBall() then
        return
    end
    
    isControlling = true
    showNotification("⚽ جاري التحكم بالكرة! استخدم WASD للتحرك", Color3.fromRGB(0, 200, 255))
    
    -- نضيف BodyVelocity عشان تتحرك الكرة معانا
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Parent = Ball
    
    -- نربط حركة الكرة بحركة اللاعب
    controlConnection = RunService.Heartbeat:Connect(function()
        if not isControlling or not Ball or not Ball.Parent then
            return
        end
        
        -- نحرك الكرة مع اللاعب
        if playerRoot and playerHumanoid then
            -- ناخذ اتجاه حركة اللاعب
            local moveDirection = playerHumanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                -- تحريك الكرة في اتجاه حركة اللاعب
                local targetPos = Ball.Position + (moveDirection * Settings.ControlSpeed * 0.1)
                targetPos = Vector3.new(targetPos.X, Ball.Position.Y, targetPos.Z)
                local direction = (targetPos - Ball.Position)
                bv.Velocity = direction * 5
                
                -- تدوير الكرة
                Ball.CFrame = CFrame.new(Ball.Position, Ball.Position + moveDirection)
            else
                -- إيقاف الكرة إذا كان اللاعب واقف
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            
            -- نحرك الكرة مع اللاعب (تتبع اللاعب)
            if playerRoot then
                local rootPos = playerRoot.Position
                local ballPos = Ball.Position
                local distance = (rootPos - ballPos).Magnitude
                
                if distance > 5 then
                    -- إذا ابتعدت الكرة كثيراً، نعيدها للاعب
                    Ball.Position = rootPos + Vector3.new(0, Settings.FlyHeight, 0)
                end
            end
        end
    end)
end

-- دالة إيقاف التحكم
local function stopControl()
    isControlling = false
    
    if controlConnection then
        controlConnection:Disconnect()
        controlConnection = nil
    end
    
    -- نرجع الكرة لمكانها الأصلي
    if Ball and Ball.Parent then
        Ball:Destroy()
    end
    
    -- نعيد الكرة الأصلية
    Ball = findBall()
    
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
    {Text = "⬆️ زيادة سرعة التحكم", Callback = function()
        Settings.ControlSpeed = Settings.ControlSpeed + 10
        showNotification("⚡ سرعة التحكم: " .. Settings.ControlSpeed, Color3.fromRGB(0, 200, 255))
    end},
    {Text = "⬇️ خفض سرعة التحكم", Callback = function()
        Settings.ControlSpeed = math.max(10, Settings.ControlSpeed - 10)
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
    print("⚽ Ball Control Script v3 Loaded! Ball found: " .. Ball.Name)
    showNotification("✅ تم العثور على الكرة! اضغط Space للتحكم", Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Control Script v3 Loaded! Ball not found.")
    showNotification("⚠️ لم يتم العثور على الكرة! استخدم 'البحث عن الكرة'", Color3.fromRGB(255, 200, 0))
end
print("📌 Press F1 to toggle GUI")
print("📌 Press SPACE to start/stop controlling the ball")
