-- Ultimate Booga Hub v3 Library: A Simple UI Library Inspired by Rayfield, with Custom Styling Matching Our GUI
-- This library creates a draggable, tabbed GUI with sliders, toggles (with keybinds), dropdowns, search, and notifications.
-- Updated GUI Size: Increased width to 700 and height to 600 for better space.
-- Usage Example:
-- local Library = loadstring(game:HttpGet("your_pastebin_link_here"))() -- Or paste this code into a ModuleScript
-- local Window = Library:CreateWindow("Ultimate Booga Hub v3")
-- local PlayerTab = Window:CreateTab("Player")
-- PlayerTab:CreateSlider("Speed", 10, 100, 16, function(value) print("Speed:", value) end)
-- PlayerTab:CreateToggle("Jump Power", function(on) print("Jump Power:", on) end, "🦘")
-- PlayerTab:CreateDropdown("Options", {"Option 1", "Option 2"}, "Option 1", function(selected) print("Selected:", selected) end)
-- Window:Open() -- To show the GUI

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer

local Library = {}

function Library:CreateWindow(title)
    local window = {}
    window.title = title or "GUI"
    window.tabs = {}
    window.currentTab = nil
    window.searchElements = {} -- For search functionality per window
    window.toggleData = {}
    window.activeKeybinds = {}
    window.keybindListening = nil
    window.draggingSliders = {}
    window.activeNotifs = 0
    window.connections = {}
    window.espConns = {}
    window.speed = 16
    window.jump = 50
    window.espDistance = 500
    window.espEnabled = false

    -- ScreenGui
    window.screenGui = Instance.new("ScreenGui")
    window.screenGui.Name = "UltimateBoogaHub"
    window.screenGui.ResetOnSpawn = false
    window.screenGui.Parent = plr.PlayerGui

    -- Main Frame (Increased size: 700x600)
    window.mainFrame = Instance.new("Frame")
    window.mainFrame.Size = UDim2.new(0, 700, 0, 600) -- Wider and taller
    window.mainFrame.Position = UDim2.new(0.5, -350, 0.5, -300)
    window.mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    window.mainFrame.BackgroundTransparency = 0.1
    window.mainFrame.BorderSizePixel = 0
    window.mainFrame.ClipsDescendants = true
    window.mainFrame.Parent = window.screenGui
    window.mainFrame.Visible = false

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25))
    }
    gradient.Rotation = 45
    gradient.Parent = window.mainFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = window.mainFrame

    -- Title Bar
    window.titleBar = Instance.new("Frame")
    window.titleBar.Size = UDim2.new(1, 0, 0, 45)
    window.titleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    window.titleBar.BorderSizePixel = 0
    window.titleBar.Parent = window.mainFrame

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 50)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))}
    titleGradient.Parent = window.titleBar

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = window.titleBar

    window.titleLabel = Instance.new("TextLabel")
    window.titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    window.titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    window.titleLabel.BackgroundTransparency = 1
    window.titleLabel.Text = "🚀 " .. window.title
    window.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.titleLabel.Font = Enum.Font.GothamBold
    window.titleLabel.TextSize = 22
    window.titleLabel.Parent = window.titleBar

    window.closeButton = Instance.new("TextButton")
    window.closeButton.Size = UDim2.new(0, 35, 0, 35)
    window.closeButton.Position = UDim2.new(1, -40, 0, 5)
    window.closeButton.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
    window.closeButton.Text = "X"
    window.closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.closeButton.Font = Enum.Font.GothamBold
    window.closeButton.TextSize = 20
    window.closeButton.Parent = window.titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = window.closeButton

    -- Confirm Popup
    window.confirmPopup = Instance.new("Frame")
    window.confirmPopup.Size = UDim2.new(0, 200, 0, 100)
    window.confirmPopup.Position = UDim2.new(0.5, -100, 0.5, -50)
    window.confirmPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    window.confirmPopup.Visible = false
    window.confirmPopup.ZIndex = 100
    window.confirmPopup.Parent = window.screenGui

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 10)
    confirmCorner.Parent = window.confirmPopup

    local confirmLabel = Instance.new("TextLabel")
    confirmLabel.Size = UDim2.new(1, 0, 0.5, 0)
    confirmLabel.Position = UDim2.new(0, 0, 0, 0)
    confirmLabel.BackgroundTransparency = 1
    confirmLabel.Text = "close gui?"
    confirmLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmLabel.Font = Enum.Font.Gotham
    confirmLabel.TextSize = 16
    confirmLabel.TextYAlignment = Enum.TextYAlignment.Center
    confirmLabel.Parent = window.confirmPopup

    window.noBtn = Instance.new("TextButton")
    window.noBtn.Size = UDim2.new(0.45, 0, 0.4, 0)
    window.noBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
    window.noBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    window.noBtn.Text = "No"
    window.noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.noBtn.Font = Enum.Font.Gotham
    window.noBtn.TextSize = 14
    window.noBtn.ZIndex = 101
    window.noBtn.Parent = window.confirmPopup

    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = window.noBtn

    window.yesBtn = Instance.new("TextButton")
    window.yesBtn.Size = UDim2.new(0.45, 0, 0.4, 0)
    window.yesBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
    window.yesBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    window.yesBtn.Text = "Yes"
    window.yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.yesBtn.Font = Enum.Font.Gotham
    window.yesBtn.TextSize = 14
    window.yesBtn.ZIndex = 101
    window.yesBtn.Parent = window.confirmPopup

    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = window.yesBtn

    window.yesBtn.MouseButton1Click:Connect(function()
        window.screenGui:Destroy()
    end)
    window.noBtn.MouseButton1Click:Connect(function()
        window.confirmPopup.Visible = false
    end)

    window.closeButton.MouseButton1Click:Connect(function()
        window.confirmPopup.Visible = true
    end)

    -- Dragging for Main Frame
    local dragging, dragStart, startPos
    window.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.mainFrame.Position
            TweenService:Create(window.mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 705, 0, 605)}):Play()
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    TweenService:Create(window.mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 700, 0, 600)}):Play()
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            window.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle Square
    window.toggleSquare = Instance.new("TextButton")
    window.toggleSquare.Size = UDim2.new(0, 60, 0, 60)
    window.toggleSquare.Position = UDim2.new(0, 10, 0.5, -30)
    window.toggleSquare.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    window.toggleSquare.Text = "🚀"
    window.toggleSquare.TextColor3 = Color3.fromRGB(255, 255, 255)
    window.toggleSquare.Font = Enum.Font.GothamBold
    window.toggleSquare.TextSize = 24
    window.toggleSquare.Parent = window.screenGui

    local squareCorner = Instance.new("UICorner")
    squareCorner.CornerRadius = UDim.new(0, 10)
    squareCorner.Parent = window.toggleSquare

    -- Animation for Toggle Square
    local function animateSquare()
        while window.toggleSquare.Parent do
            TweenService:Create(window.toggleSquare, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 65, 0, 65)}):Play()
            task.wait(1)
            TweenService:Create(window.toggleSquare, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 60, 0, 60)}):Play()
            task.wait(1)
        end
    end
    task.spawn(animateSquare)

    -- Dragging for Toggle Square
    local draggingSquare, squareDragStart, squareStartPos
    window.toggleSquare.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSquare = true
            squareDragStart = input.Position
            squareStartPos = window.toggleSquare.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and draggingSquare then
            local delta = input.Position - squareDragStart
            window.toggleSquare.Position = UDim2.new(squareStartPos.X.Scale, squareStartPos.X.Offset + delta.X, squareStartPos.Y.Scale, squareStartPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSquare then
            draggingSquare = false
        end
    end)

    window.toggleSquare.MouseButton1Click:Connect(function()
        window.mainFrame.Visible = not window.mainFrame.Visible
    end)

    -- Tab Frame
    window.tabFrame = Instance.new("Frame")
    window.tabFrame.Size = UDim2.new(1, 0, 0, 55)
    window.tabFrame.Position = UDim2.new(0, 0, 0, 45)
    window.tabFrame.BackgroundTransparency = 1
    window.tabFrame.Parent = window.mainFrame

    local tabGrid = Instance.new("UIGridLayout")
    tabGrid.CellSize = UDim2.new(0, 120, 0, 55)
    tabGrid.CellPadding = UDim2.new(0, 5, 0, 0)
    tabGrid.SortOrder = Enum.SortOrder.LayoutOrder
    tabGrid.FillDirection = Enum.FillDirection.Horizontal
    tabGrid.Parent = window.tabFrame

    -- Search Box (adjusted position for no gap)
    window.searchBox = Instance.new("TextBox")
    window.searchBox.Size = UDim2.new(1, -20, 0, 30)
    window.searchBox.Position = UDim2.new(0, 10, 0, 100) -- Adjusted to be flush after tabFrame
    window.searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    window.searchBox.Text = "Search..."
    window.searchBox.TextColor3 = Color3.fromRGB(150, 150, 150) -- Placeholder color
    window.searchBox.Font = Enum.Font.Gotham
    window.searchBox.TextSize = 14
    window.searchBox.ClearTextOnFocus = false
    window.searchBox.Parent = window.mainFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = window.searchBox

    -- Placeholder handling for search
    window.searchBox.Focused:Connect(function()
        if window.searchBox.Text == "Search..." then
            window.searchBox.Text = ""
            window.searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    window.searchBox.FocusLost:Connect(function()
        if window.searchBox.Text == "" then
            window.searchBox.Text = "Search..."
            window.searchBox.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)

    -- Notification Container
    window.notifContainer = Instance.new("Frame")
    window.notifContainer.Size = UDim2.new(0, 300, 1, 0)
    window.notifContainer.Position = UDim2.new(1, -310, 0, 0)
    window.notifContainer.BackgroundTransparency = 1
    window.notifContainer.Parent = window.screenGui

    local notifListLayout = Instance.new("UIListLayout")
    notifListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifListLayout.Padding = UDim.new(0, 10)
    notifListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifListLayout.Parent = window.notifContainer

    -- Functions
    function window:CreateTab(name)
        local tab = {}
        tab.name = name
        tab.elements = {}
        tab.contentFrame = Instance.new("ScrollingFrame")
        tab.contentFrame.Size = UDim2.new(1, -20, 1, -130) -- Adjusted for flush positioning
        tab.contentFrame.Position = UDim2.new(0, 10, 0, 130) -- Adjusted to start right after searchBox
        tab.contentFrame.BackgroundTransparency = 1
        tab.contentFrame.ScrollBarThickness = 8
        tab.contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
        tab.contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.contentFrame.ScrollingDirection = Enum.ScrollingDirection.Y -- Only vertical scroll
        tab.contentFrame.Parent = window.mainFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 10)
        listLayout.Parent = tab.contentFrame

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)

        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14 -- Smaller text for tabs
        tabButton.Parent = window.tabFrame

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton

        local underline = Instance.new("Frame")
        underline.Size = UDim2.new(1, 0, 0, 3)
        underline.Position = UDim2.new(0, 0, 1, -3)
        underline.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
        underline.BorderSizePixel = 0
        underline.Parent = tabButton

        local underlineCorner = Instance.new("UICorner")
        underlineCorner.CornerRadius = UDim.new(1, 0)
        underlineCorner.Parent = underline

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.tabs) do
                TweenService:Create(t.button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 40)}):Play()
                TweenService:Create(t.underline, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                TweenService:Create(t.contentFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(-1, 10, 0, 130)}):Play()
                t.contentFrame.Visible = false
            end
            tab.contentFrame.Visible = true
            TweenService:Create(tab.contentFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0, 10, 0, 130)}):Play()
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
            TweenService:Create(underline, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 3)}):Play()
            window.currentTab = tab
            window.searchElements = tab.elements
        end)

        tab.button = tabButton
        tab.underline = underline
        table.insert(window.tabs, tab)

        if #window.tabs == 1 then
            tab.contentFrame.Visible = true
            window.currentTab = tab
            window.searchElements = tab.elements
        else
            tab.contentFrame.Visible = false
            tab.contentFrame.Position = UDim2.new(-1, 10, 0, 130)
        end

        -- Search for this tab
        local searchConnection
        searchConnection = window.searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = window.searchBox.Text
            if query == "Search..." then query = "" end
            query = string.lower(query)
            for _, elem in ipairs(window.searchElements) do
                if elem and elem.Parent then
                    local matches = (query == "" or string.len(query) < 2) or string.find(string.lower(elem.Name), query)
                    elem.Visible = matches
                end
            end
        end)

        table.insert(window.connections, searchConnection)

        function tab:CreateSlider(name, min, max, default, onChange)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 80)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Name = name
            sliderFrame.Parent = tab.contentFrame
            table.insert(tab.elements, sliderFrame)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -80, 0, 25)
            label.BackgroundTransparency = 1
            label.Text = name .. ": " .. default
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 15
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0, 60, 0, 25)
            textBox.Position = UDim2.new(1, -70, 0, 0)
            textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            textBox.Text = tostring(default)
            textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 14
            textBox.Parent = sliderFrame

            local tbCorner = Instance.new("UICorner")
            tbCorner.CornerRadius = UDim.new(0, 6)
            tbCorner.Parent = textBox

            local barFrame = Instance.new("Frame")
            barFrame.Size = UDim2.new(1, 0, 0, 15)
            barFrame.Position = UDim2.new(0, 0, 0, 35)
            barFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            barFrame.BorderSizePixel = 0
            barFrame.Parent = sliderFrame

            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 8)
            barCorner.Parent = barFrame

            local fillPercent = (default - min) / (max - min)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(fillPercent, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            fill.BorderSizePixel = 0
            fill.Parent = barFrame

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 8)
            fillCorner.Parent = fill

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = UDim2.new(fillPercent, -12, 0, -4.5)
            knob.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            knob.BorderSizePixel = 2
            knob.BorderColor3 = Color3.fromRGB(255, 255, 255)
            knob.Parent = barFrame

            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob

            local value = default
            local draggingSlider = false

            knob.MouseEnter:Connect(function()
                TweenService:Create(knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 28, 0, 28)}):Play()
            end)
            knob.MouseLeave:Connect(function()
                if not draggingSlider then
                    TweenService:Create(knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 24, 0, 24)}):Play()
                end
            end)

            knob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    window.draggingSliders[name] = {barFrame = barFrame, fill = fill, knob = knob, textBox = textBox, label = label, min = min, max = max, name = name, onChange = onChange}
                    TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)}):Play()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and draggingSlider then
                    draggingSlider = false
                    window.draggingSliders[name] = nil
                    TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)}):Play()
                end
            end)

            textBox.FocusLost:Connect(function()
                local num = tonumber(textBox.Text)
                if num then
                    num = math.clamp(num, min, max)
                    value = num
                    local relPos = (num - min) / (max - min)
                    TweenService:Create(fill, TweenInfo.new(0.15), {Size = UDim2.new(relPos, 0, 1, 0)}):Play()
                    TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(relPos, -12, 0, -4.5)}):Play()
                    textBox.Text = tostring(num)
                    label.Text = name .. ": " .. num
                    onChange(num)
                else
                    textBox.Text = tostring(math.floor(value))
                    label.Text = name .. ": " .. math.floor(value)
                end
            end)
        end

        function tab:CreateToggle(name, onChange, icon)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 50)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Name = name
            toggleFrame.Parent = tab.contentFrame
            table.insert(tab.elements, toggleFrame)

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0.7, 0, 1, 0)
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.Text = (icon or "🔘") .. " " .. name .. " (Off)"
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 15
            button.Parent = toggleFrame

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 10)
            btnCorner.Parent = button

            local keybindButton = Instance.new("TextButton")
            keybindButton.Size = UDim2.new(0.25, 0, 1, 0)
            keybindButton.Position = UDim2.new(0.75, 5, 0, 0)
            keybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            keybindButton.Text = "None"
            keybindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            keybindButton.Font = Enum.Font.Gotham
            keybindButton.TextSize = 12
            keybindButton.Parent = toggleFrame

            local kbCorner = Instance.new("UICorner")
            kbCorner.CornerRadius = UDim.new(0, 6)
            kbCorner.Parent = keybindButton

            local enabled = false
            local boundKey = nil

            button.MouseButton1Click:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0.68, 0, 0.9, 0)}):Play()
                task.wait(0.1)
                TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0.7, 0, 1, 0)}):Play()
                enabled = not enabled
                if enabled then
                    button.Text = (icon or "🔘") .. " " .. name .. " (On)"
                    onChange(true)
                else
                    button.Text = (icon or "🔘") .. " " .. name .. " (Off)"
                    onChange(false)
                end
            end)

            keybindButton.MouseButton1Click:Connect(function()
                window.keybindListening = {button = button, keybind = keybindButton, name = name, icon = icon, onChange = onChange, enabled = enabled}
                keybindButton.Text = "Press Key..."
                keybindButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end)

            window.toggleData[name] = {frame = toggleFrame, button = button, keybindButton = keybindButton, boundKey = boundKey, enabled = enabled, onChange = onChange, icon = icon, name = name}
        end

        function tab:CreateDropdown(name, options, default, onChange)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 50)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.Name = name
            dropdownFrame.Parent = tab.contentFrame
            table.insert(tab.elements, dropdownFrame)

            local headerFrame = Instance.new("Frame")
            headerFrame.Size = UDim2.new(1, 0, 0, 50)
            headerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            headerFrame.BorderSizePixel = 0
            headerFrame.Parent = dropdownFrame

            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 10)
            headerCorner.Parent = headerFrame

            local selectedLabel = Instance.new("TextLabel")
            selectedLabel.Size = UDim2.new(0.8, 0, 1, 0)
            selectedLabel.BackgroundTransparency = 1
            selectedLabel.Text = name .. ": " .. default
            selectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectedLabel.Font = Enum.Font.Gotham
            selectedLabel.TextSize = 15
            selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
            selectedLabel.Parent = headerFrame

            local arrowButton = Instance.new("TextButton")
            arrowButton.Size = UDim2.new(0.15, 0, 1, 0)
            arrowButton.Position = UDim2.new(0.85, 0, 0, 0)
            arrowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            arrowButton.Text = "▼"
            arrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            arrowButton.Font = Enum.Font.GothamBold
            arrowButton.TextSize = 14
            arrowButton.Parent = headerFrame

            local arrowCorner = Instance.new("UICorner")
            arrowCorner.CornerRadius = UDim.new(0, 6)
            arrowCorner.Parent = arrowButton

            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1, 0, 0, 0)
            optionsFrame.Position = UDim2.new(0, 0, 1, 0)
            optionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            optionsFrame.BackgroundTransparency = 0.1
            optionsFrame.BorderSizePixel = 0
            optionsFrame.ClipsDescendants = true
            optionsFrame.Visible = false
            optionsFrame.Parent = dropdownFrame

            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 10)
            optionsCorner.Parent = optionsFrame

            local optionsList = Instance.new("UIListLayout")
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.Padding = UDim.new(0, 5)
            optionsList.Parent = optionsFrame

            local selected = default
            local isOpen = false
            local baseHeight = 50
            local openHeight = baseHeight + (#options * 35)

            for _, option in ipairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 14
                optionButton.Parent = optionsFrame

                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optionButton

                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    selectedLabel.Text = name .. ": " .. selected
                    onChange(selected)
                    closeDropdown()
                end)
            end

            local function closeDropdown()
                isOpen = false
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -20, 0, baseHeight)}):Play()
                TweenService:Create(optionsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                task.wait(0.3)
                optionsFrame.Visible = false
                arrowButton.Text = "▼"
            end

            arrowButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    optionsFrame.Visible = true
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -20, 0, openHeight)}):Play()
                    TweenService:Create(optionsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, #options * 35)}):Play()
                    arrowButton.Text = "▲"
                else
                    closeDropdown()
                end
            end)

            -- Close on outside click (basic)
            local dropdownConn
            dropdownConn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = dropdownFrame.AbsolutePosition
                    local absSize = dropdownFrame.AbsoluteSize
                    local isInside = (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y)
                    if not isInside then
                        closeDropdown()
                    end
                end
            end)
            table.insert(window.connections, dropdownConn)
        end

        return tab
    end

    function window:ShowNotification(text, icon)
        if window.activeNotifs >= 5 then return end
        window.activeNotifs = window.activeNotifs + 1
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(1, 0, 0, 0)
        notif.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        notif.BackgroundTransparency = 0.1
        notif.BorderSizePixel = 0
        notif.LayoutOrder = -window.activeNotifs
        notif.Parent = window.notifContainer

        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 40, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "ℹ"
        iconLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.TextSize = 24
        iconLabel.Parent = notif

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -50, 1, 0)
        textLabel.Position = UDim2.new(0, 40, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextSize = 14
        textLabel.TextWrapped = true
        textLabel.Parent = notif

        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        task.wait(3)
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.3)
        notif:Destroy()
        window.activeNotifs = window.activeNotifs - 1
    end

    -- Handle Keybinds
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.Keyboard and not processed then
            if window.keybindListening then
                local kc = input.KeyCode
                local boundName = window.keybindListening.name
                window.keybindListening.keybind.Text = kc.Name
                window.keybindListening.keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                window.activeKeybinds[kc] = function()
                    local data = window.toggleData[boundName]
                    if data then
                        data.enabled = not data.enabled
                        if data.enabled then
                            data.button.Text = (data.icon or "🔘") .. " " .. data.name .. " (On)"
                            data.onChange(true)
                        else
                            data.button.Text = (data.icon or "🔘") .. " " .. data.name .. " (Off)"
                            data.onChange(false)
                        end
                    end
                end
                window.toggleData[boundName].boundKey = kc
                window.keybindListening = nil
            elseif window.activeKeybinds[input.KeyCode] then
                window.activeKeybinds[input.KeyCode]()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 and not processed and window.keybindListening then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = window.keybindListening.keybind.AbsolutePosition
            local absSize = window.keybindListening.keybind.AbsoluteSize
            local isInside = (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y)
            if not isInside then
                local boundName = window.keybindListening.name
                window.keybindListening.keybind.Text = "None"
                window.keybindListening.keybind.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                if window.toggleData[boundName].boundKey then
                    window.activeKeybinds[window.toggleData[boundName].boundKey] = nil
                    window.toggleData[boundName].boundKey = nil
                end
                window.keybindListening = nil
            end
        end
    end)

    -- Handle Slider Dragging
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            for sliderName, data in pairs(window.draggingSliders) do
                local mousePos = UserInputService:GetMouseLocation()
                local barPos = data.barFrame.AbsolutePosition
                local barSize = data.barFrame.AbsoluteSize.X
                local relPos = math.clamp((mousePos.X - barPos.X) / barSize, 0, 1)
                local value = data.min + (data.max - data.min) * relPos
                TweenService:Create(data.fill, TweenInfo.new(0.15), {Size = UDim2.new(relPos, 0, 1, 0)}):Play()
                TweenService:Create(data.knob, TweenInfo.new(0.15), {Position = UDim2.new(relPos, -12, 0, -4.5)}):Play()
                data.textBox.Text = tostring(math.floor(value))
                data.label.Text = data.name .. ": " .. math.floor(value)
                data.onChange(value)
            end
        end
    end)

    function window:Open()
        window.mainFrame.Visible = true
        window:ShowNotification("GUI Loaded!", "🚀")
    end

    return window
end

return Library
