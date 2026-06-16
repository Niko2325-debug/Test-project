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

---------------------------------------------------------
-- СИСТЕМА УВЕДОМЛЕНИЙ (ПРАВЫЙ ВЕРХНИЙ УГОЛ)
---------------------------------------------------------
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "NikoNotifGui"
pcall(function() NotifGui.Parent = CoreGui end)
if not NotifGui.Parent then NotifGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 260, 0, 500)
NotifContainer.Position = UDim2.new(1, -270, 0, 20) -- Строго сверху справа
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui

local NotifList = Instance.new("UIListLayout")
NotifList.Padding = UDim.new(0, 8)
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifList.Parent = NotifContainer

local showNotifs = true

local function createNotification(titleText, descText)
    if not showNotifs then return end
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 60)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    box.BackgroundTransparency = 0.15
    box.Parent = NotifContainer
    box.Position = UDim2.new(1.5, 0, 0, 0) -- Вылет из-за правого края экрана
    
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
    
    local tweenInfoIn = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(box, tweenInfoIn, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.spawn(function()
        task.wait(3.2)
        local tweenInfoOut = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        local animOut = TweenService:Create(box, tweenInfoOut, {Position = UDim2.new(1.5, 0, 0, 0)})
        animOut:Play()
        animOut.Completed:Connect(function() box:Destroy() end)
    end)
end

---------------------------------------------------------
-- ЛОКАЛИЗАЦИЯ И ПЕРЕВОДЫ
---------------------------------------------------------
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
        bypassActive = "Античит обход",
        welcome = "Скрипт успешно загружен!",
        enabled = "Включено",
        disabled = "Выключено",
        exitQuestion = "Вы хотите выйти из интерфейса?",
        ok = "ОК",
        cancel = "Отмена"
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
        bypassActive = "Anti-Cheat Bypass",
        welcome = "Script loaded successfully!",
        enabled = "Enabled",
        disabled = "Disabled",
        exitQuestion = "Do you want to exit the interface?",
        ok = "OK",
        cancel = "Cancel"
    }
}

---------------------------------------------------------
-- ФУНКЦИОНАЛ (FLY, SPIN, BYPASS)
---------------------------------------------------------
local flyEnabled = false
local spinEnabled = false
local noclipEnabled = false
local fullBrightEnabled = false
local realBypassEnabled = false
local walkSpeedValue = 16
local flySpeedValue = 50

local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime

-- Механика полёта как в HD Admin
local flyMaxForce = Vector3.new(1e9, 1e9, 1e9)
local flyPVelocity, flyPGyro

local function startFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    flyPVelocity = Instance.new("BodyVelocity")
    flyPVelocity.MaxForce = flyMaxForce
    flyPVelocity.Velocity = Vector3.new(0, 0, 0)
    flyPVelocity.Parent = hrp
    
    flyPGyro = Instance.new("BodyGyro")
    flyPGyro.MaxTorque = flyMaxForce
    flyPGyro.CFrame = hrp.CFrame
    flyPGyro.Parent = hrp
end

local function endFly()
    if flyPVelocity then flyPVelocity:Destroy() flyPVelocity = nil end
    if flyPGyro then flyPGyro:Destroy() flyPGyro = nil end
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.PlatformStand = false end
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
    if flyEnabled and flyPVelocity and flyPGyro and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        flyPGyro.CFrame = camera.CFrame
        if moveDirection.Magnitude > 0 then 
            flyPVelocity.Velocity = moveDirection.Unit * flySpeedValue 
        else 
            flyPVelocity.Velocity = Vector3.new(0, 0, 0) 
        end
    end
end)

-- Раскрутка
RunService.Heartbeat:Connect(function()
    if spinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(90), 0)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = player.Character.HumanoidRootPart
                if (hrp.Position - targetHrp.Position).Magnitude < 18 then
                    targetHrp.Velocity = (targetHrp.Position - hrp.Position).Unit * 120 + Vector3.new(0, 50, 0)
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

-- Реальный Adonis Античит обход
local oldNC
local function toggleRealBypass(state)
    realBypassEnabled = state
    local g = getgenv and getgenv()
    if state and g then
        g.AdonisBypass = true
        oldNC = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if realBypassEnabled and (method == "Kick" or method == "Crash") then
                return nil
            end
            return oldNC(self, ...)
        end)
    end
end

---------------------------------------------------------
-- ИНТЕРФЕЙС И ДРАГ
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Active = true
MainFrame.Parent = MainGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

-- Скрипт перетаскивания за TopBar
local dragToggle, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 22, 0, 22)
TitleIcon.Position = UDim2.new(0, 12, 0, 11)
TitleIcon.Image = "rbxassetid://10734950309"
TitleIcon.BackgroundTransparency = 1
TitleIcon.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 42, 0, 0)
Title.Text = "Niko HUB | script by Niko_2325"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Кнопка СВЕРНУТЬ (—)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 7)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.Parent = TopBar

-- Кнопка ЗАКРЫТЬ (Буква X без багов)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 110, 1, -45)
TabsFrame.Position = UDim2.new(0, 0, 0, 45)
TabsFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
TabsFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -125, 1, -55)
ContentFrame.Position = UDim2.new(0, 118, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local GeneralPage = Instance.new("ScrollingFrame")
GeneralPage.Size = UDim2.new(1, 0, 1, 0)
GeneralPage.BackgroundTransparency = 1
GeneralPage.CanvasSize = UDim2.new(0, 0, 1.2, 0)
GeneralPage.ScrollBarThickness = 2
GeneralPage.Parent = ContentFrame

local BypassPage = Instance.new("ScrollingFrame")
BypassPage.Size = UDim2.new(1, 0, 1, 0)
BypassPage.BackgroundTransparency = 1
BypassPage.CanvasSize = UDim2.new(0, 0, 2.0, 0)
BypassPage.ScrollBarThickness = 2
BypassPage.Visible = false
BypassPage.Parent = ContentFrame

local genList = Instance.new("UIListLayout")
genList.Padding = UDim.new(0, 10)
genList.SortOrder = Enum.SortOrder.LayoutOrder
genList.Parent = GeneralPage
local bypList = genList:Clone()
bypList.Parent = BypassPage

local GenTabBtn = Instance.new("TextButton")
GenTabBtn.Size = UDim2.new(1, 0, 0, 45)
GenTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
GenTabBtn.Text = "  Main"
GenTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GenTabBtn.Font = Enum.Font.SourceSansBold
GenTabBtn.TextSize = 14
GenTabBtn.TextXAlignment = Enum.TextXAlignment.Left
GenTabBtn.Parent = TabsFrame

local BypTabBtn = GenTabBtn:Clone()
BypTabBtn.Position = UDim2.new(0, 0, 0, 46)
BypTabBtn.Text = "  Bypass"
BypTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
BypTabBtn.Parent = TabsFrame

GenTabBtn.MouseButton1Click:Connect(function()
    GeneralPage.Visible = true BypassPage.Visible = false
    GenTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35) BypTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
end)
BypTabBtn.MouseButton1Click:Connect(function()
    GeneralPage.Visible = false BypassPage.Visible = true
    GenTabBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18) BypTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
end)

---------------------------------------------------------
-- МАЛЕНЬКАЯ КНОПКА МЕНЮ
---------------------------------------------------------
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "NikoMenuToggleGui"
toggleGui.ResetOnSpawn = false
pcall(function() toggleGui.Parent = CoreGui end)
if not toggleGui.Parent then toggleGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 85, 0, 34)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Menu"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Visible = false
toggleButton.Parent = toggleGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    toggleButton.Visible = true
end)
toggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    toggleButton.Visible = false
end)

---------------------------------------------------------
-- КОНСТРУКТОРЫ КЛАССИЧЕСКИХ ТУМБЛЕРОВ (TOGGLES) БЕЗ ТОЧЕК
---------------------------------------------------------
local updateLanguageElements = {}

local function createToggle(page, textKey, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = page
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -75, 1, 0)
    lbl.Text = Localization[currentLang][textKey]
    lbl.TextColor3 = Color3.fromRGB(230, 230, 240)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = frame
    
    -- Кнопка тумблера без уродливых цветных кружков
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 65, 0, 28)
    btn.Position = UDim2.new(1, -70, 0, 6)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = frame
    local bC = Instance.new("UICorner") bC.CornerRadius = UDim.new(0, 5) bC.Parent = btn
    
    local state = default
    local function updateVisuals()
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            btn.Text = "ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.Text = "OFF"
            btn.TextColor3 = Color3.fromRGB(160, 160, 170)
        end
    end
    updateVisuals()
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisuals()
        callback(state)
    end)
    
    table.insert(updateLanguageElements, function()
        lbl.Text = Localization[currentLang][textKey]
    end)
    
    return frame
end

-- Слайдеры оставляем только для ползунков скорости
local function createSlider(page, textKey, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundTransparency = 1
    frame.Parent = page
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.Text = Localization[currentLang][textKey] .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(210, 210, 220)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -10, 0, 6)
    track.Position = UDim2.new(0, 5, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    track.BorderSizePixel = 0
    track.Parent = frame
    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(0, 3) tCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local thumb = Instance.new("TextButton")
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.Parent = track
    local thCorner = Instance.new("UICorner") thCorner.CornerRadius = UDim.new(1, 0) thCorner.Parent = thumb
    
    local dragging = false
    local currentVal = default
    
    local function updateSlider(input)
        local totalWidth = track.AbsoluteSize.X
        local mouseX = input.Position.X - track.AbsolutePosition.X
        local percentage = math.clamp(mouseX / totalWidth, 0, 1)
        
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        thumb.Position = UDim2.new(percentage, -6, 0.5, -6)
        
        currentVal = math.floor(min + (max - min) * percentage)
        lbl.Text = Localization[currentLang][textKey] .. ": " .. currentVal
        callback(currentVal)
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    
    table.insert(updateLanguageElements, function()
        lbl.Text = Localization[currentLang][textKey] .. ": " .. currentVal
    end)
end

---------------------------------------------------------
-- СБОРКА ЭЛЕМЕНТОВ
---------------------------------------------------------

-- [MAIN] Выбор языка
local langBox = Instance.new("Frame")
langBox.Size = UDim2.new(1, -10, 0, 40)
langBox.BackgroundTransparency = 1
langBox.Parent = GeneralPage

local lLabel = Instance.new("TextLabel")
lLabel.Size = UDim2.new(0, 180, 1, 0)
lLabel.Text = Localization[currentLang].langLabel
lLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
lLabel.Font = Enum.Font.SourceSansBold
lLabel.TextSize = 14
lLabel.TextXAlignment = Enum.TextXAlignment.Left
lLabel.BackgroundTransparency = 1
lLabel.Parent = langBox

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 65, 0, 28)
langBtn.Position = UDim2.new(1, -70, 0, 6)
langBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
langBtn.Text = "RU"
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Font = Enum.Font.SourceSansBold
langBtn.TextSize = 14
langBtn.Parent = langBox
local lC = Instance.new("UICorner") lC.CornerRadius = UDim.new(0, 5) lC.Parent = langBtn

-- [MAIN] Тумблер уведомлений
createToggle(GeneralPage, "notifLabel", true, function(state)
    showNotifs = state
end)

-- [BYPASS] Тумблеры функций
createToggle(BypassPage, "fly", false, function(state)
    flyEnabled = state
    if flyEnabled then startFly() else endFly() end
    createNotification(Localization[currentLang].fly, flyEnabled and Localization[currentLang].enabled or Localization[currentLang].disabled)
end)

createSlider(BypassPage, "flySpeed", 10, 300, 50, function(v) flySpeedValue = v end)
createSlider(BypassPage, "walkSpeed", 16, 300, 16, function(v) walkSpeedValue = v end)

createToggle(BypassPage, "spin", false, function(state)
    spinEnabled = state
    createNotification(Localization[currentLang].spin, spinEnabled and Localization[currentLang].enabled or Localization[currentLang].disabled)
end)

createToggle(BypassPage, "noclip", false, function(state)
    noclipEnabled = state
    createNotification(Localization[currentLang].noclip, noclipEnabled and Localization[currentLang].enabled or Localization[currentLang].disabled)
end)

createToggle(BypassPage, "bright", false, function(state)
    fullBrightEnabled = state
    if fullBrightEnabled then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2 Lighting.ClockTime = 14
    else
        Lighting.Ambient = origAmbient Lighting.OutdoorAmbient = origOutdoorAmbient
        Lighting.Brightness = origBrightness Lighting.ClockTime = origClockTime
    end
    createNotification(Localization[currentLang].bright, fullBrightEnabled and Localization[currentLang].enabled or Localization[currentLang].disabled)
end)

createToggle(BypassPage, "bypassActive", false, function(state)
    toggleRealBypass(state)
    createNotification(Localization[currentLang].bypassActive, realBypassEnabled and Localization[currentLang].enabled or Localization[currentLang].disabled)
end)

---------------------------------------------------------
-- МОДАЛЬНОЕ ОКНО ПОДТВЕРЖДЕНИЯ ВЫХОДА
---------------------------------------------------------
local ConfirmGui = Instance.new("Frame")
ConfirmGui.Size = UDim2.new(0, 280, 0, 130)
ConfirmGui.Position = UDim2.new(0.5, -140, 0.5, -65)
ConfirmGui.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ConfirmGui.BorderSizePixel = 0
ConfirmGui.Visible = false
ConfirmGui.ZIndex = 20000
ConfirmGui.Parent = MainGui

local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0, 8) cCorner.Parent = ConfirmGui

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, -20, 0, 50)
ConfirmText.Position = UDim2.new(0, 10, 0, 15)
ConfirmText.Text = Localization[currentLang].exitQuestion
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.Font = Enum.Font.SourceSansBold
ConfirmText.TextSize = 15
ConfirmText.TextWrapped = true
ConfirmText.BackgroundTransparency = 1
ConfirmText.ZIndex = 20001
ConfirmText.Parent = ConfirmGui

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0, 100, 0, 32)
OkBtn.Position = UDim2.new(0, 30, 0, 80)
OkBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
OkBtn.Text = Localization[currentLang].ok
OkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OkBtn.Font = Enum.Font.SourceSansBold
OkBtn.TextSize = 14
OkBtn.ZIndex = 20001
OkBtn.Parent = ConfirmGui
local oC = Instance.new("UICorner") oC.CornerRadius = UDim.new(0, 5) oC.Parent = OkBtn

local CancelBtn = OkBtn:Clone()
CancelBtn.Position = UDim2.new(1, -130, 0, 80)
CancelBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
CancelBtn.Text = Localization[currentLang].cancel
CancelBtn.Parent = ConfirmGui

CloseBtn.MouseButton1Click:Connect(function() ConfirmGui.Visible = true end)
CancelBtn.MouseButton1Click:Connect(function() ConfirmGui.Visible = false end)

OkBtn.MouseButton1Click:Connect(function()
    endFly()
    realBypassEnabled = false
    MainGui:Destroy()
    toggleGui:Destroy()
    NotifGui:Destroy()
end)

---------------------------------------------------------
-- ОБНОВЛЕНИЕ ТЕКСТОВ ПРИ СМЕНЕ ЯЗЫКА
---------------------------------------------------------
local function refreshAllTexts()
    lLabel.Text = Localization[currentLang].langLabel
    ConfirmText.Text = Localization[currentLang].exitQuestion
    OkBtn.Text = Localization[currentLang].ok
    CancelBtn.Text = Localization[currentLang].cancel
    
    for _, f in pairs(updateLanguageElements) do f() end
end

langBtn.MouseButton1Click:Connect(function()
    if currentLang == "RU" then currentLang = "EN" else currentLang = "RU" end
    langBtn.Text = currentLang
    refreshAllTexts()
end)

-- Фиксация света
task.spawn(function()
    while task.wait(1) do
        if fullBrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ClockTime = 14
        end
    end
end)

refreshAllTexts()
createNotification("Niko HUB", Localization[currentLang].welcome)
