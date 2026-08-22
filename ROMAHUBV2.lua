-- =====================================================
-- BLUE LOCK RIVALS - ULTIMATE HACK MENU VIP
-- deepseek_lua_20260810_a4573f.lua
-- =====================================================

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = replicatedStorage:FindFirstChild("RemoteEvent")
local remoteFunction = replicatedStorage:FindFirstChild("RemoteFunction")

-- ===== التحقق من وجود الريمات =====
if not remoteEvent then
    warn("❌ RemoteEvent غير موجود!")
    return
end

-- ===== واجهة المستخدم =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false
screenGui.Name = "BlueLockHackVIP"

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 400, 0, 650)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -325)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- تأثير الزجاج الفخم
local blur = Instance.new("BlurEffect")
blur.Parent = game.Lighting
blur.Size = 12

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 30)

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- ===== الشريط العلوي =====
local topBar = Instance.new("Frame")
topBar.Parent = mainFrame
topBar.Size = UDim2.new(1, 0, 0, 75)
topBar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
topBar.BackgroundTransparency = 0.4
topBar.BorderSizePixel = 0

local topCorner = Instance.new("UICorner")
topCorner.Parent = topBar
topCorner.CornerRadius = UDim.new(0, 30)

local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ BLUE LOCK VIP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.2

-- ===== زر الإغلاق =====
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = topBar
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -60, 0, 12)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(0, 15)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    closeBtn.Text = mainFrame.Visible and "✕" or "⊕"
end)

-- ===== حاوية الأزرار (سكرول) =====
local container = Instance.new("ScrollingFrame")
container.Parent = mainFrame
container.Size = UDim2.new(1, -20, 1, -95)
container.Position = UDim2.new(0, 10, 0, 85)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.CanvasSize = UDim2.new(0, 0, 0, 950)
container.ScrollBarThickness = 5
container.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
container.Name = "Container"

-- ===== دالة إنشاء زر =====
local function createButton(text, color, position, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = container
    btn.Size = UDim2.new(1, -10, 0, 55)
    btn.Position = UDim2.new(0, 5, 0, position)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false

    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 15)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6

    local isActive = false

    btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            btn.BackgroundTransparency = 0.2
            btnStroke.Color = Color3.fromRGB(0, 255, 150)
            callback(true)
        else
            btn.BackgroundColor3 = color
            btn.BackgroundTransparency = 0.3
            btnStroke.Color = Color3.fromRGB(255, 255, 255)
            callback(false)
        end
    end)

    return btn
end

-- ===== دالة إرسال الريمات =====
local function fireRemote(data)
    if remoteEvent then
        remoteEvent:FireServer(unpack(data))
    elseif remoteFunction then
        remoteFunction:InvokeServer(unpack(data))
    end
end

-- ===== الأزرار والميزات =====
local yPos = 0

-- 1. 🎯 Spin Style
createButton("🎯 Spin Style", Color3.fromRGB(255, 150, 0), yPos, function(active)
    if active then
        fireRemote({"SpinStyle"})
        showNotification("🔄 جاري تدوير الستايل...")
    end
end)
yPos = yPos + 65

-- 2. 🌀 Spin Flow
createButton("🌀 Spin Flow", Color3.fromRGB(150, 0, 255), yPos, function(active)
    if active then
        fireRemote({"SpinFlow"})
        showNotification("🌀 جاري تدوير الفلو...")
    end
end)
yPos = yPos + 65

-- 3. 📏 تغيير الحجم
createButton("📏 تغيير الحجم", Color3.fromRGB(0, 200, 255), yPos, function(active)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local size = active and 5 or 1
        fireRemote({"SetSize", size})
        showNotification(active and "✅ تم التكبير!" or "✅ تم التصغير!")
    end
end)
yPos = yPos + 65

-- 4. 💨 سرعة خارقة
createButton("💨 سرعة خارقة", Color3.fromRGB(255, 0, 100), yPos, function(active)
    local speed = active and 100 or 16
    fireRemote({"SetSpeed", speed})
    showNotification(active and "⚡ تفعيل السرعة الخارقة!" or "✅ إيقاف السرعة")
end)
yPos = yPos + 65

-- 5. ⚡ إيقاظ فوري
createButton("⚡ إيقاظ فوري", Color3.fromRGB(255, 200, 50), yPos, function(active)
    if active then
        fireRemote({"InstantAwakening"})
        showNotification("🔥 تم تفعيل الإيقاظ الفوري!")
    end
end)
yPos = yPos + 65

-- 6. 🦋 رقصة الفراشة
createButton("🦋 رقصة الفراشة", Color3.fromRGB(255, 100, 200), yPos, function(active)
    local direction = active and 1 or 0
    fireRemote({"ButterflyDanceChoiceRemote", direction})
    showNotification(active and "🦋 تفعيل رقصة الفراشة!" or "✅ إيقاف الرقصة")
end)
yPos = yPos + 65

-- 7. 🎮 تغيير الستايل
createButton("🎮 تغيير الستايل", Color3.fromRGB(0, 255, 150), yPos, function(active)
    fireRemote({"SetStyle"})
    showNotification("🔄 جاري تغيير الستايل...")
end)
yPos = yPos + 65

-- 8. 💎 سحب كل الجوائز
createButton("💎 سحب الكل", Color3.fromRGB(255, 215, 0), yPos, function(active)
    if active then
        fireRemote({"ClaimAll"})
        showNotification("💎 تم سحب كل الجوائز!")
    end
end)
yPos = yPos + 65

-- 9. 🔄 إعادة ضبط الكول داون
createButton("🔄 إعادة ضبط", Color3.fromRGB(0, 255, 255), yPos, function(active)
    if active then
        fireRemote({"AdmResetCDs"})
        showNotification("🔄 تم إعادة ضبط الكول داون!")
    end
end)
yPos = yPos + 65

-- 10. 🚀 تيليبورت
createButton("🚀 تيليبورت", Color3.fromRGB(100, 100, 255), yPos, function(active)
    local char = player.Character
    if char then
        local pos = char.HumanoidRootPart.Position
        fireRemote({"Teleport", pos + Vector3.new(0, 50, 0)})
        showNotification("🚀 تم التيليبورت!")
    end
end)
yPos = yPos + 65

-- 11. 🛡️ No Clip
createButton("🛡️ No Clip", Color3.fromRGB(100, 255, 100), yPos, function(active)
    local char = player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not active
            end
        end
        showNotification(active and "🛡️ تفعيل No Clip!" or "✅ إيقاف No Clip")
    end
end)
yPos = yPos + 65

-- 12. 💰 Auto Farm
createButton("💰 Auto Farm", Color3.fromRGB(255, 200, 100), yPos, function(active)
    if active then
        -- محاكاة الزراعة التلقائية
        spawn(function()
            while active do
                fireRemote({"ClaimReward"})
                wait(0.5)
            end
        end)
        showNotification("💰 بدء الزراعة التلقائية!")
    else
        showNotification("⏹ إيقاف الزراعة")
    end
end)
yPos = yPos + 65

-- 13. 🎁 Battlepass
createButton("🎁 Battlepass", Color3.fromRGB(200, 100, 255), yPos, function(active)
    if active then
        fireRemote({"ClaimBattlepass"})
        showNotification("🎁 تم سحب الباتل باس!")
    end
end)
yPos = yPos + 65

-- 14. 📊 تغيير المستوى
createButton("📊 مستوى أسطوري", Color3.fromRGB(255, 100, 50), yPos, function(active)
    if active then
        fireRemote({"Level", 999})
        showNotification("📊 تم رفع المستوى!")
    end
end)
yPos = yPos + 65

-- ===== دالة الإشعارات =====
function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Parent = screenGui
    notif.Size = UDim2.new(0, 350, 0, 50)
    notif.Position = UDim2.new(0.5, -175, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.5
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0

    local notifCorner = Instance.new("UICorner")
    notifCorner.Parent = notif
    notifCorner.CornerRadius = UDim.new(0, 15)

    local notifStroke = Instance.new("UIStroke")
    notifStroke.Parent = notif
    notifStroke.Color = Color3.fromRGB(0, 150, 255)
    notifStroke.Thickness = 1.5
    notifStroke.Transparency = 0.5

    game:GetService("Debris"):AddItem(notif, 3)
end

-- ===== سحب النافذة =====
local dragStart, startPos, isDragging

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ===== رسالة ترحيب =====
showNotification("🔥 تم تحميل قائمة Blue Lock VIP!")

print("✅ Blue Lock Rivals Ultimate Hack Menu Loaded!")
