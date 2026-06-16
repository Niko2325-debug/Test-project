-- Загрузка библиотеки интерфейса Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Создание главного окна с сине-серым оформлением
local Window = OrionLib:MakeWindow({
    Name = "Universal Script HUB", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "OrionNiko",
    IntroEnabled = false -- Быстрый старт без долгой заставки
})

-- Стартовое уведомление при запуске скрипта
OrionLib:MakeNotification({
    Name = "Universal HUB",
    Content = "Welcome!",
    Image = "rbxassetid://4483345997",
    Time = 4
})

---------------------------------------------------------
-- ПЕРЕМЕННЫЕ И ЛОГИКА ФУНКЦИЙ
---------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-- Переменные состояний
local flyEnabled = false
local spinEnabled = false
local noclipEnabled = false
local fullBrightEnabled = false
local antiCheatEnabled = false

-- Оригинальные настройки света для FullBright
local origAmbient = Lighting.Ambient
local origOutdoorAmbient = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime

-- 1. ЛОГИКА ПОЛЁТА (Fly)
local flySpeed = 50
RunService.RenderStepped:Connect(function()
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
            hrp.Velocity = moveDirection.Unit * flySpeed
        else
            hrp.Velocity = Vector3.new(0, 0.1, 0)
        end
    end
end)

-- 2. ЛОГИКА РАСКРУТКИ И ОТТАЛКИВАНИЯ (Spin & Push)
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

-- 3. ЛОГИКА ПРОХОЖДЕНИЯ СКВОЗЬ СТЕНЫ (No Clip)
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)


---------------------------------------------------------
-- ИНТЕРФЕЙС: ВКЛАДКИ
---------------------------------------------------------

-- Вкладка 1: General (Осталась как ты и просил)
local GeneralTab = Window:MakeTab({
    Name = "General",
    Icon = "rbxassetid://4483345997",
    PremiumOnly = false
})

GeneralTab:AddLabel("script by Niko_2325")

-- Текстовое поле под твою ссылку на GitHub
GeneralTab:AddTextbox({
    Name = "GitHub Repository:",
    Default = "https://github.com/твой_профиль/твой_репозиторий", -- Сюда вставишь реальную ссылку
    TextDisappear = false,
    Callback = function(Value)
        -- Поле для копирования
    end	
})

GeneralTab:AddParagraph("Информация", "Скрипт успешно запущен. Перейдите во вкладку Bypass для управления функциями.")

-- Вкладка 2: Bypass
local BypassTab = Window:MakeTab({
    Name = "Bypass",
    Icon = "rbxassetid://4483345997",
    PremiumOnly = false
})

-- Тумблер: Полёт
BypassTab:AddToggle({
    Name = "Режим полёта (Fly)",
    Default = false,
    Callback = function(Value)
        flyEnabled = Value
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
        -- Уведомление статуса
        OrionLib:MakeNotification({
            Name = "Fly Мод",
            Content = Value and "Fly: ON" or "Fly: OFF",
            Image = "rbxassetid://4483345997",
            Time = 2
        })
    end
})

-- Тумблер: Раскрутка
BypassTab:AddToggle({
    Name = "Раскручивать и отталкивать игроков",
    Default = false,
    Callback = function(Value)
        spinEnabled = Value
        -- Уведомление статуса
        OrionLib:MakeNotification({
            Name = "Spin & Push",
            Content = Value and "Spin & Push: ON" or "Spin & Push: OFF",
            Image = "rbxassetid://4483345997",
            Time = 2
        })
    end
})

-- Тумблер: No Clip
BypassTab:AddToggle({
    Name = "Проход сквозь стены (No Clip)",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        -- Уведомление статуса
        OrionLib:MakeNotification({
            Name = "No Clip",
            Content = Value and "No Clip: ON" or "No Clip: OFF",
            Image = "rbxassetid://4483345997",
            Time = 2
        })
    end
})

-- Тумблер: FullBright
BypassTab:AddToggle({
    Name = "Видеть в темноте (FullBright)",
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
        -- Уведомление статуса
        OrionLib:MakeNotification({
            Name = "FullBright",
            Content = Value and "FullBright: ON" or "FullBright: OFF",
            Image = "rbxassetid://4483345997",
            Time = 2
        })
    end
})

-- Поддержание освещения FullBright
task.spawn(function()
    while task.wait(1) do
        if fullBrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.ClockTime = 14
        end
    end
end)

-- Тумблер: Античит байпасс
BypassTab:AddToggle({
    Name = "Античит байпасс (Anti-Cheat Bypass)",
    Default = false,
    Callback = function(Value)
        antiCheatEnabled = Value
        if antiCheatEnabled then
            pcall(function()
                local g = getrawmetatable(game)
                if g then
                    setreadonly(g, false)
                    local old = g.__index
                    g.__index = newcclosure(function(self, key)
                        if antiCheatEnabled and tostring(self) == "HumanoidRootPart" and (key == "Velocity" or key == "CFrame") then
                            return old(self, key) 
                        end
                        return old(self, key)
                    end)
                    setreadonly(g, true)
                end
            end)
        end
        -- Уведомление статуса
        OrionLib:MakeNotification({
            Name = "Anti-Cheat Bypass",
            Content = Value and "Bypass: ON" or "Bypass: OFF",
            Image = "rbxassetid://4483345997",
            Time = 2
        })
    end
})

-- Запуск интерфейса
OrionLib:Init()
