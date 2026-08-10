-- ============================================
-- 💀 BALL DESTROYER V2 💀
-- يستخدم Remote Events عشان يخرب
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ============================================
-- 🔍 العثور على Remote Events
-- ============================================
local BallRemote = nil
local allRemotes = {}

-- جمع جميع الـ Remote Events
for _, child in pairs(ReplicatedStorage:GetChildren()) do
    if child:IsA("RemoteEvent") then
        table.insert(allRemotes, child)
        if child.Name:lower():find("ball") or child.Name:lower():find("kick") or child.Name:lower():find("shoot") then
            BallRemote = child
        end
    end
end

print("🔍 تم العثور على " .. #allRemotes .. " Remote Events")

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BallDestroyerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 200)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
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
            Size = UDim2.new(0, 220, 0, 200),
            Position = UDim2.new(0.5, -110, 0.5, -100),
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
-- 💀 1️⃣ سبام Remote Events
-- ============================================
local isSpamming = false
local spamConnection = nil

local function toggleSpam()
    isSpamming = not isSpamming
    
    if isSpamming then
        if #allRemotes == 0 then
            showNotification("❌ لا يوجد Remote Events!", Color3.fromRGB(255, 0, 0))
            isSpamming = false
            return
        end
        
        showNotification("💀 جاري سبام الـ Remotes!", Color3.fromRGB(255, 0, 100))
        
        spamConnection = RunService.Heartbeat:Connect(function()
            if not isSpamming then return end
            
            -- إرسال أوامر عشوائية لكل Remote
            for _, remote in pairs(allRemotes) do
                pcall(function()
                    remote:FireServer()
                end)
                pcall(function()
                    remote:FireServer("Use")
                end)
                pcall(function()
                    remote:FireServer(Player)
                end)
                pcall(function()
                    remote:FireServer("Activate", Player)
                end)
            end
        end)
    else
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
        showNotification("⏹ تم إيقاف السبام", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 💀 2️⃣ تضخيم الكرة (عبر Remote)
-- ============================================
local isGiant = false
local giantConnection = nil

local function toggleGiant()
    isGiant = not isGiant
    
    if isGiant then
        showNotification("🐘 جاري تضخيم الكرة عبر Remote!", Color3.fromRGB(255, 200, 0))
        
        giantConnection = RunService.Heartbeat:Connect(function()
            if not isGiant then return end
            
            -- البحث عن Remote خاص بالكرة وتضخيمها
            for _, remote in pairs(allRemotes) do
                pcall(function()
                    remote:FireServer("Size", 50)
                end)
                pcall(function()
                    remote:FireServer("Giant", true)
                end)
                pcall(function()
                    remote:FireServer("Scale", 10)
                end)
            end
        end)
    else
        if giantConnection then
            giantConnection:Disconnect()
            giantConnection = nil
        end
        -- إعادة الكرة لحجمها الطبيعي عبر Remote
        for _, remote in pairs(allRemotes) do
            pcall(function()
                remote:FireServer("Size", 1)
            end)
            pcall(function()
                remote:FireServer("Giant", false)
            end)
        end
        showNotification("⏹ تم إيقاف تضخيم الكرة", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔍 عرض الـ Remotes
-- ============================================
local function showRemotes()
    print("📡 قائمة Remote Events:")
    for i, remote in ipairs(allRemotes) do
        print(i .. ". " .. remote.Name)
    end
    showNotification("✅ تم عرض " .. #allRemotes .. " Remote في Console!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "💀 سبام Remote Events", Callback = toggleSpam},
    {Text = "🐘 تضخيم الكرة (Remote)", Callback = toggleGiant},
    {Text = "📡 عرض الـ Remotes", Callback = showRemotes},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 40
local spacing = 5
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
        toggleSpam()
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        toggleGiant()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("💀 Ball Destroyer V2 Loaded!")
print("📡 تم العثور على " .. #allRemotes .. " Remote Events")
print("📌 Press G = Spam Remotes")
print("📌 Press H = Giant Ball")
print("📌 Press F1 to toggle GUI")
showNotification("💀 جاهز! G = سبام | H = تضخيم", Color3.fromRGB(255, 50, 50))
