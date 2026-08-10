-- ============================================
-- ⚽ BLUE LOCK RIVALS ULTIMATE SCRIPT ⚽
-- جلب الكرة + Auto Roll + سرعة + ستات
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- 🔍 إيجاد الكرة
-- ============================================
local function findBall()
    local allParts = Workspace:GetDescendants()
    for _, part in pairs(allParts) do
        if part:IsA("BasePart") and part.Name:lower():find("ball") then
            return part
        end
    end
    return nil
end

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BLRUltimateGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 320)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 200, 0)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚽ BLR ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 3)
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
            Size = UDim2.new(0, 45, 0, 45),
            Position = UDim2.new(0, 10, 0.5, -22.5),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        Title.Visible = false
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = false
            end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 320),
            Position = UDim2.new(0.5, -100, 0.5, -160),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        Title.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end

CloseBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================
-- 📜 إطار التمرير
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)

-- ============================================
-- 💀 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
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
-- 🔥 1️⃣ جلب الكرة (ضغطة واحدة)
-- ============================================
local function pullBall()
    local Ball = findBall()
    if not Ball then
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local targetPos = root.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        for _, child in pairs(Ball:GetChildren()) do
            if child:IsA("Weld") or child:IsA("Attachment") or child:IsA("Constraint") then
                child:Destroy()
            end
        end
    end)
    
    pcall(function()
        Ball.Position = targetPos
        Ball.CFrame = CFrame.new(targetPos)
        Ball.Anchored = false
        Ball.CanCollide = true
    end)
    
    showNotification("✅ تم جلب الكرة!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 🔥 2️⃣ Auto Roll (لف على لافينيو)
-- ============================================
local function autoRollLavinho()
    showNotification("🔄 جاري اللف على لافينيو...", Color3.fromRGB(0, 200, 255))
    
    -- البحث عن Remote الـ Roll
    local rollRemote = nil
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") and (child.Name:lower():find("roll") or child.Name:lower():find("spin")) then
            rollRemote = child
            break
        end
    end
    
    if not rollRemote then
        showNotification("❌ لم يتم العثور على Remote اللف!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    -- محاولة إرسال أمر اللف (قد يختلف حسب اللعبة)
    pcall(function()
        rollRemote:FireServer()
    end)
    pcall(function()
        rollRemote:FireServer("Spin")
    end)
    pcall(function()
        rollRemote:FireServer("Roll")
    end)
    
    showNotification("✅ تم إرسال أمر اللف!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 🔥 3️⃣ سرعة خارقة
-- ============================================
local speedState = false
local function toggleSpeed()
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end
    
    speedState = not speedState
    if speedState then
        h.WalkSpeed = 120
        h.JumpPower = 80
        showNotification("⚡ سرعة خارقة ON!", Color3.fromRGB(0, 200, 255))
    else
        h.WalkSpeed = 16
        h.JumpPower = 50
        showNotification("⚡ سرعة خارقة OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 4️⃣ ستات مكسيمة
-- ============================================
local function maxStats()
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end
    
    h.MaxHealth = 999999
    h.Health = 999999
    h.WalkSpeed = 120
    h.JumpPower = 80
    
    showNotification("💪 تم تعزيز جميع الستات!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 🔥 5️⃣ أكواد اللعبة (Lavinho Codes)
-- ============================================
local function redeemCodes()
    local codes = {
        "BRAZILMAN",
        "DANCERHYPE", 
        "BACHIRADAD",
        "OPUPDATE",
        "SORRYFORDELAY",
        "BUNNYPEAK",
        "PRODIGYBALANCE",
        "UPDATEHYPE3"
    }
    
    -- البحث عن Remote الـ Codes
    local codeRemote = nil
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") and (child.Name:lower():find("code") or child.Name:lower():find("redeem")) then
            codeRemote = child
            break
        end
    end
    
    if not codeRemote then
        showNotification("❌ لم يتم العثور على Remote الأكواد!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    for _, code in ipairs(codes) do
        pcall(function()
            codeRemote:FireServer(code)
        end)
        task.wait(0.2)
    end
    
    showNotification("✅ تم إرسال جميع الأكواد!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "🔄 جلب الكرة", Callback = pullBall},
    {Text = "🎰 Auto Roll لافينيو", Callback = autoRollLavinho},
    {Text = "⚡ سرعة خارقة", Callback = toggleSpeed},
    {Text = "💪 Max Stats", Callback = maxStats},
    {Text = "🎁 أكواد لافينيو", Callback = redeemCodes},
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
        toggleMinimize()
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        pullBall()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("⚽ BLR Ultimate Script Loaded!")
print("📌 Press G to pull ball")
print("📌 Press F1 to toggle GUI")
showNotification("🔥 BLR Ultimate جاهز!", Color3.fromRGB(0, 200, 255))
