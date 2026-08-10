-- ============================================
-- ⚽ BALL TELEPORT SCRIPT ⚽
-- جلب الكرة إليك بضغطة زر
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- ============================================
-- 🔍 إيجاد الكرة
-- ============================================
local Ball = nil

local function findBall()
    local ballNames = {"Ball", "ball", "Football", "SoccerBall"}
    for _, name in ipairs(ballNames) do
        local found = Workspace:FindFirstChild(name)
        if found and found:IsA("BasePart") then
            return found
        end
    end
    
    for _, child in pairs(Workspace:GetChildren()) do
        if child:IsA("BasePart") and child.Name:lower():find("ball") then
            return child
        end
    end
    return nil
end

Ball = findBall()

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallTeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 180, 0, 100)
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
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
Stroke.Color = Color3.fromRGB(255, 200, 0)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "⚽ BALL TELEPORT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
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

-- ============================================
-- 🎯 زر جلب الكرة
-- ============================================
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Parent = MainFrame
TeleportBtn.Size = UDim2.new(0.8, 0, 0, 40)
TeleportBtn.Position = UDim2.new(0.1, 0, 0, 45)
TeleportBtn.Text = "🔄 جلب الكرة"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.TextScaled = true
TeleportBtn.Font = Enum.Font.GothamBold
TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TeleportBtn.BackgroundTransparency = 0.3
TeleportBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = TeleportBtn

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
-- 🔥 وظيفة جلب الكرة
-- ============================================
local function teleportBall()
    if not Ball then
        Ball = findBall()
        if not Ball then
            showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 0, 0))
            return
        end
    end
    
    local char = Player.Character
    if not char then
        showNotification("❌ لم يتم العثور على شخصيتك!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        showNotification("❌ لم يتم العثور على Root!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    -- نقل الكرة إلى اللاعب
    local targetPos = root.Position + Vector3.new(0, 3, 0)
    
    -- تأثير انتقال سلس
    TweenService:Create(Ball, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()
    
    -- تغيير مكان الكرة فوراً
    Ball.Position = targetPos
    Ball.Anchored = false
    Ball.CanCollide = true
    
    showNotification("✅ تم جلب الكرة إليك!", Color3.fromRGB(0, 200, 100))
end

TeleportBtn.MouseButton1Click:Connect(teleportBall)

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
    
    -- زر G عشان جلب الكرة
    if input.KeyCode == Enum.KeyCode.G then
        teleportBall()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
Ball = findBall()
if Ball then
    print("⚽ Ball Teleport Script Loaded! Ball found: " .. Ball.Name)
    showNotification("✅ تم العثور على الكرة! اضغط G أو زر جلب", Color3.fromRGB(0, 200, 100))
else
    print("⚽ Ball Teleport Script Loaded! Ball not found.")
    showNotification("⚠️ لم يتم العثور على الكرة!", Color3.fromRGB(255, 200, 0))
end
print("📌 Press G to teleport ball")
print("📌 Press F1 to toggle GUI")
