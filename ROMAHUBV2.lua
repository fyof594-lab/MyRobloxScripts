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
-- 🎨 الواجهة الرئيسية (نفس الشكل القديم)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (نفس الحجم القديم)
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
-- 📂 القائمة الجانبية (نفس الشكل القديم)
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
local states = {fly_free = false, fly_fixed = false, noclip = false, invisible = false, speed = false}
local connections = {}
local speedAmount = 120
local currentTab = nil

-- ============================================
-- 📦 دالة إنشاء تاب جانبي
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
-- 📦 دالة إنشاء زر في المحتوى
-- ============================================
function addContentButton(parent, text, callback, color, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos or 5)
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
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.3
        btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ============================================
-- 🚀 الطيران (نوعين)
-- ============================================

-- طيران حر
local function toggleFlyFree()
    states.fly_free = not states.fly_free
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly_free then
        h.PlatformStand = true
        connections.fly_free = RunService.Heartbeat:Connect(function()
            if not states.fly_free then return end
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
        showNotification("🚀 طيران حر ON (Space↑ / Shift↓)", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly_free then
            connections.fly_free:Disconnect()
            connections.fly_free = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ طيران حر OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- طيران ثابت (أفقي فقط)
local function toggleFlyFixed()
    states.fly_fixed = not states.fly_fixed
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly_fixed then
        h.PlatformStand = true
        connections.fly_fixed = RunService.Heartbeat:Connect(function()
            if not states.fly_fixed then return end
            local move = h.MoveDirection
            if move.Magnitude > 0 then
                local currentY = root.Position.Y
                root.Velocity = Vector3.new(move.X * 80, 0, move.Z * 80)
                root.Position = Vector3.new(root.Position.X, currentY, root.Position.Z)
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        showNotification("🚀 طيران ثابت ON (أفقي فقط)", Color3.fromRGB(0, 200, 255))
    else
        if connections.fly_fixed then
            connections.fly_fixed:Disconnect()
            connections.fly_fixed = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ طيران ثابت OFF", Color3.fromRGB(255, 200, 0))
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
        
        local T
