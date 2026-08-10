-- ============================================
-- 💀 ROMA SENPAI HUB 💀
-- صنع من طرف ROMA SENPAI
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Mouse = Player:GetMouse()

-- ============================================
-- 🎨 الواجهة الرئيسية (مصغرة)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (أصغر)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 580, 0, 280)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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
Stroke.Thickness = 1
Stroke.Transparency = 0.5

-- ============================================
-- 📌 شريط العنوان
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.3

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 16)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 ROMA SENPAI HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.Size = UDim2.new(0, 150, 0, 12)
SubTitle.Position = UDim2.new(0, 10, 0, 22)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "صنع من طرف ROMA SENPAI"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
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
            Size = UDim2.new(0, 580, 0, 280),
            Position = UDim2.new(0.5, -290, 0.5, -140),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 28, 0, 28)
        CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
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
-- 📂 القائمة الجانبية
-- ============================================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 100, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.ClipsDescendants = true

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.PaddingRight = UDim.new(0, 5)

-- ============================================
-- 📄 المحتوى
-- ============================================
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -110, 1, -45)
ContentFrame.Position = UDim2.new(0, 105, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true

-- ============================================
-- 🔥 دالة الإشعار
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
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {fly = false, fly2 = false, fly3 = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120
local currentTab = nil
local flyButtons = {} -- لتخزين أزرار الطيران عشان نتحكم فيها

-- ============================================
-- 📦 دالة إنشاء تاب جانبي (مصغر)
-- ============================================
function createTab(name, icon, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.LayoutOrder = 1
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= btn then
            btn.BackgroundTransparency = 0.3
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
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

-- ============================================
-- 📦 دالة إنشاء Frame قابل للسحب (للميزات)
-- ============================================
local function createDraggableFrame(title, callback, color)
    local frame = Instance.new("Frame")
    frame.Parent = ContentFrame
    frame.Size = UDim2.new(0.9, 0, 0, 0)
    frame.Position = UDim2.new(0.05, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Active = true
    frame.Draggable = true
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = frame
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.BackgroundColor3 = color or Color3.fromRGB(30, 30, 50)
    titleLabel.BackgroundTransparency = 0.3
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleLabel
    
    -- زر إغلاق الـ Frame
    local closeFrame = Instance.new("TextButton")
    closeFrame.Parent = titleLabel
    closeFrame.Size = UDim2.new(0, 20, 0, 20)
    closeFrame.Position = UDim2.new(1, -25, 0.5, -10)
    closeFrame.Text = "✕"
    closeFrame.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeFrame.TextScaled = true
    closeFrame.Font = Enum.Font.GothamBold
    closeFrame.BackgroundTransparency = 1
    closeFrame.BorderSizePixel = 0
    
    closeFrame.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)
    
    -- محتوى الـ Frame
    local content = Instance.new("Frame")
    content.Parent = frame
    content.Size = UDim2.new(1, 0, 1, -25)
    content.Position = UDim2.new(0, 0, 0, 25)
    content.BackgroundTransparency = 1
    
    -- دالة لإضافة زر داخل الـ Frame
    local function addButtonToFrame(text, cb, col)
        local btn = Instance.new("TextButton")
        btn.Parent = content
        btn.Size = UDim2.new(0.95, 0, 0, 28)
        btn.Position = UDim2.new(0.025, 0, 0, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = col or Color3.fromRGB(30, 30, 50)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundTransparency = 0
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundTransparency = 0.3
            btn.BackgroundColor3 = col or Color3.fromRGB(30, 30, 50)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        btn.MouseButton1Click:Connect(cb)
        return btn
    end
    
    return frame, content, addButtonToFrame
end

-- ============================================
-- 🚀 الطيران (3 أنواع)
-- ============================================

-- النوع الأول: طيران عادي (فوق وتحت)
local function toggleFly1()
    states.fly = not states.fly
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

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
            if move.Magnitude > 0 then
                root.Velocity = move * 80 + up
            else
                root.Velocity = up
            end
        end)
        showNotification("🚀 طيران عادي ON (Space↑ / Shift↓)", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ طيران عادي OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- النوع الثاني: طيران ثابت (أمام/خلف/يمين/يسار فقط)
local function toggleFly2()
    states.fly2 = not states.fly2
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly2 then
        h.PlatformStand = true
        connections.fly2 = RunService.Heartbeat:Connect(function()
            if not states.fly2 then return end
            local move = h.MoveDirection
            if move.Magnitude > 0 then
                -- نثبت الارتفاع ونسمح فقط بالحركة الأفقية
                local currentY = root.Position.Y
                root.Velocity = Vector3.new(move.X * 80, 0, move.Z * 80)
                root.Position = Vector3.new(root.Position.X, currentY, root.Position.Z)
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        showNotification("🚀 طيران ثابت ON (أفقي فقط)", Color3.fromRGB(0, 200, 255))
    else
        if connections.fly2 then
            connections.fly2:Disconnect()
            connections.fly2 = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ طيران ثابت OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- النوع الثالث: طيران حر (فوق وتحت)
local function toggleFly3()
    states.fly3 = not states.fly3
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly3 then
        h.PlatformStand = true
        connections.fly3 = RunService.Heartbeat:Connect(function()
            if not states.fly3 then return end
            local move = h.MoveDirection
            local up = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                up = Vector3.new(0, 10, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                up = Vector3.new(0, -10, 0)
            end
            if move.Magnitude > 0 then
                root.Velocity = move * 80 + up
            else
                root.Velocity = up
            end
        end)
        showNotification("🚀 طيران حر ON (Space↑ / Shift↓)", Color3.fromRGB(150, 100, 255))
    else
        if connections.fly3 then
            connections.fly3:Disconnect()
            connections.fly3 = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ طيران حر OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🧱 اختراق الجدران
-- ============================================
local function toggleNoclip()
    states.noclip = not states.noclip
    if states.noclip then
        connections.noclip = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
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

-- ============================================
-- 👻 اختفاء
-- ============================================
local function toggleInvisible()
    states.invisible = not states.invisible
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

-- ============================================
-- ⚡ السرعة
-- ============================================
local function toggleSpeed()
    states.speed = not states.speed
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        showNotification("⚡ سرعة " .. speedAmount, Color3.fromRGB(0, 255, 200))
    else
        h.WalkSpeed = 16
        showNotification("⏹ سرعة OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function increaseSpeed()
    speedAmount = speedAmount + 10
    if speedAmount > 500 then speedAmount = 500 end
    if states.speed then
        local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = speedAmount end
    end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

local function decreaseSpeed()
    speedAmount = speedAmount - 10
    if speedAmount < 20 then speedAmount = 20 end
    if states.speed then
        local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
        if h then h.WalkSpeed = speedAmount end
    end
    showNotification("⚡ السرعة: " .. speedAmount, Color3.fromRGB(0, 255, 200))
end

-- ============================================
-- 🌐 تيليبورت للاعبين
-- ============================================
local TeleportFrame = nil
local function showTeleportMenu()
    if TeleportFrame and TeleportFrame.Visible then
        TeleportFrame.Visible = false
        return
    end
    
    if not TeleportFrame then
        TeleportFrame = Instance.new("Frame")
        TeleportFrame.Parent = MainFrame
        TeleportFrame.Size = UDim2.new(0.8, 0, 0, 150)
        TeleportFrame.Position = UDim2.new(0.1, 0, 0, 45)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TeleportFrame.BackgroundTransparency = 0.3
        TeleportFrame.BorderSizePixel = 0
        TeleportFrame.ClipsDescendants = true
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 12)
        TCorner.Parent = TeleportFrame
        
        local TScroll = Instance.new("ScrollingFrame")
        TScroll.Parent = TeleportFrame
        TScroll.Size = UDim2.new(1, -10, 1, -10)
        TScroll.Position = UDim2.new(0, 5, 0, 5)
        TScroll.BackgroundTransparency = 1
        TScroll.BorderSizePixel = 0
        TScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        TScroll.ScrollBarThickness = 3
        
        local yOff = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local btn = Instance.new("TextButton")
                btn.Parent = TScroll
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.Position = UDim2.new(0, 0, 0, yOff)
                btn.Text = "🌐 " .. plr.Name
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextScaled = true
                btn.Font = Enum.Font.GothamBold
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
                btn.BackgroundTransparency = 0.3
                btn.BorderSizePixel = 0
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                btn.MouseEnter:Connect(function()
                    btn.BackgroundTransparency = 0
                end)
                btn.MouseLeave:Connect(function()
                    btn.BackgroundTransparency = 0.3
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
                yOff = yOff + 33
            end
        end
        TScroll.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)
        
        local closeT = Instance.new("TextButton")
        closeT.Parent = TeleportFrame
        closeT.Size = UDim2.new(0, 28, 0, 28)
        closeT.Position = UDim2.new(1, -34, 0, 2)
        closeT.Text = "✕"
        closeT.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeT.TextScaled = true
        closeT.Font = Enum.Font.GothamBold
        closeT.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        closeT.BackgroundTransparency = 0.3
        closeT.BorderSizePixel = 0
        
        local closeTCorner = Instance.new("UICorner")
        closeTCorner.CornerRadius = UDim.new(1, 0)
        closeTCorner.Parent = closeT
        
        closeT.MouseButton1Click:Connect(function()
            TeleportFrame.Visible = false
        end)
    end
    
    TeleportFrame.Visible = true
end

-- ============================================
-- 🗺️ تيليبورت للخريطة
-- ============================================
local MapFrame = nil
local function showMapTeleport()
    if MapFrame and MapFrame.Visible then
        MapFrame.Visible = false
        return
    end
    
    if not MapFrame then
        MapFrame = Instance.new("Frame")
        MapFrame.Parent = MainFrame
        MapFrame.Size = UDim2.new(0.8, 0, 0, 150)
        MapFrame.Position = UDim2.new(0.1, 0, 0, 45)
        MapFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MapFrame.BackgroundTransparency = 0.3
        MapFrame.BorderSizePixel = 0
        MapFrame.ClipsDescendants = true
        
        local MCorner = Instance.new("UICorner")
        MCorner.CornerRadius = UDim.new(0, 12)
        MCorner.Parent = MapFrame
        
        local MapImage = Instance.new("ImageLabel")
        MapImage.Parent = MapFrame
        MapImage.Size = UDim2.new(1, -10, 1, -10)
        MapImage.Position = UDim2.new(0, 5, 0, 5)
        MapImage.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        MapImage.BackgroundTransparency = 0.3
        MapImage.Image = "rbxassetid://" 
        
        local MCorner2 = Instance.new("UICorner")
        MCorner2.CornerRadius = UDim.new(0, 8)
        MCorner2.Parent = MapImage
        
        local closeMap = Instance.new("TextButton")
        closeMap.Parent = MapFrame
        closeMap.Size = UDim2.new(0, 28, 0, 28)
        closeMap.Position = UDim2.new(1, -34, 0, 2)
        closeMap.Text = "✕"
        closeMap.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeMap.TextScaled = true
        closeMap.Font = Enum.Font.GothamBold
        closeMap.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        closeMap.BackgroundTransparency = 0.3
        closeMap.BorderSizePixel = 0
        
        local closeMapCorner = Instance.new("UICorner")
        closeMapCorner.CornerRadius = UDim.new(1, 0)
        closeMapCorner.Parent = closeMap
        
        closeMap.MouseButton1Click:Connect(function()
            MapFrame.Visible = false
        end)
        
        MapImage.MouseButton1Click:Connect(function(x, y)
            local absSize = MapImage.AbsoluteSize
            local absPos = MapImage.AbsolutePosition
            
            local relX = (x - absPos.X) / absSize.X
            local relY = (y - absPos.Y) / absSize.Y
            
            local worldSize = 200
            local targetPos = Vector3.new((relX - 0.5) * worldSize, 5, (relY - 0.5) * worldSize)
            
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(targetPos)
                showNotification("✅ تم التليفورت!", Color3.fromRGB(0, 200, 100))
                MapFrame.Visible = false
            end
        end)
    end
    
    MapFrame.Visible = true
end

-- ============================================
-- 🔧 إيقاف الكل
-- ============================================
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
    if MapFrame then
        MapFrame.Visible = false
    end
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 📂 إنشاء الأقسام والمحتوى
-- ============================================

-- 🔥 Tab 1: الطيران
local function showTab1()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    
    local yPos = 5
    
    -- زر لفتح Frame الطيران العادي
    local btn1 = Instance.new("TextButton")
    btn1.Parent = ContentFrame
    btn1.Size = UDim2.new(0.9, 0, 0, 30)
    btn1.Position = UDim2.new(0.05, 0, 0, yPos)
    btn1.Text = "🚀 طيران عادي (Space↑ / Shift↓)"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn1.TextScaled = true
    btn1.Font = Enum.Font.GothamBold
    btn1.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    btn1.BackgroundTransparency = 0.3
    btn1.BorderSizePixel = 0
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = btn1
    
    btn1.MouseEnter:Connect(function()
        btn1.BackgroundTransparency = 0
        btn1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn1.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn1.MouseLeave:Connect(function()
        btn1.BackgroundTransparency = 0.3
        btn1.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn1.MouseButton1Click:Connect(toggleFly1)
    yPos = yPos + 40
    
    -- زر لفتح Frame الطيران الثابت
    local btn2 = Instance.new("TextButton")
    btn2.Parent = ContentFrame
    btn2.Size = UDim2.new(0.9, 0, 0, 30)
    btn2.Position = UDim2.new(0.05, 0, 0, yPos)
    btn2.Text = "🚀 طيران ثابت (أفقي فقط)"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn2.TextScaled = true
    btn2.Font = Enum.Font.GothamBold
    btn2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    btn2.BackgroundTransparency = 0.3
    btn2.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn2
    
    btn2.MouseEnter:Connect(function()
        btn2.BackgroundTransparency = 0
        btn2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn2.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn2.MouseLeave:Connect(function()
        btn2.BackgroundTransparency = 0.3
        btn2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn2.MouseButton1Click:Connect(toggleFly2)
    yPos = yPos + 40
    
    -- زر لفتح Frame الطيران الحر
    local btn3 = Instance.new("TextButton")
    btn3.Parent = ContentFrame
    btn3.Size = UDim2.new(0.9, 0, 0, 30)
    btn3.Position = UDim2.new(0.05, 0, 0, yPos)
    btn3.Text = "🚀 طيران حر (Space↑ / Shift↓)"
    btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn3.TextScaled = true
    btn3.Font = Enum.Font.GothamBold
    btn3.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    btn3.BackgroundTransparency = 0.3
    btn3.BorderSizePixel = 0
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 6)
    btnCorner3.Parent = btn3
    
    btn3.MouseEnter:Connect(function()
        btn3.BackgroundTransparency = 0
        btn3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn3.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn3.MouseLeave:Connect(function()
        btn3.BackgroundTransparency = 0.3
        btn3.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn3.MouseButton1Click:Connect(toggleFly3)
    yPos = yPos + 40
end

-- ⚡ Tab 2: السرعة
local function showTab2()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    local yPos = 5
    
    local btn1 = Instance.new("TextButton")
    btn1.Parent = ContentFrame
    btn1.Size = UDim2.new(0.9, 0, 0, 30)
    btn1.Position = UDim2.new(0.05, 0, 0, yPos)
    btn1.Text = "⚡ تفعيل السرعة"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn1.TextScaled = true
    btn1.Font = Enum.Font.GothamBold
    btn1.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    btn1.BackgroundTransparency = 0.3
    btn1.BorderSizePixel = 0
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = btn1
    
    btn1.MouseEnter:Connect(function()
        btn1.BackgroundTransparency = 0
        btn1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn1.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn1.MouseLeave:Connect(function()
        btn1.BackgroundTransparency = 0.3
        btn1.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
        btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn1.MouseButton1Click:Connect(toggleSpeed)
    yPos = yPos + 40
    
    local btn2 = Instance.new("TextButton")
    btn2.Parent = ContentFrame
    btn2.Size = UDim2.new(0.9, 0, 0, 30)
    btn2.Position = UDim2.new(0.05, 0, 0, yPos)
    btn2.Text = "⬆️ زيادة السرعة +10"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn2.TextScaled = true
    btn2.Font = Enum.Font.GothamBold
    btn2.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    btn2.BackgroundTransparency = 0.3
    btn2.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn2
    
    btn2.MouseEnter:Connect(function()
        btn2.BackgroundTransparency = 0
        btn2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn2.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn2.MouseLeave:Connect(function()
        btn2.BackgroundTransparency = 0.3
        btn2.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn2.MouseButton1Click:Connect(increaseSpeed)
    yPos = yPos + 40
    
    local btn3 = Instance.new("TextButton")
    btn3.Parent = ContentFrame
    btn3.Size = UDim2.new(0.9, 0, 0, 30)
    btn3.Position = UDim2.new(0.05, 0, 0, yPos)
    btn3.Text = "⬇️ خفض السرعة -10"
    btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn3.TextScaled = true
    btn3.Font = Enum.Font.GothamBold
    btn3.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    btn3.BackgroundTransparency = 0.3
    btn3.BorderSizePixel = 0
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 6)
    btnCorner3.Parent = btn3
    
    btn3.MouseEnter:Connect(function()
        btn3.BackgroundTransparency = 0
        btn3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn3.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn3.MouseLeave:Connect(function()
        btn3.BackgroundTransparency = 0.3
        btn3.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn3.MouseButton1Click:Connect(decreaseSpeed)
    yPos = yPos + 40
end

-- 🌐 Tab 3: التيليبورت
local function showTab3()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    local yPos = 5
    
    local btn1 = Instance.new("TextButton")
    btn1.Parent = ContentFrame
    btn1.Size = UDim2.new(0.9, 0, 0, 30)
    btn1.Position = UDim2.new(0.05, 0, 0, yPos)
    btn1.Text = "🌐 تيليبورت للاعب"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn1.TextScaled = true
    btn1.Font = Enum.Font.GothamBold
    btn1.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    btn1.BackgroundTransparency = 0.3
    btn1.BorderSizePixel = 0
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = btn1
    
    btn1.MouseEnter:Connect(function()
        btn1.BackgroundTransparency = 0
        btn1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn1.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn1.MouseLeave:Connect(function()
        btn1.BackgroundTransparency = 0.3
        btn1.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn1.MouseButton1Click:Connect(showTeleportMenu)
    yPos = yPos + 40
    
    local btn2 = Instance.new("TextButton")
    btn2.Parent = ContentFrame
    btn2.Size = UDim2.new(0.9, 0, 0, 30)
    btn2.Position = UDim2.new(0.05, 0, 0, yPos)
    btn2.Text = "🗺️ تيليبورت للخريطة"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn2.TextScaled = true
    btn2.Font = Enum.Font.GothamBold
    btn2.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    btn2.BackgroundTransparency = 0.3
    btn2.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn2
    
    btn2.MouseEnter:Connect(function()
        btn2.BackgroundTransparency = 0
        btn2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn2.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn2.MouseLeave:Connect(function()
        btn2.BackgroundTransparency = 0.3
        btn2.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn2.MouseButton1Click:Connect(showMapTeleport)
    yPos = yPos + 40
end

-- 🔧 Tab 4: أوامر إضافية
local function showTab4()
    for _, child in pairs(ContentFrame:GetChildren()) do child:Destroy() end
    local yPos = 5
    
    local btn1 = Instance.new("TextButton")
    btn1.Parent = ContentFrame
    btn1.Size = UDim2.new(0.9, 0, 0, 30)
    btn1.Position = UDim2.new(0.05, 0, 0, yPos)
    btn1.Text = "🧱 اختراق الجدران"
    btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn1.TextScaled = true
    btn1.Font = Enum.Font.GothamBold
    btn1.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
    btn1.BackgroundTransparency = 0.3
    btn1.BorderSizePixel = 0
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = btn1
    
    btn1.MouseEnter:Connect(function()
        btn1.BackgroundTransparency = 0
        btn1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn1.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn1.MouseLeave:Connect(function()
        btn1.BackgroundTransparency = 0.3
        btn1.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn1.MouseButton1Click:Connect(toggleNoclip)
    yPos = yPos + 40
    
    local btn2 = Instance.new("TextButton")
    btn2.Parent = ContentFrame
    btn2.Size = UDim2.new(0.9, 0, 0, 30)
    btn2.Position = UDim2.new(0.05, 0, 0, yPos)
    btn2.Text = "👻 اختفاء"
    btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn2.TextScaled = true
    btn2.Font = Enum.Font.GothamBold
    btn2.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    btn2.BackgroundTransparency = 0.3
    btn2.BorderSizePixel = 0
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = btn2
    
    btn2.MouseEnter:Connect(function()
        btn2.BackgroundTransparency = 0
        btn2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn2.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn2.MouseLeave:Connect(function()
        btn2.BackgroundTransparency = 0.3
        btn2.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn2.MouseButton1Click:Connect(toggleInvisible)
    yPos = yPos + 40
    
    local btn3 = Instance.new("TextButton")
    btn3.Parent = ContentFrame
    btn3.Size = UDim2.new(0.9, 0, 0, 30)
    btn3.Position = UDim2.new(0.05, 0, 0, yPos)
    btn3.Text = "🔄 إيقاف الكل"
    btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn3.TextScaled = true
    btn3.Font = Enum.Font.GothamBold
    btn3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn3.BackgroundTransparency = 0.3
    btn3.BorderSizePixel = 0
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 6)
    btnCorner3.Parent = btn3
    
    btn3.MouseEnter:Connect(function()
        btn3.BackgroundTransparency = 0
        btn3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn3.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn3.MouseLeave:Connect(function()
        btn3.BackgroundTransparency = 0.3
        btn3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn3.MouseButton1Click:Connect(stopAll)
    yPos = yPos + 40
end

-- ============================================
-- 📋 إنشاء الأزرار الجانبية
-- ============================================
createTab("الطيران", "🚀", showTab1)
createTab("السرعة", "⚡", showTab2)
createTab("التيليبورت", "🌐", showTab3)
createTab("إضافات", "🔧", showTab4)

-- تفعيل التاب الأول افتراضياً
showTab1()

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 ROMA SENPAI HUB Loaded!")
print("📌 F1 = Toggle GUI")
showNotification("💀 ROMA SENPAI HUB جاهز!", Color3.fromRGB(150, 150, 255))
