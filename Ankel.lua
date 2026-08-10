-- ============================================
-- 👹 DEMON ANKLE BREAKER SCRIPT 👹
-- سبام حركة الأنكل بريكر على جميع اللاعبين
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- ============================================
-- 🔍 البحث عن Remote Events الخاصة بالحركات
-- ============================================

local function findAbilityRemote()
    -- Remote Events المحتملة لحركات الأنكل بريكر
    local possibleRemotes = {
        "Ability",
        "UseAbility",
        "Skill",
        "ActivateSkill",
        "Dribble",
        "AnkleBreaker",
        "Malice",
        "VMagic",
        "LionChop",
        "RisingDance"
    }
    
    for _, name in ipairs(possibleRemotes) do
        local remote = ReplicatedStorage:FindFirstChild(name) 
            or ReplicatedStorage:FindFirstChild(name .. "Remote")
            or game:GetService("ReplicatedStorage"):FindFirstChild(name)
        
        if remote and remote:IsA("RemoteEvent") then
            return remote
        end
    end
    
    -- البحث العميق في ReplicatedStorage
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") and (
            child.Name:lower():find("ability") or
            child.Name:lower():find("skill") or
            child.Name:lower():find("dribble") or
            child.Name:lower():find("tackle")
        ) then
            return child
        end
    end
    
    return nil
end

local abilityRemote = findAbilityRemote()

-- ============================================
-- 🎨 الواجهة الزجاجية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DemonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 280)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
Stroke.Color = Color3.fromRGB(255, 50, 50)
Stroke.Thickness = 1.5
Stroke.Transparency = 0.5

-- ============================================
-- 📌 شريط العنوان
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👹 ANKLE BREAKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
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
    if isVisible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 280),
            BackgroundTransparency = 0.15
        }):Play()
        CloseBtn.Text = "✕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = true end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 45, 0, 45),
            BackgroundTransparency = 0.3
        }):Play()
        CloseBtn.Text = "⊕"
        for _, child in pairs(MainFrame:GetChildren()) do
            if child ~= TitleBar then child.Visible = false end
        end
    end
end)

local Line = Instance.new("Frame")
Line.Parent = MainFrame
Line.Size = UDim2.new(0.85, 0, 0, 1.5)
Line.Position = UDim2.new(0.075, 0, 0, 35)
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BackgroundTransparency = 0.5
Line.BorderSizePixel = 0

-- ============================================
-- 📜 إطار التمرير
-- ============================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)

-- ============================================
-- 💀 دالة الإشعارات
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
    
    game:GetService("Debris"):AddItem(notif, 2.5)
end

-- ============================================
-- 🔥 أوامر الأنكل بريكر
-- ============================================

local isSpamming = false
local spamConnection = nil

-- 1️⃣ سبام الأنكل بريكر على الكل
local function spamAnkleBreaker()
    isSpamming = not isSpamming
    
    if isSpamming then
        if not abilityRemote then
            showNotification("❌ لم يتم العثور على Remote Event!", Color3.fromRGB(255, 0, 0))
            isSpamming = false
            return
        end
        
        showNotification("👹 جاري سبام الأنكل بريكر على الكل!", Color3.fromRGB(255, 50, 50))
        
        spamConnection = RunService.Heartbeat:Connect(function()
            -- إرسال الأمر لكل لاعب في السيرفر
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player then
                    -- محاولة إرسال الأمر بطرق مختلفة
                    pcall(function()
                        -- الطريقة الأولى: إرسال مباشر
                        abilityRemote:FireServer(plr)
                    end)
                    pcall(function()
                        -- الطريقة الثانية: إرسال مع بيانات إضافية
                        abilityRemote:FireServer("Use", plr)
                    end)
                    pcall(function()
                        -- الطريقة الثالثة: إرسال مع موضع اللاعب
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            abilityRemote:FireServer(root.Position, plr)
                        end
                    end)
                end
            end
        end)
    else
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
        showNotification("⏹ تم إيقاف السبام!", Color3.fromRGB(255, 200, 0))
    end
end

-- 2️⃣ كشف Remote Events في اللعبة
local function scanRemotes()
    showNotification("🔍 جاري البحث عن Remote Events...", Color3.fromRGB(0, 200, 255))
    
    local found = {}
    for _, container in pairs({ReplicatedStorage, game:GetService("ReplicatedStorage")}) do
        for _, child in pairs(container:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(found, child.Name)
            end
        end
    end
    
    if #found > 0 then
        showNotification("✅ تم العثور على " .. #found .. " Remote Events!", Color3.fromRGB(0, 200, 100))
        print("📡 Remote Events found:")
        for _, name in ipairs(found) do
            print("  - " .. name)
        end
    else
        showNotification("❌ لم يتم العثور على Remote Events!", Color3.fromRGB(255, 0, 0))
    end
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "👹 سبام الأنكل بريكر", Callback = spamAnkleBreaker},
    {Text = "🔍 كشف Remote Events", Callback = scanRemotes},
}

-- ============================================
-- 🎨 إنشاء الأزرار
-- ============================================
local buttonHeight = 40
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
    Button.BackgroundColor3 = Color3.fromRGB(60, 30, 60)
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
        isVisible = not isVisible
        if isVisible then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 280),
                BackgroundTransparency = 0.15
            }):Play()
            CloseBtn.Text = "✕"
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then child.Visible = true end
            end
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 45, 0, 45),
                BackgroundTransparency = 0.3
            }):Play()
            CloseBtn.Text = "⊕"
            for _, child in pairs(MainFrame:GetChildren()) do
                if child ~= TitleBar then child.Visible = false end
            end
        end
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("👹 Demon Ankle Breaker Script Loaded!")
print("📌 Press F1 to toggle GUI")

if abilityRemote then
    showNotification("✅ تم العثور على Remote: " .. abilityRemote.Name, Color3.fromRGB(0, 200, 100))
else
    showNotification("⚠️ لم يتم العثور على Remote، استخدم 'كشف Remote Events'", Color3.fromRGB(255, 200, 0))
end
