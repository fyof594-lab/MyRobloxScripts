-- ============================================
-- 💀 Blue Lock Rivals - Full Exploit Menu
-- ============================================

local Player = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- واجهة
local GUI = Instance.new("ScreenGui")
GUI.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Parent = GUI
Main.Size = UDim2.new(0, 180, 0, 350)
Main.Position = UDim2.new(0.75, 0, 0.45, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "💀 Exploit Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold

-- قائمة
local BtnList = Instance.new("ScrollingFrame")
BtnList.Parent = Main
BtnList.Size = UDim2.new(1, -10, 0, 315)
BtnList.Position = UDim2.new(0, 5, 0, 30)
BtnList.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
BtnList.BorderSizePixel = 0
BtnList.ScrollBarThickness = 2

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 5)
ListCorner.Parent = BtnList

-- ============================================
-- دالة إرسال
-- ============================================
local function fire(remoteName, ...)
    for _, v in pairs(RS:GetDescendants()) do
        if v.Name == remoteName then
            pcall(function()
                v:FireServer(...)
            end)
        end
    end
end

-- ============================================
-- دالة إنشاء زر
-- ============================================
local function createButton(yPos, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = BtnList
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ============================================
-- الأزرار
-- ============================================
local yOff = 5

-- No Cooldown
createButton(yOff, "⏳ No Cooldown", function()
    fire("AdmResetCDs", Player)
    fire("ToggleCooldowns", true)
    fire("UpdateDribbleCooldown", 0)
    fire("AbCutCooldown", 0)
end)
yOff = yOff + 33

-- Speed
createButton(yOff, "⚡ Set Speed 500", function()
    fire("SetSpeed", 500)
    fire("ChangeSpeed", 500)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = 500
    end
end)
yOff = yOff + 33

-- Teleport
createButton(yOff, "🚀 Teleport", function()
    fire("Teleport", Player)
    fire("Teleport", Player.Character.HumanoidRootPart)
    fire("Teleport", CFrame.new(0, 100, 0))
end)
yOff = yOff + 33

-- Set Size
createButton(yOff, "📏 Set Size 10", function()
    fire("SetSize", 10)
    fire("SetSize", Player, 10)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
    end
end)
yOff = yOff + 33

-- Awakening
createButton(yOff, "💥 Instant Awakening", function()
    fire("InstantAwakening", Player)
    fire("PublicInstantAwakening", Player)
    fire("SecretAwakening", Player)
    fire("StartAwakening", Player)
end)
yOff = yOff + 33

-- Set Style
createButton(yOff, "🎨 Set Style", function()
    fire("SetStyle", "NEL Bachira")
    fire("SetStyle", Player, "NEL Bachira")
end)
yOff = yOff + 33

-- Money
createButton(yOff, "💰 Money 9999999", function()
    fire("Money", 9999999)
    fire("Money", Player, 9999999)
end)
yOff = yOff + 33

-- Dribble
createButton(yOff, "⚽ Dribble", function()
    fire("GrabBallDribble", workspace.CurrentCamera.CFrame.LookVector)
    fire("Dribble", workspace.CurrentCamera.CFrame.LookVector)
end)
yOff = yOff + 33

-- Slide
createButton(yOff, "🛝 Slide", function()
    fire("Slide", Player)
    fire("Slide", Player.Character)
end)
yOff = yOff + 33

-- Jump
createButton(yOff, "⬆️ Jump", function()
    fire("Jump", Player)
    fire("Jump", Player.Character)
end)
yOff = yOff + 33

-- Shoot
createButton(yOff, "🥅 Shoot", function()
    fire("Shoot", workspace.CurrentCamera.CFrame.LookVector)
    fire("Shoot", Player)
end)
yOff = yOff + 33

-- Pass
createButton(yOff, "📤 Pass", function()
    fire("Pass", Player)
    fire("Pass", workspace.CurrentCamera.CFrame.LookVector)
end)
yOff = yOff + 33

-- Set Flow
createButton(yOff, "💧 Set Flow 100", function()
    fire("SetFlow", 100)
    fire("SetFlow", Player, 100)
end)
yOff = yOff + 33

-- Boost
createButton(yOff, "🔥 Boost", function()
    fire("Boost", Player)
    fire("Boost", true)
end)
yOff = yOff + 33

-- Execute Command
createButton(yOff, "💀 Execute Command", function()
    fire("ExecuteCommand", "kill all")
    fire("ExecuteCommand", "reset cds")
end)
yOff = yOff + 33

-- Screen Blind
createButton(yOff, "🌑 Screen Blind", function()
    fire("ScreenBlind", true)
    fire("ScreenBlind", Player)
end)
yOff = yOff + 33

-- Controls Inversed
createButton(yOff, "🔄 Controls Inversed", function()
    fire("ControlsInversed", true)
    fire("ControlsInversed", Player)
end)
yOff = yOff + 33

-- Ability
createButton(yOff, "⚡ Ability", function()
    fire("Ability", Player)
    fire("Ability", "dribble")
    fire("Ability", "shoot")
end)
yOff = yOff + 33

BtnList.CanvasSize = UDim2.new(0, 0, 0, yOff + 10)

print("✅ القائمة جاهزة!")
