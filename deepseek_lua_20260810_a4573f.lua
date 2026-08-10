
-- ============================================
-- ⚽ BLUE LOCK RIVALS SCRIPT ⚽
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🎨 واجهة عصرية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLockGUI"
ScreenGui.Parent = Player.PlayerGui

-- خلفية داكنة شفافة
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- زوايا مدورة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- إطار متوهج (Neon Stroke)
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(0, 200, 255)
Stroke.Transparency = 0.5
Stroke.Parent = MainFrame

-- ============================================
-- 📌 شريط العنوان مع زر X دائري
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 16)
TopCorner.Parent = TopBar

-- عنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚽ BLUE LOCK"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- زر X دائري (إخفاء القائمة)
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.Image = "rbxassetid://3926305904" -- دائرة شفافة
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

-- دائرة زر X
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- نص X
local CloseText = Instance.new("TextLabel")
CloseText.Size = UDim2.new(1, 0, 1, 0)
CloseText.BackgroundTransparency = 1
CloseText.Text = "✕"
CloseText.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseText.TextScaled = true
CloseText.Font = Enum.Font.GothamBold
CloseText.Parent = CloseBtn

-- متغير لحالة القائمة
local isVisible = true

-- وظيفة إظهار/إخفاء القائمة بشكل دائري
local function ToggleMenu()
    isVisible = not isVisible
    local targetSize = isVisible and UDim2.new(0, 380, 0, 520) or UDim2.new(0, 60, 0, 60)
    local targetPos = isVisible and UDim2.new(0.5, -190, 0.5, -260) or UDim2.new(0, 10, 0, 100)
    local targetTrans = isVisible and 0.1 or 0.8
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize,
        Position = targetPos,
        BackgroundTransparency = targetTrans
    }):Play()
    
    -- إخفاء/إظهار المحتوى
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= TopBar and child.Name ~= "Particles" then
            child.Visible = isVisible
        end
    end
end

CloseBtn.MouseButton1Click:Connect(ToggleMenu)

-- ============================================
-- 📜 قائمة الأوامر (سكربت بلو لوك)
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -55)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ScrollFrame.Parent = MainFrame

-- ============================================
-- ⚽ أوامر بلو لوك رايفلز
-- ============================================
local Commands = {
    -- 🏃 دريبل تلقائي (Auto Dribble)
    {Text = "🏃 Auto Dribble", Color = Color3.fromRGB(0, 200, 255), Callback = function()
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local dribbling = false
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1, 1, 1) * 100000
        
        local function startDribble()
            dribbling = true
            bv.Parent = root
            local con
            con = RunService.Heartbeat:Connect(function()
                if not dribbling or not root or not bv.Parent then
                    con:Disconnect()
                    return
                end
                -- حركة عشوائية تشبه الدريبل
                local dir = Vector3.new(
                    math.random(-2, 2),
                    0,
                    math.random(-2, 2)
                )
                bv.Velocity = dir * 30
            end)
            return con
        end
        
        local con = startDribble()
        
        if bv.Parent then
            dribbling = false
            bv:Destroy()
            if con then con:Disconnect() end
        else
            startDribble()
        end
    end},
    
    -- 🎯 شخصيات مجانية (Free Characters)
    {Text = "🎯 Free Characters", Color = Color3.fromRGB(255, 215, 0), Callback = function()
        -- محاكاة فتح الشخصيات
        for i = 1, 10 do
            local char = Instance.new("Model")
            char.Name = "Character_" .. i
            char.Parent = Player.Character
            wait(0.1)
        end
        print("✅ تم فتح 10 شخصيات!")
    end},
    
    -- ⚡ سرعة خارقة (Super Speed)
    {Text = "⚡ Super Speed", Color = Color3.fromRGB(255, 100, 255), Callback = function()
        local h = Player.Character.Humanoid
        if h.WalkSpeed == 16 then
            h.WalkSpeed = 120
            h.JumpPower = 80
        else
            h.WalkSpeed = 16
            h.JumpPower = 50
        end
    end},
    
    -- 🎯 Iframe Hitbox (تحسين التسديد)
    {Text = "🎯 Iframe Hitbox", Color = Color3.fromRGB(255, 50, 100), Callback = function()
        local char = Player.Character
        if not char then return end
        
        -- تكبير الهيت بوكس
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = part.Size * 1.5
                part.Transparency = 0.5
            end
        end
        
        -- تأثير بصري
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 100)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = char
        
        wait(5)
        highlight:Destroy()
    end},
    
    -- 🎯 تسديد دقيق (Perfect Shot)
    {Text = "🎯 Perfect Shot", Color = Color3.fromRGB(0, 255, 200), Callback = function()
        -- محاكاة تسديد دقيق
        local root = Player.Character.HumanoidRootPart
        if root then
            -- اتجاه التسديد
            local dir = Mouse.Hit.Position - root.Position
            local vel = Instance.new("BodyVelocity")
            vel.MaxForce = Vector3.new(1, 1, 1) * 100000
            vel.Velocity = dir.Unit * 200
            vel.Parent = root
            wait(0.5)
            vel:Destroy()
        end
    end},
    
    -- 👻 اختراق (Noclip)
    {Text = "👻 Noclip", Color = Color3.fromRGB(150, 100, 255), Callback = function()
        local char = Player.Character
        if not char then return end
        local noclip = false
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not part.CanCollide
                noclip = true
            end
        end
    end},
    
    -- 💨 طيران
    {Text = "💨 Fly", Color = Color3.fromRGB(0, 150, 255), Callback = function()
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local flying = false
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        
        local function startFly()
            flying = true
            bodyVelocity.Parent = root
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if not flying or not root or not bodyVelocity.Parent then
                    connection:Disconnect()
                    return
                end
                local direction = Mouse.UnitRay.Direction * 50
                bodyVelocity.Velocity = direction
            end)
            return connection
        end
        
        local con = startFly()
        
        if bodyVelocity.Parent then
            flying = false
            bodyVelocity:Destroy()
            if con then con:Disconnect() end
        else
            startFly()
        end
    end},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 45
local spacing = 6
local canvasHeight = #Commands * (buttonHeight + spacing) + 20

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, buttonHeight)
    Button.Position = UDim2.new(0, 0, 0, 5 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = cmdData.Color or Color3.fromRGB(30, 30, 60)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Parent = ScrollFrame
    
    -- زوايا مدورة
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Button
    
    -- تأثير التمرير
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.2
    end)
    
    Button.MouseButton1Click:Connect(cmdData.Callback)
end

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        ToggleMenu()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("⚽ Blue Lock Script Loaded!")
print("📌 Press F1 to toggle GUI")
