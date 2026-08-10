-- ============================================
-- 💀 ROMA SENPAI HUB (Axel Hub Style) 💀
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {
    fly = false,
    noclip = false,
    invisible = false,
    speed = false,
    teleport = false
}
local connections = {}
local speedAmount = 120
local flySpeed = 80

-- ============================================
-- 🛠️ دوال الوظائف
-- ============================================

-- الطيران
local function toggleFly(state)
    states.fly = state
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly then
        h.PlatformStand = true
        if not connections.fly then
            connections.fly = RunService.Heartbeat:Connect(function()
                if not states.fly then return end
                local move = h.MoveDirection
                local up = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    up = Vector3.new(0, 10, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    up = Vector3.new(0, -10, 0)
                end
                if move.Magnitude > 0 then
                    root.Velocity = move * flySpeed + up
                else
                    root.Velocity = up
                end
            end)
        end
        showNotification("🚀 الطيران ON", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ الطيران OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- اختراق الجدران
local function toggleNoclip(state)
    states.noclip = state
    if states.noclip then
        if not connections.noclip then
            connections.noclip = RunService.Heartbeat:Connect(function()
                local char = Player.Character
                if not char then return end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
        showNotification("🧱 اختراق الجدران ON", Color3.fromRGB(150, 100, 255))
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
        showNotification("⏹ اختراق الجدران OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- اختفاء
local function toggleInvisible(state)
    states.invisible = state
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
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 0
            char.Humanoid.NameDisplayDistance = 0
        end)
        showNotification("👻 اختفاء ON", Color3.fromRGB(200, 100, 255))
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
        showNotification("👁️ اختفاء OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- السرعة
local function toggleSpeed(state)
    states.speed = state
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        showNotification("⚡ سرعة " .. speedAmount .. " ON", Color3.fromRGB(0, 255, 200))
    else
        h.WalkSpeed = 16
        showNotification("⏹ سرعة OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- إيقاف الكل
local function stopAll()
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
    if TeleportFrame then
        TeleportFrame.Visible = false
    end
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 🌐 التيليبورت
-- ============================================
local TeleportFrame = nil

local function toggleTeleport(state)
    states.teleport = state
    if states.teleport then
        showTeleportMenu()
    else
        if TeleportFrame then
            TeleportFrame.Visible = false
        end
    end
end

local function showTeleportMenu()
    if TeleportFrame and TeleportFrame.Visible then
        TeleportFrame.Visible = false
        return
    end
    
    if not TeleportFrame then
        TeleportFrame = Instance.new("Frame")
        TeleportFrame.Parent = ScreenGui
        TeleportFrame.Size = UDim2.new(0, 200, 0, 200)
        TeleportFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        TeleportFrame.BackgroundTransparency = 0.1
        TeleportFrame.BorderSizePixel = 0
        TeleportFrame.ClipsDescendants = true
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 10)
        TCorner.Parent = TeleportFrame
        
        local TStroke = Instance.new("UIStroke")
        TStroke.Parent = TeleportFrame
        TStroke.Color = Color3.fromRGB(45, 45, 55)
        TStroke.Thickness = 1
        
        local TTitle = Instance.new("TextLabel")
        TTitle.Parent = TeleportFrame
        TTitle.Size = UDim2.new(1, 0, 0, 30)
        TTitle.BackgroundTransparency = 1
        TTitle.Text = "🌐 التيليبورت"
        TTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
        TTitle.TextSize = 14
        TTitle.Font = Enum.Font.GothamBold
        
        local closeT = Instance.new("TextButton")
        closeT.Parent = TeleportFrame
        closeT.Size = UDim2.new(0, 25, 0, 25)
        closeT.Position = UDim2.new(1, -30, 0, 3)
        closeT.BackgroundTransparency = 1
        closeT.Text = "✕"
        closeT.TextColor3 = Color3.fromRGB(160, 160, 175)
        closeT.TextSize = 14
        closeT.Font = Enum.Font.GothamBold
        
        closeT.MouseButton1Click:Connect(function()
            TeleportFrame.Visible = false
        end)
        
        local TScroll = Instance.new("ScrollingFrame")
        TScroll.Parent = TeleportFrame
        TScroll.Size = UDim2.new(1, -10, 1, -40)
        TScroll.Position = UDim2.new(0, 5, 0, 35)
        TScroll.BackgroundTransparency = 1
        TScroll.BorderSizePixel = 0
        TScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        TScroll.ScrollBarThickness = 3
        
        local yOff = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local btn = Instance.new("TextButton")
                btn.Parent = TScroll
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Position = UDim2.new(0, 0, 0, yOff)
                btn.Text = "🌐 " .. plr.Name
                btn.TextColor3 = Color3.fromRGB(200, 200, 215)
                btn.TextSize = 12
                btn.Font = Enum.Font.GothamMedium
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                btn.BorderSizePixel = 0
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseEnter:Connect(function()
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                end)
                
                btn.MouseButton1Click:Connect(function()
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                            showNotification("✅ تم التليفورت إلى " .. plr.Name, Color3.fromRGB(0, 200, 100))
                        end
                    else
                        showNotification("❌ اللاعب غير موجود!", Color3.fromRGB(255, 0, 0))
                    end
                    TeleportFrame.Visible = false
                end)
                yOff = yOff + 35
            end
        end
        TScroll.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)
    end
    
    TeleportFrame.Visible = true
end

-- ============================================
-- 💬 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 14
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- 🎨 الواجهة الرئيسية (مصغرة)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaAxelHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 320)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BackgroundTransparency = 0.1
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

-- ============================================
-- 📌 شريط العنوان
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = TopBar
LogoLabel.Size = UDim2.new(0, 130, 1, 0)
LogoLabel.Position = UDim2.new(0, 12, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "⚡ ROMA HUB"
LogoLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
LogoLabel.TextSize = 14
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left

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
-- 📂 القائمة الجانبية
-- ============================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 120, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 8)
SidebarPadding.PaddingRight = UDim.new(0, 8)

-- ============================================
-- 🖥️ حاوية المحتوى
-- ============================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -125, 1, -45)
ContentContainer.Position = UDim2.new(0, 125, 0, 40)
ContentContainer.BackgroundTransparency = 1

local currentTabBtn = nil

local function createTabButton(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(140, 140, 160)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.TextColor3 = Color3.fromRGB(240, 240, 245)
    end)
    btn.MouseLeave:Connect(function()
        if currentTabBtn ~= btn then
            btn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
    end)
    
    return btn
end

local function createContentPanel(titleText)
    for _, v in pairs(ContentContainer:GetChildren()) do v:Destroy() end
    
    local panel = Instance.new("ScrollingFrame")
    panel.Parent = ContentContainer
    panel.Size = UDim2.new(1, 0, 1, 0)
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
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    return panel
end

local function addToggle(parent, titleText, callback)
    local toggle = Instance.new("Frame")
    toggle.Parent = parent
    toggle.Size = UDim2.new(1, -5, 0, 32)
    toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggle.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Parent = toggle
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(200, 200, 215)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton")
    btn.Parent = toggle
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local active = false
    local indicator = Instance.new("Frame")
    indicator.Parent = toggle
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = UDim2.new(1, -20, 0.5, -7)
    indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 4)
    indCorner.Parent = indicator
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(indicator, TweenInfo.new(0.2), {
            BackgroundColor3 = active and Color3.fromRGB(80, 140, 255) or Color3.fromRGB(40, 40, 50)
        }):Play()
        callback(active)
    end)
end

-- ============================================
-- ⚙️ بناء القوائم
-- ============================================

local function createMovementTab()
    local panel = createContentPanel("🚀 إعدادات الحركة")
    addToggle(panel, "الطيران (Fly)", function(state)
        toggleFly(state)
    end)
    addToggle(panel, "اختراق الجدران (Noclip)", function(state)
        toggleNoclip(state)
    end)
    addToggle(panel, "اختفاء (Invisible)", function(state)
        toggleInvisible(state)
    end)
end

local function createSpeedTab()
    local panel = createContentPanel("⚡ إعدادات السرعة")
    addToggle(panel, "تفعيل السرعة العالية", function(state)
        toggleSpeed(state)
    end)
end

local function createTeleportTab()
    local panel = createContentPanel("🌐 الانتقال للاعبين")
    addToggle(panel, "فتح قائمة التيليبورت", function(state)
        if state then
            showTeleportMenu()
        else
            if TeleportFrame then
                TeleportFrame.Visible = false
            end
        end
    end)
end

local function createExtrasTab()
    local panel = createContentPanel("🔧 إضافات")
    addToggle(panel, "إيقاف الكل", function(state)
        if state then
            stopAll()
        end
    end)
end

-- ============================================
-- 📋 إنشاء الأزرار الجانبية
-- ============================================
local tab1 = createTabButton("الحركة", "🚀")
tab1.MouseButton1Click:Connect(function()
    if currentTabBtn then
        currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    end
    currentTabBtn = tab1
    tab1.TextColor3 = Color3.fromRGB(240, 240, 245)
    createMovementTab()
end)

local tab2 = createTabButton("السرعة", "⚡")
tab2.MouseButton1Click:Connect(function()
    if currentTabBtn then
        currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    end
    currentTabBtn = tab2
    tab2.TextColor3 = Color3.fromRGB(240, 240, 245)
    createSpeedTab()
end)

local tab3 = createTabButton("التيليبورت", "🌐")
tab3.MouseButton1Click:Connect(function()
    if currentTabBtn then
        currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    end
    currentTabBtn = tab3
    tab3.TextColor3 = Color3.fromRGB(240, 240, 245)
    createTeleportTab()
end)

local tab4 = createTabButton("إضافات", "🔧")
tab4.MouseButton1Click:Connect(function()
    if currentTabBtn then
        currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    end
    currentTabBtn = tab4
    tab4.TextColor3 = Color3.fromRGB(240, 240, 245)
    createExtrasTab()
end)

-- ============================================
-- 🚀 فتح التاب الأول افتراضياً
-- ============================================
tab1.MouseButton1Click()

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 ROMA SENPAI HUB (Axel Style) Loaded!")
print("📌 F1 = Toggle GUI")
showNotification("💀 ROMA HUB جاهز!", Color3.fromRGB(150, 150, 255))
