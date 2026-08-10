-- نافذة رئيسية بشفافية زجاجية
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false

-- النافذة الرئيسية
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 360, 0, 500)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- تأثير الزجاج (Glassmorphism)
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 24)

local blur = Instance.new("BlurEffect")
blur.Parent = game.Lighting
blur.Size = 12

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.6

-- عنوان
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ CONTROL PANEL"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.5

-- خط فاصل
local line = Instance.new("Frame")
line.Parent = mainFrame
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 70)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.5
line.BorderSizePixel = 0

-- ==================== الزر الأول: الطيران الجماعي ====================
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = mainFrame
flyBtn.Size = UDim2.new(0.85, 0, 0, 70)
flyBtn.Position = UDim2.new(0.075, 0, 0, 95)
flyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.BackgroundTransparency = 0.2
flyBtn.Text = "🚀 الطيران الجماعي"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.GothamBold
flyBtn.BorderSizePixel = 0

local btnCorner1 = Instance.new("UICorner")
btnCorner1.Parent = flyBtn
btnCorner1.CornerRadius = UDim.new(0, 16)

local btnStroke1 = Instance.new("UIStroke")
btnStroke1.Parent = flyBtn
btnStroke1.Color = Color3.fromRGB(255, 255, 255)
btnStroke1.Thickness = 1
btnStroke1.Transparency = 0.6

-- حالة الزر
local isFlying = false
local flyingPlayers = {}

flyBtn.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    if isFlying then
        flyBtn.Text = "🚀 إيقاف الطيران"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player then
                local otherChar = otherPlayer.Character
                if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Velocity = Vector3.new(0, 150, 0) -- سرعة الصعود
                    bodyVelocity.MaxForce = Vector3.new(0, 4000, 0)
                    bodyVelocity.Parent = otherChar.HumanoidRootPart
                    table.insert(flyingPlayers, bodyVelocity)
                end
            end
        end
    else
        flyBtn.Text = "🚀 الطيران الجماعي"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        flyBtn.BackgroundTransparency = 0.2
        
        for _, vel in pairs(flyingPlayers) do
            if vel and vel.Parent then
                vel:Destroy()
            end
        end
        flyingPlayers = {}
    end
end)

-- ==================== الزر الثاني: جلب الكرة ====================
local ballBtn = Instance.new("TextButton")
ballBtn.Parent = mainFrame
ballBtn.Size = UDim2.new(0.85, 0, 0, 70)
ballBtn.Position = UDim2.new(0.075, 0, 0, 185)
ballBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ballBtn.BackgroundTransparency = 0.2
ballBtn.Text = "⚽ جلب الكرة"
ballBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ballBtn.TextScaled = true
ballBtn.Font = Enum.Font.GothamBold
ballBtn.BorderSizePixel = 0

local btnCorner2 = Instance.new("UICorner")
btnCorner2.Parent = ballBtn
btnCorner2.CornerRadius = UDim.new(0, 16)

local btnStroke2 = Instance.new("UIStroke")
btnStroke2.Parent = ballBtn
btnStroke2.Color = Color3.fromRGB(255, 255, 255)
btnStroke2.Thickness = 1
btnStroke2.Transparency = 0.6

ballBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball")
    if ball and ball:FindFirstChild("Handle") then
        local handle = ball.Handle
        local charPos = character.HumanoidRootPart.Position
        handle.CFrame = CFrame.new(charPos + Vector3.new(0, 3, 0))
        -- إضافة تأثير حركي
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0, 10, 0)
        bodyVel.MaxForce = Vector3.new(0, 1000, 0)
        bodyVel.Parent = handle
        game:GetService("Debris"):AddItem(bodyVel, 0.5)
        
        -- إشعار
        local notif = Instance.new("TextLabel")
        notif.Parent = screenGui
        notif.Size = UDim2.new(0, 300, 0, 50)
        notif.Position = UDim2.new(0.5, -150, 0.1, 0)
        notif.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        notif.BackgroundTransparency = 0.3
        notif.Text = "✅ تم جلب الكرة!"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextScaled = true
        notif.Font = Enum.Font.GothamBold
        notif.BorderSizePixel = 0
        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notif
        notifCorner.CornerRadius = UDim.new(0, 12)
        game:GetService("Debris"):AddItem(notif, 2)
    else
        -- رسالة خطأ إذا لم توجد الكرة
        local notif = Instance.new("TextLabel")
        notif.Parent = screenGui
        notif.Size = UDim2.new(0, 300, 0, 50)
        notif.Position = UDim2.new(0.5, -150, 0.1, 0)
        notif.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        notif.BackgroundTransparency = 0.3
        notif.Text = "❌ لم يتم العثور على الكرة!"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextScaled = true
        notif.Font = Enum.Font.GothamBold
        notif.BorderSizePixel = 0
        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notif
        notifCorner.CornerRadius = UDim.new(0, 12)
        game:GetService("Debris"):AddItem(notif, 2)
    end
end)

-- ==================== الزر الثالث: التحكم بالكرة ====================
local controlBtn = Instance.new("TextButton")
controlBtn.Parent = mainFrame
controlBtn.Size = UDim2.new(0.85, 0, 0, 70)
controlBtn.Position = UDim2.new(0.075, 0, 0, 275)
controlBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
controlBtn.BackgroundTransparency = 0.2
controlBtn.Text = "🎯 التحكم بالكرة"
controlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
controlBtn.TextScaled = true
controlBtn.Font = Enum.Font.GothamBold
controlBtn.BorderSizePixel = 0

local btnCorner3 = Instance.new("UICorner")
btnCorner3.Parent = controlBtn
btnCorner3.CornerRadius = UDim.new(0, 16)

local btnStroke3 = Instance.new("UIStroke")
btnStroke3.Parent = controlBtn
btnStroke3.Color = Color3.fromRGB(255, 255, 255)
btnStroke3.Thickness = 1
btnStroke3.Transparency = 0.6

local isControlling = false
local controlConnection = nil

controlBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    isControlling = not isControlling
    
    if isControlling then
        controlBtn.Text = "🎯 إيقاف التحكم"
        controlBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
        controlBtn.BackgroundTransparency = 0.1
        
        local ball = workspace:FindFirstChild("Ball") or workspace:FindFirstChild("ball")
        if ball and ball:FindFirstChild("Handle") then
            local handle = ball.Handle
            
            -- جعل الكرة تتبع الماوس في السماء
            controlConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local mouse = player:GetMouse()
                local targetPos = mouse.Hit.Position + Vector3.new(0, 10, 0) -- تحليق في السماء
                handle.CFrame = CFrame.new(targetPos)
                
                -- إضافة تأثير طيران للكرة
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.Velocity = Vector3.new(0, 20, 0)
                bodyVel.MaxForce = Vector3.new(0, 2000, 0)
                bodyVel.Parent = handle
                game:GetService("Debris"):AddItem(bodyVel, 0.1)
            end)
            
            -- إشعار
            local notif = Instance.new("TextLabel")
            notif.Parent = screenGui
            notif.Size = UDim2.new(0, 300, 0, 50)
            notif.Position = UDim2.new(0.5, -150, 0.1, 0)
            notif.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
            notif.BackgroundTransparency = 0.3
            notif.Text = "🎯 حرك الماوس للتحكم بالكرة!"
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            notif.TextScaled = true
            notif.Font = Enum.Font.GothamBold
            notif.BorderSizePixel = 0
            local notifCorner = Instance.new("UICorner")
            notifCorner.Parent = notif
            notifCorner.CornerRadius = UDim.new(0, 12)
            game:GetService("Debris"):AddItem(notif, 3)
        else
            isControlling = false
            controlBtn.Text = "🎯 التحكم بالكرة"
            controlBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            controlBtn.BackgroundTransparency = 0.2
            
            local notif = Instance.new("TextLabel")
            notif.Parent = screenGui
            notif.Size = UDim2.new(0, 300, 0, 50)
            notif.Position = UDim2.new(0.5, -150, 0.1, 0)
            notif.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            notif.BackgroundTransparency = 0.3
            notif.Text = "❌ لم يتم العثور على الكرة!"
            notif.TextColor3 = Color3.fromRGB(255, 255, 255)
            notif.TextScaled = true
            notif.Font = Enum.Font.GothamBold
            notif.BorderSizePixel = 0
            local notifCorner = Instance.new("UICorner")
            notifCorner.Parent = notif
            notifCorner.CornerRadius = UDim.new(0, 12)
            game:GetService("Debris"):AddItem(notif, 2)
        end
    else
        controlBtn.Text = "🎯 التحكم بالكرة"
        controlBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        controlBtn.BackgroundTransparency = 0.2
        
        if controlConnection then
            controlConnection:Disconnect()
            controlConnection = nil
        end
        
        -- إشعار
        local notif = Instance.new("TextLabel")
        notif.Parent = screenGui
        notif.Size = UDim2.new(0, 300, 0, 50)
        notif.Position = UDim2.new(0.5, -150, 0.1, 0)
        notif.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        notif.BackgroundTransparency = 0.3
        notif.Text = "⏹ تم إيقاف التحكم"
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextScaled = true
        notif.Font = Enum.Font.GothamBold
        notif.BorderSizePixel = 0
        local notifCorner = Instance.new("UICorner")
        notifCorner.Parent = notif
        notifCorner.CornerRadius = UDim.new(0, 12)
        game:GetService("Debris"):AddItem(notif, 2)
    end
end)

-- ==================== زر الإغلاق (X) ====================
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 45, 0, 45)
closeBtn.Position = UDim2.new(1, -55, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.Parent = closeBtn
closeCorner.CornerRadius = UDim.new(0, 12)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        closeBtn.Text = "✕"
    else
        closeBtn.Text = "⊕"
    end
end)

-- زر سحب النافذة (لتحريكها)
local dragBtn = Instance.new("TextButton")
dragBtn.Parent = mainFrame
dragBtn.Size = UDim2.new(1, -60, 0, 60)
dragBtn.Position = UDim2.new(0, 0, 0, 0)
dragBtn.BackgroundTransparency = 1
dragBtn.Text = ""
dragBtn.BorderSizePixel = 0

local dragging = false
local dragStart = nil
local startPos = nil

dragBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

dragBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==================== ملاحظة: الكود جاهز للتشغيل ====================
print("✅ تم تحميل الواجهة الزجاجية الفخمة بنجاح!")
