-- ============================================
-- 👹 ANKLE BREAKER v4 - ENCRYPTED 👹
-- مع تشويش عشان يخفي السبام
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- ============================================
-- 🔐 تشفير البيانات (تمويه)
-- ============================================
local function encrypt(data)
    local encoded = ""
    for i = 1, #data do
        local char = string.byte(data, i)
        char = char + 3
        encoded = encoded .. string.char(char)
    end
    return encoded
end

local function decrypt(data)
    local decoded = ""
    for i = 1, #data do
        local char = string.byte(data, i)
        char = char - 3
        decoded = decoded .. string.char(char)
    end
    return decoded
end

-- ============================================
-- 🔍 جمع Remote Events
-- ============================================
local allRemotes = {}
for _, container in pairs({ReplicatedStorage, game:GetService("ReplicatedStorage")}) do
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("RemoteEvent") then
            table.insert(allRemotes, child)
        end
    end
end

print("🔍 تم العثور على " .. #allRemotes .. " Remote Events")
for i, remote in ipairs(allRemotes) do
    print(i .. ". " .. remote.Name)
end

-- ============================================
-- 🎨 الواجهة الزجاجية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnkleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
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
            Size = UDim2.new(0, 220, 0, 320),
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
-- 🔥 سبام الأنكل بريكر (مشفر ومخفي)
-- ============================================

local isSpamming = false
local spamConnection = nil
local randomDelay = 0

-- دالة لإرسال Remote بشكل عشوائي ومخفي
local function sendHiddenRemote(remote, target)
    -- تمويه: نرسل أوامر فارغة عشان نشوش
    for i = 1, math.random(1, 3) do
        pcall(function()
            local fakeRemote = allRemotes[math.random(1, #allRemotes)]
            if fakeRemote and fakeRemote ~= remote then
                fakeRemote:FireServer()
            end
        end)
    end
    
    -- إرسال الأمر الحقيقي ولكن بتأخير عشوائي
    task.wait(math.random(1, 5) / 100)
    pcall(function()
        remote:FireServer(target)
    end)
end

local function spamAnkleBreaker()
    isSpamming = not isSpamming
    
    if isSpamming then
        if #allRemotes == 0 then
            showNotification("❌ لا يوجد Remote Events!", Color3.fromRGB(255, 0, 0))
            isSpamming = false
            return
        end
        
        showNotification("👹 جاري السبام المشفر...", Color3.fromRGB(255, 50, 50))
        randomDelay = 0.5 + math.random() * 0.3
        
        spamConnection = RunService.Heartbeat:Connect(function()
            -- تأخير عشوائي بين الإرسال
            if math.random() < 0.3 then
                local remote = allRemotes[math.random(1, #allRemotes)]
                
                -- اختيار لاعب عشوائي
                local players = {}
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= Player then
                        table.insert(players, plr)
                    end
                end
                
                if #players > 0 then
                    local target = players[math.random(1, #players)]
                    sendHiddenRemote(remote, target)
                    
                    -- إرسال لعدد من اللاعبين بشكل عشوائي
                    if math.random() < 0.2 then
                        local secondTarget = players[math.random(1, #players)]
                        if secondTarget ~= target then
                            task.wait(math.random(1, 3) / 100)
                            sendHiddenRemote(remote, secondTarget)
                        end
                    end
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

-- ============================================
-- 📋 قائمة الأوامر
-- ============================================
local Commands = {
    {Text = "👹 سبام مشفر", Callback = spamAnkleBreaker},
    {Text = "📡 عرض الـ Remotes", Callback = function()
        print("📡 قائمة Remote Events:")
        for i, remote in ipairs(allRemotes) do
            print(i .. ". " .. remote.Name)
        end
        showNotification("✅ تم عرض " .. #allRemotes .. " Remote في Console!", Color3.fromRGB(0, 200, 100))
    end},
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
                Size = UDim2.new(0, 220, 0, 320),
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
print("👹 Ankle Breaker v4 (Encrypted) Loaded!")
print("📌 Press F1 to toggle GUI")
print("📡 تم العثور على " .. #allRemotes .. " Remote Events")
showNotification("✅ جاهز! سبام مشفر وآمن", Color3.fromRGB(0, 200, 100))
