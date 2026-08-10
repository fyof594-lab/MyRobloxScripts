-- ============================================
-- ⚽ BLUE LOCK RIVALS SCRIPT ⚽
-- واجهة زجاجية فخمة + أوامر احترافية
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- 🎨 إنشاء الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlueLockGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

-- النافذة الرئيسية (Glassmorphism)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

-- زوايا مدورة
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 20)
Corner.Parent = MainFrame

-- تأثير الزجاج (Blur)
local Blur = Instance.new("BlurEffect")
Blur.Parent = game.Lighting
Blur.Size = 16

-- إطار متوهج
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- ============================================
-- 📌 شريط العنوان مع زر X
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundTransparency = 1
TitleBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚽ BLUE LOCK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- زر X دائري
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
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
    MainFrame.Visible = isVisible
    CloseBtn.Text = isVisible and "✕" or "⊕"
end)

-- خط فاصل
local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.9, 0, 0, 2)
Line.Position = UDim2.new(0.05, 0, 0, 60)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📜 إطار التمرير (ScrollingFrame)
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -20, 1, -70)
ScrollFrame.Position = UDim2.new(0, 10, 0, 65)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)

-- ============================================
-- 🎮 أوامر بلو لوك الاحترافية
-- ============================================
local Commands = {
    -- 🚀 طيران جماعي
    {Text = "🚀 طيران جماعي", Color = Color3.fromRGB(0, 150, 255), Callback = function()
        local isFlying = false
        local flyingPlayers = {}
        
        return function()
            isFlying = not isFlying
            local char = Player.Character
            if not char then return end
            
            if isFlying then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        local otherChar = plr.Character
                        if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = Vector3.new(0, 100, 0)
                            bv.MaxForce = Vector3.new(0, 4000, 0)
                            bv.Parent = otherChar.HumanoidRootPart
                            table.insert(flyingPlayers, bv)
                        end
                    end
                end
                showNotification("✅ تم تشغيل الطيران الجماعي!", Color3.fromRGB(0, 200, 100))
            else
                for _, bv in pairs(flyingPlayers) do
                    if bv and bv.Parent then bv:Destroy() end
                end
                flyingPlayers = {}
                showNotification("⏹ تم إيقاف الطيران", Color3.fromRGB(255, 150, 50))
            end
        end
    end},
    
    -- ⚽ جلب الكرة
    {Text = "⚽ جلب الكرة", Color = Color3.fromRGB(255, 215, 0), Callback = function()
        local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball")
        local char = Player.Character
        if not char or not ball or not ball:FindFirstChild("Handle") then
            showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 50, 50))
            return
        end
        
        local handle = ball.Handle
        local charPos = char.HumanoidRootPart.Position
        handle.CFrame = CFrame.new(charPos + Vector3.new(0, 3, 0))
        
        -- تأثير حركي
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 10, 0)
        bv.MaxForce = Vector3.new(0, 1000, 0)
        bv.Parent = handle
        game:GetService("Debris"):AddItem(bv, 0.5)
        
        showNotification("✅ تم جلب الكرة!", Color3.fromRGB(0, 200, 100))
    end},
    
    -- 🎯 التحكم بالكرة
    {Text = "🎯 التحكم بالكرة", Color = Color3.fromRGB(0, 200, 255), Callback = function()
        local isControlling = false
        local connection = nil
        
        return function()
            isControlling = not isControlling
            local char = Player.Character
            if not char then return end
            
            local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball")
            if not ball or not ball:FindFirstChild("Handle") then
                showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 50, 50))
                isControlling = false
                return
            end
            
            if isControlling then
                local handle = ball.Handle
                connection = RunService.RenderStepped:Connect(function()
                    local targetPos = Mouse.Hit.Position + Vector3.new(0, 10, 0)
                    handle.CFrame = CFrame.new(targetPos)
                end)
                showNotification("🎯 حرك الماوس للتحكم بالكرة!", Color3.fromRGB(0, 200, 255))
            else
                if connection then
                    connection:Disconnect()
                    connection = nil
                end
                showNotification("⏹ تم إيقاف التحكم", Color3.fromRGB(255, 150, 50))
            end
        end
    end},
    
    -- ⚡ سرعة خارقة
    {Text = "⚡ سرعة خارقة", Color = Color3.fromRGB(255, 100, 255), Callback = function()
        local h = Player.Character.Humanoid
        if h.WalkSpeed == 16 then
            h.WalkSpeed = 120
            h.JumpPower = 80
            showNotification("⚡ تم تشغيل السرعة الخارقة!", Color3.fromRGB(255, 100, 255))
        else
            h.WalkSpeed = 16
            h.JumpPower = 50
            showNotification("⏹ تم إيقاف السرعة", Color3.fromRGB(255, 150, 50))
        end
    end},
    
    -- 🎯 Iframe Hitbox
    {Text = "🎯 Iframe Hitbox", Color = Color3.fromRGB(255, 50, 100), Callback = function()
        local char = Player.Character
        if not char then return end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = part.Size * 1.5
                part.Transparency = 0.3
            end
        end
        
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 100)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = char
        
        showNotification("🎯 تم تفعيل Iframe Hitbox!", Color3.fromRGB(255, 50, 100))
        wait(5)
        highlight:Destroy()
    end},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 50
local spacing = 8
local canvasHeight = #Commands * (buttonHeight + spacing) + 20

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollFrame
    Button.Size = UDim2.new(1, 0, 0, buttonHeight)
    Button.Position = UDim2.new(0, 0, 0, 5 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = cmdData.Color or Color3.fromRGB(40, 40, 70)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = Button
    
    -- تأثير التمرير
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.2
    end)
    
    -- حفظ الدالة
    local callback = cmdData.Callback
    if type(callback) == "function" then
        Button.MouseButton1Click:Connect(callback)
    end
end

-- ============================================
-- 💬 دالة الإشعارات (Notification)
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 350, 0, 45)
    notif.Position = UDim2.new(0.5, -175, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 200, 100)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 3)
end

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        isVisible = not isVisible
        MainFrame.Visible = isVisible
        CloseBtn.Text = isVisible and "✕" or "⊕"
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("⚽ Blue Lock Script Loaded!")
print("📌 Press F1 to toggle GUI")
showNotification("🔥 تم تحميل سكربت بلو لوك!", Color3.fromRGB(0, 200, 255))
