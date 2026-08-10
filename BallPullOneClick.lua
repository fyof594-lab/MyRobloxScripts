-- ============================================
-- ⚽ BALL PULL ONE CLICK ⚽
-- جلب الكرة بضغطة زر واحدة
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ============================================
-- 🔍 إيجاد الكرة (أحدث طريقة)
-- ============================================
local Ball = nil

local function findBall()
    -- البحث في Workspace كامل
    local allParts = Workspace:GetDescendants()
    for _, part in pairs(allParts) do
        if part:IsA("BasePart") and part.Name:lower():find("ball") then
            return part
        end
    end
    
    -- البحث المباشر بأسماء معروفة
    local ballNames = {"Ball", "ball", "Football", "SoccerBall", "BALL"}
    for _, name in ipairs(ballNames) do
        local found = Workspace:FindFirstChild(name)
        if found and found:IsA("BasePart") then
            return found
        end
    end
    
    return nil
end

-- تحديث الكرة
Ball = findBall()

-- ============================================
-- 🎨 الواجهة
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
-- 🔥 وظيفة جلب الكرة (ضغطة واحدة)
-- ============================================
local function pullBall()
    -- البحث عن الكرة
    Ball = findBall()
    
    if not Ball then
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local char = Player.Character
    if not char then
        showNotification("❌ شخصيتك غير موجودة!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        showNotification("❌ Root غير موجود!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    -- موقع الكرة الجديد (عند اللاعب)
    local targetPos = root.Position + Vector3.new(0, 3, 0)
    
    -- 🛠️ إزالة القيود (Weld, Attachment, Constraints)
    pcall(function()
        for _, child in pairs(Ball:GetChildren()) do
            if child:IsA("Weld") or child:IsA("Attachment") or child:IsA("Constraint") or child:IsA("WeldConstraint") then
                child:Destroy()
            end
        end
    end)
    
    -- تحرير الكرة
    pcall(function()
        Ball.Anchored = false
        Ball.CanCollide = true
        Ball.Parent = Workspace
    end)
    
    -- 🎯 تغيير موقع الكرة بثلاث طرق مختلفة
    local success = false
    
    -- الطريقة 1: تغيير الموقع مباشرة
    pcall(function()
        Ball.Position = targetPos
        success = true
    end)
    
    -- الطريقة 2: تغيير CFrame
    pcall(function()
        Ball.CFrame = CFrame.new(targetPos)
        success = true
    end)
    
    -- الطريقة 3: Tween (حركة سلسة)
    pcall(function()
        TweenService:Create(Ball, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos
        }):Play()
        success = true
    end)
    
    -- الطريقة 4: BodyVelocity (دفع الكرة)
    pcall(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1, 1, 1) * 100000
        bv.Velocity = (targetPos - Ball.Position).Unit * 100
        bv.Parent = Ball
        game:GetService("Debris"):AddItem(bv, 0.5)
        success = true
    end)
    
    if success then
        showNotification("✅ تم جلب الكرة!", Color3.fromRGB(0, 200, 100))
    else
        showNotification("❌ فشل جلب الكرة!", Color3.fromRGB(255, 0, 0))
    end
end

PullBtn.MouseButton1Click:Connect(pullBall)

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        pullBall()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
Ball = findBall()
if Ball then
    print("⚽ Ball Pull One Click Loaded! Ball found: " .. Ball.Name)
    showNotification("✅ جاهز! اضغط G لجلب الكرة", Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Pull One Click Loaded! Ball not found.")
    showNotification("⚠️ الكرة غير موجودة!", Color3.fromRGB(255, 200, 0))
end
print("📌 Press G to pull ball")
print("📌 Press F1 to toggle GUI")
