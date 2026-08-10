-- ============================================
-- 💀 ROMA SENPAI HUB (Axel Hub Style - Fixed) 💀
-- صنع من طرف ROMA SENPAI
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RomaAxelHub") then
    PlayerGui.RomaAxelHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaAxelHub"
ScreenGui.ResetOnSpawn = false

local TargetParent = PlayerGui
if gethui then
    TargetParent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    TargetParent = game:GetService("CoreGui")
end
ScreenGui.Parent = TargetParent

-- النافذة الرئيسية (مقاسات مضبوطة ورايقة)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 480, 0, 310)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1

-- شريط العناوين العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundTransparency = 1

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = TopBar
LogoLabel.Size = UDim2.new(0, 200, 1, 0)
LogoLabel.Position = UDim2.new(0, 15, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "⚡  ROMA SENPAI HUB"
LogoLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
LogoLabel.TextSize = 13
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 175)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- 📂 السايدبار (القائمة الجانبية اليسرى)
-- ============================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 145, 1, -85)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 200)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)

-- بروفايل المستخدم أسفل السايدبار
local UserProfile = Instance.new("Frame")
UserProfile.Parent = MainFrame
UserProfile.Size = UDim2.new(0, 135, 0, 42)
UserProfile.Position = UDim2.new(0, 5, 1, -47)
UserProfile.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
UserProfile.BorderSizePixel = 0

local UserCorner = Instance.new("UICorner")
UserCorner.CornerRadius = UDim.new(0, 8)
UserCorner.Parent = UserProfile

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = UserProfile
AvatarImg.Size = UDim2.new(0, 30, 0, 30)
AvatarImg.Position = UDim2.new(0, 6, 0.5, -15)
AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AvatarImg.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

local UserName = Instance.new("TextLabel")
UserName.Parent = UserProfile
UserName.Size = UDim2.new(1, -40, 0, 15)
UserName.Position = UDim2.new(0, 40, 0, 7)
UserName.BackgroundTransparency = 1
UserName.Text = Player.Name
UserName.TextColor3 = Color3.fromRGB(240, 240, 245)
UserName.TextSize = 11
UserName.Font = Enum.Font.GothamBold
UserName.TextXAlignment = Enum.TextXAlignment.Left

local UserSub = Instance.new("TextLabel")
UserSub.Parent = UserProfile
UserSub.Size = UDim2.new(1, -40, 0, 12)
UserSub.Position = UDim2.new(0, 40, 0, 22)
UserSub.BackgroundTransparency = 1
UserSub.Text = "Roma Senpai"
UserSub.TextColor3 = Color3.fromRGB(120, 120, 140)
UserSub.TextSize = 9
UserSub.Font = Enum.Font.Gotham
UserSub.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🖥️ حاوية المحتوى الرئيسي
-- ============================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -155, 1, -48)
ContentContainer.Position = UDim2.new(0, 150, 0, 42)
ContentContainer.BackgroundTransparency = 1

local currentTabBtn = nil

local function createTabButton(name, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(140, 140, 160)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.BackgroundTransparency = 1
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = btn
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        callback()
    end)
    return btn
end

local function createContentPanel(titleText)
    for _, v in pairs(ContentContainer:GetChildren()) do v:Destroy() end
    
    local panel = Instance.new("ScrollingFrame")
    panel.Parent = ContentContainer
    panel.Size = UDim2.new(1, -5, 1, 0)
    panel.Position = UDim2.new(0, 0, 0, 0)
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.ScrollBarThickness = 2
    panel.CanvasSize = UDim2.new(0, 0, 0, 250)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = panel
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    local title = Instance.new("TextLabel")
    title.Parent = panel
    title.Size = UDim2.new(1, 0, 0, 22)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(240, 240, 250)
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    return panel
end

local function addActionButton(parent, titleText, callback)
    local btnFrame = Instance.new("TextButton")
    btnFrame.Parent = parent
    btnFrame.Size = UDim2.new(1, -10, 0, 32)
    btnFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    btnFrame.BorderSizePixel = 0
    btnFrame.Text = ""
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btnFrame
    
    local label = Instance.new("TextLabel")
    label.Parent = btnFrame
    label.Size = UDim2.new(1, -15, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(200, 200, 215)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    btnFrame.MouseButton1Click:Connect(callback)
end

-- ============================================
// 🔥 المتغيرات والوظائف الأساسية
-- ============================================
local states = {fly = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120

local function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 250, 0, 30)
    notif.Position = UDim2.new(0.5, -125, 0.04, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 11
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 8)
    nc.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

-- الوظائف (طيران، نوكب، اختفاء، سرعة)
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

-- قائمة التيليبورت للاعبين (تظهر داخل لوحة المحتوى بشكل مرتب)
local function showTeleportList(parent)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            addActionButton(parent, "🌐 تليبورت إلى: " .. plr.Name, function()
                local char = plr.Character
                local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if char and char:FindFirstChild("HumanoidRootPart") and root then
                    root.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    showNotification("✅ تم التليفورت إلى " .. plr.Name, Color3.fromRGB(0, 200, 100))
                else
                    showNotification("❌ اللاعب غير موجود!", Color3.fromRGB(255, 0, 0))
                end
            end)
        end
    end
end

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
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 📋 بناء التبويبات (الأزرار الجانبية)
-- ============================================

local btn1 = createTabButton("الحركة", "🚀", function()
    local panel = createContentPanel("إعدادات الحركة")
    addActionButton(panel, "🚀 الطيران (Fly)", toggleFly)
    addActionButton(panel, "🧱 اختراق الجدران (Noclip)", toggleNoclip)
    addActionButton(panel, "👻 اختفاء (Invisible)", toggleInvisible)
end)

local btn2 = createTabButton("السرعة", "⚡", function()
    local panel = createContentPanel("إعدادات السرعة")
    addActionButton(panel, "⚡ تفعيل/إيقاف السرعة", toggleSpeed)
    addActionButton(panel, "⬆️ زيادة السرعة (+10)", increaseSpeed)
    addActionButton(panel, "⬇️ خفض السرعة (-10)", decreaseSpeed)
end)

local btn3 = createTabButton("التيليبورت", "🌐", function()
    local panel = createContentPanel("قائمة التيليبورت للاعبين")
    showTeleportList(panel)
end)

local btn4 = createTabButton("إضافات", "🔧", function()
    local panel = createContentPanel("الأدوات والإضافات")
    addActionButton(panel, "🔄 إيقاف جميع الوظائف", stopAll)
end)

-- فتح التاب الأول افتراضياً
btn1.MouseButton1Click()

print("💀 ROMA SENPAI HUB (Axel Style) Loaded!")
showNotification("💀 جاهز يا بطل!", Color3.fromRGB(150, 150, 255))
