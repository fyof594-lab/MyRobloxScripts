-- ============================================
-- 💀 ROMA SENPAI HUB 💀
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local ContextActionService = game:GetService("ContextActionService")

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {
    fly = false,
    noclip = false,
    invisible = false,
    speed = false
}
local connections = {}
local speedAmount = 120
local flySpeed = 80
local isMinimized = false
local ScreenGui = nil
local joystickVector = Vector3.new(0, 0, 0)

-- ============================================
-- 🛠️ دوال الوظائف
-- ============================================

local function toggleFly(state)
    states.fly = state
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local h = char:FindFirstChild("Humanoid")
    if not h then return end

    if states.fly then
        h.PlatformStand = true
        if not connections.fly then
            connections.fly = RunService.Heartbeat:Connect(function()
                if not states.fly then return end
                if not Player.Character then return end
                
                local root = Player.Character:FindFirstChild("HumanoidRootPart")
                local h = Player.Character:FindFirstChild("Humanoid")
                if not root or not h then return end
                
                local camera = workspace.CurrentCamera
                
                -- ✅ ناخذ حركة العصا (Mobile Joystick)
                local moveVector = h.MoveDirection
                
                -- ✅ إذا كانت العصا متحركة
                if moveVector.Magnitude > 0 then
                    -- نأخذ اتجاه الكاميرا
                    local forward = camera.CFrame.LookVector
                    local right = camera.CFrame.RightVector
                    local up = camera.CFrame.UpVector
                    
                    -- نطبق الحركة على اتجاه الكاميرا (تحريك حر)
                    local moveDirection = (forward * moveVector.Z + right * moveVector.X)
                    
                    -- نضيف الصعود والنزول
                    local upDirection = Vector3.new(0, 0, 0)
                    
                    -- أزرار الصعود/النزول (للكيبورد والجوال)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        upDirection = up * flySpeed
                    elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        upDirection = -up * flySpeed
                    end
                    
                    -- نطبق السرعة
                    if moveDirection.Magnitude > 0 then
                        root.Velocity = moveDirection.Unit * flySpeed + upDirection
                    else
                        root.Velocity = upDirection
                    end
                else
                    -- إذا ما في حركة، نوقف فقط إذا ما في أزرار صعود/نزول
                    if not UserInputService:IsKeyDown(Enum.KeyCode.Space) and not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        root.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
        showNotification("🚀 الطيران ON", Color3.fromRGB(0, 150, 255))
    else
        if connections.fly then
            connections.fly:Disconnect()
            connections.fly = nil
        end
        h.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
        showNotification("⏹ الطيران OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- باقي الكود (نفسه ما تغير)
-- ============================================
local function toggleNoclip(state)
    states.noclip = state
    if states.noclip then
        if not connections.noclip then
            connections.noclip = RunService.Heartbeat:Connect(function()
                local char = Player.Character
                if not char then return end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
        showNotification("🧱 اختراق الجدران ON", Color3.fromRGB(150, 100, 255))
    else
        if connections.noclip then
            connections.noclip:Disconnect()
            connections.noclip = nil
        end
        local char = Player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        showNotification("⏹ اختراق الجدران OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function toggleInvisible(state)
    states.invisible = state
    local char = Player.Character
    if not char then return end

    if states.invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            end
        end
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 0
            char.Humanoid.NameDisplayDistance = 0
        end)
        showNotification("👻 اختفاء ON", Color3.fromRGB(200, 100, 255))
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
        pcall(function()
            char.Humanoid.HealthDisplayDistance = 50
            char.Humanoid.NameDisplayDistance = 50
        end)
        showNotification("👁️ اختفاء OFF", Color3.fromRGB(255, 200, 0))
    end
end

local function toggleSpeed(state)
    states.speed = state
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        showNotification("⚡ سرعة " .. speedAmount .. " ON", Color3.fromRGB(0, 255, 200))
    else
        h.WalkSpeed = 16
        showNotification("⏹ سرعة OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- 💀 أمر الطرد
local function kickPlayer(plr)
    if not plr or plr == Player then 
        showNotification("❌ لا يمكن طرد نفسك!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    pcall(function()
        local vu = game:GetService("VirtualUser")
        if vu then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
    
    pcall(function()
        for _, remote in pairs(ReplicatedStorage:GetChildren()) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                pcall(function()
                    remote:FireServer("Kick", plr)
                    remote:FireServer("KickPlayer", plr)
                    remote:FireServer(plr)
                    remote:FireServer("kick", plr.Name)
                end)
            end
        end
    end)
    
    pcall(function()
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part:BreakJoints()
                    part.CanCollide = false
                end
                if part:IsA("Humanoid") then
                    part.Health = 0
                    part.PlatformStand = true
                    part.BreakJointsOnDeath = true
                end
            end
            plr.Character:Destroy()
        end
    end)
    
    pcall(function()
        game.Players:FindFirstChild(plr.Name):Kick("تم طردك بواسطة ROMA SENPAI 💀")
    end)
    
    showNotification("💀 تم طرد " .. plr.Name .. " من السيرفر!", Color3.fromRGB(255, 0, 0))
end

-- ⚽ التيليبورت إلى الكرة
local function teleportToBall()
    local ball = nil
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("ball") or 
            obj.Name:lower():find("sphere") or
            obj.Name:lower():find("football") or
            obj.Name:lower():find("soccer") or
            obj.Name:lower():find("bll")
        ) then
            ball = obj
            break
        end
    end
    
    if not ball then
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("ball") then
                ball = obj
                break
            end
        end
    end
    
    if ball then
        local myChar = Player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local root = myChar.HumanoidRootPart
            root.CFrame = ball.CFrame + Vector3.new(0, 3, 0)
            showNotification("⚽ تم التليفورت إلى الكرة!", Color3.fromRGB(0, 255, 100))
        end
    else
        showNotification("❌ لم يتم العثور على الكرة!", Color3.fromRGB(255, 0, 0))
    end
end

-- 🌐 قائمة اللاعبين
local TeleportFrame = nil
local PlayersList = nil
local pullConnections = {}

local function pullPlayerReal(plr)
    if not plr or not plr.Character then 
        showNotification("❌ اللاعب غير موجود!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot or not myRoot then 
        showNotification("❌ تعذر العثور على اللاعب!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    if pullConnections[plr] then
        pullConnections[plr]:Disconnect()
        pullConnections[plr] = nil
    end
    
    local targetPos = myRoot.CFrame + Vector3.new(0, 3, 0)
    
    local tween = TweenService:Create(targetRoot, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = targetPos
    })
    tween:Play()
    
    pullConnections[plr] = RunService.Heartbeat:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            if pullConnections[plr] then
                pullConnections[plr]:Disconnect()
                pullConnections[plr] = nil
            end
            return
        end
        
        local root = plr.Character.HumanoidRootPart
        local h = plr.Character:FindFirstChild("Humanoid")
        
        root.CFrame = myRoot.CFrame + Vector3.new(0, 3, 0)
        root.Velocity = Vector3.new(0, 0, 0)
        root.RotVelocity = Vector3.new(0, 0, 0)
        
        if h then
            h.PlatformStand = true
            h.Sit = true
            h.WalkSpeed = 0
            h.JumpPower = 0
        end
    end)
    
    task.wait(5)
    if pullConnections[plr] then
        pullConnections[plr]:Disconnect()
        pullConnections[plr] = nil
        local h = plr.Character:FindFirstChild("Humanoid")
        if h then
            h.PlatformStand = false
            h.Sit = false
            h.WalkSpeed = 16
            h.JumpPower = 50
        end
    end
    
    showNotification("✅ تم جلب " .. plr.Name, Color3.fromRGB(0, 200, 100))
end

local function showTeleportMenu()
    if TeleportFrame and TeleportFrame.Visible then
        TeleportFrame.Visible = false
        return
    end
    
    if not TeleportFrame then
        TeleportFrame = Instance.new("Frame")
        TeleportFrame.Parent = ScreenGui
        TeleportFrame.Size = UDim2.new(0, 280, 0, 350)
        TeleportFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
        TeleportFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        TeleportFrame.BackgroundTransparency = 0.1
        TeleportFrame.BorderSizePixel = 0
        TeleportFrame.ClipsDescendants = true
        
        local TCorner = Instance.new("UICorner")
        TCorner.CornerRadius = UDim.new(0, 10)
        TCorner.Parent = TeleportFrame
        
        local TStroke = Instance.new("UIStroke")
        TStroke.Parent = TeleportFrame
        TStroke.Color = Color3.fromRGB(45, 45, 55)
        TStroke.Thickness = 1
        
        local TTitle = Instance.new("TextLabel")
        TTitle.Parent = TeleportFrame
        TTitle.Size = UDim2.new(1, 0, 0, 30)
        TTitle.BackgroundTransparency = 1
        TTitle.Text = "👥 قائمة اللاعبين"
        TTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
        TTitle.TextSize = 13
        TTitle.Font = Enum.Font.GothamBold
        
        local closeT = Instance.new("TextButton")
        closeT.Parent = TeleportFrame
        closeT.Size = UDim2.new(0, 25, 0, 25)
        closeT.Position = UDim2.new(1, -30, 0, 3)
        closeT.BackgroundTransparency = 1
        closeT.Text = "✕"
        closeT.TextColor3 = Color3.fromRGB(160, 160, 175)
        closeT.TextSize = 14
        closeT.Font = Enum.Font.GothamBold
        
        closeT.MouseButton1Click:Connect(function()
            TeleportFrame.Visible = false
        end)
        
        PlayersList = Instance.new("ScrollingFrame")
        PlayersList.Parent = TeleportFrame
        PlayersList.Size = UDim2.new(1, -10, 1, -40)
        PlayersList.Position = UDim2.new(0, 5, 0, 35)
        PlayersList.BackgroundTransparency = 1
        PlayersList.BorderSizePixel = 0
        PlayersList.CanvasSize = UDim2.new(0, 0, 0, 0)
        PlayersList.ScrollBarThickness = 3
    end
    
    for _, child in pairs(PlayersList:GetChildren()) do
        child:Destroy()
    end
    
    local yOff = 0
    local playerCount = 0
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            playerCount = playerCount + 1
            
            local btn = Instance.new("TextButton")
            btn.Parent = PlayersList
            btn.Size = UDim2.new(1, 0, 0, 55)
            btn.Position = UDim2.new(0, 0, 0, yOff)
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            btn.BorderSizePixel = 0
            btn.ClipsDescendants = true
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = btn
            nameLabel.Size = UDim2.new(1, 0, 0, 20)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = "👤 " .. plr.Name
            nameLabel.TextColor3 = Color3.fromRGB(200, 200, 215)
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.GothamMedium
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local tpBtn = Instance.new("TextButton")
            tpBtn.Parent = btn
            tpBtn.Size = UDim2.new(0, 50, 0, 25)
            tpBtn.Position = UDim2.new(0.01, 0, 0.5, -10)
            tpBtn.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
            tpBtn.BackgroundTransparency = 0.3
            tpBtn.Text = "🚀 انتقال"
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpBtn.TextSize = 9
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.BorderSizePixel = 0
            
            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 4)
            tpCorner.Parent = tpBtn
            
            tpBtn.MouseEnter:Connect(function()
                tpBtn.BackgroundTransparency = 0
            end)
            tpBtn.MouseLeave:Connect(function()
                tpBtn.BackgroundTransparency = 0.3
            end)
            
            tpBtn.MouseButton1Click:Connect(function()
                local targetChar = plr.Character
                if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                    local myChar = Player.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local myRoot = myChar.HumanoidRootPart
                        local noclipState = states.noclip
                        if not noclipState then
                            toggleNoclip(true)
                        end
                        myRoot.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        if not noclipState then
                            task.wait(0.1)
                            toggleNoclip(false)
                        end
                        showNotification("✅ تم التليفورت إلى " .. plr.Name, Color3.fromRGB(0, 200, 100))
                        TeleportFrame.Visible = false
                    end
                else
                    showNotification("❌ اللاعب غير موجود!", Color3.fromRGB(255, 0, 0))
                end
            end)
            
            local pullBtn = Instance.new("TextButton")
            pullBtn.Parent = btn
            pullBtn.Size = UDim2.new(0, 45, 0, 25)
            pullBtn.Position = UDim2.new(0.25, 0, 0.5, -10)
            pullBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
            pullBtn.BackgroundTransparency = 0.3
            pullBtn.Text = "📥 جلب"
            pullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pullBtn.TextSize = 9
            pullBtn.Font = Enum.Font.GothamBold
            pullBtn.BorderSizePixel = 0
            
            local pullCorner = Instance.new("UICorner")
            pullCorner.CornerRadius = UDim.new(0, 4)
            pullCorner.Parent = pullBtn
            
            pullBtn.MouseEnter:Connect(function()
                pullBtn.BackgroundTransparency = 0
            end)
            pullBtn.MouseLeave:Connect(function()
                pullBtn.BackgroundTransparency = 0.3
            end)
            
            pullBtn.MouseButton1Click:Connect(function()
                pullPlayerReal(plr)
                TeleportFrame.Visible = false
            end)
            
            local kickBtn = Instance.new("TextButton")
            kickBtn.Parent = btn
            kickBtn.Size = UDim2.new(0, 50, 0, 25)
            kickBtn.Position = UDim2.new(0.55, 0, 0.5, -10)
            kickBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            kickBtn.BackgroundTransparency = 0.3
            kickBtn.Text = "💀 طرد"
            kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            kickBtn.TextSize = 9
            kickBtn.Font = Enum.Font.GothamBold
            kickBtn.BorderSizePixel = 0
            
            local kickCorner = Instance.new("UICorner")
            kickCorner.CornerRadius = UDim.new(0, 4)
            kickCorner.Parent = kickBtn
            
            kickBtn.MouseEnter:Connect(function()
                kickBtn.BackgroundTransparency = 0
            end)
            kickBtn.MouseLeave:Connect(function()
                kickBtn.BackgroundTransparency = 0.3
            end)
            
            kickBtn.MouseButton1Click:Connect(function()
                kickPlayer(plr)
                TeleportFrame.Visible = false
            end)
            
            yOff = yOff + 60
        end
    end
    
    local ballBtn = Instance.new("TextButton")
    ballBtn.Parent = PlayersList
    ballBtn.Size = UDim2.new(1, 0, 0, 35)
    ballBtn.Position = UDim2.new(0, 0, 0, yOff)
    ballBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    ballBtn.BackgroundTransparency = 0.3
    ballBtn.Text = "⚽ التيليبورت إلى الكرة"
    ballBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ballBtn.TextSize = 12
    ballBtn.Font = Enum.Font.GothamBold
    ballBtn.BorderSizePixel = 0
    
    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(0, 6)
    ballCorner.Parent = ballBtn
    
    ballBtn.MouseEnter:Connect(function()
        ballBtn.BackgroundTransparency = 0
    end)
    ballBtn.MouseLeave:Connect(function()
        ballBtn.BackgroundTransparency = 0.3
    end)
    
    ballBtn.MouseButton1Click:Connect(function()
        teleportToBall()
        TeleportFrame.Visible = false
    end)
    
    yOff = yOff + 40
    
    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Parent = PlayersList
    rejoinBtn.Size = UDim2.new(1, 0, 0, 35)
    rejoinBtn.Position = UDim2.new(0, 0, 0, yOff)
    rejoinBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    rejoinBtn.BackgroundTransparency = 0.3
    rejoinBtn.Text = "🔄 إعادة الانضمام للسيرفر"
    rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    rejoinBtn.TextSize = 12
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.BorderSizePixel = 0
    
    local rejoinCorner = Instance.new("UICorner")
    rejoinCorner.CornerRadius = UDim.new(0, 6)
    rejoinCorner.Parent = rejoinBtn
    
    rejoinBtn.MouseEnter:Connect(function()
        rejoinBtn.BackgroundTransparency = 0
    end)
    rejoinBtn.MouseLeave:Connect(function()
        rejoinBtn.BackgroundTransparency = 0.3
    end)
    
    rejoinBtn.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)
    
    yOff = yOff + 40
    
    if playerCount == 0 then
        local noPlayers = Instance.new("TextLabel")
        noPlayers.Parent = PlayersList
        noPlayers.Size = UDim2.new(1, 0, 0, 30)
        noPlayers.Position = UDim2.new(0, 0, 0, 10)
        noPlayers.BackgroundTransparency = 1
        noPlayers.Text = "❌ لا يوجد لاعبين آخرين"
        noPlayers.TextColor3 = Color3.fromRGB(160, 160, 175)
        noPlayers.TextSize = 12
        noPlayers.Font = Enum.Font.GothamMedium
        yOff = 50
    end
    
    PlayersList.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)
    TeleportFrame.Visible = true
end

-- ============================================
-- 💬 دالة الإشعار
-- ============================================
function showNotification(text, color)
    if not ScreenGui then return end
    local notif = Instance.new("TextLabel")
    notif.Parent = ScreenGui
    notif.Size = UDim2.new(0, 280, 0, 35)
    notif.Position = UDim2.new(0.5, -140, 0.05, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 13
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 0
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notif
    game:GetService("Debris"):AddItem(notif, 2)
end

local function stopAll()
    for _, conn in pairs(connections) do
        if conn then
            conn:Disconnect()
        end
    end
    connections = {}
    for key in pairs(states) do
        states[key] = false
    end
    
    for plr, conn in pairs(pullConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    pullConnections = {}
    
    local char = Player.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
            if part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 0
            end
        end
        local h = char:FindFirstChild("Humanoid")
        if h then
            h.PlatformStand = false
            h.WalkSpeed = 16
            h.JumpPower = 50
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
        end
    end
    showNotification("⏹ تم إيقاف الكل!", Color3.fromRGB(255, 200, 0))
end

-- ============================================
-- 🎬 شاشة Intro
-- ============================================
local function showIntro()
    local intro = Instance.new("Frame")
    intro.Parent = Player.PlayerGui
    intro.Size = UDim2.new(1, 0, 1, 0)
    intro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    intro.BackgroundTransparency = 0.2
    intro.BorderSizePixel = 0
    
    local text = Instance.new("TextLabel")
    text.Parent = intro
    text.Size = UDim2.new(0, 350, 0, 70)
    text.Position = UDim2.new(0.5, -175, 0.5, -35)
    text.BackgroundTransparency = 1
    text.Text = "💀 ROMA SENPAI\nصنع من طرف ROMA SENPAI"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0.5
    
    local subText = Instance.new("TextLabel")
    subText.Parent = intro
    subText.Size = UDim2.new(0, 250, 0, 25)
    subText.Position = UDim2.new(0.5, -125, 0.5, 50)
    subText.BackgroundTransparency = 1
    subText.Text = "جاري التحميل..."
    subText.TextColor3 = Color3.fromRGB(150, 150, 255)
    subText.TextScaled = true
    subText.Font = Enum.Font.GothamSemibold
    
    task.wait(1.5)
    intro:Destroy()
    createGUI()
end

-- ============================================
-- 🎨 الواجهة الرئيسية
-- ============================================
local MainFrame = nil
local MinBtn = nil
local CloseBtn = nil

function createGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RomaAxelHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Player.PlayerGui

    MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 260, 0, 230)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -115)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Parent = MainFrame
    MainStroke.Color = Color3.fromRGB(45, 45, 55)
    MainStroke.Thickness = 1

    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.Size = UDim2.new(1, 0, 0, 32)
    TopBar.BackgroundTransparency = 1

    local LogoLabel = Instance.new("TextLabel")
    LogoLabel.Parent = TopBar
    LogoLabel.Size = UDim2.new(0, 100, 1, 0)
    LogoLabel.Position = UDim2.new(0, 8, 0, 0)
    LogoLabel.BackgroundTransparency = 1
    LogoLabel.Text = "💀 ROMA HUB"
    LogoLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    LogoLabel.TextSize = 12
    LogoLabel.Font = Enum.Font.GothamBold
    LogoLabel.TextXAlignment = Enum.TextXAlignment.Left

    MinBtn = Instance.new("TextButton")
    MinBtn.Parent = TopBar
    MinBtn.Size = UDim2.new(0, 22, 0, 22)
    MinBtn.Position = UDim2.new(1, -50, 0.5, -11)
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.BackgroundTransparency = 0.3
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.BorderSizePixel = 0
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinBtn

    CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.Size = UDim2.new(0, 22, 0, 22)
    CloseBtn.Position = UDim2.new(1, -26, 0.5, -11)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseBtn.BackgroundTransparency = 0.3
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    local function minimizeGUI()
        isMinimized = true
        MainFrame.Visible = false
        
        local miniButton = Instance.new("TextButton")
        miniButton.Name = "MiniButton"
        miniButton.Parent = ScreenGui
        miniButton.Size = UDim2.new(0, 40, 0, 40)
        miniButton.Position = UDim2.new(0, 10, 0.5, -20)
        miniButton.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        miniButton.BackgroundTransparency = 0.1
        miniButton.Text = "💀"
        miniButton.TextColor3 = Color3.fromRGB(240, 240, 245)
        miniButton.TextSize = 20
        miniButton.Font = Enum.Font.GothamBold
        miniButton.BorderSizePixel = 0
        
        local miniCorner = Instance.new("UICorner")
        miniCorner.CornerRadius = UDim.new(1, 0)
        miniCorner.Parent = miniButton
        
        local miniStroke = Instance.new("UIStroke")
        miniStroke.Parent = miniButton
        miniStroke.Color = Color3.fromRGB(45, 45, 55)
        miniStroke.Thickness = 1
        
        miniButton.MouseButton1Click:Connect(function()
            isMinimized = false
            MainFrame.Visible = true
            miniButton:Destroy()
        end)
    end

    MinBtn.MouseButton1Click:Connect(function()
        minimizeGUI()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        minimizeGUI()
    end)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Parent = MainFrame
    Sidebar.Size = UDim2.new(0, 100, 1, -32)
    Sidebar.Position = UDim2.new(0, 0, 0, 32)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 200)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 4)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingLeft = UDim.new(0, 6)
    SidebarPadding.PaddingRight = UDim.new(0, 6)

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.Size = UDim2.new(1, -105, 1, -40)
    ContentContainer.Position = UDim2.new(0, 105, 0, 36)
    ContentContainer.BackgroundTransparency = 1

    local currentTabBtn = nil

    local function createTabButton(name, icon)
        local btn = Instance.new("TextButton")
        btn.Parent = Sidebar
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundTransparency = 1
        btn.Text = "   " .. icon .. "  " .. name
        btn.TextColor3 = Color3.fromRGB(140, 140, 160)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamSemibold
        btn.TextXAlignment = Enum.TextXAlignment.Left
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
        
        btn.MouseEnter:Connect(function()
            btn.TextColor3 = Color3.fromRGB(240, 240, 245)
        end)
        btn.MouseLeave:Connect(function()
            if currentTabBtn ~= btn then
                btn.TextColor3 = Color3.fromRGB(140, 140, 160)
            end
        end)
        
        return btn
    end

    local function createContentPanel(titleText)
        for _, v in pairs(ContentContainer:GetChildren()) do v:Destroy() end
        
        local panel = Instance.new("ScrollingFrame")
        panel.Parent = ContentContainer
        panel.Size = UDim2.new(1, 0, 1, 0)
        panel.BackgroundTransparency = 1
        panel.BorderSizePixel = 0
        panel.ScrollBarThickness = 2
        panel.CanvasSize = UDim2.new(0, 0, 0, 200)
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = panel
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        
        local title = Instance.new("TextLabel")
        title.Parent = panel
        title.Size = UDim2.new(1, 0, 0, 20)
        title.BackgroundTransparency = 1
        title.Text = titleText
        title.TextColor3 = Color3.fromRGB(240, 240, 250)
        title.TextSize = 12
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        return panel
    end

    local function addToggle(parent, titleText, callback)
        local toggle = Instance.new("Frame")
        toggle.Parent = parent
        toggle.Size = UDim2.new(1, -5, 0, 28)
        toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        toggle.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = toggle
        
        local label = Instance.new("TextLabel")
        label.Parent = toggle
        label.Size = UDim2.new(1, -42, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = titleText
        label.TextColor3 = Color3.fromRGB(200, 200, 215)
        label.TextSize = 10
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local btn = Instance.new("TextButton")
        btn.Parent = toggle
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        
        local active = false
        local indicator = Instance.new("Frame")
        indicator.Parent = toggle
        indicator.Size = UDim2.new(0, 12, 0, 12)
        indicator.Position = UDim2.new(1, -18, 0.5, -6)
        indicator.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        local indCorner = Instance.new("UICorner")
        indCorner.CornerRadius = UDim.new(0, 4)
        indCorner.Parent = indicator
        
        btn.MouseButton1Click:Connect(function()
            active = not active
            TweenService:Create(indicator, TweenInfo.new(0.2), {
                BackgroundColor3 = active and Color3.fromRGB(80, 140, 255) or Color3.fromRGB(40, 40, 50)
            }):Play()
            callback(active)
        end)
    end

    local function createMovementTab()
        local panel = createContentPanel("🚀 إعدادات الحركة")
        addToggle(panel, "الطيران (Fly)", function(state) toggleFly(state) end)
        addToggle(panel, "اختراق الجدران", function(state) toggleNoclip(state) end)
        addToggle(panel, "اختفاء (Invisible)", function(state) toggleInvisible(state) end)
    end

    local function createSpeedTab()
        local panel = createContentPanel("⚡ إعدادات السرعة")
        addToggle(panel, "تفعيل السرعة العالية", function(state) toggleSpeed(state) end)
    end

    local function createTeleportTab()
        local panel = createContentPanel("👥 قائمة اللاعبين")
        
        local teleportBtn = Instance.new("TextButton")
        teleportBtn.Parent = panel
        teleportBtn.Size = UDim2.new(1, -5, 0, 35)
        teleportBtn.Position = UDim2.new(0, 2, 0, 5)
        teleportBtn.Text = "👥 فتح قائمة اللاعبين"
        teleportBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
        teleportBtn.TextSize = 12
        teleportBtn.Font = Enum.Font.GothamMedium
        teleportBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        teleportBtn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = teleportBtn
        
        teleportBtn.MouseEnter:Connect(function()
            teleportBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end)
        teleportBtn.MouseLeave:Connect(function()
            teleportBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end)
        
        teleportBtn.MouseButton1Click:Connect(function()
            showTeleportMenu()
        end)
    end

    local function createExtrasTab()
        local panel = createContentPanel("🔧 إضافات")
        
        local stopBtn = Instance.new("TextButton")
        stopBtn.Parent = panel
        stopBtn.Size = UDim2.new(1, -5, 0, 35)
        stopBtn.Position = UDim2.new(0, 2, 0, 5)
        stopBtn.Text = "🔄 إيقاف الكل"
        stopBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
        stopBtn.TextSize = 12
        stopBtn.Font = Enum.Font.GothamMedium
        stopBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        stopBtn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = stopBtn
        
        stopBtn.MouseEnter:Connect(function()
            stopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end)
        stopBtn.MouseLeave:Connect(function()
            stopBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        end)
        
        stopBtn.MouseButton1Click:Connect(function()
            stopAll()
        end)
    end

    local tab1 = createTabButton("الحركة", "🚀")
    tab1.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab1
        tab1.TextColor3 = Color3.fromRGB(240, 240, 245)
        createMovementTab()
    end)

    local tab2 = createTabButton("السرعة", "⚡")
    tab2.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab2
        tab2.TextColor3 = Color3.fromRGB(240, 240, 245)
        createSpeedTab()
    end)

    local tab3 = createTabButton("اللاعبين", "👥")
    tab3.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab3
        tab3.TextColor3 = Color3.fromRGB(240, 240, 245)
        createTeleportTab()
    end)

    local tab4 = createTabButton("إضافات", "🔧")
    tab4.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab4
        tab4.TextColor3 = Color3.fromRGB(240, 240, 245)
        createExtrasTab()
    end)

    tab1.MouseButton1Click()

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            if isMinimized then
                isMinimized = false
                MainFrame.Visible = true
                local miniBtn = ScreenGui:FindFirstChild("MiniButton")
                if miniBtn then miniBtn:Destroy() end
            else
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)

    print("💀 ROMA SENPAI HUB Loaded!")
    print("📌 F1 = Toggle GUI")
    showNotification("💀 ROMA HUB جاهز!", Color3.fromRGB(150, 150, 255))
end

showIntro()
