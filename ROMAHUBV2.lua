-- ============================================
-- 💀 ROMA SENPAI HUB 💀
-- مخصص للعمل على Delta Executor
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- تنظيف الأنسخة القديمة
if PlayerGui:FindFirstChild("RomaHub") then
    PlayerGui.RomaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false

-- اختيار الحاوية المناسبة لمحقن Delta
local TargetParent = PlayerGui
if gethui then
    TargetParent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    TargetParent = game:GetService("CoreGui")
end
ScreenGui.Parent = TargetParent

-- النافذة الرئيسية (مقاس مدمج 360x240 يناسب شاشة الجوال)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(60, 60, 75)
MainStroke.Thickness = 1.5

-- الشريط العلوي
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 32)

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TopBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "💀 ROMA SENPAI HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 12
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- زر إظهار/إخفاء عائم عند تصغير القائمة
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "FloatingBtn"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
FloatingBtn.Position = UDim2.new(0, 15, 0.4, 0)
FloatingBtn.Size = UDim2.new(0, 42, 0, 42)
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "💀"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 18
FloatingBtn.Visible = false

local FBCorner = Instance.new("UICorner")
FBCorner.CornerRadius = UDim.new(1, 0)
FBCorner.Parent = FloatingBtn

local FBStroke = Instance.new("UIStroke")
FBStroke.Parent = FloatingBtn
FBStroke.Color = Color3.fromRGB(0, 170, 255)
FBStroke.Thickness = 1.5

-- زر التصغير (-)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -9)
CloseBtn.Size = UDim2.new(0, 18, 0, 18)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "-"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12

local CBCorner = Instance.new("UICorner")
CBCorner.CornerRadius = UDim.new(0, 4)
CBCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingBtn.Visible = true
end)

FloatingBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingBtn.Visible = false
end)

-- القائمة الجانبية
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.Size = UDim2.new(0, 105, 1, -32)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.TopPadding = UDim.new(0, 6)

-- حاوية الصفحات
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 110, 0, 36)
PagesContainer.Size = UDim2.new(1, -115, 1, -40)

local CurrentTab = nil
local Pages = {}

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = Sidebar
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(0, 95, 0, 26)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = " " .. icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 165)
    TabButton.TextSize = 10
    TabButton.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = PagesContainer
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
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
                b.BackgroundTransparency = 1
                b.TextColor3 = Color3.fromRGB(150, 150, 165)
            end
        end
        Page.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    if not CurrentTab then
        CurrentTab = name
        Page.Visible = true
        TabButton.BackgroundTransparency = 0
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return Page
end

local function AddToggle(parentPage, titleText, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parentPage
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    ToggleFrame.Size = UDim2.new(1, -4, 0, 28)

    local TFCorner = Instance.new("UICorner")
    TFCorner.CornerRadius = UDim.new(0, 4)
    TFCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 6, 0, 0)
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(210, 210, 220)
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    ToggleBtn.Position = UDim2.new(1, -32, 0.5, -6)
    ToggleBtn.Size = UDim2.new(0, 26, 0, 12)
    ToggleBtn.Text = ""

    local TBCorner = Instance.new("UICorner")
    TBCorner.CornerRadius = UDim.new(1, 0)
    TBCorner.Parent = ToggleBtn

    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBtn
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Position = UDim2.new(0, 2, 0.5, -4)
    Circle.Size = UDim2.new(0, 8, 0, 8)

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(1, 0)
    CC.Parent = Circle

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Circle.Position = toggled and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
        ToggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 58)
        pcall(callback, toggled)
    end)
end

-- إنشاء التبويبات والأزرار
local MovementPage = CreateTab("الحركة", "🚀")
local SpeedPage = CreateTab("السرعة", "⚡")
local ExtrasPage = CreateTab("إضافات", "🔧")

AddToggle(MovementPage, "الطيران", function(state) print("Fly:", state) end)
AddToggle(MovementPage, "اختراق الجدران", function(state) print("Noclip:", state) end)
AddToggle(MovementPage, "اختفاء", function(state) print("Invisible:", state) end)
AddToggle(SpeedPage, "سرعة عالية", function(state) print("Speed:", state) end)
AddToggle(ExtrasPage, "تيليبورت", function(state) print("TP:", state) end)

-- تحريك النافذة للمس الجوال
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
