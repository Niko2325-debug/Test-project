local MainGui = Instance.new("ScreenGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

MainGui.Name = "AbysallStyleHub"
MainGui.ResetOnSpawn = false
pcall(function() MainGui.Parent = CoreGui end)
if not MainGui.Parent then MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 310)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MainGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Верхняя панель (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 22, 0, 22)
TitleIcon.Position = UDim2.new(0, 12, 0, 11)
TitleIcon.Image = "rbxassetid://10734950309"
TitleIcon.BackgroundTransparency = 1
TitleIcon.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 42, 0, 0)
Title.Text = "Niko HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Боковая панель для вкладок
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 110, 1, -45)
TabsFrame.Position = UDim2.new(0, 0, 0, 45)
TabsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabsFrame.Parent = MainFrame

-- Контейнер для страниц функций
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -110, 1, -45)
ContentFrame.Position = UDim2.new(0, 110, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local GeneralPage = Instance.new("ScrollingFrame")
GeneralPage.Size = UDim2.new(1, 0, 1, 0)
GeneralPage.BackgroundTransparency = 1
GeneralPage.CanvasSize = UDim2.new(0, 0, 1.5, 0)
GeneralPage.ScrollBarThickness = 3
GeneralPage.Parent = ContentFrame

local BypassPage = Instance.new("ScrollingFrame")
BypassPage.Size = UDim2.new(1, 0, 1, 0)
BypassPage.BackgroundTransparency = 1
BypassPage.CanvasSize = UDim2.new(0, 0, 1.8, 0)
BypassPage.ScrollBarThickness = 3
BypassPage.Visible = false
BypassPage.Parent = ContentFrame

local genList = Instance.new("UIListLayout")
genList.Padding = UDim.new(0, 10)
genList.SortOrder = Enum.SortOrder.LayoutOrder
genList.Parent = GeneralPage
local bypList = genList:Clone()
bypList.Parent = BypassPage

local currentLang = "RU"
local Localization = {
    RU = {
        langLabel = "Выбрать язык / Select Language",
        fly = "Fly / Полёт",
        spin = "Spin & Push / Раскрутка",
        noclip = "No Clip / Сквозь стены",
        bright = "FullBright / Свет в темноте",
        flySpeed = "Скорость полёта",
        walkSpeed = "Скорость игрока"
    },
    EN = {
        langLabel = "Select Language",
        fly = "Fly Mode",
        spin = "Spin & Push Players",
        noclip = "No Clip (Walls)",
        bright = "FullBright (Light)",
        flySpeed = "Fly Speed",
        walkSpeed = "WalkSpeed"
    }
}

---------------------------------------------------------
-- СОЗДАНИЕ КНОПОК ВКЛАДОК
---------------------------------------------------------
local GenTabBtn = Instance.new("TextButton")
GenTabBtn.Size = UDim2.new(1, 0, 0, 45)
GenTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
GenTabBtn.Text = "   Main"
GenTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GenTabBtn.Font = Enum.Font.SourceSansBold
GenTabBtn.TextSize = 14
GenTabBtn.TextXAlignment = Enum.TextXAlignment.Left
GenTabBtn.Parent = TabsFrame

local GenIcon = Instance.new("ImageLabel")
GenIcon.Size = UDim2.new(0, 16, 0, 16)
GenIcon.Position = UDim2.new(1, -26, 0, 14)
GenIcon.Image = "rbxassetid://10734963371"
GenIcon.BackgroundTransparency = 1
GenIcon.Parent = GenTabBtn

local BypTabBtn = GenTabBtn:Clone()
BypTabBtn.Position = UDim2.new(0, 0, 0, 48)
BypTabBtn.Text = "   Bypass"
BypTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
BypTabBtn.Parent = TabsFrame
BypTabBtn.ImageLabel.Image = "rbxassetid://10723374184"

GenTabBtn.MouseButton1Click:Connect(function()
    GeneralPage.Visible = true
    BypassPage.Visible = false
    GenTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    BypTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
end)

BypTabBtn.MouseButton1Click:Connect(function()
    GeneralPage.Visible = false
    BypassPage.Visible = true
    GenTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    BypTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
end)

---------------------------------------------------------
-- КНОПКА СВЕРНУТЬ МЕНЮШКУ
---------------------------------------------------------
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "NikoMenuToggleGui"
toggleGui.ResetOnSpawn = false
pcall(function() toggleGui.Parent = CoreGui end)
if not toggleGui.Parent then toggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Parent = toggleGui
toggleButton.Size = UDim2.new(0, 95, 0, 36)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Menu"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 15
toggleButton.ZIndex = 10000

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local menuVisible = true
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

---------------------------------------------------------
-- ЛОГИКА ТВОИХ ФУНКЦИЙ
---------------------------------------------------------
local flyEnabled = false
local spinEnabled = false
local noclipEnabled = false
local fullBrightEnabled = false
local walkSpeedValue = 16
local flySpeedValue = 50

local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if not flyEnabled and LocalPlayer.Character.Humanoid.WalkSpeed ~= walkSpeedValue then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end
    if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0,0,0)
        local uis = game:GetService("UserInputService")
        if uis:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        if moveDirection.Magnitude > 0 then hrp.Velocity = moveDirection.Unit * flySpeedValue else hrp.Velocity = Vector3.new(0, 0.1, 0) end
    end
end)

RunService.Heartbeat:Connect(function()
    if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(45), 0)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = player.Character.HumanoidRootPart
                if (hrp.Position - targetHrp.Position).Magnitude < 15 then
                    targetHrp.Velocity = (targetHrp.Position - hrp.Position).Unit * 80 + Vector3.new(0, 35, 0)
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

---------------------------------------------------------
-- ЗАПОЛНЕНИЕ СТРАНИЦ КНОПКАМИ И ДИЗАЙНОМ
---------------------------------------------------------

-- [ВКЛАДКА MAIN (Только смена языков)]
local langBox = Instance.new("Frame")
langBox.Size = UDim2.new(1, -20, 0, 40)
langBox.BackgroundTransparency = 1
langBox.Parent = GeneralPage

local lLabel = Instance.new("TextLabel")
lLabel.Size = UDim2.new(0, 200, 1, 0)
lLabel.Text = Localization[currentLang].langLabel
lLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
lLabel.Font = Enum.Font.SourceSansBold
lLabel.TextSize = 14
lLabel.TextXAlignment = Enum.TextXAlignment.Left
lLabel.BackgroundTransparency = 1
lLabel.Parent = langBox

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 70, 0, 30)
langBtn.Position = UDim2.new(1, -70, 0, 5)
langBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
langBtn.Text = "RU"
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Font = Enum.Font.SourceSansBold
langBtn.TextSize = 14
langBtn.Parent = langBox
local lCorner = Instance.new("UICorner") or Instance.new("UICorner", langBtn)
lCorner.CornerRadius = UDim.new(0, 5)
lCorner.Parent = langBtn

-- [ВКЛАДКА BYPASS (Наши тумблеры)]
local function createToggle(textKey, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.Text = "   " .. Localization[currentLang][textKey]
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 15
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = BypassPage
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 14, 0, 14)
    indicator.Position = UDim2.new(1, -26, 0, 13)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    indicator.Parent = btn
    local iCorner = Instance.new("UICorner")
    iCorner.CornerRadius = UDim.new(1, 0)
    iCorner.Parent = indicator
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        if enabled then
            indicator.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        else
            indicator.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        end
    end)
    return btn, indicator
end

local function createSlider(textKey, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = BypassPage
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Text = Localization[currentLang][textKey] .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 0, 10)
    sliderBtn.Position = UDim2.new(0, 0, 0, 25)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    sliderBtn.Text = ""
    sliderBtn.Parent = frame
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 4)
    sCorner.Parent = sliderBtn
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBtn
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = fill
    
    sliderBtn.MouseButton1Click:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        local percent = math.clamp((mouse.X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        local val = math.floor(min + (max - min) * percent)
        lbl.Text = Localization[currentLang][textKey] .. ": " .. val
        callback(val)
    end)
    return frame, lbl
end

local flyToggle, flyInd = createToggle("fly", function(v) flyEnabled = v if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) end end)
local _, flySlLabel = createSlider("flySpeed", 10, 300, 50, function(v) flySpeedValue = v end)
local _, walkSlLabel = createSlider("walkSpeed", 16, 300, 16, function(v) walkSpeedValue = v end)
local spinToggle, spinInd = createToggle("spin", function(v) spinEnabled = v end)
local noclipToggle, noclipInd = createToggle("noclip", function(v) noclipEnabled = v end)

local brightToggle, brightInd = createToggle("bright", function(v)
    fullBrightEnabled = v
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = origAmbient
        Lighting.OutdoorAmbient = origOutdoorAmbient
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClockTime
    end
end)

langBtn.MouseButton1Click:Connect(function()
    if currentLang == "RU" then currentLang = "EN" else currentLang = "RU" end
    langBtn.Text = currentLang
    lLabel.Text = Localization[currentLang].langLabel
    
    flyToggle.Text = "   " .. Localization[currentLang].fly
    spinToggle.Text = "   " .. Localization[currentLang].spin
    noclipToggle.Text = "   " .. Localization[currentLang].noclip
    brightToggle.Text = "   " .. Localization[currentLang].bright
    flySlLabel.Text = Localization[currentLang].flySpeed .. ": " .. flySpeedValue
    walkSlLabel.Text = Localization[currentLang].walkSpeed .. ": " .. walkSpeedValue
end)

task.spawn(function()
    while task.wait(1) do
        if fullBrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ClockTime = 14
        end
    end
end)
