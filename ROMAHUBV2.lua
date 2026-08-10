-- ============================================
-- 💀 ROMA SENPAI HUB 💀
-- صنع من طرف ROMA SENPAI (نسخة محسنة وأسطورية)
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- إزالة النسخة القديمة إن وجدت لمنع التكرار
if PlayerGui:FindFirstChild("RomaHub") then
    PlayerGui.RomaHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- النافذة الرئيسية (حجم متناسق ومناسب للشاشات)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -155)
MainFrame.Size = UDim2.new(0, 460, 0, 310)
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- تأثير حدود خفيفة للنافذة (Stroke)
local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1.5

-- ============================================
-- 📂 القائمة الجانبية (Sidebar)
-- ============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Size = UDim2.new(0, 140, 1, 0)

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

-- العنوان في القائمة الجانبية
local HubTitle = Instance.new("TextLabel")
HubTitle.Parent = Sidebar
HubTitle.BackgroundTransparency = 1
HubTitle.Position = UDim2.new(0, 12, 0, 12)
HubTitle.Size = UDim2.new(1, -24, 0, 25)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.Text = "Roma Hub"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.TextSize = 15
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local HubSubtitle = Instance.new("TextLabel")
HubSubtitle.Parent = Sidebar
HubSubtitle.BackgroundTransparency = 1
HubSubtitle.Position = UDim2.new(0, 12, 0, 32)
HubSubtitle.Size = UDim2.new(1, -24, 0, 15)
HubSubtitle.Font = Enum.Font.Gotham
HubSubtitle.Text = "by Roma Senpai"
HubSubtitle.TextColor3 = Color3.fromRGB(140, 140, 150)
HubSubtitle.TextSize = 10
HubSubtitle.TextXAlignment = Enum.TextXAlignment.Left

-- حاوية الأزرار الجانبية
local TabsContainer = Instance.new("ScrollingFrame")
TabsContainer.Parent = Sidebar
TabsContainer.Active = true
TabsContainer.BackgroundTransparency = 1
TabsContainer.Position = UDim2.new(0, 0, 0, 60)
TabsContainer.Size = UDim2.new(1, 0, 1, -60)
TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabsContainer.ScrollBarThickness = 0
TabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.Parent = TabsContainer
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabsLayout.Padding = UDim.new(0, 4)

-- ============================================
-- 🖥️ حاوية الصفحات (Container)
-- ============================================
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 145, 0, 0)
PagesContainer.Size = UDim2.new(1, -145, 1, 0)

-- ============================================
-- ⚙️ نظام التنقل بين التبويبات (Tabs System)
-- ============================================
local CurrentTab = nil
local Pages = {}

local function CreateTab(name, iconText)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabsContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(0, 126, 0, 32)
    TabButton.AutoButtonColor = false
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.Text = "   " .. name
    TabButton.TextColor3 = Color3.fromRGB(160, 160, 170)
    TabButton.TextSize = 12
    TabButton.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Parent = PagesContainer
    Page.Active = true
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 75)
    Page.Visible = false
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)

    Pages[name] = Page

    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        for _, b in pairs(TabsContainer:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.fromRGB(160, 160, 170)
                }):Play()
            end
        end
        Page.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
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
-- 🛠️ دالة إضافة خيار Toggle (زر تفعيل)
-- ============================================
local function AddToggle(parentPage, titleText, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parentPage
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 33)
    ToggleFrame.Size = UDim2.new(1, -5, 0, 38)

    local TFCorner = Instance.new("UICorner")
    TFCorner.CornerRadius = UDim.new(0, 6)
    TFCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = titleText
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    ToggleBtn.Size = UDim2.new(0, 36, 0, 20)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Text = ""

    local TB siis = Instance.new("UICorner")
    TB siis.CornerRadius = UDim.new(1, 0)
    TB siis.Parent = ToggleBtn

    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBtn
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.Size = UDim2.new(0, 16, 0, 16)

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(1, 0)
    CC.Parent = Circle

    local toggled = false
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        local goalCirclePos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local goalColor = toggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 55)
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = goalCirclePos}):Play()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
        
        pcall(callback, toggled)
    end)
end

-- ============================================
-- 📱 إضافة التبويبات والأزرار (تجربة الواجهة)
-- ============================================
local MainPage = CreateTab("Main", "🏠")
local FarmPage = CreateTab("Auto Farm", "⚔️")
local SettingsPage = CreateTab("Settings", "⚙️")

-- أمثلة للأزرار داخل صفحة Main
AddToggle(MainPage, "Auto Farm Level", function(state)
    print("Auto Farm Level:", state)
end)

AddToggle(MainPage, "Bypass Teleport", function(state)
    print("Bypass TP:", state)
end)

AddToggle(MainPage, "Auto Quest Complete", function(state)
    print("Auto Quest:", state)
end)

-- ============================================
-- 🖱️ خاصية تحريك النافذة (Draggable للأجهزة والكمبيوتر)
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
