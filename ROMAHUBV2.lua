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
local espObjects = {}
local aimbotTarget = nil
local aimlockTarget = nil
local aimlockCircle = nil

-- ============================================
-- ⚽ BLUE LOCK - المتغيرات
-- ============================================
local ball = nil
local ballNoClipConnection = nil
local ballAimConnection = nil
local ballStickConnection = nil

-- ============================================
-- ❤️ HP FULL
-- ============================================
local hpActive = false
local hpConnections = {}

-- ============================================
-- 🎨 SKIN LOADER
-- ============================================
local skinLoaderActive = false

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
        Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
        return 
    end
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    ball.CFrame = root.CFrame + Vector3.new(0, 2, 0)
    ball.Velocity = Vector3.new(0, 0, 0)
    ball.RotVelocity = Vector3.new(0, 0, 0)
    
    Rayfield:Notify({Title = "⚽ تم", Content = "تم جلب الكرة!", Duration = 3})
end

-- ============================================
-- 🚀 الانتقال إلى الكرة
-- ============================================
local function teleportToBall()
    if not ball then findBall() end
    if not ball then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
        return 
    end
    
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    root.CFrame = ball.CFrame + Vector3.new(0, 3, 0)
    root.Velocity = Vector3.new(0, 0, 0)
    
    Rayfield:Notify({Title = "🚀 تم", Content = "تم الانتقال إلى الكرة!", Duration = 3})
end

-- ============================================
-- 🥅 تسديد (تخترق اللاعبين)
-- ============================================
local function shootBall()
    if not ball then findBall() end
    if not ball then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
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
    
    Rayfield:Notify({Title = "⚽ تم", Content = "تم التسديد!", Duration = 3})
end

-- ============================================
-- ⚽ الكرة تخترق اللاعبين (Toggle)
-- ============================================
local function toggleBallNoClip(state)
    states.ballNoClip = state
    
    if states.ballNoClip then
        if not ball then findBall() end
        if not ball then
            Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
            return
        end
        
        if not ballNoClipConnection then
            ballNoClipConnection = RunService.Heartbeat:Connect(function()
                if not ball then return end
                ball.CanCollide = false
            end)
        end
        Rayfield:Notify({Title = "⚽ تم", Content = "الكرة تخترق اللاعبين ON", Duration = 3})
    else
        if ballNoClipConnection then
            ballNoClipConnection:Disconnect()
            ballNoClipConnection = nil
        end
        if ball then
            ball.CanCollide = true
        end
        Rayfield:Notify({Title = "⏹ تم", Content = "الكرة تخترق اللاعبين OFF", Duration = 3})
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
            Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
            return
        end
        
        if not ballAimConnection then
            ballAimConnection = RunService.RenderStepped:Connect(function()
                if not states.ballAimlock then return end
                if not ball then return end
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, ball.Position)
            end)
        end
        Rayfield:Notify({Title = "🎯 تم", Content = "Aimlock على الكرة ON", Duration = 3})
    else
        if ballAimConnection then
            ballAimConnection:Disconnect()
            ballAimConnection = nil
        end
        Rayfield:Notify({Title = "⏹ تم", Content = "Aimlock على الكرة OFF", Duration = 3})
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
            Rayfield:Notify({Title = "❌ خطأ", Content = "الكرة غير موجودة!", Duration = 3})
            return
        end
        
        if not ballStickConnection then
            ballStickConnection = RunService.Heartbeat:Connect(function()
                if not states.ballStick then return end
                if not ball then return end
                if not Player.Character then return end
                
                local root = Player.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                ball.CFrame = root.CFrame + Vector3.new(0, 2, 0)
                ball.Velocity = Vector3.new(0, 0, 0)
                ball.RotVelocity = Vector3.new(0, 0, 0)
                ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                ball.CanCollide = false
            end)
        end
        Rayfield:Notify({Title = "🔒 تم", Content = "الكرة ملتصقة فيك ON", Duration = 3})
    else
        if ballStickConnection then
            ballStickConnection:Disconnect()
            ballStickConnection = nil
        end
        if ball then
            ball.CanCollide = true
        end
        Rayfield:Notify({Title = "⏹ تم", Content = "الكرة ملتصقة فيك OFF", Duration = 3})
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
        Rayfield:Notify({Title = "🎯 تم", Content = "Aimbot ON", Duration = 3})
    else
        if connections.aimbot then
            connections.aimbot:Disconnect()
            connections.aimbot = nil
        end
        aimbotTarget = nil
        Rayfield:Notify({Title = "⏹ تم", Content = "Aimbot OFF", Duration = 3})
    end
end

-- ============================================
-- 🔒 AIM LOCK
-- ============================================
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
                    end
                else
                    aimlockTarget = nil
                end
            end)
        end
        Rayfield:Notify({Title = "🔒 تم", Content = "Aim Lock ON", Duration = 3})
    else
        if connections.aimlock then
            connections.aimlock:Disconnect()
            connections.aimlock = nil
        end
        aimlockTarget = nil
        Rayfield:Notify({Title = "⏹ تم", Content = "Aim Lock OFF", Duration = 3})
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
        Rayfield:Notify({Title = "👁️ تم", Content = "ESP ON", Duration = 3})
    else
        if connections.esp then
            connections.esp:Disconnect()
            connections.esp = nil
        end
        for plr, data in pairs(espObjects) do
            if data.box then data.box:Destroy() end
        end
        espObjects = {}
        Rayfield:Notify({Title = "⏹ تم", Content = "ESP OFF", Duration = 3})
    end
end

-- ============================================
-- ❤️ HP FULL
-- ============================================
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
        
        Rayfield:Notify({Title = "❤️ تم", Content = "HP FULL ON", Duration = 3})
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
        Rayfield:Notify({Title = "⏹ تم", Content = "HP FULL OFF", Duration = 3})
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
        Rayfield:Notify({Title = "🧱 تم", Content = "اختراق الجدران ON", Duration = 3})
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
        Rayfield:Notify({Title = "⏹ تم", Content = "اختراق الجدران OFF", Duration = 3})
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
        Rayfield:Notify({Title = "👻 تم", Content = "اختفاء ON", Duration = 3})
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
        Rayfield:Notify({Title = "👁️ تم", Content = "اختفاء OFF", Duration = 3})
    end
end

local function toggleSpeed(state)
    states.speed = state
    local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if not h then return end

    if states.speed then
        h.WalkSpeed = speedAmount
        Rayfield:Notify({Title = "⚡ تم", Content = "سرعة " .. speedAmount .. " ON", Duration = 3})
    else
        h.WalkSpeed = 16
        Rayfield:Notify({Title = "⏹ تم", Content = "سرعة OFF", Duration = 3})
    end
end

-- ============================================
-- 💀 أمر الطرد
-- ============================================
local function kickPlayer(plr)
    if not plr or plr == Player then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "لا يمكن طرد نفسك!", Duration = 3})
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
    
    Rayfield:Notify({Title = "💀 تم", Content = "تم طرد " .. plr.Name, Duration = 3})
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
    Rayfield:Notify({Title = "💀 تم", Content = "تم طرد " .. count .. " لاعب", Duration = 3})
end

-- ============================================
-- 🚀 الانتقال إلى لاعب
-- ============================================
local function teleportToPlayer(plr)
    if not plr or not plr.Character then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "اللاعب غير موجود!", Duration = 3})
        return 
    end
    
    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot or not myRoot then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "تعذر العثور على اللاعب!", Duration = 3})
        return 
    end
    
    local noclipState = states.noclip
    if not noclipState then
        toggleNoclip(true)
    end
    myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
    if not noclipState then
        task.wait(0.1)
        toggleNoclip(false)
    end
    
    Rayfield:Notify({Title = "✅ تم", Content = "تم التليفورت إلى " .. plr.Name, Duration = 3})
end

-- ============================================
-- 📥 جلب لاعب
-- ============================================
local pullConnections = {}

local function pullPlayer(plr)
    if not plr or not plr.Character then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "اللاعب غير موجود!", Duration = 3})
        return 
    end
    
    local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetRoot or not myRoot then 
        Rayfield:Notify({Title = "❌ خطأ", Content = "تعذر العثور على اللاعب!", Duration = 3})
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
    
    Rayfield:Notify({Title = "✅ تم", Content = "تم جلب " .. plr.Name, Duration = 3})
end

-- ============================================
-- 🛩️ FLY (الطيران)
-- ============================================
local FlyMain = nil
local FlyFrame = nil
local nowe = false
local tpwalking = false
local speeds = 1
local flyConnections = {}

local function toggleFly()
    local speaker = Player
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
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
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
end

local function createFlyGUI()
    if FlyMain then
        FlyMain:Destroy()
        FlyMain = nil
        return
    end
    
    FlyMain = Instance.new("ScreenGui")
    FlyMain.Name = "FlyGUI"
    FlyMain.Parent = Player.PlayerGui
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
    titleLabel.Text = "FLY V3"
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
-- 🎨 SKIN LOADER
-- ============================================
local function toggleSkinLoader()
    if skinLoaderActive then
        Rayfield:Notify({Title = "⏳ تنبيه", Content = "جاري تحميل السكنات بالفعل!", Duration = 3})
        return
    end
    
    skinLoaderActive = true
    Rayfield:Notify({Title = "🎨 تم", Content = "جاري تحميل السكنات...", Duration = 3})
    
    pcall(function()
        local success, result = pcall(function()
            return loadstring(game:HttpGet("https://loaderxzuyax.vercel.app/Csmtc%20only"))()
        end)
        
        if success then
            Rayfield:Notify({Title = "✅ تم", Content = "تم تحميل السكنات بنجاح!", Duration = 3})
        else
            Rayfield:Notify({Title = "❌ خطأ", Content = "فشل تحميل السكنات!", Duration = 3})
        end
        skinLoaderActive = false
    end)
end

-- ============================================
-- 🎮 الجرافيك الخيالي (RTX)
-- ============================================
local rtxActive = false
local rtxObjects = {}

local function toggleRTX(state)
    rtxActive = state
    
    if rtxActive then
        local Lighting = game:GetService("Lighting")
        local StarterGui = game:GetService("StarterGui")
        
        -- تنظيف الاضافات القديمة
        for i, v in pairs(rtxObjects) do
            pcall(function() v:Destroy() end)
        end
        rtxObjects = {}
        
        -- تنظيف الـ Lighting من الاضافات القديمة
        for i, v in pairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or 
               v:IsA("SunRaysEffect") or v:IsA("Sky") or v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
        
        -- انشاء المؤثرات
        local Bloom = Instance.new("BloomEffect")
        Bloom.Parent = Lighting
        table.insert(rtxObjects, Bloom)
        
        local Blur = Instance.new("BlurEffect")
        Blur.Parent = Lighting
        table.insert(rtxObjects, Blur)
        
        local ColorCor = Instance.new("ColorCorrectionEffect")
        ColorCor.Parent = Lighting
        table.insert(rtxObjects, ColorCor)
        
        local SunRays = Instance.new("SunRaysEffect")
        SunRays.Parent = Lighting
        table.insert(rtxObjects, SunRays)
        
        local Sky = Instance.new("Sky")
        Sky.Parent = Lighting
        table.insert(rtxObjects, Sky)
        
        local Atm = Instance.new("Atmosphere")
        Atm.Parent = Lighting
        table.insert(rtxObjects, Atm)
        
        -- اضافة الظل (Vignette)
        local Gui = Instance.new("ScreenGui")
        Gui.Parent = StarterGui
        Gui.IgnoreGuiInset = true
        table.insert(rtxObjects, Gui)
        
        local ShadowFrame = Instance.new("ImageLabel")
        ShadowFrame.Parent = Gui
        ShadowFrame.AnchorPoint = Vector2.new(0.5,1)
        ShadowFrame.Position = UDim2.new(0.5,0,1,0)
        ShadowFrame.Size = UDim2.new(1,0,1.05,0)
        ShadowFrame.BackgroundTransparency = 1
        ShadowFrame.Image = "rbxassetid://4576475446"
        ShadowFrame.ImageTransparency = 0.3
        ShadowFrame.ZIndex = 10
        table.insert(rtxObjects, ShadowFrame)
        
        -- ضبط المؤثرات
        Bloom.Intensity = 0.3
        Bloom.Size = 10
        Bloom.Threshold = 0.8
        
        Blur.Size = 5
        
        ColorCor.Brightness = 0.1
        ColorCor.Contrast = 0.5
        ColorCor.Saturation = -0.3
        ColorCor.TintColor = Color3.fromRGB(255, 235, 203)
        
        SunRays.Intensity = 0.075
        SunRays.Spread = 0.727
        
        Sky.SkyboxBk = "http://www.roblox.com/asset/?id=151165214"
        Sky.SkyboxDn = "http://www.roblox.com/asset/?id=151165197"
        Sky.SkyboxFt = "http://www.roblox.com/asset/?id=151165224"
        Sky.SkyboxLf = "http://www.roblox.com/asset/?id=151165191"
        Sky.SkyboxRt = "http://www.roblox.com/asset/?id=151165206"
        Sky.SkyboxUp = "http://www.roblox.com/asset/?id=151165227"
        Sky.SunAngularSize = 10
        
        Lighting.Ambient = Color3.fromRGB(2,2,2)
        Lighting.Brightness = 2.25
        Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
        Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
        Lighting.EnvironmentDiffuseScale = 0.2
        Lighting.EnvironmentSpecularScale = 0.2
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        Lighting.ShadowSoftness = 0.2
        Lighting.ClockTime = 17
        Lighting.GeographicLatitude = 45
        Lighting.ExposureCompensation = 0.5
        Lighting.Technology = Enum.Technology.ShadowMap
        
        Atm.Density = 0.364
        Atm.Offset = 0.556
        Atm.Color = Color3.fromRGB(199, 175, 166)
        Atm.Decay = Color3.fromRGB(44, 39, 33)
        Atm.Glare = 0.36
        Atm.Haze = 1.72
        
        Rayfield:Notify({Title = "🎮 تم", Content = "تم تفعيل الجرافيك الخيالي (RTX)!", Duration = 3})
    else
        -- إزالة المؤثرات
        for i, v in pairs(rtxObjects) do
            pcall(function() v:Destroy() end)
        end
        rtxObjects = {}
        
        -- إعادة ضبط الـ Lighting
        local Lighting = game:GetService("Lighting")
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        Lighting.Brightness = 1
        Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
        Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
        Lighting.EnvironmentDiffuseScale = 1
        Lighting.EnvironmentSpecularScale = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        Lighting.ShadowSoftness = 0.3
        Lighting.ClockTime = 14
        Lighting.GeographicLatitude = 45
        Lighting.ExposureCompensation = 0
        Lighting.Technology = Enum.Technology.ShadowMap
        
        Rayfield:Notify({Title = "⏹ تم", Content = "تم إيقاف الجرافيك الخيالي", Duration = 3})
    end
end

-- ============================================
-- 🔄 إيقاف الكل
-- ============================================
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
    
    -- إيقاف RTX
    if rtxActive then
        toggleRTX(false)
    end
    
    Rayfield:Notify({Title = "⏹ تم", Content = "تم إيقاف الكل!", Duration = 3})
end

-- ============================================
-- 📦 تحميل Rayfield
-- ============================================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "💀 ROMA SENPAI V2",
    LoadingTitle = "💀 ROMA SENPAI HUB",
    LoadingSubtitle = "صنع من طرف ROMA SENPAI",
    ConfigurationSaving = { Enabled = false }
})

-- ============================================
-- 📂 التاب: الحركة 🚀
-- ============================================
local MovementTab = Window:CreateTab("🚀 الحركة")

MovementTab:CreateToggle({
    Name = "🧱 اختراق الجدران",
    CurrentValue = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

MovementTab:CreateToggle({
    Name = "👻 اختفاء (Invisible)",
    CurrentValue = false,
    Callback = function(Value)
        toggleInvisible(Value)
    end
})

MovementTab:CreateButton({
    Name = "🛩️ فتح الطيران",
    Callback = function()
        createFlyGUI()
        Rayfield:Notify({
            Title = "✅ تم",
            Content = "تم فتح الطيران",
            Duration = 3
        })
    end
})

-- ============================================
-- 📂 التاب: القتال 🎯
-- ============================================
local CombatTab = Window:CreateTab("🎯 القتال")

CombatTab:CreateToggle({
    Name = "🎯 Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        toggleAimbot(Value)
    end
})

CombatTab:CreateToggle({
    Name = "🔒 Aim Lock",
    CurrentValue = false,
    Callback = function(Value)
        toggleAimlock(Value)
    end
})

CombatTab:CreateToggle({
    Name = "👁️ ESP",
    CurrentValue = false,
    Callback = function(Value)
        toggleESP(Value)
    end
})

CombatTab:CreateToggle({
    Name = "❤️ HP FULL",
    CurrentValue = false,
    Callback = function(Value)
        toggleHP(Value)
    end
})

-- ============================================
-- 📂 التاب: السرعة ⚡
-- ============================================
local SpeedTab = Window:CreateTab("⚡ السرعة")

SpeedTab:CreateToggle({
    Name = "⚡ تفعيل السرعة العالية",
    CurrentValue = false,
    Callback = function(Value)
        toggleSpeed(Value)
    end
})

SpeedTab:CreateInput({
    Name = "📝 تعديل قيمة السرعة",
    PlaceholderText = "أدخل قيمة السرعة (افتراضي: 120)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            speedAmount = num
            if states.speed then
                local h = Player.Character and Player.Character:FindFirstChild("Humanoid")
                if h then
                    h.WalkSpeed = speedAmount
                end
            end
            Rayfield:Notify({
                Title = "✅ تم",
                Content = "تم ضبط السرعة إلى: " .. speedAmount,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "❌ خطأ",
                Content = "يرجى إدخال رقم صحيح!",
                Duration = 3
            })
        end
    end
})

-- ============================================
-- 📂 التاب: اللاعبين 👥
-- ============================================
local PlayersTab = Window:CreateTab("👥 اللاعبين")

-- قائمة اللاعبين ديناميكية (زر)
PlayersTab:CreateButton({
    Name = "🔄 تحديث قائمة اللاعبين",
    Callback = function()
        local playerList = "👥 اللاعبين:\n"
        local count = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                count = count + 1
                playerList = playerList .. "• " .. plr.Name .. " (ID: " .. plr.UserId .. ")\n"
            end
        end
        if count == 0 then
            playerList = playerList .. "❌ لا يوجد لاعبين آخرين"
        end
        Rayfield:Notify({
            Title = "📋 قائمة اللاعبين",
            Content = playerList,
            Duration = 8
        })
    end
})

-- اختيار لاعب (إدخال اسم)
local selectedPlayerName = ""

PlayersTab:CreateInput({
    Name = "📝 اسم اللاعب",
    PlaceholderText = "أدخل اسم اللاعب",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        selectedPlayerName = text
    end
})

-- الانتقال إلى لاعب
PlayersTab:CreateButton({
    Name = "🚀 انتقال إلى لاعب",
    Callback = function()
        if selectedPlayerName == "" then
            Rayfield:Notify({
                Title = "⚠️ تنبيه",
                Content = "يرجى إدخال اسم اللاعب أولاً!",
                Duration = 3
            })
            return
        end
        local target = Players:FindFirstChild(selectedPlayerName)
        if target then
            teleportToPlayer(target)
        else
            Rayfield:Notify({
                Title = "❌ خطأ",
                Content = "اللاعب غير موجود!",
                Duration = 3
            })
        end
    end
})

-- جلب لاعب
PlayersTab:CreateButton({
    Name = "📥 جلب لاعب",
    Callback = function()
        if selectedPlayerName == "" then
            Rayfield:Notify({
                Title = "⚠️ تنبيه",
                Content = "يرجى إدخال اسم اللاعب أولاً!",
                Duration = 3
            })
            return
        end
        local target = Players:FindFirstChild(selectedPlayerName)
        if target then
            pullPlayer(target)
        else
            Rayfield:Notify({
                Title = "❌ خطأ",
                Content = "اللاعب غير موجود!",
                Duration = 3
            })
        end
    end
})

-- طرد لاعب
PlayersTab:CreateButton({
    Name = "💀 طرد لاعب",
    Callback = function()
        if selectedPlayerName == "" then
            Rayfield:Notify({
                Title = "⚠️ تنبيه",
                Content = "يرجى إدخال اسم اللاعب أولاً!",
                Duration = 3
            })
            return
        end
        local target = Players:FindFirstChild(selectedPlayerName)
        if target then
            kickPlayer(target)
        else
            Rayfield:Notify({
                Title = "❌ خطأ",
                Content = "اللاعب غير موجود!",
                Duration = 3
            })
        end
    end
})

-- طرد الجميع
PlayersTab:CreateButton({
    Name = "💀 طرد جميع اللاعبين",
    Callback = function()
        kickAllPlayers()
    end
})

-- إعادة الانضمام
PlayersTab:CreateButton({
    Name = "🔄 إعادة الانضمام",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Player)
        Rayfield:Notify({
            Title = "✅ تم",
            Content = "جاري إعادة الانضمام...",
            Duration = 3
        })
    end
})

-- ============================================
-- 📂 التاب: الاضافات 🎨
-- ============================================
local AddonsTab = Window:CreateTab("🎨 الاضافات")

AddonsTab:CreateButton({
    Name = "🎨 تحميل السكنات",
    Callback = function()
        toggleSkinLoader()
    end
})

AddonsTab:CreateToggle({
    Name = "🎮 الجرافيك الخيالي (RTX)",
    CurrentValue = false,
    Callback = function(Value)
        toggleRTX(Value)
    end
})

-- ============================================
-- 📂 التاب: Blue Lock ⚽
-- ============================================
local BlueLockTab = Window:CreateTab("⚽ Blue Lock")

BlueLockTab:CreateLabel("📌 قد يستغرق التحميل بضع ثواني")

-- جلب الكرة
BlueLockTab:CreateButton({
    Name = "⚽ جلب الكرة",
    Callback = function()
        pullBall()
    end
})

-- الانتقال إلى الكرة
BlueLockTab:CreateButton({
    Name = "🚀 الانتقال إلى الكرة",
    Callback = function()
        teleportToBall()
    end
})

-- تسديد
BlueLockTab:CreateButton({
    Name = "🥅 تسديد (تخترق اللاعبين)",
    Callback = function()
        shootBall()
    end
})

-- الكرة تخترق اللاعبين
BlueLockTab:CreateToggle({
    Name = "⚽ الكرة تخترق اللاعبين",
    CurrentValue = false,
    Callback = function(Value)
        toggleBallNoClip(Value)
    end
})

-- Aimlock على الكرة
BlueLockTab:CreateToggle({
    Name = "🎯 Aimlock على الكرة",
    CurrentValue = false,
    Callback = function(Value)
        toggleBallAimlock(Value)
    end
})

-- الكرة تلتصق فيك
BlueLockTab:CreateToggle({
    Name = "🔒 الكرة تلتصق فيك",
    CurrentValue = false,
    Callback = function(Value)
        toggleBallStick(Value)
    end
})

-- إيقاف الكل
BlueLockTab:CreateButton({
    Name = "🔄 إيقاف الكل",
    Callback = function()
        stopAll()
    end
})

-- ============================================
-- 📂 التاب: معلومات ℹ️
-- ============================================
local InfoTab = Window:CreateTab("ℹ️ معلومات")

InfoTab:CreateLabel("💀 ROMA SENPAI HUB V2")
InfoTab:CreateLabel("صنع من طرف ROMA SENPAI")
InfoTab:CreateLabel("📌 F1 = Toggle GUI")
InfoTab:CreateLabel("⚽ يدعم Blue Lock Rivals")
InfoTab:CreateLabel("🎨 يدعم الاضافات والجرافيك الخيالي")

InfoTab:CreateButton({
    Name = "🔄 إعادة تعيين الكل",
    Callback = function()
        stopAll()
        Rayfield:Notify({
            Title = "✅ تم",
            Content = "تم إعادة تعيين جميع الإعدادات",
            Duration = 3
        })
    end
})

print("💀 ROMA SENPAI HUB V2 Loaded!")
print("📌 F1 = Toggle GUI")
print("⚽ Blue Lock Rivals Tab Added!")
print("🎨 Addons Tab Added (Skin Loader + RTX)!")
print("🎮 RTX Graphics Added!")
