local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/ionlyusegithubformodding/ROBLOX-UI-Library/main/Orion/Source.lua'))()

local Window = OrionLib:MakeWindow({
    Name = "Universal Script HUB", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroEnabled = false
})

local currentLang = "RU"

local Localization = {
    RU = {
        welcome = "Добро пожаловать!",
        scriptBy = "script by Niko_2325",
        info = "Информация",
        infoDesc = "Скрипт успешно запущен. Перейдите во вкладку Bypass для управления функциями.",
        statusOn = "ВКЛ",
        statusOff = "ВЫКЛ",
        selectLang = "Выбрать язык / Select Language",
        walkSpeedName = "Скорость бега / WalkSpeed",
        flySpeedName = "Скорость полёта / Fly Speed"
    },
    EN = {
        welcome = "Welcome!",
        scriptBy = "script by Niko_2325",
        info = "Information",
        infoDesc = "Script loaded successfully. Go to Bypass tab to manage features.",
        statusOn = "ON",
        statusOff = "OFF",
        selectLang = "Выбрать язык / Select Language",
        walkSpeedName = "WalkSpeed",
        flySpeedName = "Fly Speed"
    }
}

local function notify(titleKey, textKey, isStatus, state)
    local title = Localization[currentLang][titleKey] or titleKey
    local text = ""
    if isStatus then
        local status = state and Localization[currentLang].statusOn or Localization[currentLang].statusOff
        text = titleKey .. ": " .. status
    else
        text = Localization[currentLang][textKey] or textKey
    end
    
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Image = "rbxassetid://4483345997",
        Time = 2
    })
end

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("NikoMenuToggleGui") then
    CoreGui.NikoMenuToggleGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NikoMenuToggleGui"
screenGui.ResetOnSpawn = false

local success, err = pcall(function() screenGui.Parent = CoreGui end)
if not success then
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "MenuToggleButton"
toggleButton.Parent = screenGui
toggleButton.Size = UDim2.new(0, 90, 0, 35)
toggleButton.Position = UDim2.new(0, 15, 0, 15)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Меню"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 10000

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = toggleButton

local menuVisible = true
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    local targetGui = CoreGui:FindFirstChild("Orion") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Orion")
    if targetGui then
        targetGui.Enabled = menuVisible
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

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
        
        if moveDirection.Magnitude > 0 then
            hrp.Velocity = moveDirection.Unit * flySpeedValue
        else
            hrp.Velocity = Vector3.new(0, 0.1, 0)
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
                local distance = (hrp.Position - targetHrp.Position).Magnitude
                if distance < 15 then
                    local direction = (targetHrp.Position - hrp.Position).Unit
                    targetHrp.Velocity = direction * 80 + Vector3.new(0, 35, 0)
                end
            end
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local GeneralTab = Window:MakeTab({ Name = "General", Icon = "rbxassetid://4483345997", PremiumOnly = false })
local BypassTab = Window:MakeTab({ Name = "Bypass", Icon = "rbxassetid://4483345997", PremiumOnly = false })

local authorLabel = GeneralTab:AddLabel(Localization[currentLang].scriptBy)

GeneralTab:AddTextbox({
    Name = "GitHub Repository:",
    Default = "https://github.com/Niko2325/Test-project",
    TextDisappear = false,
    Callback = function() end	
})

local infoParagraph = GeneralTab:AddParagraph(Localization[currentLang].info, Localization[currentLang].infoDesc)

local langDropdown = GeneralTab:AddDropdown({
    Name = Localization[currentLang].selectLang,
    Default = "RU",
    Options = {"RU", "EN"},
    Callback = function(Value)
        currentLang = Value
        authorLabel:Set(Localization[currentLang].scriptBy)
        infoParagraph:Set(Localization[currentLang].info, Localization[currentLang].infoDesc)
    end
})

BypassTab:AddToggle({
    Name = "Fly / Полёт",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
        notify(currentLang == "RU" and "Полёт" or "Fly", "", true, Value)
    end
})

BypassTab:AddSlider({
    Name = "Скорость полёта / Fly Speed",
    Min = 10,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(0, 120, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        flySpeedValue = Value
    end
})

BypassTab:AddSlider({
    Name = "Скорость игрока / WalkSpeed",
    Min = 16,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(0, 120, 255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        walkSpeedValue = Value
    end
})

BypassTab:AddToggle({
    Name = "Spin & Push / Раскрутка",
    Default = false,
    Callback = function(Value)
        spinEnabled = Value
        notify(currentLang == "RU" and "Раскрутка" or "Spin & Push", "", true, Value)
    end
})

BypassTab:AddToggle({
    Name = "No Clip / Сквозь стены",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        notify(currentLang == "RU" and "Сквозь стены" or "No Clip", "", true, Value)
    end
})

BypassTab:AddToggle({
    Name = "FullBright / Свет в темноте",
    Default = false,
    Callback = function(Value)
        fullBrightEnabled = Value
        if fullBrightEnabled then
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
        notify(currentLang == "RU" and "Свет в темноте" or "FullBright", "", true, Value)
    end
})

task.spawn(function()
    while task.wait(1) do
        if fullBrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ClockTime = 14
        end
    end
end)

OrionLib:Init()
notify("Universal HUB", "welcome", false)
