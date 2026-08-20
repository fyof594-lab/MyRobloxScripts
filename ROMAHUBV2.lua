-- ============================================
-- 💀 ROMA SENPAI HUB V2 💀
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
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()

-- ============================================
-- 🔥 المتغيرات والحالات
-- ============================================
local states = {
    noclip = false,
    invisible = false,
    speed = false,
    aimbot = false,
    aimlock = false,
    esp = false,
    hp = false,
    ballNoClip = false,
    ballAimlock = false,
    ballStick = false
}
local connections = {}
local speedAmount = 120
local isMinimized = false
local ScreenGui = nil
local espObjects = {}
local aimbotTarget = nil
local aimlockTarget = nil
local aimlockCircle = nil

-- ============================================
-- ⚽ BLUE LOCK - المتغيرات
-- ============================================
local ball = nil
local ballNoClipActive = false
local ballAimlockActive = false
local ballStickActive = false
local ballAimConnection = nil
local ballNoClipConnection = nil
local ballStickConnection = nil

-- ============================================
-- ❤️ HP FULL
-- ============================================
local hpActive = false
local hpConnections = {}

local function setInfiniteHealth(humanoid)
    if not humanoid then return end
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    humanoid.BreakJointsOnDeath = false
    
    local conn = humanoid.HealthChanged:Connect(function()
        if hpActive and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    table.insert(hpConnections, conn)
end

local function onCharacterAdded(character)
    if not hpActive then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        setInfiniteHealth(humanoid)
    end
end

local function toggleHP(state)
    hpActive = state
    
    if hpActive then
        local char = Player.Character
        if char then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then
                setInfiniteHealth(h)
            end
        end
        
        local conn = Player.CharacterAdded:Connect(onCharacterAdded)
        table.insert(hpConnections, conn)
        
        showNotification("❤️ HP FULL ON", Color3.fromRGB(0, 255, 100))
    else
        for _, conn in pairs(hpConnections) do
            pcall(function() conn:Disconnect() end)
        end
        hpConnections = {}
        
        local char = Player.Character
        if char then
            local h = char:FindFirstChildOfClass("Humanoid")
            if h then
                h.MaxHealth = 100
                h.Health = 100
                h.BreakJointsOnDeath = true
            end
        end
        showNotification("⏹ HP FULL OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔥 دوال التحقق من العدو/الصديق
-- ============================================

local function isEnemy(plr)
    if not plr or plr == Player then return false end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then return false end
    
    local myTeam = Player.Team
    local theirTeam = plr.Team
    
    if not myTeam or not theirTeam then return true end
    return myTeam ~= theirTeam
end

local function isFriend(plr)
    if not plr or plr == Player then return false end
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return false end
    if not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then return false end
    
    local myTeam = Player.Team
    local theirTeam = plr.Team
    
    if not myTeam or not theirTeam then return false end
    return myTeam == theirTeam
end

-- ============================================
-- 🔍 البحث عن الكرة
-- ============================================
local function findBall()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("ball") or 
            obj.Name:lower():find("football") or
            obj.Name:lower():find("soccer") or
            obj.Name:lower():find("sphere") or
            obj.Name:lower():find("bll")
        ) then
            ball = obj
            return ball
        end
    end
    return nil
end

-- ============================================
-- ⚽ جلب الكرة
-- ============================================
local function pullBall()
    if not ball then findBall() end
    if not ball then 
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    ball.CFrame = root.CFrame + Vector3.new(0, 2, 0)
    ball.Velocity = Vector3.new(0, 0, 0)
    ball.RotVelocity = Vector3.new(0, 0, 0)
    
    showNotification("⚽ تم جلب الكرة!", Color3.fromRGB(0, 200, 255))
end

-- ============================================
-- 🚀 الانتقال إلى الكرة
-- ============================================
local function teleportToBall()
    if not ball then findBall() end
    if not ball then 
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    root.CFrame = ball.CFrame + Vector3.new(0, 3, 0)
    root.Velocity = Vector3.new(0, 0, 0)
    
    showNotification("🚀 تم الانتقال إلى الكرة!", Color3.fromRGB(0, 200, 100))
end

-- ============================================
-- 🥅 تسديد (تخترق اللاعبين)
-- ============================================
local function shootBall()
    if not ball then findBall() end
    if not ball then 
        showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    local oldCanCollide = ball.CanCollide
    ball.CanCollide = false
    
    local camera = workspace.CurrentCamera
    local direction = camera.CFrame.LookVector
    
    ball.Velocity = direction * 200
    ball.RotVelocity = Vector3.new(0, 0, 0)
    
    task.wait(1)
    ball.CanCollide = oldCanCollide
    
    showNotification("⚽ تم التسديد!", Color3.fromRGB(255, 200, 50))
end

-- ============================================
-- ⚽ الكرة تخترق اللاعبين (Toggle)
-- ============================================
local function toggleBallNoClip(state)
    states.ballNoClip = state
    
    if states.ballNoClip then
        if not ball then findBall() end
        if not ball then
            showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
            return
        end
        
        if not ballNoClipConnection then
            ballNoClipConnection = RunService.Heartbeat:Connect(function()
                if not ball then return end
                ball.CanCollide = false
            end)
        end
        showNotification("⚽ الكرة تخترق اللاعبين ON", Color3.fromRGB(255, 0, 0))
    else
        if ballNoClipConnection then
            ballNoClipConnection:Disconnect()
            ballNoClipConnection = nil
        end
        if ball then
            ball.CanCollide = true
        end
        showNotification("⏹ الكرة تخترق اللاعبين OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🎯 Aimlock على الكرة
-- ============================================
local function toggleBallAimlock(state)
    states.ballAimlock = state
    
    if states.ballAimlock then
        if not ball then findBall() end
        if not ball then
            showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
            return
        end
        
        if not ballAimConnection then
            ballAimConnection = RunService.RenderStepped:Connect(function()
                if not states.ballAimlock then return end
                if not ball then return end
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, ball.Position)
            end)
        end
        showNotification("🎯 Aimlock على الكرة ON", Color3.fromRGB(0, 200, 255))
    else
        if ballAimConnection then
            ballAimConnection:Disconnect()
            ballAimConnection = nil
        end
        showNotification("⏹ Aimlock على الكرة OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔒 الكرة تلتصق فيك (Stick Ball)
-- ============================================
local function toggleBallStick(state)
    states.ballStick = state
    
    if states.ballStick then
        if not ball then findBall() end
        if not ball then
            showNotification("❌ الكرة غير موجودة!", Color3.fromRGB(255, 0, 0))
            return
        end
        
        if not ballStickConnection then
            ballStickConnection = RunService.Heartbeat:Connect(function()
                if not states.ballStick then return end
                if not ball then return end
                if not Player.Character then return end
                
                local root = Player.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                -- نلصق الكرة باللاعب
                ball.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                ball.Velocity = Vector3.new(0, 0, 0)
                ball.RotVelocity = Vector3.new(0, 0, 0)
                ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                ball.CanCollide = false
            end)
        end
        showNotification("🔒 الكرة ملتصقة فيك ON", Color3.fromRGB(255, 200, 0))
    else
        if ballStickConnection then
            ballStickConnection:Disconnect()
            ballStickConnection = nil
        end
        if ball then
            ball.CanCollide = true
        end
        showNotification("⏹ الكرة ملتصقة فيك OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🎯 AIMBOT
-- ============================================
local function getClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    local myPos = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not myPos then return nil end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local root = plr.Character.HumanoidRootPart
            local dist = (root.Position - myPos.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = plr
            end
        end
    end
    return closest
end

local function toggleAimbot(state)
    states.aimbot = state
    
    if states.aimbot then
        if states.aimlock then
            toggleAimlock(false)
        end
        if not connections.aimbot then
            connections.aimbot = RunService.RenderStepped:Connect(function()
                if not states.aimbot then return end
                if not Player.Character then return end
                
                local target = getClosestEnemy()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    local head = target.Character.Head
                    local headPos = head.Position
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
                    aimbotTarget = target
                else
                    aimbotTarget = nil
                end
            end)
        end
        showNotification("🎯 Aimbot ON", Color3.fromRGB(255, 50, 50))
    else
        if connections.aimbot then
            connections.aimbot:Disconnect()
            connections.aimbot = nil
        end
        aimbotTarget = nil
        showNotification("⏹ Aimbot OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🔒 AIM LOCK
-- ============================================
local function createAimlockCircle()
    if aimlockCircle then
        aimlockCircle:Destroy()
        aimlockCircle = nil
    end
    
    aimlockCircle = Instance.new("Frame")
    aimlockCircle.Parent = ScreenGui
    aimlockCircle.Size = UDim2.new(0, 150, 0, 150)
    aimlockCircle.Position = UDim2.new(0.5, -75, 0.5, -75)
    aimlockCircle.BackgroundTransparency = 0.8
    aimlockCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    aimlockCircle.BorderSizePixel = 2
    aimlockCircle.BorderColor3 = Color3.fromRGB(255, 0, 0)
    aimlockCircle.ZIndex = 999
    aimlockCircle.Visible = true
    
    local corner = Instance.new("UICorner")
    corner.Parent = aimlockCircle
    corner.CornerRadius = UDim.new(1, 0)
    
    local cross = Instance.new("Frame")
    cross.Parent = aimlockCircle
    cross.Size = UDim2.new(0, 2, 0, 30)
    cross.Position = UDim2.new(0.5, -1, 0.5, -15)
    cross.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    cross.BackgroundTransparency = 0.3
    cross.BorderSizePixel = 0
    
    local cross2 = Instance.new("Frame")
    cross2.Parent = aimlockCircle
    cross2.Size = UDim2.new(0, 30, 0, 2)
    cross2.Position = UDim2.new(0.5, -15, 0.5, -1)
    cross2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    cross2.BackgroundTransparency = 0.3
    cross2.BorderSizePixel = 0
end

local function getEnemiesInCircle()
    local targets = {}
    local radius = 75
    
    for _, plr in pairs(Players:GetPlayers()) do
        if isEnemy(plr) then
            local root = plr.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < radius then
                    table.insert(targets, plr)
                end
            end
        end
    end
    return targets
end

local function toggleAimlock(state)
    states.aimlock = state
    
    if states.aimlock then
        if states.aimbot then
            toggleAimbot(false)
        end
        createAimlockCircle()
        if not connections.aimlock then
            connections.aimlock = RunService.RenderStepped:Connect(function()
                if not states.aimlock then return end
                if not Player.Character then return end
                
                local targets = getEnemiesInCircle()
                if #targets > 0 then
                    local closest = targets[1]
                    local closestDist = math.huge
                    local myPos = Player.Character.HumanoidRootPart.Position
                    
                    for _, plr in pairs(targets) do
                        local dist = (plr.Character.HumanoidRootPart.Position - myPos).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = plr
                        end
                    end
                    
                    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                        local head = closest.Character.Head
                        local headPos = head.Position
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
                        aimlockTarget = closest
                        
                        if aimlockCircle then
                            aimlockCircle.BorderColor3 = Color3.fromRGB(0, 255, 0)
                            aimlockCircle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        end
                    end
                else
                    aimlockTarget = nil
                    if aimlockCircle then
                        aimlockCircle.BorderColor3 = Color3.fromRGB(255, 0, 0)
                        aimlockCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    end
                end
            end)
        end
        showNotification("🔒 Aim Lock ON", Color3.fromRGB(0, 200, 255))
    else
        if connections.aimlock then
            connections.aimlock:Disconnect()
            connections.aimlock = nil
        end
        if aimlockCircle then
            aimlockCircle:Destroy()
            aimlockCircle = nil
        end
        aimlockTarget = nil
        showNotification("⏹ Aim Lock OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 👁️ ESP
-- ============================================
local function createESP(plr)
    if not plr or plr == Player then return end
    if espObjects[plr] then return end
    
    local char = plr.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local color
    if isFriend(plr) then
        color = Color3.fromRGB(0, 255, 0)
    else
        color = Color3.fromRGB(255, 0, 0)
    end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Parent = root
    box.Adornee = root
    box.Size = Vector3.new(4, 6, 2)
    box.Color3 = color
    box.Transparency = 0.3
    box.ZIndex = 10
    box.AlwaysOnTop = true
    box.Visible = true
    
    espObjects[plr] = {
        box = box
    }
end

local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not espObjects[plr] then
                createESP(plr)
            else
                local color
                if isFriend(plr) then
                    color = Color3.fromRGB(0, 255, 0)
                else
                    color = Color3.fromRGB(255, 0, 0)
                end
                espObjects[plr].box.Color3 = color
            end
        end
    end
    
    for plr, data in pairs(espObjects) do
        if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or (plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health <= 0) then
            if data.box then data.box:Destroy() end
            espObjects[plr] = nil
        end
    end
end

local function toggleESP(state)
    states.esp = state
    
    if states.esp then
        if not connections.esp then
            connections.esp = RunService.Heartbeat:Connect(updateESP)
        end
        showNotification("👁️ ESP ON", Color3.fromRGB(0, 255, 100))
    else
        if connections.esp then
            connections.esp:Disconnect()
            connections.esp = nil
        end
        for plr, data in pairs(espObjects) do
            if data.box then data.box:Destroy() end
        end
        espObjects = {}
        showNotification("⏹ ESP OFF", Color3.fromRGB(255, 200, 0))
    end
end

-- ============================================
-- 🛠️ دوال الوظائف الأساسية
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

-- ============================================
-- 💀 أمر الطرد
-- ============================================
local function kickPlayer(plr)
    if not plr or plr == Player then 
        showNotification("❌ لا يمكن طرد نفسك!", Color3.fromRGB(255, 0, 0))
        return 
    end
    
    pcall(function()
        plr:Kick("💀 تم طردك بواسطة ROMA SENPAI!")
    end)
    
    pcall(function()
        game.Players:FindFirstChild(plr.Name):Kick("💀 تم طردك بواسطة ROMA SENPAI!")
    end)
    
    pcall(function()
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part:BreakJoints()
                end
                if part:IsA("Humanoid") then
                    part.Health = 0
                end
            end
            plr.Character:Destroy()
        end
        task.wait(0.5)
        plr:Kick("💀 تم طردك بواسطة ROMA SENPAI!")
    end)
    
    showNotification("💀 تم طرد " .. plr.Name, Color3.fromRGB(255, 0, 0))
end

local function kickAllPlayers()
    local count = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            pcall(function()
                plr:Kick("💀 تم طرد الجميع!")
                count = count + 1
            end)
        end
    end
    showNotification("💀 تم طرد " .. count .. " لاعب", Color3.fromRGB(255, 0, 0))
end

-- ============================================
-- 🌐 قائمة اللاعبين
-- ============================================
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
        TeleportFrame.Size = UDim2.new(0, 280, 0, 400)
        TeleportFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
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
    
    local kickAllBtn = Instance.new("TextButton")
    kickAllBtn.Parent = PlayersList
    kickAllBtn.Size = UDim2.new(1, 0, 0, 35)
    kickAllBtn.Position = UDim2.new(0, 0, 0, yOff)
    kickAllBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    kickAllBtn.BackgroundTransparency = 0.3
    kickAllBtn.Text = "💀 طرد جميع اللاعبين"
    kickAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    kickAllBtn.TextSize = 12
    kickAllBtn.Font = Enum.Font.GothamBold
    kickAllBtn.BorderSizePixel = 0
    
    local kickAllCorner = Instance.new("UICorner")
    kickAllCorner.CornerRadius = UDim.new(0, 6)
    kickAllCorner.Parent = kickAllBtn
    
    kickAllBtn.MouseEnter:Connect(function()
        kickAllBtn.BackgroundTransparency = 0
    end)
    kickAllBtn.MouseLeave:Connect(function()
        kickAllBtn.BackgroundTransparency = 0.3
    end)
    
    kickAllBtn.MouseButton1Click:Connect(function()
        kickAllPlayers()
        TeleportFrame.Visible = false
    end)
    
    yOff = yOff + 40
    
    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Parent = PlayersList
    rejoinBtn.Size = UDim2.new(1, 0, 0, 35)
    rejoinBtn.Position = UDim2.new(0, 0, 0, yOff)
    rejoinBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    rejoinBtn.BackgroundTransparency = 0.3
    rejoinBtn.Text = "🔄 إعادة الانضمام"
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
    
    -- إيقاف HP FULL
    hpActive = false
    for _, conn in pairs(hpConnections) do
        pcall(function() conn:Disconnect() end)
    end
    hpConnections = {}
    
    local char = Player.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.MaxHealth = 100
            h.Health = 100
            h.BreakJointsOnDeath = true
        end
    end
    
    -- إيقاف BLUE LOCK
    if ballNoClipConnection then
        ballNoClipConnection:Disconnect()
        ballNoClipConnection = nil
    end
    if ballAimConnection then
        ballAimConnection:Disconnect()
        ballAimConnection = nil
    end
    if ballStickConnection then
        ballStickConnection:Disconnect()
        ballStickConnection = nil
    end
    if ball then
        ball.CanCollide = true
    end
    
    for plr, data in pairs(espObjects) do
        if data.box then data.box:Destroy() end
    end
    espObjects = {}
    
    if aimlockCircle then
        aimlockCircle:Destroy()
        aimlockCircle = nil
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
            h.Sit = false
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
-- 🎨 FLY GUI V3
-- ============================================
local FlyMain = nil
local FlyFrame = nil

local function createFlyGUI()
    if FlyMain then
        FlyMain:Destroy()
        FlyMain = nil
        return
    end
    
    FlyMain = Instance.new("ScreenGui")
    FlyMain.Name = "FlyGUI"
    FlyMain.Parent = ScreenGui or Player.PlayerGui
    FlyMain.ResetOnSpawn = false
    FlyMain.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    FlyFrame = Instance.new("Frame")
    FlyFrame.Parent = FlyMain
    FlyFrame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
    FlyFrame.BorderColor3 = Color3.fromRGB(103, 221, 213)
    FlyFrame.Position = UDim2.new(0.5, -95, 0.5, -28)
    FlyFrame.Size = UDim2.new(0, 190, 0, 57)
    FlyFrame.Active = true
    FlyFrame.Draggable = true
    
    local upBtn = Instance.new("TextButton")
    upBtn.Name = "up"
    upBtn.Parent = FlyFrame
    upBtn.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
    upBtn.Size = UDim2.new(0, 44, 0, 28)
    upBtn.Font = Enum.Font.SourceSans
    upBtn.Text = "UP"
    upBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    upBtn.TextSize = 14
    
    local downBtn = Instance.new("TextButton")
    downBtn.Name = "down"
    downBtn.Parent = FlyFrame
    downBtn.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
    downBtn.Position = UDim2.new(0, 0, 0.491228074, 0)
    downBtn.Size = UDim2.new(0, 44, 0, 28)
    downBtn.Font = Enum.Font.SourceSans
    downBtn.Text = "DOWN"
    downBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    downBtn.TextSize = 14
    
    local onoffBtn = Instance.new("TextButton")
    onoffBtn.Name = "onof"
    onoffBtn.Parent = FlyFrame
    onoffBtn.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
    onoffBtn.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
    onoffBtn.Size = UDim2.new(0, 56, 0, 28)
    onoffBtn.Font = Enum.Font.SourceSans
    onoffBtn.Text = "fly"
    onoffBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    onoffBtn.TextSize = 14
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = FlyFrame
    titleLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
    titleLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
    titleLabel.Size = UDim2.new(0, 100, 0, 28)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.Text = "FLY GUI V3"
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextScaled = true
    titleLabel.TextSize = 14
    titleLabel.TextWrapped = true
    
    local plusBtn = Instance.new("TextButton")
    plusBtn.Name = "plus"
    plusBtn.Parent = FlyFrame
    plusBtn.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
    plusBtn.Position = UDim2.new(0.231578946, 0, 0, 0)
    plusBtn.Size = UDim2.new(0, 45, 0, 28)
    plusBtn.Font = Enum.Font.SourceSans
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    plusBtn.TextScaled = true
    plusBtn.TextSize = 14
    plusBtn.TextWrapped = true
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "speed"
    speedLabel.Parent = FlyFrame
    speedLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    speedLabel.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
    speedLabel.Size = UDim2.new(0, 44, 0, 28)
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.Text = "1"
    speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.TextScaled = true
    speedLabel.TextSize = 14
    speedLabel.TextWrapped = true
    
    local minusBtn = Instance.new("TextButton")
    minusBtn.Name = "mine"
    minusBtn.Parent = FlyFrame
    minusBtn.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
    minusBtn.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
    minusBtn.Size = UDim2.new(0, 45, 0, 29)
    minusBtn.Font = Enum.Font.SourceSans
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    minusBtn.TextScaled = true
    minusBtn.TextSize = 14
    minusBtn.TextWrapped = true
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Parent = FlyFrame
    closeBtn.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.Size = UDim2.new(0, 45, 0, 28)
    closeBtn.Text = "X"
    closeBtn.TextSize = 30
    closeBtn.Position = UDim2.new(0, 0, -1, 27)
    
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "minimize"
    minBtn.Parent = FlyFrame
    minBtn.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
    minBtn.Font = Enum.Font.SourceSans
    minBtn.Size = UDim2.new(0, 45, 0, 28)
    minBtn.Text = "-"
    minBtn.TextSize = 40
    minBtn.Position = UDim2.new(0, 44, -1, 27)
    
    local maxBtn = Instance.new("TextButton")
    maxBtn.Name = "minimize2"
    maxBtn.Parent = FlyFrame
    maxBtn.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
    maxBtn.Font = Enum.Font.SourceSans
    maxBtn.Size = UDim2.new(0, 45, 0, 28)
    maxBtn.Text = "+"
    maxBtn.TextSize = 40
    maxBtn.Position = UDim2.new(0, 44, -1, 57)
    maxBtn.Visible = false
    
    local speeds = 1
    local nowe = false
    local tpwalking = false
    local flyConnections = {}
    local speaker = Player
    
    local function toggleFly()
        if nowe == true then
            nowe = false
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            onoffBtn.Text = "fly"
            onoffBtn.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        else
            nowe = true
            for i = 1, speeds do
                spawn(function()
                    local hb = game:GetService("RunService").Heartbeat
                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
            game.Players.LocalPlayer.Character.Animate.Disabled = true
            local Char = game.Players.LocalPlayer.Character
            local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
            for i,v in next, Hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            
            if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
                local plr = game.Players.LocalPlayer
                local torso = plr.Character.Torso
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50
                local speed = 0
                local bg = Instance.new("BodyGyro", torso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = torso.CFrame
                local bv = Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                if nowe == true then
                    plr.Character.Humanoid.PlatformStand = true
                end
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    game:GetService("RunService").RenderStepped:Wait()
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed+.5+(speed/maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then
                            speed = 0
                        end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
                    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                end
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                bg:Destroy()
                bv:Destroy()
                plr.Character.Humanoid.PlatformStand = false
                game.Players.LocalPlayer.Character.Animate.Disabled = false
                tpwalking = false
            else
                local plr = game.Players.LocalPlayer
                local UpperTorso = plr.Character.UpperTorso
                local ctrl = {f = 0, b = 0, l = 0, r = 0}
                local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                local maxspeed = 50
                local speed = 0
                local bg = Instance.new("BodyGyro", UpperTorso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = UpperTorso.CFrame
                local bv = Instance.new("BodyVelocity", UpperTorso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                if nowe == true then
                    plr.Character.Humanoid.PlatformStand = true
                end
                while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                    wait()
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed+.5+(speed/maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed-1
                        if speed < 0 then
                            speed = 0
                        end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
                    bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                end
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                bg:Destroy()
                bv:Destroy()
                plr.Character.Humanoid.PlatformStand = false
                game.Players.LocalPlayer.Character.Animate.Disabled = false
                tpwalking = false
            end
        end
        if nowe == true then
            onoffBtn.Text = "ON"
            onoffBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            onoffBtn.Text = "fly"
            onoffBtn.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
        end
    end
    
    onoffBtn.MouseButton1Down:Connect(toggleFly)
    
    local upPress
    upBtn.MouseButton1Down:Connect(function()
        upPress = RunService.RenderStepped:Connect(function()
            if nowe then
                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
        end)
    end)
    upBtn.MouseLeave:Connect(function()
        if upPress then
            upPress:Disconnect()
            upPress = nil
        end
    end)
    
    local downPress
    downBtn.MouseButton1Down:Connect(function()
        downPress = RunService.RenderStepped:Connect(function()
            if nowe then
                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)
            end
        end)
    end)
    downBtn.MouseLeave:Connect(function()
        if downPress then
            downPress:Disconnect()
            downPress = nil
        end
    end)
    
    plusBtn.MouseButton1Down:Connect(function()
        speeds = speeds + 1
        speedLabel.Text = speeds
        if nowe == true then
            tpwalking = false
            for i = 1, speeds do
                spawn(function()
                    local hb = game:GetService("RunService").Heartbeat
                    tpwalking = true
                    local chr = game.Players.LocalPlayer.Character
                    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                    while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                        if hum.MoveDirection.Magnitude > 0 then
                            chr:TranslateBy(hum.MoveDirection)
                        end
                    end
                end)
            end
        end
    end)
    
    minusBtn.MouseButton1Down:Connect(function()
        if speeds == 1 then
            speedLabel.Text = 'cannot be less than 1'
            task.wait(1)
            speedLabel.Text = speeds
        else
            speeds = speeds - 1
            speedLabel.Text = speeds
            if nowe == true then
                tpwalking = false
                for i = 1, speeds do
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat
                        tpwalking = true
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection)
                            end
                        end
                    end)
                end
            end
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        if nowe then
            toggleFly()
        end
        FlyMain:Destroy()
        FlyMain = nil
    end)
    
    minBtn.MouseButton1Click:Connect(function()
        upBtn.Visible = false
        downBtn.Visible = false
        onoffBtn.Visible = false
        plusBtn.Visible = false
        speedLabel.Visible = false
        minusBtn.Visible = false
        minBtn.Visible = false
        maxBtn.Visible = true
        FlyFrame.BackgroundTransparency = 1
        closeBtn.Position = UDim2.new(0, 0, -1, 57)
    end)
    
    maxBtn.MouseButton1Click:Connect(function()
        upBtn.Visible = true
        downBtn.Visible = true
        onoffBtn.Visible = true
        plusBtn.Visible = true
        speedLabel.Visible = true
        minusBtn.Visible = true
        minBtn.Visible = true
        maxBtn.Visible = false
        FlyFrame.BackgroundTransparency = 0
        closeBtn.Position = UDim2.new(0, 0, -1, 27)
    end)
    
    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.7)
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    end)
end

-- ============================================
-- ⚽ BLUE LOCK RIVALS - تبويب
-- ============================================
local function createBlueLockTab()
    local panel = createContentPanel("⚽ Blue Lock Rivals")
    
    -- زر جلب الكرة
    local pullBtn = Instance.new("TextButton")
    pullBtn.Parent = panel
    pullBtn.Size = UDim2.new(1, -5, 0, 35)
    pullBtn.Position = UDim2.new(0, 2, 0, 5)
    pullBtn.Text = "⚽ جلب الكرة"
    pullBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    pullBtn.TextSize = 12
    pullBtn.Font = Enum.Font.GothamBold
    pullBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    pullBtn.BackgroundTransparency = 0.2
    pullBtn.BorderSizePixel = 0
    
    local pullCorner = Instance.new("UICorner")
    pullCorner.CornerRadius = UDim.new(0, 6)
    pullCorner.Parent = pullBtn
    
    pullBtn.MouseEnter:Connect(function()
        pullBtn.BackgroundTransparency = 0
    end)
    pullBtn.MouseLeave:Connect(function()
        pullBtn.BackgroundTransparency = 0.2
    end)
    pullBtn.MouseButton1Click:Connect(pullBall)
    
    -- زر الانتقال إلى الكرة
    local tpBallBtn = Instance.new("TextButton")
    tpBallBtn.Parent = panel
    tpBallBtn.Size = UDim2.new(1, -5, 0, 35)
    tpBallBtn.Position = UDim2.new(0, 2, 0, 45)
    tpBallBtn.Text = "🚀 الانتقال إلى الكرة"
    tpBallBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBallBtn.TextSize = 12
    tpBallBtn.Font = Enum.Font.GothamBold
    tpBallBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    tpBallBtn.BackgroundTransparency = 0.2
    tpBallBtn.BorderSizePixel = 0
    
    local tpBallCorner = Instance.new("UICorner")
    tpBallCorner.CornerRadius = UDim.new(0, 6)
    tpBallCorner.Parent = tpBallBtn
    
    tpBallBtn.MouseEnter:Connect(function()
        tpBallBtn.BackgroundTransparency = 0
    end)
    tpBallBtn.MouseLeave:Connect(function()
        tpBallBtn.BackgroundTransparency = 0.2
    end)
    tpBallBtn.MouseButton1Click:Connect(teleportToBall)
    
    -- زر التسديد
    local shootBtn = Instance.new("TextButton")
    shootBtn.Parent = panel
    shootBtn.Size = UDim2.new(1, -5, 0, 35)
    shootBtn.Position = UDim2.new(0, 2, 0, 85)
    shootBtn.Text = "🥅 تسديد (تخترق اللاعبين)"
    shootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    shootBtn.TextSize = 12
    shootBtn.Font = Enum.Font.GothamBold
    shootBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    shootBtn.BackgroundTransparency = 0.2
    shootBtn.BorderSizePixel = 0
    
    local shootCorner = Instance.new("UICorner")
    shootCorner.CornerRadius = UDim.new(0, 6)
    shootCorner.Parent = shootBtn
    
    shootBtn.MouseEnter:Connect(function()
        shootBtn.BackgroundTransparency = 0
    end)
    shootBtn.MouseLeave:Connect(function()
        shootBtn.BackgroundTransparency = 0.2
    end)
    shootBtn.MouseButton1Click:Connect(shootBall)
    
    -- ⚽ الكرة تخترق اللاعبين
    addToggle(panel, "⚽ الكرة تخترق اللاعبين", function(state) toggleBallNoClip(state) end)
    
    -- 🎯 Aimlock على الكرة
    addToggle(panel, "🎯 Aimlock على الكرة", function(state) toggleBallAimlock(state) end)
    
    -- 🔒 الكرة تلتصق فيك
    addToggle(panel, "🔒 الكرة تلتصق فيك (تجربة)", function(state) toggleBallStick(state) end)
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
    text.Text = "💀 ROMA SENPAI V2\nصنع من طرف ROMA SENPAI"
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
    ScreenGui.Name = "RomaSenpaiV2"
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
    LogoLabel.Text = "💀 ROMA V2"
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
        addToggle(panel, "اختراق الجدران", function(state) toggleNoclip(state) end)
        addToggle(panel, "اختفاء (Invisible)", function(state) toggleInvisible(state) end)
        
        local flyGuiBtn = Instance.new("TextButton")
        flyGuiBtn.Parent = panel
        flyGuiBtn.Size = UDim2.new(1, -5, 0, 35)
        flyGuiBtn.Position = UDim2.new(0, 2, 0, 5)
        flyGuiBtn.Text = "🛩️ فتح FLY GUI V3"
        flyGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        flyGuiBtn.TextSize = 12
        flyGuiBtn.Font = Enum.Font.GothamBold
        flyGuiBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        flyGuiBtn.BackgroundTransparency = 0.2
        flyGuiBtn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = flyGuiBtn
        
        flyGuiBtn.MouseEnter:Connect(function()
            flyGuiBtn.BackgroundTransparency = 0
        end)
        flyGuiBtn.MouseLeave:Connect(function()
            flyGuiBtn.BackgroundTransparency = 0.2
        end)
        
        flyGuiBtn.MouseButton1Click:Connect(function()
            createFlyGUI()
        end)
    end
    
    local function createCombatTab()
        local panel = createContentPanel("🎯 القتال")
        addToggle(panel, "🎯 Aimbot", function(state) toggleAimbot(state) end)
        addToggle(panel, "🔒 Aim Lock", function(state) toggleAimlock(state) end)
        addToggle(panel, "👁️ ESP", function(state) toggleESP(state) end)
        addToggle(panel, "❤️ HP FULL", function(state) toggleHP(state) end)
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
    
    -- ⚽ تبويب Blue Lock
    local function createBlueLockTab()
        createBlueLockTab()
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

    -- ============================================
    -- 🎨 الأزرار الجانبية
    -- ============================================
    
    local tab1 = createTabButton("الحركة", "🚀")
    tab1.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab1
        tab1.TextColor3 = Color3.fromRGB(240, 240, 245)
        createMovementTab()
    end)

    local tab2 = createTabButton("القتال", "🎯")
    tab2.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab2
        tab2.TextColor3 = Color3.fromRGB(240, 240, 245)
        createCombatTab()
    end)

    local tab3 = createTabButton("السرعة", "⚡")
    tab3.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab3
        tab3.TextColor3 = Color3.fromRGB(240, 240, 245)
        createSpeedTab()
    end)

    local tab4 = createTabButton("اللاعبين", "👥")
    tab4.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab4
        tab4.TextColor3 = Color3.fromRGB(240, 240, 245)
        createTeleportTab()
    end)

    -- ⚽ تبويب Blue Lock Rivals
    local tab5 = createTabButton("Blue Lock", "⚽")
    tab5.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab5
        tab5.TextColor3 = Color3.fromRGB(240, 240, 245)
        createBlueLockTab()
    end)

    local tab6 = createTabButton("إضافات", "🔧")
    tab6.MouseButton1Click:Connect(function()
        if currentTabBtn then
            currentTabBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
        end
        currentTabBtn = tab6
        tab6.TextColor3 = Color3.fromRGB(240, 240, 245)
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

    print("💀 ROMA SENPAI HUB V2 Loaded!")
    print("📌 F1 = Toggle GUI")
    print("⚽ Blue Lock Rivals Tab Added!")
    showNotification("💀 ROMA HUB V2 جاهز!", Color3.fromRGB(150, 150, 255))
end

showIntro()
