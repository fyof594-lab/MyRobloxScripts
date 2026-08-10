-- ============================================
-- 🎰 LUCKY SPINS SCRIPT 🎰
-- يعطيك Lucky Spins كثيرة
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ============================================
-- 🔍 العثور على Remote الـ Spins
-- ============================================
local SpinRemote = nil

for _, child in pairs(ReplicatedStorage:GetChildren()) do
    if child:IsA("RemoteEvent") then
        local name = child.Name:lower()
        if name:find("spin") or name:find("roll") or name:find("gacha") or name:find("lucky") then
            SpinRemote = child
            print("✅ تم العثور على Remote: " .. child.Name)
            break
        end
    end
end

-- ============================================
-- 🎨 الواجهة
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LuckySpinsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 200, 0, 200)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
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
Stroke.Color = Color3.fromRGB(255, 215, 0)
Stroke.Thickness = 2
Stroke.Transparency = 0.3

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 5, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎰 LUCKY SPINS"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
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
            Size = UDim2.new(0, 200, 0, 200),
            Position = UDim2.new(0.5, -100, 0.5, -100),
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
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)

-- ============================================
-- 💀 دالة الإشعار
-- ============================================
function showNotification(text, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = color or Color3.fromRGB(255, 215, 0)
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
-- 🎰 1️⃣ سبام Spins (كثيرة)
-- ============================================
local isSpinning = false
local spinConnection = nil
local spinCount = 0

local function toggleSpins()
    isSpinning = not isSpinning
    
    if isSpinning then
        if not SpinRemote then
            showNotification("❌ لم يتم العثور على Remote!", Color3.fromRGB(255, 0, 0))
            isSpinning = false
            return
        end
        
        spinCount = 0
        showNotification("🎰 جاري اللف! اضغط مرة ثانية عشان توقف", Color3.fromRGB(255, 215, 0))
        
        spinConnection = RunService.Heartbeat:Connect(function()
            if not isSpinning then return end
            
            -- إرسال أمر اللف بطرق مختلفة
            pcall(function()
                SpinRemote:FireServer()
                spinCount = spinCount + 1
            end)
            pcall(function()
                SpinRemote:FireServer("Spin")
                spinCount = spinCount + 1
            end)
            pcall(function()
                SpinRemote:FireServer("Roll")
                spinCount = spinCount + 1
            end)
            pcall(function()
                SpinRemote:FireServer("LuckySpin")
                spinCount = spinCount + 1
            end)
            pcall(function()
                SpinRemote:FireServer(Player)
                spinCount = spinCount + 1
            end)
        end)
    else
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
        showNotification("⏹ تم إيقاف اللف! عدد اللفات: " .. spinCount, Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🎰 2️⃣ Spin مرة واحدة
-- ============================================
local function singleSpin()
    if not SpinRemote then
        showNotification("❌ لم يتم العثور على Remote!", Color3.fromRGB(255, 0, 0))
        return
    end
    
    local success = false
    
    pcall(function()
        SpinRemote:FireServer()
        success = true
    end)
    
    if not success then
        pcall(function()
            SpinRemote:FireServer("Spin")
            success = true
        end)
    end
    
    if not success then
        pcall(function()
            SpinRemote:FireServer("Roll")
            success = true
        end)
    end
    
    if success then
        showNotification("✅ تم اللف!", Color3.fromRGB(0, 200, 100))
    else
        showNotification("❌ فشل اللف!", Color3.fromRGB(255, 0, 0))
    end
end

-- ============================================
-- 🔍 عرض الـ Remotes
-- ============================================
local function showRemotes()
    print("📡 قائمة Remote Events:")
    local found = 0
    for _, child in pairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") then
            found = found + 1
            print(found .. ". " .. child.Name)
        end
    end
    showNotification("✅ تم عرض " .. found .. " Remote في Console!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "🎰 سبام Spins (كثيرة)", Callback = toggleSpins},
    {Text = "🎰 Spin مرة واحدة", Callback = singleSpin},
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
    Button.BackgroundColor3 = Color3.fromRGB(60, 40, 20)
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
        toggleSpins()
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        singleSpin()
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
if SpinRemote then
    print("🎰 Lucky Spins Script Loaded! Remote found: " .. SpinRemote.Name)
    showNotification("✅ جاهز! G = سبام Spins | H = Spin مرة", Color3.fromRGB(255, 215, 0))
else
    print("🎰 Lucky Spins Script Loaded! No Remote found.")
    showNotification("⚠️ لم يتم العثور على Remote! استخدم 'عرض الـ Remotes'", Color3.fromRGB(255, 200, 0))
end
print("📌 Press G = Spam Spins")
print("📌 Press H = Single Spin")
print("📌 Press F1 to toggle GUI")
