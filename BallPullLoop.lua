-- ============================================
-- ⚽ BALL PULL LOOP ⚽
-- يجلب الكرة إليك بقوة (حتى لو متحكمة)
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🔍 إيجاد الكرة
-- ============================================
local Ball = nil

local function findBall()
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("BasePart") and child.Name:lower():find("ball") then
            return child
        end
    end
    return nil
end

Ball = findBall()

-- ============================================
-- 🎨 الواجهة (مختصرة للسرعة)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallPullGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
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
Stroke.Color = Color3.fromRGB(255, 200, 0)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚽ PULL BALL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 3)
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
            Size = UDim2.new(0, 45, 0, 45),
            Position = UDim2.new(0, 10, 0.5, -22.5),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        CloseBtn.Size = UDim2.new(0, 35, 0, 35)
        CloseBtn.Position = UDim2.new(0, 5, 0, 5)
        Title.Visible = false
        PullBtn.Visible = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 180, 0, 100),
            Position = UDim2.new(0.5, -90, 0.5, -50),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        CloseBtn.Size = UDim2.new(0, 28, 0, 28)
        CloseBtn.Position = UDim2.new(1, -34, 0, 3)
        Title.Visible = true
        PullBtn.Visible = true
    end
end

CloseBtn.MouseButton1Click:Connect(toggleMinimize)

local PullBtn = Instance.new("TextButton")
PullBtn.Parent = MainFrame
PullBtn.Size = UDim2.new(0.8, 0, 0, 40)
PullBtn.Position = UDim2.new(0.1, 0, 0, 45)
PullBtn.Text = "🔄 جلب الكرة"
PullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PullBtn.TextScaled = true
PullBtn.Font = Enum.Font.GothamBold
PullBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
PullBtn.BackgroundTransparency = 0.3
PullBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = PullBtn

-- ============================================
-- 💀 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 150, 255)
    notif.BackgroundTransparency = 0.2
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextScaled = true
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 2)
end

-- ============================================
-- 🔥 وظيفة جلب الكرة (باستخدام Loop)
-- ============================================
local isPulling = false
local pullConnection = nil

local function startPulling()
    if isPulling then
        -- إيقاف الجلب
        isPulling = false
        if pullConnection then
            pullConnection:Disconnect()
            pullConnection = nil
        end
        PullBtn.Text = "🔄 جلب الكرة"
        PullBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        showNotification("⏹ تم إيقاف جلب الكرة", Color3.fromRGB(255, 200, 0))
        return
    end
    
    Ball = findBall()
    if not Ball then
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    isPulling = true
    PullBtn.Text = "⏹ إيقاف الجلب"
    PullBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    showNotification("⚽ جاري جلب الكرة بقوة!", Color3.fromRGB(0, 200, 255))
    
    -- 🔄 الضغط المستمر على مكان الكرة
    pullConnection = RunService.Heartbeat:Connect(function()
        if not isPulling then return end
        
        -- تحديث الكرة باستمرار
        Ball = findBall()
        if not Ball then return end
        
        local char = Player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local targetPos = root.Position + Vector3.new(0, 3, 0)
        
        -- 🔥 تغيير مكان الكرة بقوة (كل إطار)
        pcall(function()
            Ball.Position = targetPos
            Ball.CFrame = CFrame.new(targetPos)
            Ball.Velocity = Vector3.new(0, 0, 0)
            Ball.RotVelocity = Vector3.new(0, 0, 0)
        end)
        
        -- إزالة أي وصلات (Welds) بشكل مستمر
        pcall(function()
            for _, child in pairs(Ball:GetChildren()) do
                if child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("Attachment") then
                    child:Destroy()
                end
            end
        end)
        
        -- فك Anchored
        pcall(function()
            Ball.Anchored = false
            Ball.CanCollide = true
        end)
    end)
end

PullBtn.MouseButton1Click:Connect(startPulling)

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        startPulling()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
Ball = findBall()
if Ball then
    print("⚽ Ball Pull Loop Loaded! Ball found: " .. Ball.Name)
    showNotification("✅ اضغط G لجلب الكرة بقوة", Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Pull Loop Loaded! Ball not found.")
    showNotification("⚠️ الكرة غير موجودة!", Color3.fromRGB(255, 200, 0))
end
print("📌 Press G to start/stop pulling ball")
print("📌 Press F1 to toggle GUI")
