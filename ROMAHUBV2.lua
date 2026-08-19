--[[
  واجهة مستخدم رسومية (GUI) لأداة Aimbot في Roblox.
  تحتوي على:
  - زر التفعيل (Toggle)
  - خيارات: تجاهل الزملاء (Ignore Team), اختراق الجدران (Wallbang)
  - مؤشرات (Indicators) لتوضيح حالة كل خيار.
  - إطار قابل للسحب.
--]]

-- المتغيرات العامة
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- إعدادات الواجهة
local Gui = Instance.new("ScreenGui")
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

-- الإطار الرئيسي (قابل للسحب)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = Gui
MainFrame.Size = UDim2.new(0, 140, 0, 200)
MainFrame.Position = UDim2.new(0.5, -70, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 20)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0

-- عنوان "AIMBOT"
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Text = "AIMBOT"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSans
TitleLabel.TextSize = 18
TitleLabel.BackgroundTransparency = 1

-- زر التفعيل (Toggle)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = MainFrame
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 30)
ToggleButton.Text = "Enable: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 24
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleButton.BorderSizePixel = 0

-- زر تجاهل الزملاء (Ignore Team)
local IgnoreTeamButton = Instance.new("TextButton")
IgnoreTeamButton.Parent = MainFrame
IgnoreTeamButton.Size = UDim2.new(0, 120, 0, 20)
IgnoreTeamButton.Position = UDim2.new(0, 10, 0, 80)
IgnoreTeamButton.Text = "Ignore Team: OFF"
IgnoreTeamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IgnoreTeamButton.Font = Enum.Font.SourceSans
IgnoreTeamButton.TextSize = 18
IgnoreTeamButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
IgnoreTeamButton.BorderSizePixel = 0

-- مؤشر Ignore Team (مربع صغير)
local IgnoreTeamIndicator = Instance.new("Frame")
IgnoreTeamIndicator.Parent = IgnoreTeamButton
IgnoreTeamIndicator.Size = UDim2.new(0, 20, 0, 20)
IgnoreTeamIndicator.Position = UDim2.new(0, 0, 0, 0)
IgnoreTeamIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
IgnoreTeamIndicator.BorderSizePixel = 1

-- زر اختراق الجدران (Wallbang)
local WallbangButton = Instance.new("TextButton")
WallbangButton.Parent = MainFrame
WallbangButton.Size = UDim2.new(0, 120, 0, 20)
WallbangButton.Position = UDim2.new(0, 10, 0, 110)
WallbangButton.Text = "Wallbang: OFF"
WallbangButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WallbangButton.Font = Enum.Font.SourceSans
WallbangButton.TextSize = 18
WallbangButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WallbangButton.BorderSizePixel = 0

-- مؤشر Wallbang (مربع صغير)
local WallbangIndicator = Instance.new("Frame")
WallbangIndicator.Parent = WallbangButton
WallbangIndicator.Size = UDim2.new(0, 20, 0, 20)
WallbangIndicator.Position = UDim2.new(0, 0, 0, 0)
WallbangIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
WallbangIndicator.BorderSizePixel = 1

-- حقل إدخال إزاحة الهدف X
local OffsetXBox = Instance.new("TextBox")
OffsetXBox.Parent = MainFrame
OffsetXBox.Size = UDim2.new(0, 40, 0, 20)
OffsetXBox.Position = UDim2.new(0, 10, 0, 140)
OffsetXBox.Text = "X"
OffsetXBox.TextColor3 = Color3.fromRGB(255, 255, 255)
OffsetXBox.Font = Enum.Font.SourceSans
OffsetXBox.TextSize = 18
OffsetXBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OffsetXBox.BorderSizePixel = 0

-- حقل إدخال إزاحة الهدف Y
local OffsetYBox = Instance.new("TextBox")
OffsetYBox.Parent = MainFrame
OffsetYBox.Size = UDim2.new(0, 40, 0, 20)
OffsetYBox.Position = UDim2.new(0, 60, 0, 140)
OffsetYBox.Text = "Y"
OffsetYBox.TextColor3 = Color3.fromRGB(255, 255, 255)
OffsetYBox.Font = Enum.Font.SourceSans
OffsetYBox.TextSize = 18
OffsetYBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OffsetYBox.BorderSizePixel = 0

-- الحالات (States)
local AimbotEnabled = false
local IgnoreTeamEnabled = false
local WallbangEnabled = false

-- وظيفة زر التفعيل
ToggleButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    ToggleButton.Text = "Enable: " .. (AimbotEnabled and "ON" or "OFF")
    local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(ToggleButton, TweenInfo, { BackgroundColor3 = (AimbotEnabled and Color3.fromRGB(0, 200, 0)) or Color3.fromRGB(200, 0, 0) })
    Tween:Play()
end)

-- وظيفة زر تجاهل الزملاء
IgnoreTeamButton.MouseButton1Click:Connect(function()
    IgnoreTeamEnabled = not IgnoreTeamEnabled
    local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(IgnoreTeamIndicator, TweenInfo, { BackgroundColor3 = (IgnoreTeamEnabled and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) })
    Tween:Play()
end)

-- وظيفة زر اختراق الجدران
WallbangButton.MouseButton1Click:Connect(function()
    WallbangEnabled = not WallbangEnabled
    local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Tween = TweenService:Create(WallbangIndicator, TweenInfo, { BackgroundColor3 = (WallbangEnabled and Color3.fromRGB(0, 255, 0)) or Color3.fromRGB(255, 0, 0) })
    Tween:Play()
end)

-- متغيرات للسحب
local isDragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

-- وظيفة تحديث موضع الإطار أثناء السحب
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- بدء السحب
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

-- تحديث السحب
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- تطبيق السحب على الإطار
UserInputService.InputChanged:Connect(function(input)
    if isDragging and input == dragInput then
        updateDrag(input)
    end
end)

-- دوال Aimbot الأساسية

-- التحقق من وجود الهدف في خط الرؤية
local function isVisible(target)
    local character = target.Character
    if not character then return false end
    local head = character:FindFirstChild("Head")
    if not head then return false end
    local ray = Ray.new(LocalPlayer.Character.Head.Position, (head.Position - LocalPlayer.Character.Head.Position).unit * 300)
    local hit, position = RunService:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit and hit:IsDescendantOf(character)
end

-- البحث عن أقرب لاعب (الهدف)
local function getClosestPlayer()
    local closest = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local head = character.Head
                local distance = (head.Position - LocalPlayer.Character.Head.Position).magnitude
                if IgnoreTeamEnabled and player.Team == LocalPlayer.Team then continue end
                if player.Character.Humanoid.Health <= 0 then continue end
                if WallbangEnabled and not isVisible(player) then continue end
                if distance < closestDistance then
                    closest = player
                    closestDistance = distance
                end
            end
        end
    end
    return closest
end

-- متغير التويين (Tween) الخاص بالكاميرا
local cameraTween = nil

-- توجيه الكاميرا نحو الهدف
local function aimAtPlayer(target)
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local camera = RunService.CurrentCamera
        local offsetX = tonumber(OffsetXBox.Text) or 0
        local offsetY = tonumber(OffsetYBox.Text) or 0
        local targetPosition = head.Position + Vector3.new(offsetX, offsetY, 0)

        if cameraTween then cameraTween:Cancel() end

        local tweenInfo = TweenInfo.new(0.007, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenProperties = { CFrame = CFrame.new(camera.CFrame.Position, targetPosition) }
        cameraTween = TweenService:Create(camera, tweenInfo, tweenProperties)
        cameraTween:Play()
    end
end

-- التحديث المستمر (RenderStepped)
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        aimAtPlayer(target)
    end
end)
