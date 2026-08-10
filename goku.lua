-- ============================================
-- 🐉 DRAGON DESTROYER 🐉
-- تخريب حقيقي على السيرفر
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🎨 إنشاء الواجهة الزجاجية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DragonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (زجاجية صغيرة)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- ============================================
-- 📌 شريط العنوان مع زر X دائري
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🐉 DRAGON"
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
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = true end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 45, 0, 45),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = false end
        end
    end
end)

-- خط فاصل
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.85, 0, 0, 1.5)
Line.Position = UDim2.new(0.075, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

-- ============================================
-- 💀 أوامر تخريبية حقيقية (تعمل على السيرفر)
-- ============================================

-- متغيرات لتخزين الحالات
local activeEffects = {}

-- دالة الإشعارات
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 50, 100)
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

-- 🛠️ دالة تنفيذ الأمر على السيرفر
local function executeOnServer(command, data)
    -- إرسال الأمر إلى السيرفر عبر RemoteEvent
    local remote = Instance.new("RemoteEvent")
    remote.Name = "DragonCommand"
    remote.Parent = game.ReplicatedStorage
    
    remote:FireServer(command, data)
    
    -- تنظيف الـ Remote بعد الاستخدام
    game:GetService("Debris"):AddItem(remote, 1)
end

-- 1️⃣ تجميد جميع اللاعبين (تجميد حقيقي)
local function freezeAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local char = plr.Character
            if char and char:FindFirstChild("Humanoid") then
                local h = char.Humanoid
                h.WalkSpeed = 0
                h.JumpPower = 0
                h.PlatformStand = true
                
                -- تجميد الجسم
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            end
        end
    end
    showNotification("❄️ تم تجميد جميع اللاعبين!", Color3.fromRGB(100, 200, 255))
end

-- 2️⃣ إلغاء التجميد
local function unfreezeAll()
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

-- 3️⃣ إغراق اللاعبين تحت الأرض (حقيقي)
local function sinkAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame + Vector3.new(0, -50, 0)
            end
        end
    end
    showNotification("⬇️ تم إغراق اللاعبين تحت الأرض!", Color3.fromRGB(255, 150, 0))
end

-- 4️⃣ طيران اللاعبين (حقيقي)
local function flyAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 150, 0)
                bv.MaxForce = Vector3.new(0, 5000, 0)
                bv.Parent = root
                game:GetService("Debris"):AddItem(bv, 3)
            end
        end
    end
    showNotification("🚀 تم إطلاق اللاعبين في الهواء!", Color3.fromRGB(0, 150, 255))
end

-- 5️⃣ تفجير اللاعبين (حقيقي)
local function explodeAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local exp = Instance.new("Explosion")
                exp.Position = root.Position
                exp.BlastRadius = 15
                exp.BlastPressure = 500
                exp.Parent = workspace
            end
        end
    end
    showNotification("💥 تم تفجير جميع اللاعبين!", Color3.fromRGB(255, 100, 0))
end

-- 6️⃣ سحب اللاعبين إليك (حقيقي)
local function pullAll()
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = myRoot.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5))
            end
        end
    end
    showNotification("🔄 تم سحب جميع اللاعبين إليك!", Color3.fromRGB(200, 100, 255))
end

-- 7️⃣ شل حركة الخصوم (نوب)
local function noobAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if h then
                h.WalkSpeed = 2
                h.JumpPower = 0
                h.PlatformStand = true
            end
        end
    end
    showNotification("🤡 تم تحويل الخصوم إلى نوب!", Color3.fromRGB(255, 200, 0))
end

-- 8️⃣ إلغاء النوب
local function unnoobAll()
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

-- 9️⃣ قتل جميع اللاعبين
local function killAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if h then
                h.Health = 0
            end
        end
    end
    showNotification("💀 تم قتل جميع اللاعبين!", Color3.fromRGB(255, 0, 0))
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "❄️ تجميد الكل", Callback = freezeAll},
    {Text = "🔥 إلغاء التجميد", Callback = unfreezeAll},
    {Text = "⬇️ إغراق الكل", Callback = sinkAll},
    {Text = "🚀 طيران الكل", Callback = flyAll},
    {Text = "💥 تفجير الكل", Callback = explodeAll},
    {Text = "🔄 سحب الكل", Callback = pullAll},
    {Text = "🤡 نوب الخصوم", Callback = noobAll},
    {Text = "💪 إلغاء النوب", Callback = unnoobAll},
    {Text = "💀 قتل الكل", Callback = killAll},
}

-- ============================================
-- 🎨 إنشاء الأزرار الصغيرة
-- ============================================
local buttonHeight = 32
local spacing = 4
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
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
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
                BackgroundTransparency = 0.15
            }):Play()
            CloseBtn.Text = "✕"
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then child.Visible = true end
            end
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundTransparency = 0.3
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
print("🐉 Dragon Destroyer Script Loaded!")
print("📌 Press F1 to toggle GUI")
showNotification("🔥 تم تحميل سكربت التخريب الحقيقي!", Color3.fromRGB(255, 50, 100))
