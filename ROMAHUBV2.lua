-- ============================================
-- 💀 ROMA SENPAI HUB (Axel Hub Style) 💀
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RomaAxelHub") then
    PlayerGui.RomaAxelHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RomaAxelHub"
ScreenGui.ResetOnSpawn = false

local TargetParent = PlayerGui
if gethui then
    TargetParent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    TargetParent = game:GetService("CoreGui")
end
ScreenGui.Parent = TargetParent

-- النافذة الرئيسية (ستايل أكسل هب داكن وشفاف)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1

-- شريط العناوين العلوي
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = TopBar
LogoLabel.Size = UDim2.new(0, 150, 1, 0)
LogoLabel.Position = UDim2.new(0, 15, 0, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "⚡  ROMA HUB"
LogoLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
LogoLabel.TextSize = 14
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextXAlignment = Enum.TextXAlignment.Left

-- أزرار التحكم (تصغير/إغلاق)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12.5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(160, 160, 175)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- 📂 السايدبار (القائمة الجانبية اليسرى)
-- ============================================
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.Parent = Sidebar
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)

-- بروفايل المستخدم أسفل السايدبار
local UserProfile = Instance.new("Frame")
UserProfile.Parent = MainFrame
UserProfile.Size = UDim2.new(0, 150, 0, 50)
UserProfile.Position = UDim2.new(0, 5, 1, -55)
UserProfile.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
UserProfile.BorderSizePixel = 0

local UserCorner = Instance.new("UICorner")
UserCorner.CornerRadius = UDim.new(0, 8)
UserCorner.Parent = UserProfile

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Parent = UserProfile
AvatarImg.Size = UDim2.new(0, 36, 0, 36)
AvatarImg.Position = UDim2.new(0, 7, 0.5, -18)
AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AvatarImg.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImg

local UserName = Instance.new("TextLabel")
UserName.Parent = UserProfile
UserName.Size = UDim2.new(1, -50, 0, 18)
UserName.Position = UDim2.new(0, 48, 0, 9)
UserName.BackgroundTransparency = 1
UserName.Text = Player.Name
UserName.TextColor3 = Color3.fromRGB(240, 240, 245)
UserName.TextSize = 12
UserName.Font = Enum.Font.GothamBold
UserName.TextXAlignment = Enum.TextXAlignment.Left

local UserSub = Instance.new("TextLabel")
UserSub.Parent = UserProfile
UserSub.Size = UDim2.new(1, -50, 0, 14)
UserSub.Position = UDim2.new(0, 48, 0, 25)
UserSub.BackgroundTransparency = 1
UserSub.Text = "Roma Senpai"
UserSub.TextColor3 = Color3.fromRGB(120, 120, 140)
UserSub.TextSize = 10
UserSub.Font = Enum.Font.Gotham
UserSub.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================
-- 🖥️ حاوية المحتوى الرئيسي
-- ============================================
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.Size = UDim2.new(1, -170, 1, -50)
ContentContainer.Position = UDim2.new(0, 165, 0, 45)
ContentContainer.BackgroundTransparency = 1

local currentTabBtn = nil

local function createTabButton(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = Sidebar
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(140, 140, 160)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
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
    panel.CanvasSize = UDim2.new(0, 0, 0, 300)
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = panel
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local title = Instance.new("TextLabel")
    title.Parent = panel
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(240, 240, 250)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    return panel
end

-- تصميم الأزرار والعناصر داخل القوائم (ستايل أكسل هب)
local function addToggle(parent, titleText, callback)
    local toggle = Instance.new("Frame")
    toggle.Parent = parent
    toggle.Size = UDim2.new(1, -5, 0, 36)
    toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggle.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = toggle
    
    local label = Instance.new("TextLabel")
    label.Parent = toggle
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = titleText
    label.TextColor3 = Color3.fromRGB(200, 200, 215)
    label.TextSize = 12
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
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(1, -26, 0.5, -8)
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

-- ============================================
-- ⚙️ بناء القوائم والوظائف
-- ============================================

-- تبويب الحركة
local tab1Btn = createTabButton("الحركة", "🚀")
tab1Btn.MouseButton1Click:Connect(function()
    local panel = createContentPanel("إعدادات الحركة")
    addToggle(panel, "الطيران (Fly)", function(state)
        -- كود الطيران الخاص بك
    end)
    addToggle(panel, "اختراق الجدران (Noclip)", function(state)
        -- كود النوكب
    end)
    addToggle(panel, "اختفاء (Invisible)", function(state)
        -- كود الاختفاء
    end)
end)

-- تبويب السرعة
local tab2Btn = createTabButton("السرعة", "⚡")
tab2Btn.MouseButton1Click:Connect(function()
    local panel = createContentPanel("إعدادات السرعة")
    addToggle(panel, "تفعيل السرعة العالية", function(state)
        -- كود السرعة
    end)
end)

-- تبويب التيليبورت
local tab3Btn = createTabButton("التيليبورت", "🌐")
tab3Btn.MouseButton1Click:Connect(function()
    local panel = createContentPanel("الانتقال للاعبين")
    -- هنا تضع قائمة التيليبورت
end)

-- تبويب إضافات
local tab4Btn = createTabButton("إضافات", "🔧")
tab4Btn.MouseButton1Click:Connect(function()
    local panel = createContentPanel("الأدوات والإضافات")
    addToggle(panel, "إيقاف الكل", function(state)
        -- إيقاف كل الوظائف
    end)
end)

-- فتح أول تبويب تلقائياً
tab1Btn.MouseButton1Click()

print("⚡ Axel Hub Style Loaded Successfully!")
