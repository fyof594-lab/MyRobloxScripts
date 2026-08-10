-- ============================================
-- ⚽ BALL CONTROL SCRIPT ⚽
-- يوجه الكرة نحو المرمى عبر Remote Event
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🎯 إعدادات الكود
-- ============================================
local Settings = {
    ShootPower = 80,
    AimMode = "Goal",
    Team = "Blue"
}

-- ============================================
-- 🔍 العثور على Remote Event الخاص بالتسديد
-- ============================================
local ShootRemote = nil

local possibleRemoteNames = {
    "Shoot", "Kick", "Shot", "Goal", "ShootGoal",
    "BallShoot", "KickBall", "RemoteEvent"
}

local function findShootRemote()
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") then
            for _, name in ipairs(possibleRemoteNames) do
                if child.Name:find(name) then
                    return child
                end
            end
        end
    end
    return nil
end

ShootRemote = findShootRemote()

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
Stroke.Color = Color3.fromRGB(255, 200, 0)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

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
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 0)

-- ============================================
-- 💀 دوال الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 200, 0)
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
-- 🎯 وظيفة التسديد
-- ============================================
local function performShoot()
    if not ShootRemote then
        showNotification("❌ لم يتم العثور على Remote!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        showNotification("❌ لم يتم العثور على شخصيتك!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local targetPosition
    if Settings.AimMode == "Goal" then
        local goalPart
        if Settings.Team == "Blue" then
            goalPart = workspace:FindFirstChild("RedGoal") or workspace:FindFirstChild("GoalRed")
        else
            goalPart = workspace:FindFirstChild("BlueGoal") or workspace:FindFirstChild("GoalBlue")
        end
        
        if goalPart then
            targetPosition = goalPart.Position
        else
            targetPosition = root.Position + (root.CFrame.LookVector * 80) + Vector3.new(0, 5, 0)
        end
    else
        local mouse = Player:GetMouse()
        targetPosition = mouse.Hit.Position
    end
    
    local success = pcall(function()
        ShootRemote:FireServer(targetPosition, Settings.ShootPower)
    end)
    
    if success then
        showNotification("✅ تم تسديد الكرة!", Color3.fromRGB(0, 200, 100))
    else
        pcall(function()
            ShootRemote:FireServer((targetPosition - root.Position).Unit * Settings.ShootPower)
        end)
        showNotification("⚽ محاولة تسديد بديلة...", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "⚽ تسديد نحو المرمى", Callback = performShoot},
    {Text = "🔄 تبديل وضع التسديد", Callback = function()
        if Settings.AimMode == "Goal" then
            Settings.AimMode = "Mouse"
            showNotification("🔄 وضع التسديد: اتجاه الماوس", Color3.fromRGB(0, 200, 255))
        else
            Settings.AimMode = "Goal"
            showNotification("🔄 وضع التسديد: المرمى", Color3.fromRGB(0, 200, 255))
        end
    end},
    {Text = "📡 عرض الـ Remote", Callback = function()
        if ShootRemote then
            showNotification("✅ الـ Remote: " .. ShootRemote.Name, Color3.fromRGB(0, 200, 100))
        else
            showNotification("❌ لم يتم العثور على Remote!", Color3.fromRGB(255, 0, 0))
        end
    end},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 40
local spacing = 6
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
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
if ShootRemote then
    print("⚽ Ball Control Script Loaded! Remote: " .. ShootRemote.Name)
    showNotification("✅ تم العثور على Remote: " .. ShootRemote.Name, Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Control Script Loaded! No Remote found.")
    showNotification("⚠️ لم يتم العثور على Remote", Color3.fromRGB(255, 200, 0))
end
print("📌 Press F1 to toggle GUI")
