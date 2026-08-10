-- ============================================
-- 💀 ROMA SENPAI HUB (النسخة النهائية المصححة لـ Delta) 💀
-- صنع من طرف ROMA SENPAI
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- تنظيف النسخة القديمة لمنع التكرار
if PlayerGui:FindFirstChild("RomaHub") then
    PlayerGui.RomaHub:Destroy()
end

-- ============================================
-- 🎨 الواجهة الرئيسية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false

-- استخدام حماية Delta المضمونة للإظهار
local TargetParent = PlayerGui
if gethui then
    TargetParent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    TargetParent = game:GetService("CoreGui")
end
ScreenGui.Parent = TargetParent

-- النافذة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1
Stroke.Transparency = 0.5

-- ============================================
-- 📌 العنوان
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.3

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 ROMA SENPAI HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.Size = UDim2.new(0, 140, 0, 15)
SubTitle.Position = UDim2.new(0, 10, 0, 28)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "صنع من طرف ROMA SENPAI"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
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
        CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar and child ~= CloseBtn then
                child.Visible = false
            end
        end
        Title.Visible = false
        SubTitle.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 400, 0, 500),
            Position = UDim2.new(0.5, -200, 0.5, -250),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        Title.Visible = true
        SubTitle.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end
CloseBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================
-- 📂 القائمة الجانبية والمحتوى
-- ============================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 10)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)

local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -140, 1, -55)
ContentFrame.Position = UDim2.new(0, 135, 0, 52)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true

-- ============================================
-- 🔥 دالة الإشعار
-- ============================================
local function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

local states = {fly = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120
local currentTab = nil

-- دالة التاب الجانبي
local function createTab(name, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.BackgroundTransparency = 0.3
            currentTab.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        currentTab = btn
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        callback()
    end)
    return btn
end

-- دالة زر المحتوى
local function addContentButton(text, callback, color, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = ContentFrame
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Position = UDim2.new(0.025, 0, 0, yPos or 5)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ============================================
-- 🚀 الوظائف (طيران، نوكب، اختفاء، سرعة)
-- ============================================
local function toggleFly()
    states.fly = not states.fly
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local h = char:FindFirstChild("Humanoid")
    if not root or not h then return end

    if states.fly then
        h.PlatformStand = true
        connections.fly = RunService.Heartbeat:Connect(function()
            if not states.fly then return end
            local move = h.MoveDirection
            local up = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                up = Vector3.new(0, 10, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                up = Vector3.new(0, -10, 0)
            end
            root.Velocity = move.Magnitude > 0 and (move * 80 + up) or up
        end)
        showNotification("🚀 الطيران ON", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ الطيران OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function toggleNoclip()
    states.noclip = not states.noclip
    if states.noclip then
        connections.noclip = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        showNotification("🧱 اختراق الجدران ON", Color3.fromRGB(150, 100, 255))
    else
        if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        showNotification("⏹ اختراق الجدران OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function toggleInvisible()
    states.invisible = not states.invisible
    local char = Player.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = states.invisible and 1 or 0
        end
    end
    showNotification(states.invisible and "👻 اختفاء ON" or "👁️ اختفاء OFF", Color3.fromRGB(200, 100, 255))
end

local function toggleSpeed()
    states.speed = not states.speed
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = states.speed and speedAmount or 16 end
    showNotification(states.speed and ("⚡ سرعة " .. speedAmount) or "⏹ سرعة OFF", Color3.fromRGB(0, 255, 200))
end

local function increaseSpeed()
    speedAmount = math.clamp(speedAmount + 10, 20, 500)
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if h and states.speed then h.WalkSpeed = speedAmount end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

local function decreaseSpeed()
    speedAmount = math.clamp(speedAmount - 10, 20, 500)
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if h and states.speed then h.WalkSpeed = speedAmount end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

-- ============================================
-- 🌐 تيليبورت للاعبين
-- ============================================
local TeleportFrame = nil
local function showTeleportMenu()
    if TeleportFrame then TeleportFrame:Destroy(); TeleportFrame = nil; return end
    
    TeleportFrame = Instance.new("Frame")
    TeleportFrame.Parent = MainFrame
    TeleportFrame.Size = UDim2.new(0.85, 0, 0, 180)
    TeleportFrame.Position = UDim2.new(0.075, 0, 0, 55)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TeleportFrame.BackgroundTransparency = 0.3
    TeleportFrame.BorderSizePixel = 0
    
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 12)
    TCorner.Parent = TeleportFrame
    
    local TScroll = Instance.new("ScrollingFrame")
    TScroll.Parent = TeleportFrame
    TScroll.Size = UDim2.new(1, -10, 1, -10)
    TScroll.Position = UDim2.new(0, 5, 0, 5)
    TScroll.BackgroundTransparency = 1
    TScroll.ScrollBarThickness = 3
    
    local yOff = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = Instance.new("TextButton")
            btn.Parent = TScroll
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yOff)
            btn.Text = "🌐 " .. plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            btn.BorderSizePixel = 0
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 6)
            bc.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                local char = plr.Character
                local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if char and char:FindFirstChild("HumanoidRootPart") and root then
                    root.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    showNotification("✅ تم التليفورت إلى " .. plr.Name, Color3.fromRGB(0, 200, 100))
                end
                TeleportFrame:Destroy()
                TeleportFrame = nil
            end)
            yOff = yOff + 35
        end
    end
    TScroll.CanvasSize = UDim2.new(0, 0, 0, yOff)
end

-- ============================================
-- 🔧 إيقاف الكل
-- ============================================
local function stopAll()
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    connections = {}
    for key in pairs(states) do states[key] = false end
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true; part.Transparency = 0 end
        end
        local h = char:FindFirstChild("Humanoid")
        if h then h.PlatformStand = false; h.WalkSpeed = 16 end
    end
    if TeleportFrame then TeleportFrame:Destroy(); TeleportFrame = nil end
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 📂 محتوى التبويبات
-- ============================================
local function showTab1()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    addContentButton("🚀 الطيران", toggleFly, Color3.fromRGB(0, 150, 255), 5)
    addContentButton("🧱 اختراق الجدران", toggleNoclip, Color3.fromRGB(150, 100, 255), 47)
    addContentButton("👻 اختفاء", toggleInvisible, Color3.fromRGB(200, 100, 255), 89)
end

local function showTab2()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    addContentButton("⚡ تفعيل السرعة", toggleSpeed, Color3.fromRGB(0, 255, 200), 5)
    addContentButton("⬆️ زيادة السرعة +10", increaseSpeed, Color3.fromRGB(50, 200, 100), 47)
    addContentButton("⬇️ خفض السرعة -10", decreaseSpeed, Color3.fromRGB(200, 150, 50), 89)
end

local function showTab3()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    addContentButton("🌐 تيليبورت للاعب", showTeleportMenu, Color3.fromRGB(100, 150, 255), 5)
end

local function showTab4()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    addContentButton("🔄 إيقاف الكل", stopAll, Color3.fromRGB(200, 50, 50), 5)
end

-- إنشاء الأزرار الجانبية
createTab("الحركة", "🚀", showTab1)
createTab("السرعة", "⚡", showTab2)
createTab("التيليبورت", "🌐", showTab3)
createTab("إضافات", "🔧", showTab4)

-- تفعيل أول تاب افتراضياً
showTab1()

print("💀 ROMA SENPAI HUB Loaded Successfully!")
showNotification("💀 ROMA SENPAI HUB جاهز!", Color3.fromRGB(150, 150, 255))
