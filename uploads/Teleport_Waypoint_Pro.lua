--[[
    ═══════════════════════════════════════════════════════════
      TELEPORT WAYPOINT PRO
      Key: .
      Style: Horizontal Compact Dark
    ═══════════════════════════════════════════════════════════
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Stats            = game:GetService("Stats")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("TPWaypointPro") then
        CoreGui.TPWaypointPro:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TPWaypointPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props and props.Parent then obj.Parent = props.Parent end
    return obj
end

local function Tween(obj, time, goal, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end

local function Round(n)
    return math.floor(n + 0.5)
end

--// ====================== KEY SYSTEM ======================
local KEY = "."

local KeyFrame = Create("Frame", {
    Name = "KeyFrame",
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(22, 22, 30),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = KeyFrame})
Create("UIStroke", {
    Color = Color3.fromRGB(60, 60, 80),
    Thickness = 1,
    Transparency = 0.3,
    Parent = KeyFrame
})

Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 26),
    Position = UDim2.new(0, 0, 0, 14),
    BackgroundTransparency = 1,
    Text = "Teleport Waypoint Pro",
    TextColor3 = Color3.fromRGB(240, 240, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    Parent = KeyFrame
})

Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundTransparency = 1,
    Text = "Enter key to continue",
    TextColor3 = Color3.fromRGB(130, 130, 155),
    Font = Enum.Font.Gotham,
    TextSize = 12,
    Parent = KeyFrame
})

local KeyBox = Create("TextBox", {
    Size = UDim2.new(1, -36, 0, 34),
    Position = UDim2.new(0, 18, 0, 68),
    BackgroundColor3 = Color3.fromRGB(32, 32, 42),
    Text = "",
    PlaceholderText = "Key",
    PlaceholderColor3 = Color3.fromRGB(100, 100, 120),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center,
    ClearTextOnFocus = false,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = KeyBox})

local UnlockBtn = Create("TextButton", {
    Size = UDim2.new(1, -36, 0, 34),
    Position = UDim2.new(0, 18, 0, 112),
    BackgroundColor3 = Color3.fromRGB(90, 70, 255),
    Text = "Unlock",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    AutoButtonColor = false,
    Parent = KeyFrame
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = UnlockBtn})

local KeyStatus = Create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -24),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    Parent = KeyFrame
})

UnlockBtn.MouseEnter:Connect(function()
    Tween(UnlockBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(110, 90, 255)})
end)
UnlockBtn.MouseLeave:Connect(function()
    Tween(UnlockBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(90, 70, 255)})
end)

--// ====================== TOGGLE BUTTON ======================
local ToggleBtn = Create("TextButton", {
    Name = "ToggleBtn",
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 14, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(90, 70, 255),
    Text = "📍",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    AutoButtonColor = false,
    Visible = false,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleBtn})
Create("UIStroke", {
    Color = Color3.fromRGB(130, 110, 255),
    Thickness = 1.3,
    Transparency = 0.25,
    Parent = ToggleBtn
})

local dragging, dragStart, startPos = false, nil, nil

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)

ToggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

ToggleBtn.MouseEnter:Connect(function()
    Tween(ToggleBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(110, 90, 255)})
end)
ToggleBtn.MouseLeave:Connect(function()
    Tween(ToggleBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(90, 70, 255)})
end)

--// ====================== MAIN GUI (HORIZONTAL) ======================
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundColor3 = Color3.fromRGB(22, 22, 30),
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
    Parent = ScreenGui
})
Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
Create("UIStroke", {
    Color = Color3.fromRGB(55, 55, 75),
    Thickness = 1,
    Transparency = 0.3,
    Parent = Main
})

-- Top row: Avatar + Name + Close
local TopRow = Create("Frame", {
    Size = UDim2.new(1, -16, 0, 40),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    Parent = Main
})

local AvatarHolder = Create("Frame", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(0, 0, 0.5, -16),
    BackgroundColor3 = Color3.fromRGB(40, 40, 55),
    BorderSizePixel = 0,
    Parent = TopRow
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = AvatarHolder})
Create("UIStroke", {
    Color = Color3.fromRGB(100, 80, 255),
    Thickness = 1.2,
    Parent = AvatarHolder
})

local Avatar = Create("ImageLabel", {
    Size = UDim2.new(1, -2, 1, -2),
    Position = UDim2.new(0, 1, 0, 1),
    BackgroundTransparency = 1,
    Image = "",
    Parent = AvatarHolder
})
Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Avatar})

task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and img then Avatar.Image = img end
end)

Create("TextLabel", {
    Size = UDim2.new(0, 140, 0, 16),
    Position = UDim2.new(0, 40, 0, 2),
    BackgroundTransparency = 1,
    Text = LocalPlayer.DisplayName,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopRow
})

Create("TextLabel", {
    Size = UDim2.new(0, 140, 0, 14),
    Position = UDim2.new(0, 40, 0, 19),
    BackgroundTransparency = 1,
    Text = "@" .. LocalPlayer.Name,
    TextColor3 = Color3.fromRGB(130, 130, 155),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TopRow
})

local CloseBtn = Create("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -26, 0.5, -13),
    BackgroundColor3 = Color3.fromRGB(40, 40, 52),
    Text = "×",
    TextColor3 = Color3.fromRGB(220, 90, 90),
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    AutoButtonColor = false,
    Parent = TopRow
})
Create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = CloseBtn})

-- Stats row
local StatsRow = Create("Frame", {
    Size = UDim2.new(1, -16, 0, 28),
    Position = UDim2.new(0, 8, 0, 52),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    BorderSizePixel = 0,
    Parent = Main
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = StatsRow})

local FPSLabel = Create("TextLabel", {
    Size = UDim2.new(0.5, -8, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "FPS  --",
    TextColor3 = Color3.fromRGB(100, 220, 150),
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = StatsRow
})

local PingLabel = Create("TextLabel", {
    Size = UDim2.new(0.5, -8, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "PING  --ms",
    TextColor3 = Color3.fromRGB(100, 180, 255),
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = StatsRow
})

-- Name + Set row
local NameBox = Create("TextBox", {
    Size = UDim2.new(1, -100, 0, 32),
    Position = UDim2.new(0, 8, 0, 88),
    BackgroundColor3 = Color3.fromRGB(32, 32, 42),
    Text = "",
    PlaceholderText = "Tên chỗ...",
    PlaceholderColor3 = Color3.fromRGB(110, 110, 130),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 13,
    ClearTextOnFocus = false,
    Parent = Main
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = NameBox})
Create("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = NameBox})

local SetBtn = Create("TextButton", {
    Size = UDim2.new(0, 84, 0, 32),
    Position = UDim2.new(1, -92, 0, 88),
    BackgroundColor3 = Color3.fromRGB(90, 70, 255),
    Text = "SET",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    AutoButtonColor = false,
    Parent = Main
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SetBtn})

-- List
local ListFrame = Create("ScrollingFrame", {
    Size = UDim2.new(1, -16, 0, 110),
    Position = UDim2.new(0, 8, 0, 128),
    BackgroundColor3 = Color3.fromRGB(28, 28, 38),
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(100, 80, 255),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = Main
})
Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ListFrame})

local ListLayout = Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
    Parent = ListFrame
})
Create("UIPadding", {
    PaddingTop = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    Parent = ListFrame
})

--// Logic
local Waypoints = {}
local isOpen = false
local isUnlocked = false

local function UpdateList()
    for _, c in ipairs(ListFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end

    for i, data in ipairs(Waypoints) do
        local Item = Create("Frame", {
            Size = UDim2.new(1, -4, 0, 32),
            BackgroundColor3 = Color3.fromRGB(36, 36, 48),
            LayoutOrder = i,
            Parent = ListFrame
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Item})

        Create("TextLabel", {
            Size = UDim2.new(1, -90, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = data.Name,
            TextColor3 = Color3.fromRGB(235, 235, 250),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Item
        })

        local TeleBtn = Create("TextButton", {
            Size = UDim2.new(0, 42, 0, 22),
            Position = UDim2.new(1, -76, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(0, 140, 255),
            Text = "TELE",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            AutoButtonColor = false,
            Parent = Item
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = TeleBtn})

        TeleBtn.MouseEnter:Connect(function()
            Tween(TeleBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(40, 165, 255)})
        end)
        TeleBtn.MouseLeave:Connect(function()
            Tween(TeleBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(0, 140, 255)})
        end)

        TeleBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = data.CFrame
            end
        end)

        local DelBtn = Create("TextButton", {
            Size = UDim2.new(0, 22, 0, 22),
            Position = UDim2.new(1, -28, 0.5, -11),
            BackgroundColor3 = Color3.fromRGB(200, 55, 70),
            Text = "×",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            Parent = Item
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = DelBtn})

        DelBtn.MouseEnter:Connect(function()
            Tween(DelBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(230, 70, 85)})
        end)
        DelBtn.MouseLeave:Connect(function()
            Tween(DelBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(200, 55, 70)})
        end)

        DelBtn.MouseButton1Click:Connect(function()
            table.remove(Waypoints, i)
            UpdateList()
        end)
    end

    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

SetBtn.MouseEnter:Connect(function()
    Tween(SetBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(110, 90, 255)})
end)
SetBtn.MouseLeave:Connect(function()
    Tween(SetBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(90, 70, 255)})
end)

SetBtn.MouseButton1Click:Connect(function()
    local name = NameBox.Text
    if name == "" or name:match("^%s*$") then
        name = "Chỗ " .. (#Waypoints + 1)
    end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(Waypoints, {
            Name = name,
            CFrame = char.HumanoidRootPart.CFrame
        })
        NameBox.Text = ""
        UpdateList()
    end
end)

local function OpenMain()
    if isOpen then return end
    isOpen = true
    Main.Visible = true
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)

    Tween(Main, 0.32, {
        Size = UDim2.new(0, 300, 0, 250),
        Position = UDim2.new(0.5, -150, 0.5, -125)
    }, Enum.EasingStyle.Back)
end

local function CloseMain()
    if not isOpen then return end
    isOpen = false
    local t = Tween(Main, 0.25, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, Enum.EasingStyle.Quint)
    t.Completed:Connect(function()
        Main.Visible = false
    end)
end

local function ToggleMain()
    if isOpen then CloseMain() else OpenMain() end
end

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(55, 45, 65)})
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, 0.12, {BackgroundColor3 = Color3.fromRGB(40, 40, 52)})
end)

CloseBtn.MouseButton1Click:Connect(CloseMain)

ToggleBtn.MouseButton1Click:Connect(function()
    if isUnlocked then ToggleMain() end
end)

local function TryUnlock()
    if KeyBox.Text == KEY then
        KeyStatus.TextColor3 = Color3.fromRGB(100, 230, 140)
        KeyStatus.Text = "Correct key"
        isUnlocked = true

        Tween(KeyFrame, 0.28, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, Enum.EasingStyle.Quint)

        task.delay(0.28, function()
            KeyFrame.Visible = false
            ToggleBtn.Visible = true
            OpenMain()
        end)
    else
        KeyStatus.TextColor3 = Color3.fromRGB(255, 90, 90)
        KeyStatus.Text = "Wrong key"
        KeyBox.Text = ""
    end
end

UnlockBtn.MouseButton1Click:Connect(TryUnlock)
KeyBox.FocusLost:Connect(function(enter)
    if enter then TryUnlock() end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if not isUnlocked then return end
        ToggleMain()
    end
end)

local fps = 60
RunService.RenderStepped:Connect(function(dt)
    fps = math.clamp(Round(1 / math.max(dt, 0.001)), 1, 999)
end)

task.spawn(function()
    while true do
        FPSLabel.Text = "FPS  " .. fps
        if fps >= 50 then
            FPSLabel.TextColor3 = Color3.fromRGB(100, 220, 150)
        elseif fps >= 30 then
            FPSLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
        else
            FPSLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
        end

        local ping = 0
        pcall(function()
            ping = Round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        PingLabel.Text = "PING  " .. ping .. "ms"

        task.wait(0.35)
    end
end)

Tween(KeyFrame, 0.4, {
    Size = UDim2.new(0, 260, 0, 175),
    Position = UDim2.new(0.5, -130, 0.5, -87)
}, Enum.EasingStyle.Back)

print("Teleport Waypoint Pro loaded | Key: . | Horizontal Compact")
