local MainGui = Instance.new("ScreenGui")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

MainGui.Name = "AbysallStyleHub"
MainGui.ResetOnSpawn = false
pcall(function() MainGui.Parent = CoreGui end)
if not MainGui.Parent then MainGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- СИСТЕМА УВЕДОМЛЕНИЙ (NOTIFICATIONS)
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "NikoNotifGui"
pcall(function() NotifGui.Parent = CoreGui end)
if not NotifGui.Parent then NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotifList = Instance.new("UIListLayout")
NotifList.Padding = UDim.new(0, 5)
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 250, 1, -20)
NotifContainer.Position = UDim2.new(1, -260, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui
NotifList.Parent = NotifContainer

local showNotifs = true

local function createNotification(titleText, descText)
    if not showNotifs then return end
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 60)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    box.BackgroundTransparency = 1
    box.Parent = NotifContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box
    
    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -10, 0, 20)
    tLbl.Position = UDim2.new(0, 10, 0, 5)
    tLbl.Text = titleText
    tLbl.TextColor3 = Color3.fromRGB(0, 150, 255)
    tLbl.Font = Enum.Font.SourceSansBold
    tLbl.TextSize = 14
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.BackgroundTransparency = 1
    tLbl.Parent = box
    
    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -10, 0, 30)
    dLbl.Position = UDim2.new(0, 10, 0, 25)
    dLbl.Text = descText
    dLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    dLbl.Font = Enum.Font.SourceSans
    dLbl.TextSize = 13
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.TextWrapped = true
    dLbl.BackgroundTransparency = 1
    dLbl.Parent = box
    
    TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    task.spawn(function()
        task.wait(3.5)
        local t = TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        t:Play()
        t.Completed:Connect(function() box:Destroy() end)
    end)
end

-- ВСТРОЕННЫЙ ОБХОД АНТИЧИТА ADONIS
local function initAdonisBypass()
    local g = getgenv and getgenv()
    if g then
        g.AdonisBypass = true
        local oldNC
        oldNC = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "Crash" then
                return nil
            end
            return oldNC(self, ...)
        end)
    end
end
initAdonisBypass()

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -160)
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
Title.Text = "Niko HUB | script by Niko_2325"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
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
ContentFrame.Size = UDim2.new(1, -120, 1, -55)
ContentFrame.Position = UDim2.new(0, 115, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local GeneralPage = Instance.new("ScrollingFrame")
GeneralPage.Size = UDim2.new(1, 0, 1, 0)
GeneralPage.BackgroundTransparency = 1
GeneralPage.CanvasSize = UDim2.new(0, 0, 1.2, 0)
GeneralPage.ScrollBarThickness = 3
GeneralPage.Parent = ContentFrame

local BypassPage = Instance.new("ScrollingFrame")
BypassPage.Size = UDim2.new(1, 0, 1, 0)
BypassPage.BackgroundTransparency = 1
BypassPage.CanvasSize = UDim2.new(0, 0, 2.2, 0)
BypassPage.ScrollBarThickness = 3
BypassPage.Visible = false
BypassPage.Parent = ContentFrame

local genList = Instance.new("UIListLayout")
genList.Padding = UDim.new(0, 8)
genList.SortOrder = Enum.SortOrder.LayoutOrder
genList.Parent = GeneralPage
local bypList = genList:Clone()
bypList.Parent = BypassPage

local currentLang = "RU"
local Localization = {
    RU = {
        langLabel = "Выбрать язык",
        notifLabel = "Уведомления",
        fly = "Полёт",
        spin = "Раскрутка игроков",
        noclip = "Сквозь стены",
        bright = "Свет в темноте",
        flySpeed = "Скорость полёта",
        walkSpeed = "Скорость игрока",
        bypassActive = "Античит обход активен",
        welcome = "Скрипт успешно загружен!",
        enabled = "Включено",
        disabled = "Выключено"
    },
    EN = {
        langLabel = "Select Language",
        notifLabel = "Notifications",
        fly = "Fly Mode",
        spin = "Spin & Push Players",
        noclip = "No Clip",
        bright = "FullBright",
        flySpeed = "Fly Speed",
        walkSpeed = "WalkSpeed",
        bypassActive = "Anti-Cheat Bypass Active",
        welcome = "Script loaded successfully!",
        enabled = "Enabled",
        disabled = "Disabled"
    }
}

---------------------------------------------------------
-- СОЗДАНИЕ КНОПОК ВКЛАДОК (ВСЕГДА НА АНГЛИЙСКОМ)
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
-- НАСТРОЙКА ПЕРЕМЕННЫХ И ЛОГИКА ФУНКЦИЙ
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

local flyBodyVel, flyBodyGyro

local function startFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVel.Velocity = Vector3.new(0, 0.1, 0)
    flyBodyVel.Parent = hrp
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp
end

local function endFly()
    if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
end

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if not flyEnabled and LocalPlayer.Character.Humanoid.WalkSpeed ~= walkSpeedValue then
            LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end
    if flyEnabled and flyBodyVel and flyBodyGyro and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        flyBodyGyro.CFrame = camera.CFrame
        if moveDirection.Magnitude > 0 then 
            flyBodyVel.Velocity = moveDirection.Unit * flySpeedValue 
        else 
            flyBodyVel.Velocity = Vector3.new(0, 0.1, 0) 
        end
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
-- ОПТИМИЗИРОВАННЫЕ ЭЛЕМЕНТЫ ИНТЕРФЕЙСА
---------------------------------------------------------

-- [СТРАНИЦА MAIN]
-- Выбор языка
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
local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 5)
lCorner.Parent = langBtn

-- Управление уведомлениями
local notifBox = Instance.new("Frame")
notifBox.Size = UDim2.new(1, -20, 0, 40)
notifBox.BackgroundTransparency = 1
notifBox.Parent = GeneralPage

local nLabel = Instance.new("TextLabel")
nLabel.Size = UDim2.new(0, 200, 1, 0)
nLabel.Text = Localization[currentLang].notifLabel
nLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nLabel.Font = Enum.Font.SourceSansBold
nLabel.TextSize = 14
nLabel.TextXAlignment = Enum.TextXAlignment.Left
nLabel.BackgroundTransparency = 1
nLabel.Parent = notifBox

local notifToggleBtn = Instance.new("TextButton")
notifToggleBtn.Size = UDim2.new(0, 70, 0, 30)
notifToggleBtn.Position = UDim2.new(1, -70, 0, 5)
notifToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
notifToggleBtn.Text = "ON"
notifToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
notifToggleBtn.Font = Enum.Font.SourceSansBold
notifToggleBtn.TextSize = 14
notifToggleBtn.Parent = notifBox
local nBCorner = Instance.new("UICorner")
nBCorner.CornerRadius = UDim.new(0, 5)
nBCorner.Parent = notifToggleBtn

notifToggleBtn.MouseButton1Click:Connect(function()
    showNotifs = not showNotifs
    if showNotifs then
        notifToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 255, 70)
        notifToggleBtn.Text = "ON"
    else
        notifToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        notifToggleBtn.Text = "OFF"
    end
end)


-- АНТИЧИТ ТЕКСТ-ИНДИКАТОР В BYPASS
local bypassTextLabel = Instance.new("TextLabel")
bypassTextLabel.Size = UDim2.new(1, -20, 0, 30)
bypassTextLabel.Text = "🛡️ " .. Localization[currentLang].bypassActive
bypassTextLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
bypassTextLabel.Font = Enum.Font.SourceSansBold
bypassTextLabel.TextSize = 15
bypassTextLabel.TextXAlignment = Enum.TextXAlignment.Center
bypassTextLabel.BackgroundTransparency = 1
bypassTextLabel.Parent = BypassPage

-- [СТРАНИЦА BYPASS: ТУМБЛЕРЫ И ПОЛЗУНКИ]
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
            createNotification(Localization[currentLang][textKey], Localization[currentLang].enabled)
        else
            indicator.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            createNotification(Localization[currentLang][textKey], Localization[currentLang].disabled)
        end
    end)
    return btn
end

local function createSlider(textKey, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 55)
    frame.BackgroundTransparency = 1
    frame.Parent = BypassPage
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Text = Localization[currentLang][textKey] .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    -- Рейка трека ползунка
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -10, 0, 6)
    track.Position = UDim2.new(0, 5, 0, 30)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    track.BorderSizePixel = 0
    track.Parent = frame
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 3)
    tCorner.Parent = track
    
    -- Заполнение трека цветом
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 3)
    fCorner.Parent = fill
    
    -- Подвижный Круглый Ползунок-шарик
    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.Parent = track
    local thCorner = Instance.new("UICorner")
    thCorner.CornerRadius = UDim.new(1, 0)
    thCorner.Parent = thumb
    
    local dragging = false
    
    local function updateSlider(input)
        local totalWidth = track.AbsoluteSize.X
        local mouseX = input.Position.X - track.AbsolutePosition.X
        local percentage = math.clamp(mouseX / totalWidth, 0, 1)
        
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        local value = math.floor(min + (max - min) * percentage)
        lbl.Text = Localization[currentLang][textKey] .. ": " .. value
        callback(value)
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return frame, lbl
end

-- Инициализация всех элементов
local flyToggle = createToggle("fly", function(v) flyEnabled = v if v then startFly() else endFly() end end)
local _, flySlLabel = createSlider("flySpeed", 10, 300, 50, function(v) flySpeedValue = v end)
local _, walkSlLabel = createSlider("walkSpeed", 16, 300, 16, function(v) walkSpeedValue = v end)
local spinToggle = createToggle("spin", function(v) spinEnabled = v end)
local noclipToggle = createToggle("noclip", function(v) noclipEnabled = v end)

local brightToggle = createToggle("bright", function(v)
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

-- Полное обновление текстов при языковой мутации (без слэшей)
local function refreshLocalization()
    lLabel.Text = Localization[currentLang].langLabel
    nLabel.Text = Localization[currentLang].notifLabel
    bypassTextLabel.Text = "🛡️ " .. Localization[currentLang].bypassActive
    
    flyToggle.Text = "   " .. Localization[currentLang].fly
    spinToggle.Text = "   " .. Localization[currentLang].spin
    noclipToggle.Text = "   " .. Localization[currentLang].noclip
    brightToggle.Text = "   " .. Localization[currentLang].bright
    
    flySlLabel.Text = Localization[currentLang].flySpeed .. ": " .. flySpeedValue
    walkSlLabel.Text = Localization[currentLang].walkSpeed .. ": " .. walkSpeedValue
end

langBtn.MouseButton1Click:Connect(function()
    if currentLang == "RU" then currentLang = "EN" else currentLang = "RU" end
    langBtn.Text = currentLang
    refreshLocalization()
end)

-- Постоянная фиксация света
task.spawn(function()
    while task.wait(1) do
        if fullBrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ClockTime = 14
        end
    end
end)

-- ПРИВЕТСТВЕННОЕ УВЕДОМЛЕНИЕ ПРИ СТАРТЕ
refreshLocalization()
createNotification("Niko HUB", Localization[currentLang].welcome)
