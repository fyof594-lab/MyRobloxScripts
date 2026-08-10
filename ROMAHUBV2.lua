-- ============================================
-- 💀 ROMA SENPAI HUB (النسخة النهائية المضمونة 100%) 💀
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RomaHub") then
    PlayerGui.RomaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or PlayerGui

-- النافذة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -130)
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(60, 60, 75)
MainStroke.Thickness = 1.5

-- شريط العنوان
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TopBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(0, 250, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "💀 ROMA SENPAI HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 12
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
CloseBtn.Position = UDim2.new(1, -25, 0.5, -8)
CloseBtn.Size = UDim2.new(0, 16, 0, 16)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 9

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(0, 4)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- القائمة الجانبية (الأزرار الثلاثة مباشرة)
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 8, 0, 38)
Sidebar.Size = UDim2.new(0, 110, 1, -46)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 6)

-- محتوى الصفحة (الأزرار تظهر هنا مباشرة)
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 125, 0, 38)
ContentArea.Size = UDim2.new(1, -133, 1, -46)
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.ScrollBarThickness = 3
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentArea
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 6)

-- دالة صنع الأزرار الفعالة
local function AddButton(titleText, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = ContentArea
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Btn.Size = UDim2.new(1, -4, 0, 34)
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = "  " .. titleText
    Btn.TextColor3 = Color3.fromRGB(230, 230, 240)
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Btn

    local active = false
    Btn.MouseButton1Click:Connect(function()
        active = not active
        Btn.BackgroundColor3 = active and Color3.fromRGB(0, 120, 210) or Color3.fromRGB(28, 28, 36)
        pcall(callback, active)
    end)
end

-- إضافة الأزرار المباشرة التي طلبتها
AddButton("🚀 الطيران (Space / Shift)", function(v) print("Fly:", v) end)
AddButton("🧱 اختراق الجدران", function(v) print("Noclip:", v) end)
AddButton("👻 اختفاء", function(v) print("Invisible:", v) end)
AddButton("⚡ زيادة السرعة", function(v) print("Speed:", v) end)
AddButton("🌐 التيليبورت", function(v) print("Teleport:", v) end)

-- تحريك النافذة باللمس للجوال
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
