-- ============================================
-- ⚽ BALL DESTROYER SCRIPT ⚽
-- سبام الكرة تحت الأرض + تضخيم
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

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

-- تحديث الكرة
Ball = findBall()

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallDestroyerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
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
Stroke.Color = Color3.fromRGB(255, 50, 50)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💀 BALL DESTROYER"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
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
        Title.Visible = false
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = false
            end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 150),
            Position = UDim2.new(0.5, -100, 0.5, -75),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        Title.Visible = true
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= Title and child ~= CloseBtn then
                child.Visible = true
            end
        end
    end
end

CloseBtn.MouseButton1Click:Connect(toggleMinimize)

-- ============================================
-- 📜 إطار التمرير
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)

-- ============================================
-- 💀 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 50, 50)
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
-- 💀 1️⃣ سبام الكرة تحت الأرض
-- ============================================
local isSinking = false
local sinkConnection = nil

local function toggleSink()
    isSinking = not isSinking
    
    if isSinking then
        Ball = findBall()
        if not Ball then
            showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
            isSinking = false
            return
        end
        
        showNotification("⬇️ جاري إغراق الكرة تحت الأرض!", Color3.fromRGB(255, 0, 100))
        
        sinkConnection = RunService.Heartbeat:Connect(function()
            if not isSinking then return end
            
            Ball = findBall()
            if not Ball then return end
            
            -- 🛠️ إزالة القيود
            pcall(function()
                for _, child in pairs(Ball:GetChildren()) do
                    if child:IsA("Weld") or child:IsA("Attachment") or child:IsA("Constraint") then
                        child:Destroy()
                    end
                end
            end)
            
            -- ⬇️ إنزال الكرة تحت الأرض
            pcall(function()
                Ball.Position = Ball.Position + Vector3.new(0, -5, 0)
                Ball.CFrame = CFrame.new(Ball.Position)
                Ball.Anchored = false
                Ball.CanCollide = true
                
                -- ندفع الكرة للأسفل بقوة
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(0, 1, 0) * 100000
                bv.Velocity = Vector3.new(0, -100, 0)
                bv.Parent = Ball
                game:GetService("Debris"):AddItem(bv, 0.1)
            end)
        end)
    else
        if sinkConnection then
            sinkConnection:Disconnect()
            sinkConnection = nil
        end
        showNotification("⏹ تم إيقاف إغراق الكرة", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 💀 2️⃣ تضخيم الكرة
-- ============================================
local isGiant = false
local giantConnection = nil

local function toggleGiant()
    isGiant = not isGiant
    
    if isGiant then
        Ball = findBall()
        if not Ball then
            showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
            isGiant = false
            return
        end
        
        showNotification("🐘 جاري تضخيم الكرة!", Color3.fromRGB(255, 200, 0))
        
        giantConnection = RunService.Heartbeat:Connect(function()
            if not isGiant then return end
            
            Ball = findBall()
            if not Ball then return end
            
            -- تكبير الكرة بشكل تدريجي
            pcall(function()
                Ball.Size = Vector3.new(50, 50, 50)
                Ball.Transparency = 0.3
                Ball.BrickColor = BrickColor.new("Bright red")
                Ball.Material = Enum.Material.Neon
                
                -- تأثير ضوئي
                local pointLight = Instance.new("PointLight")
                pointLight.Color = Color3.fromRGB(255, 0, 0)
                pointLight.Range = 30
                pointLight.Brightness = 5
                pointLight.Parent = Ball
                game:GetService("Debris"):AddItem(pointLight, 0.2)
            end)
        end)
    else
        if giantConnection then
            giantConnection:Disconnect()
            giantConnection = nil
        end
        -- إعادة الكرة لحجمها الطبيعي
        Ball = findBall()
        if Ball then
            pcall(function()
                Ball.Size = Vector3.new(2, 2, 2)
                Ball.Transparency = 0
                Ball.BrickColor = BrickColor.new("White")
                Ball.Material = Enum.Material.Plastic
            end)
        end
        showNotification("⏹ تم إيقاف تضخيم الكرة", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "⬇️ إغراق الكرة تحت الأرض", Callback = toggleSink},
    {Text = "🐘 تضخيم الكرة", Callback = toggleGiant},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 45
local spacing = 6
local canvasHeight = #Commands * (buttonHeight + spacing) + 10

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollFrame
    Button.Size = UDim2.new(1, -10, 0, buttonHeight)
    Button.Position = UDim2.new(0, 5, 0, 2 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = Color3.fromRGB(60, 20, 40)
    Button.BackgroundTransparency = 0.3
    Button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.3
    end)
    
    Button.MouseButton1Click:Connect(cmdData.Callback)
end

-- ============================================
-- ⌨️ اختصارات
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleMinimize()
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        toggleSink()
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        toggleGiant()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
Ball = findBall()
if Ball then
    print("💀 Ball Destroyer Script Loaded! Ball found: " .. Ball.Name)
    showNotification("💀 جاهز! G = إغراق | H = تضخيم", Color3.fromRGB(255, 50, 50))
else
    print("💀 Ball Destroyer Script Loaded! Ball not found.")
    showNotification("⚠️ الكرة غير موجودة!", Color3.fromRGB(255, 200, 0))
end
print("📌 Press G to sink ball")
print("📌 Press H to giant ball")
print("📌 Press F1 to toggle GUI")
