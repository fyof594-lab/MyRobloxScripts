-- ============================================
-- 💀 ROMA SENPAI HUB 💀
-- صنع من طرف ROMA SENPAI (نسخة نهائية مضبوطة 100%)
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- إزالة النسخة القديمة لمنع التكرار
if PlayerGui:FindFirstChild("RomaHub") then
    PlayerGui.RomaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- النافذة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(50, 50, 65)
MainStroke.Thickness = 1.5

-- ============================================
-- 🔝 شريط العنوان العلوي (TopBar)
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 32)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Parent = TopBar
TopBarFix.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TopBarFix.BorderSizePixel = 0
TopBarFix.Position = UDim2.new(0, 0, 1, -5)
TopBarFix.Size = UDim2.new(1, 0, 0, 5)

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

-- ============================================
-- 🔵 زر فتح وإغلاق عائم (يظهر لما تصغر القائمة)
-- ============================================
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
FloatingBtn.AutoButtonColor = false
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "💀"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 20
FloatingBtn.Visible = false -- مخفي بالبداية لأن الهب بيكون مفتوح

local FBなんだ = Instance.new("UICorner")
FBなんだ.CornerRadius = UDim.new(1, 0)
FBなんだ.Parent = FloatingBtn

local FBStroke = Instance.new("UIStroke")
FBStroke.Parent = FloatingBtn
FBStroke.Color = Color3.fromRGB(0, 170, 255)
FBStroke.Thickness = 2

-- زر التصغير/الإغلاق (X) في الشريط العلوي
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 45, 45)
CloseButton.Position = UDim2.new(1, -26, 0.5, -9)
CloseButton.Size = UDim2.new(0, 18, 0, 18)
CloseButton.AutoButtonColor = false
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "-"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 11

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

-- وظيفة زر التصغير والإظهار
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingBtn.Visible = true
end)

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- ============================================
-- 📂 القائمة الجانبية (Sidebar)
-- ============================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.Active = true
Sidebar.BackgroundColor3 = Color3.fromRGB(21, 21, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.Size = UDim2.new(0, 120, 1, -32)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 0
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.TopPadding = UDim.new(0, 6)

-- ============================================
-- 🖥️ حاوية الصفحات (تم تصحيح المقاسات لتظهر الأزرار بوضوح)
-- ============================================
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 125, 0, 38)
PagesContainer.Size = UDim2.new(1, -130, 1, -42)

local CurrentTab = nil
local Pages = {}

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = Sidebar
    TabButton.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(0, 108, 0, 28)
    TabButton.AutoButtonColor = false
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = "  " .. icon .. "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabButton.TextSize = 10
    TabButton.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = PagesContainer
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    Pages[name] = Page

    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.15), {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(150, 150, 160)
                }):Play()
            end
        end
        Page.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.15), {
            BackgroundTransparency = 0,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    if not CurrentTab then
        CurrentTab = name
        Page.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return Page
end

-- ============================================
-- 🛠️ دالة إضافة أزرار التفعيل (Toggles)
-- ============================================
local function AddToggle(parentPage, titleText, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parentPage
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    ToggleFrame.Size = UDim2.new(1, -6, 0, 30)

    local TFCorner = Instance.new("UICorner")
    TFCorner.CornerRadius = UDim.new(0, 5)
    TFCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(200, 200, 215)
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    ToggleBtn.Position = UDim2.new(1, -36, 0.5, -7)
    ToggleBtn.Size = UDim2.new(0, 28, 0, 14)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(1, 0)
    TBCorner.Parent = ToggleBtn

    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBtn
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Position = UDim2.new(0, 2, 0.5, -5)
    Circle.Size = UDim2.new(0, 10, 0, 10)

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(1, 0)
    CC.Parent = Circle

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        local goalCirclePos = toggled and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        local goalColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 52)
        
        TweenService:Create(Circle, TweenInfo.new(0.15), {Position = goalCirclePos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = goalColor}):Play()
        
        pcall(callback, toggled)
    end)
end

-- بناء الأقسام والأزرار بداخلها
local MovementPage = CreateTab("الحركة", "🚀")
local SpeedPage = CreateTab("السرعة", "⚡")
local ExtrasPage = CreateTab("إضافات", "🔧")

AddToggle(MovementPage, "الطيران (Space / Shift)", function(state) print(state) end)
AddToggle(MovementPage, "اختراق الجدران", function(state) print(state) end)
AddToggle(MovementPage, "اختفاء", function(state) print(state) end)
AddToggle(SpeedPage, "زيادة السرعة الخارقة", function(state) print(state) end)
AddToggle(ExtrasPage, "التيليبورت العشوائي", function(state) print(state) end)

-- ============================================
-- 🖱️ خاصية السحب للموبايل والكمبيوتر (Draggable)
-- ============================================
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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
