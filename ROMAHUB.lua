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
-- 🎨 الواجهة الرئيسية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 350)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.2
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
-- 📌 شريط العنوان
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TitleBar.BackgroundTransparency = 0.3

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 ROMA HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.Size = UDim2.new(0, 130, 0, 12)
SubTitle.Position = UDim2.new(0, 8, 0, 26)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "صنع من طرف ROMA SENPAI"
SubTitle.TextColor3 = Color3.fromRGB(150, 150, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
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
            BackgroundTransparency = 0.4
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
            Size = UDim2.new(0, 200, 0, 350),
            Position = UDim2.new(0.5, -100, 0.5, -175),
            BackgroundTransparency = 0.2
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 28, 0, 28)
        CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
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
-- 📂 القائمة الرئيسية (الأزرار)
-- ============================================
local MainList = Instance.new("ScrollingFrame")
MainList.Parent = MainFrame
MainList.Size = UDim2.new(1, -10, 1, -50)
MainList.Position = UDim2.new(0, 5, 0, 45)
MainList.BackgroundTransparency = 1
MainList.BorderSizePixel = 0
MainList.CanvasSize = UDim2.new(0, 0, 0, 0)
MainList.ScrollBarThickness = 3
MainList.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

local yOffset = 5
local function addMainButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = MainList
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color or Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
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
    yOffset = yOffset + 48
    MainList.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    return btn
end

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
local subFrames = {}

-- ============================================
-- 📦 دالة إنشاء نافذة فرعية (تابعة)
-- ============================================
function createSubFrame(title, parent)
    local frame = Instance.new("Frame")
    frame.Parent = parent or MainFrame
    frame.Size = UDim2.new(0, 180, 0, 200)
    frame.Position = UDim2.new(1.05, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Active = true
    frame.Draggable = true
    frame.Visible = false
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Parent = frame
    frameStroke.Color = Color3.fromRGB(255, 255, 255)
    frameStroke.Thickness = 1
    frameStroke.Transparency = 0.5
    
    -- عنوان النافذة
    local frameTitle = Instance.new("Frame")
    frameTitle.Parent = frame
    frameTitle.Size = UDim2.new(1, 0, 0, 30)
    frameTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frameTitle.BackgroundTransparency = 0.3
    
    local frameTitleCorner = Instance.new("UICorner")
    frameTitleCorner.CornerRadius = UDim.new(0, 12)
    frameTitleCorner.Parent = frameTitle
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = frameTitle
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- زر إغلاق النافذة
    local closeFrame = Instance.new("TextButton")
    closeFrame.Parent = frameTitle
    closeFrame.Size = UDim2.new(0, 24, 0, 24)
    closeFrame.Position = UDim2.new(1, -28, 0.5, -12)
    closeFrame.Text = "✕"
    closeFrame.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeFrame.TextScaled = true
    closeFrame.Font = Enum.Font.GothamBold
    closeFrame.BackgroundTransparency = 1
    closeFrame.BorderSizePixel = 0
    
    closeFrame.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)
    
    -- محتوى النافذة
    local content = Instance.new("ScrollingFrame")
    content.Parent = frame
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local function addSubButton(text, callback, color)
        local btn = Instance.new("TextButton")
        btn.Parent = content
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, 0)
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
    
    -- دالة لإضافة أزرار مع ترتيب
    local function addButtons(buttons)
        local yPos = 5
        for _, b in ipairs(buttons) do
            local btn = addSubButton(b.text, b.callback, b.color)
            btn.Position = UDim2.new(0.05, 0, 0, yPos)
            yPos = yPos + 38
        end
        content.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
    end
    
    return frame, addButtons, content
end

-- ============================================
-- 🚀 1️⃣ الطيران (نافذة فرعية)
-- ============================================
local flyFrame, addFlyButtons = createSubFrame("🚀 الطيران")

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

-- طيران ثابت (أمامي فقط)
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
                -- نثبت الارتفاع ونسمح فقط بالحركة الأفقية (أمام/خلف)
                local currentY = root.Position.Y
                root.Velocity = Vector3.new(move.X * 80, 0, move.Z * 80)
                root.Position = Vector3.new(root.Position.X, currentY, root.Position.Z)
            else
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        showNotification("🚀 طيران ثابت ON (أمامي فقط)", Color3.fromRGB(0, 200, 255))
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

addFlyButtons({
    {text = "🔄 طيران حر", callback = toggleFlyFree, color = Color3.fromRGB(0, 150, 255)},
    {text = "🔄 طيران ثابت", callback = toggleFlyFixed, color = Color3.fromRGB(0, 200, 255)},
    {text = "⏹ إيقاف الطيران", callback = function()
        if states.fly_free then
            toggleFlyFree()
        end
        if states.fly_fixed then
            toggleFlyFixed()
        end
    end, color = Color3.fromRGB(255, 50, 50)},
})

-- ============================================
-- ⚡ 2️⃣ السرعة (نافذة فرعية)
-- ============================================
local speedFrame, addSpeedButtons = createSubFrame("⚡ السرعة")

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

addSpeedButtons({
    {text = "⚡ تفعيل السرعة", callback = toggleSpeed, color = Color3.fromRGB(0, 255, 200)},
    {text = "⬆️ زيادة +10", callback = increaseSpeed, color = Color3.fromRGB(50, 200, 100)},
    {text = "⬇️ خفض -10", callback = decreaseSpeed, color = Color3.fromRGB(200, 150, 50)},
})

-- ============================================
-- 🌐 3️⃣ التيليبورت (نافذة فرعية)
-- ============================================
local tpFrame, addTpButtons = createSubFrame("🌐 التيليبورت")

-- تيليبورت للاعبين
local TeleportFrame = nil
local function showTeleportMenu()
    if TeleportFrame and TeleportFrame.Visible then
        TeleportFrame.Visible = false
        return
    end
    
    if not TeleportFrame then
        TeleportFrame = Instance.new("Frame")
        TeleportFrame.Parent = MainFrame
        TeleportFrame.Size = UDim2.new(0, 170, 0, 200)
        TeleportFrame.Position = UDim2.new(1.05, 0, 0, 50)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TeleportFrame.BackgroundTransparency = 0.2
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
        closeT.Size = UDim2.new(0, 24, 0, 24)
        closeT.Position = UDim2.new(1, -28, 0, 2)
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

-- تيليبورت للخريطة
local MapFrame = nil
local function showMapTeleport()
    if MapFrame and MapFrame.Visible then
        MapFrame.Visible = false
        return
    end
    
    if not MapFrame then
        MapFrame = Instance.new("Frame")
        MapFrame.Parent = MainFrame
        MapFrame.Size = UDim2.new(0, 170, 0, 200)
        MapFrame.Position = UDim2.new(1.05, 0, 0, 50)
        MapFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        MapFrame.BackgroundTransparency = 0.2
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
        closeMap.Size = UDim2.new(0, 24, 0, 24)
        closeMap.Position = UDim2.new(1, -28, 0, 2)
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

addTpButtons({
    {text = "🌐 تيليبورت للاعب", callback = showTeleportMenu, color = Color3.fromRGB(100, 150, 255)},
    {text = "🗺️ تيليبورت للخريطة", callback = showMapTeleport, color = Color3.fromRGB(255, 200, 50)},
})

-- ============================================
-- 🔧 4️⃣ إضافات (نافذة فرعية)
-- ============================================
local extraFrame, addExtraButtons = createSubFrame("🔧 إضافات")

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

addExtraButtons({
    {text = "🧱 اختراق الجدران", callback = toggleNoclip, color = Color3.fromRGB(150, 100, 255)},
    {text = "👻 اختفاء", callback = toggleInvisible, color = Color3.fromRGB(200, 100, 255)},
    {text = "🔄 إيقاف الكل", callback = stopAll, color = Color3.fromRGB(200, 50, 50)},
})

-- ============================================
-- 📋 الأزرار الرئيسية (تفتح النوافذ الفرعية)
-- ============================================
local function toggleFlyFrame()
    flyFrame.Visible = not flyFrame.Visible
    speedFrame.Visible = false
    tpFrame.Visible = false
    extraFrame.Visible = false
    if TeleportFrame then TeleportFrame.Visible = false end
    if MapFrame then MapFrame.Visible = false end
end

local function toggleSpeedFrame()
    speedFrame.Visible = not speedFrame.Visible
    flyFrame.Visible = false
    tpFrame.Visible = false
    extraFrame.Visible = false
    if TeleportFrame then TeleportFrame.Visible = false end
    if MapFrame then MapFrame.Visible = false end
end

local function toggleTpFrame()
    tpFrame.Visible = not tpFrame.Visible
    flyFrame.Visible = false
    speedFrame.Visible = false
    extraFrame.Visible = false
    if TeleportFrame then TeleportFrame.Visible = false end
    if MapFrame then MapFrame.Visible = false end
end

local function toggleExtraFrame()
    extraFrame.Visible = not extraFrame.Visible
    flyFrame.Visible = false
    speedFrame.Visible = false
    tpFrame.Visible = false
    if TeleportFrame then TeleportFrame.Visible = false end
    if MapFrame then MapFrame.Visible = false end
end

addMainButton("🚀 الطيران", toggleFlyFrame, Color3.fromRGB(0, 150, 255))
addMainButton("⚡ السرعة", toggleSpeedFrame, Color3.fromRGB(0, 255, 200))
addMainButton("🌐 التيليبورت", toggleTpFrame, Color3.fromRGB(100, 150, 255))
addMainButton("🔧 إضافات", toggleExtraFrame, Color3.fromRGB(200, 100, 255))
addMainButton("💀 إغلاق الكل", function()
    flyFrame.Visible = false
    speedFrame.Visible = false
    tpFrame.Visible = false
    extraFrame.Visible = false
    if TeleportFrame then TeleportFrame.Visible = false end
    if MapFrame then MapFrame.Visible = false end
end, Color3.fromRGB(255, 50, 50))

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
showNotification("💀 ROMA HUB جاهز!", Color3.fromRGB(150, 150, 255))
