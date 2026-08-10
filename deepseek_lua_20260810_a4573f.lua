-- ============================================
-- 🔥 SUPER ADMIN PANEL v2.0 🔥
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- 🎨 إنشاء الواجهة الرئيسية
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperAdminGUI"
ScreenGui.Parent = Player.PlayerGui

-- الخلفية الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- زوايا مدورة (UI Corner)
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- عنوان الواجهة
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.BackgroundTransparency = 0.3
Title.Text = "⚡ SUPER ADMIN v2.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextScaled = true
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ScrollingFrame للأزرار
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

-- ============================================
-- 🎮 قائمة الأوامر (الوظائف)
-- ============================================
local Commands = {
    -- 🪄 الطيران
    {Text = "🪄 Fly", Color = Color3.fromRGB(0, 150, 255), Callback = function()
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
        
        -- إيقاف الطيران عند الضغط مرة أخرى أو الخروج
        local function stopFly()
            flying = false
            bodyVelocity:Destroy()
            if con then con:Disconnect() end
        end
        
        -- تشغيل/إيقاف بالضغط على الزر
        if bodyVelocity.Parent then
            stopFly()
        else
            startFly()
        end
    end},
    
    -- 💀 قتل النفس
    {Text = "💀 Kill", Color = Color3.fromRGB(255, 50, 50), Callback = function()
        Player.Character.Humanoid.Health = 0
    end},
    
    -- 🏃 السرعة
    {Text = "🏃 Speed x2", Color = Color3.fromRGB(255, 200, 50), Callback = function()
        local h = Player.Character.Humanoid
        if h.WalkSpeed == 16 then
            h.WalkSpeed = 50
        else
            h.WalkSpeed = 16
        end
    end},
    
    -- 🦘 قفز لا نهائي
    {Text = "🦘 Infinite Jump", Color = Color3.fromRGB(100, 255, 100), Callback = function()
        local h = Player.Character.Humanoid
        h:AddAccessory(Instance.new("Accessory"))
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(0, 1, 0) * 100000
        bv.Velocity = Vector3.new(0, 60, 0)
        bv.Parent = h.Parent.HumanoidRootPart
        wait(0.5)
        bv:Destroy()
    end},
    
    -- ❄️ تجميد الكل
    {Text = "❄️ Freeze All", Color = Color3.fromRGB(100, 200, 255), Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
                if h then
                    h.WalkSpeed = 0
                    h.JumpPower = 0
                end
            end
        end
    end},
    
    -- 🔥 تفجير الكل
    {Text = "💥 Explode All", Color = Color3.fromRGB(255, 100, 0), Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player then
                local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local exp = Instance.new("Explosion")
                    exp.Position = root.Position
                    exp.Parent = workspace
                end
            end
        end
    end},
    
    -- 💚 شفاء الكل
    {Text = "💚 Heal All", Color = Color3.fromRGB(50, 255, 50), Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            local h = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if h then
                h.Health = h.MaxHealth
            end
        end
    end},
    
    -- 🛡️ حماية (Godmode)
    {Text = "🛡️ Godmode", Color = Color3.fromRGB(200, 150, 255), Callback = function()
        local h = Player.Character.Humanoid
        if h.MaxHealth == h.Health then
            h.MaxHealth = 999999
            h.Health = 999999
        else
            h.MaxHealth = 100
            h.Health = 100
        end
    end},
    
    -- 👻 اختراق الجدران (Noclip)
    {Text = "👻 Noclip", Color = Color3.fromRGB(150, 100, 255), Callback = function()
        local char = Player.Character
        if not char then return end
        local noclip = false
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not part.CanCollide
                noclip = true
            end
        end
        
        -- تأثير بصري
        if noclip then
            print("Noclip: ON")
        else
            print("Noclip: OFF")
        end
    end},
    
    -- 🌐 نقل إلى موقع عشوائي
    {Text = "🌐 Random TP", Color = Color3.fromRGB(100, 200, 200), Callback = function()
        local root = Player.Character.HumanoidRootPart
        local randomPos = Vector3.new(
            math.random(-100, 100),
            math.random(20, 100),
            math.random(-100, 100)
        )
        root.CFrame = CFrame.new(randomPos)
    end},
    
    -- 🔫 مسدس (أداة)
    {Text = "🔫 Give Tool", Color = Color3.fromRGB(255, 150, 50), Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "SuperSword"
        tool.RequiresHandle = true
        local handle = Instance.new("Part")
        handle.Size = Vector3.new(1, 4, 0.5)
        handle.BrickColor = BrickColor.new("Bright red")
        handle.Material = Enum.Material.Neon
        handle.Parent = tool
        tool.Parent = Player.Backpack
    end},
}

-- ============================================
-- 🎨 إنشاء الأزرار في الواجهة
-- ============================================
local buttonHeight = 45
local spacing = 5
local canvasHeight = #Commands * (buttonHeight + spacing) + 10

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, canvasHeight)

for i, cmdData in ipairs(Commands) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, buttonHeight)
    Button.Position = UDim2.new(0.05, 0, 0, 5 + (i-1) * (buttonHeight + spacing))
    Button.Text = cmdData.Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.BackgroundColor3 = cmdData.Color or Color3.fromRGB(60, 60, 80)
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Parent = ScrollFrame
    
    -- زوايا مدورة للأزرار
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
-- ⌨️ اختصارات لوحة المفاتيح
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1 = إظهار/إخفاء الواجهة
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- F2 = الطيران
    if input.KeyCode == Enum.KeyCode.F2 then
        Commands[1].Callback() -- Fly
    end
    
    -- F3 = السرعة
    if input.KeyCode == Enum.KeyCode.F3 then
        Commands[3].Callback() -- Speed
    end
end)

-- ============================================
-- 💬 رسالة ترحيب
-- ============================================
print("⚡ Super Admin v2.0 Loaded!")
print("📌 Press F1 to toggle GUI")
print("📌 Press F2 for Fly")
print("📌 Press F3 for Speed")