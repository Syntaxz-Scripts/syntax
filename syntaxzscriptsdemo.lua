-- Syntaxz Scripts 5.0

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local guiName = "SyntaxzScriptsUI"
local function getOrCreateGui()
    local gui = player.PlayerGui:FindFirstChild(guiName)
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = guiName
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.Parent = player.PlayerGui
    end
    return gui
end

for _,g in ipairs(player.PlayerGui:GetChildren()) do
    if g:IsA("ScreenGui") and g.Name == guiName and g ~= player.PlayerGui:FindFirstChild(guiName) then
        g:Destroy()
    end
end

local gui = getOrCreateGui()
gui.Enabled = true

for _, child in ipairs(gui:GetChildren()) do
    child:Destroy()
end

-- Animation helpers
local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.35, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function roundify(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 18)
    corner.Parent = inst
    return corner
end
local function strokify(inst, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 2
    s.Color = color or Color3.fromRGB(180, 220, 255)
    s.Transparency = transparency or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end
local function glassify(inst, glassColor, transparency)
    inst.BackgroundTransparency = transparency or 0.25
    inst.BackgroundColor3 = glassColor or Color3.fromRGB(45, 60, 90)
    roundify(inst, 20)
    strokify(inst, 2, Color3.fromRGB(180, 220, 255), 0.29)
end

-- Mobile support
local function isMobile()
    return UIS.TouchEnabled and not UIS.KeyboardEnabled
end

local function getUISize()
    if isMobile() then
        if workspace.CurrentCamera then
            return math.floor(workspace.CurrentCamera.ViewportSize.X * 0.75), math.floor(workspace.CurrentCamera.ViewportSize.Y * 0.73)
        else
            return 490, 340
        end
    else
        return 490, 340
    end
end

local function getTabBarWidth()
    return isMobile() and 60 or 76
end

local UI_WIDTH, UI_HEIGHT = getUISize()
local TABBAR_WIDTH = getTabBarWidth()

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
frame.Position = UDim2.new(0.5, -UI_WIDTH//2, 0.5, -UI_HEIGHT//2)
glassify(frame, Color3.fromRGB(38, 54, 88), 0.14)
frame.BorderSizePixel = 0
frame.Active = true

-- UNIVERSAL DRAG SCRIPT (desktop and mobile touch support)
frame.Draggable = false
local dragging, dragInput, dragStart, startPos
local function update(input)
    if not dragStart or not startPos then return end
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        frame.Position.X.Scale,
        startPos.X.Offset + delta.X,
        frame.Position.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Blur effect
local blur = Instance.new("BlurEffect")
blur.Size = 14
blur.Parent = Lighting
RunService.RenderStepped:Connect(function()
    blur.Enabled = gui.Enabled
end)

-- Top Title Bar
local titleBarHeight = 46
local titleBar = Instance.new("Frame")
titleBar.Parent = frame
titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 37, 61)
titleBar.BackgroundTransparency = 0.08
titleBar.BorderSizePixel = 0
roundify(titleBar, 16)
strokify(titleBar, 1, Color3.fromRGB(110,180,255), 0.18)

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = titleBar
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Syntaxz Scripts"
titleLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextStrokeTransparency = 0.75

-- Make the title bar draggable too
titleBar.Active = true
titleBar.Draggable = false
local barDragging, barDragInput, barDragStart, barStartPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        barDragging = true
        barDragStart = input.Position
        barStartPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                barDragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        barDragInput = input
    end
end)
UIS.InputChanged:Connect(function(input)
    if input == barDragInput and barDragging then
        local delta = input.Position - barDragStart
        frame.Position = UDim2.new(
            frame.Position.X.Scale,
            barStartPos.X.Offset + delta.X,
            frame.Position.Y.Scale,
            barStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Tabs
local tabNames = {"Credits", "Forsaken", "Universal", "Garden"}
local tabButtons, tabFrames = {}, {}

local function getTabBtnHeight()
    return isMobile() and 44 or 38
end
local function getTabBtnFontSize()
    return isMobile() and 18 or 16
end

local tabBar = Instance.new("ScrollingFrame", frame)
tabBar.Size = UDim2.new(0, TABBAR_WIDTH, 1, -(titleBarHeight+44))
tabBar.Position = UDim2.new(0, 8, 0, titleBarHeight+2)
tabBar.BackgroundTransparency = 0.08
tabBar.BackgroundColor3 = Color3.fromRGB(38, 54, 88)
tabBar.BorderSizePixel = 0
tabBar.CanvasSize = UDim2.new(0, 0, 0, #tabNames * (getTabBtnHeight() + 6))
tabBar.ScrollBarThickness = isMobile() and 12 or 6
tabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabBar.ClipsDescendants = true
roundify(tabBar, 14)
strokify(tabBar, 1, Color3.fromRGB(110,180,255), 0.15)

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1, -10, 0, getTabBtnHeight())
    btn.Position = UDim2.new(0, 5, 0, (idx-1)*(getTabBtnHeight()+6))
    btn.AutoButtonColor = true
    btn.BackgroundColor3 = Color3.fromRGB(44, 56, 82)
    btn.TextColor3 = Color3.fromRGB(220,220,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = getTabBtnFontSize()
    btn.Text = name
    btn.TextStrokeTransparency = 0.78
    btn.BackgroundTransparency = 0.17
    roundify(btn, 8)
    strokify(btn, 0.8, Color3.fromRGB(130,180,255), 0.39)
    btn.ClipsDescendants = true
    return btn
end

local function createTabFrame()
    local tf = Instance.new("Frame", frame)
    tf.Size = UDim2.new(1, -TABBAR_WIDTH-20, 1, -(titleBarHeight+56))
    tf.Position = UDim2.new(0, TABBAR_WIDTH+16, 0, titleBarHeight+8)
    tf.BackgroundTransparency = 0.45
    tf.BackgroundColor3 = Color3.fromRGB(36, 48, 72)
    roundify(tf, 15)
    strokify(tf, 1.1, Color3.fromRGB(90,120,200), 0.4)
    tf.Visible = false
    tf.ClipsDescendants = true
    return tf
end

local function showTab(tab)
    for _, name in ipairs(tabNames) do
        if tabButtons[name] and tabFrames[name] then
            if name == tab then
                tabButtons[name].BackgroundColor3 = Color3.fromRGB(52, 74, 120)
                tabButtons[name].TextColor3 = Color3.fromRGB(255,255,255)
                tabButtons[name].TextStrokeTransparency = 0.61
                if not tabFrames[name].Visible then
                    tabFrames[name].Visible = true
                    tabFrames[name].Position = UDim2.new(0, TABBAR_WIDTH+28, 0, titleBarHeight+8)
                    tabFrames[name].BackgroundTransparency = 1
                    tween(tabFrames[name], {Position = UDim2.new(0, TABBAR_WIDTH+16, 0, titleBarHeight+8), BackgroundTransparency = 0.45}, 0.25)
                end
            else
                tabButtons[name].BackgroundColor3 = Color3.fromRGB(44, 56, 82)
                tabButtons[name].TextColor3 = Color3.fromRGB(220,220,255)
                tabButtons[name].TextStrokeTransparency = 0.77
                if tabFrames[name].Visible then
                    tween(tabFrames[name], {Position = UDim2.new(0, TABBAR_WIDTH+28, 0, titleBarHeight+8), BackgroundTransparency = 1}, 0.17).Completed:Connect(function()
                        tabFrames[name].Visible = false
                    end)
                end
            end
        end
    end
end

for i, name in ipairs(tabNames) do
    tabButtons[name] = createTabButton(name, i)
    tabFrames[name] = createTabFrame()
    tabButtons[name].MouseButton1Click:Connect(function() showTab(name) end)
end
showTab("Credits")

-- Notify system
local notif = Instance.new("TextLabel", frame)
notif.BackgroundTransparency = 0.13
notif.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
notif.Size = UDim2.new(1, -48, 0, 28)
notif.Position = UDim2.new(0, 24, 1, -40)
notif.Visible = false
notif.TextColor3 = Color3.fromRGB(255, 255, 255)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 16
notif.TextStrokeTransparency = 0.65
notif.TextStrokeColor3 = Color3.fromRGB(0,0,0)
roundify(notif, 10)
strokify(notif, 1, Color3.fromRGB(180,255,180), 0.19)

function notify(msg, col)
    notif.Text = msg
    notif.BackgroundColor3 = col or Color3.fromRGB(60, 120, 80)
    notif.Visible = true
    delay(2.1, function() notif.Visible = false end)
end

-----------------------
-- Credits Tab
-----------------------
do
    local tf = tabFrames["Credits"]
    if tf then
        local function label(txt, ypos)
            local l = Instance.new("TextLabel", tf)
            l.Size = UDim2.new(1, -24, 0, 28)
            l.Position = UDim2.new(0, 12, 0, ypos)
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.fromRGB(230, 230, 200)
            l.Font = Enum.Font.Gotham
            l.TextSize = 19
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextStrokeTransparency = 0.85
            l.Text = txt
            return l
        end
        label("ESP & UI: Syntaxz Scripts", 10)
        label("Discord: no discord.. :(", 38)
    end
end

-- UI Open/Close Animation
local function animateOpen()
    gui.Enabled = true
    frame.Visible = true
    local width, height = getUISize()
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(0.5, -width//2, 0.5, -height//2)
    frame.BackgroundTransparency = 1
    tween(frame, {BackgroundTransparency = 0}, 0.33)
end
local function animateClose()
    tween(frame, {BackgroundTransparency = 1}, 0.27).Completed:Connect(function()
        frame.Visible = false
        gui.Enabled = false
    end)
end

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 100, 0, 32)
closeBtn.Position = UDim2.new(1, -112, 1, -46)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "Close"
closeBtn.BackgroundTransparency = 0.20
roundify(closeBtn, 10)
strokify(closeBtn, 1, Color3.fromRGB(220,130,130), 0.29)
closeBtn.MouseButton1Click:Connect(animateClose)

-- Toggle keybind (RightShift)
local toggling = false
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed and not toggling and not isMobile() then
        toggling = true
        if not gui.Enabled or not frame.Visible then
            animateOpen()
        else
            animateClose()
        end
        wait(0.2)
        toggling = false
    end
end)

local function ensureGuiOnSpawn()
    local function onCharacterAdded()
        wait(1)
        local gui = player.PlayerGui:FindFirstChild(guiName)
        if not gui then
            getOrCreateGui()
        else
            gui.Enabled = true
        end
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end
ensureGuiOnSpawn()

local toggleBtnGui = Instance.new("ScreenGui")
toggleBtnGui.Name = "SyntaxzToggleBtnGui"
toggleBtnGui.ResetOnSpawn = false
toggleBtnGui.IgnoreGuiInset = true
toggleBtnGui.Parent = player.PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "UIToggleButton"
toggleBtn.Size = isMobile() and UDim2.new(0, 64, 0, 64) or UDim2.new(0, 56, 0, 56)
toggleBtn.Position = isMobile() and UDim2.new(0, 16, 1, -88) or UDim2.new(0, 15, 1, -74)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
toggleBtn.TextColor3 = Color3.fromRGB(240,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 27
toggleBtn.Text = "☰"
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = not isMobile()
toggleBtn.BackgroundTransparency = 0.18
roundify(toggleBtn, 28)
strokify(toggleBtn, 1.2, Color3.fromRGB(180,220,255), 0.18)
toggleBtn.Parent = toggleBtnGui

toggleBtn.MouseButton1Click:Connect(function()
    if not gui.Enabled or not frame.Visible then
        animateOpen()
    else
        animateClose()
    end
end)

gui.AncestryChanged:Connect(function()
    if not gui:IsDescendantOf(game) then
        blur:Destroy()
    end
end)

-----------------------
-- Forsaken Tab 
-----------------------
local forsakenVars = { esp = false, stamina = false }
do
    local tf = tabFrames["Forsaken"]
    local function styledBtn(parent, y, text, col)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 180, 0, 34)
        btn.Position = UDim2.new(0, 14, 0, y)
        btn.BackgroundColor3 = col or Color3.fromRGB(55, 68, 95)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 17
        btn.Text = text
        btn.AutoButtonColor = true
        btn.BackgroundTransparency = 0.20
        roundify(btn, 11)
        strokify(btn, 1, Color3.fromRGB(100,180,120), 0.35)
        btn.ClipsDescendants = true
        return btn
    end

    local espBtn = styledBtn(tf, 10, "Player ESP: OFF", Color3.fromRGB(50, 85, 90))

    -- ESP Logic
    local highlighted, espConnection = {}, nil
    local ESP_LABEL_NAME = "ESPLabel"
    local function highlight(part, text, color)
        if not part:FindFirstChild(ESP_LABEL_NAME) then
            local gui = Instance.new("BillboardGui")
            gui.Name = ESP_LABEL_NAME
            gui.AlwaysOnTop = true
            gui.Size = UDim2.new(0, 50, 0, 50)
            gui.StudsOffset = Vector3.new(0, 2, 0)
            gui.Parent = part

            local label = Instance.new("TextLabel")
            label.Parent = gui
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = text
            label.TextScaled = true
            label.TextStrokeTransparency = 0.5
            label.TextColor3 = color
        end
    end
    local function handle(obj)
        if highlighted[obj] then return end
        if obj:IsA("Model") and obj.Name == "Generator" and obj.Parent and obj.Parent.Name == "Map" then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                highlight(part, "Generator", Color3.fromRGB(255, 255, 0))
                highlighted[obj] = true
            end
        end
        if obj:IsA("Tool") and obj.Parent and obj.Parent.Name == "Ingame" then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                highlight(part, obj.Name, Color3.fromRGB(255, 255, 0))
                highlighted[obj] = true
            end
        end
        if obj:IsA("Model") and obj.Parent and obj.Parent.Name == "Killers" then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                highlight(part, "Killer", Color3.fromRGB(255, 0, 0))
                highlighted[obj] = true
            end
        end
    end
    local function clearESP()
        for obj in pairs(highlighted) do
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                local gui = part:FindFirstChild(ESP_LABEL_NAME)
                if gui then gui:Destroy() end
            end
            highlighted[obj] = nil
        end
    end
    local function EnableESP()
        for _, obj in ipairs(workspace:GetDescendants()) do handle(obj) end
        espConnection = workspace.DescendantAdded:Connect(handle)
    end
    local function DisableESP()
        if espConnection then espConnection:Disconnect() espConnection = nil end
        clearESP()
    end
    espBtn.MouseButton1Click:Connect(function()
        forsakenVars.esp = not forsakenVars.esp
        espBtn.Text = "Player ESP: " .. (forsakenVars.esp and "ON" or "OFF")
        if forsakenVars.esp then EnableESP() else DisableESP() end
        notify("Player ESP " .. (forsakenVars.esp and "enabled" or "disabled"))
    end)

    -- Infinite Stamina
    local staminaBtn = styledBtn(tf, 54, "Infinite Stamina: OFF", Color3.fromRGB(85, 85, 60))
    staminaBtn.MouseButton1Click:Connect(function()
        forsakenVars.stamina = not forsakenVars.stamina
        staminaBtn.Text = "Infinite Stamina: " .. (forsakenVars.stamina and "ON" or "OFF")
        notify("Infinite Stamina " .. (forsakenVars.stamina and "enabled." or "disabled."))
    end)
    spawn(function()
        local Sprinting = ReplicatedStorage:FindFirstChild("Systems")
            and ReplicatedStorage.Systems:FindFirstChild("Character")
            and ReplicatedStorage.Systems.Character:FindFirstChild("Game")
            and ReplicatedStorage.Systems.Character.Game:FindFirstChild("Sprinting")
        local m = Sprinting and require(Sprinting)
        while wait(0.15) do
            if forsakenVars.stamina and m then
                if m.Stamina <= 5 then m.Stamina = 20 end
            end
        end
    end)
end

-----------------------
-- Universal Tab 
-----------------------
do
    local tf = tabFrames["Universal"]
    local universalVars = {fullbright = false, acBypass = false, infHealth = false}
    local jitterVars = {enabled = false, connection = nil, origPos = nil, jitterTime = 0}

    local function styledBtn(parent, x, y, w, text, col)
        local maxWidth = tf.AbsoluteSize.X - 32
        local width = math.min(w or 190, maxWidth)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, width, 0, 34)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = col or Color3.fromRGB(46, 60, 120)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = text
        btn.AutoButtonColor = true
        btn.BackgroundTransparency = 0.18
        roundify(btn, 11)
        strokify(btn, 1.1, Color3.fromRGB(120,200,240), 0.34)
        btn.ClipsDescendants = true
        return btn
    end

    local contentParent = tf
    local contentY = 10
    if isMobile() then
        local scroll = Instance.new("ScrollingFrame", tf)
        scroll.Size = UDim2.new(1, -16, 1, -16)
        scroll.Position = UDim2.new(0, 8, 0, 8)
        scroll.CanvasSize = UDim2.new(0,0,0,800)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarThickness = 12
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentParent = scroll
        contentY = 0
    end

    -- Fullbright
    local fbBtn = styledBtn(contentParent, 14, contentY, 170, "Fullbright: OFF", Color3.fromRGB(80, 80, 110))
    local orig = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogEnd = Lighting.FogEnd
    }
    local function enableFullbright()
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 5
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.FogEnd = 100000
        universalVars.fullbright = true
    end
    local function disableFullbright()
        for k,v in pairs(orig) do Lighting[k]=v end
        universalVars.fullbright = false
    end
    fbBtn.MouseButton1Click:Connect(function()
        universalVars.fullbright = not universalVars.fullbright
        fbBtn.Text = "Fullbright: " .. (universalVars.fullbright and "ON" or "OFF")
        if universalVars.fullbright then enableFullbright() else disableFullbright() end
        notify("Fullbright " .. (universalVars.fullbright and "ON" or "OFF"))
    end)
    Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if universalVars.fullbright and Lighting.Ambient ~= Color3.new(1,1,1) then enableFullbright() end
    end)
    contentY = contentY + 44

    -- Infinite Health
    local infHealthBtn = styledBtn(contentParent, 14, contentY, 170, "Infinite Health: OFF", Color3.fromRGB(90, 60, 90))
    local infHealthLoop = nil
    local lastHealth = nil
    local healthChangedConn = nil
    local function startInfHealth()
        local function getHumanoid()
            local char = player.Character
            if char then
                for _, v in ipairs(char:GetChildren()) do
                    if v:IsA("Humanoid") then
                        return v
                    end
                end
            end
        end
        infHealthLoop = coroutine.create(function()
            while universalVars.infHealth do
                local humanoid = getHumanoid()
                if humanoid then
                    if humanoid.MaxHealth < 1e9 then
                        pcall(function() humanoid.MaxHealth = 1e9 end)
                    end
                    if humanoid.Health < humanoid.MaxHealth then
                        pcall(function() humanoid.Health = humanoid.MaxHealth end)
                    end
                end
                wait(0.08)
            end
        end)
        coroutine.resume(infHealthLoop)
        if healthChangedConn then pcall(function() healthChangedConn:Disconnect() end) end
        local humanoid = getHumanoid()
        if humanoid then
            lastHealth = humanoid.Health
            healthChangedConn = humanoid.HealthChanged:Connect(function(newHealth)
                if universalVars.infHealth then
                    if newHealth > lastHealth then
                        for i = 1, 3 do
                            pcall(function()
                                humanoid.Health = math.min(humanoid.Health + (newHealth - lastHealth), humanoid.MaxHealth)
                            end)
                            wait(0.03)
                        end
                    end
                    lastHealth = humanoid.Health
                end
            end)
        end
    end
    local function stopInfHealth()
        universalVars.infHealth = false
        if infHealthLoop then
            infHealthLoop = nil
        end
        if healthChangedConn then
            pcall(function() healthChangedConn:Disconnect() end)
            healthChangedConn = nil
        end
    end
    infHealthBtn.MouseButton1Click:Connect(function()
        universalVars.infHealth = not universalVars.infHealth
        infHealthBtn.Text = "Infinite Health: " .. (universalVars.infHealth and "ON" or "OFF")
        if universalVars.infHealth then
            notify("Infinite Health enabled!")
            startInfHealth()
        else
            notify("Infinite Health disabled.")
            stopInfHealth()
        end
    end)
    player.CharacterAdded:Connect(function()
        if universalVars.infHealth then
            wait(1)
            startInfHealth()
        end
    end)
    contentY = contentY + 44

    -- Anti-Cheat Bypass
    local acBtn = styledBtn(contentParent, 200, 10, 220, "Anti-Cheat Detector/Bypass: OFF", Color3.fromRGB(120, 60, 60))
    local acDetectorEnabled = false
    local function scanForAntiCheat()
        local keywords = {"AntiCheat", "AC", "Ban", "Kick", "Logger", "Admin", "Detector"}
        local found = {}
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                for _, word in ipairs(keywords) do
                    if obj.Name:lower():find(word:lower()) then
                        table.insert(found, obj:GetFullName())
                    end
                end
            end
        end
        return found
    end
    local function scanForSuspiciousRemotes()
        local remotes = {}
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                if obj.Name:lower():find("cheat") or obj.Name:lower():find("kick") or obj.Name:lower():find("ban") then
                    table.insert(remotes, obj:GetFullName())
                end
            end
        end
        return remotes
    end
    local function disableAntiCheatScripts()
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("LocalScript") and obj.Name:lower():find("anticheat") then
                pcall(function() obj.Disabled = true end)
            end
        end
    end
    local function blockKickFunction()
        if not player then return end
        if typeof(hookfunction) == "function" then
            if not player.__kickHooked then
                pcall(function()
                    hookfunction(player.Kick, function() return end)
                    player.__kickHooked = true
                end)
            end
        else
            player.Kick = function() return end
        end
    end
    local function enableACDetectorBypass()
        local scripts = scanForAntiCheat()
        local remotes = scanForSuspiciousRemotes()
        if #scripts == 0 and #remotes == 0 then
            notify("No obvious anti-cheat found.", Color3.fromRGB(60,120,60))
        else
            notify("Anti-cheat scripts/remotes found!", Color3.fromRGB(150,100,50))
        end
        disableAntiCheatScripts()
        blockKickFunction()
        acDetectorEnabled = true
    end
    local function disableACDetectorBypass()
        acDetectorEnabled = false
        notify("Anti-cheat bypass disabled. (Some changes may persist)", Color3.fromRGB(120,60,60))
    end
    acBtn.MouseButton1Click:Connect(function()
        acDetectorEnabled = not acDetectorEnabled
        acBtn.Text = "Anti-Cheat Detector/Bypass: " .. (acDetectorEnabled and "ON" or "OFF")
        if acDetectorEnabled then
            local ok, err = pcall(enableACDetectorBypass)
            if not ok then
                notify("Anti-cheat bypass error: " .. tostring(err), Color3.fromRGB(180,50,50))
            end
        else
            disableACDetectorBypass()
        end
    end)
    contentY = contentY + 44

    -- Fire all Remotes (probe)
    local probeBtn = styledBtn(contentParent, 200, 54, 220, "Fire all Remotes", Color3.fromRGB(60, 120, 120))
    probeBtn.MouseButton1Click:Connect(function()
        local popup = Instance.new("ScreenGui")
        popup.Name = "FireResultsPopup"
        popup.Parent = player.PlayerGui
        local frame = Instance.new("Frame", popup)
        frame.Size = UDim2.new(0, 520, 0, 380)
        frame.Position = UDim2.new(0.5, -260, 0.5, -190)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true
        roundify(frame, 13)
        strokify(frame, 2, Color3.fromRGB(90,190,245), 0.26)

        local closeBtn = Instance.new("TextButton", frame)
        closeBtn.Size = UDim2.new(0, 80, 0, 34)
        closeBtn.Position = UDim2.new(1, -90, 0, 10)
        closeBtn.Text = "Close"
        closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.TextSize = 18
        closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)
        roundify(closeBtn, 10)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, -20, 0, 34)
        title.Position = UDim2.new(0, 10, 0, 10)
        title.Text = "Fire Remotes Results"
        title.Font = Enum.Font.GothamBold
        title.TextColor3 = Color3.fromRGB(200,255,200)
        title.BackgroundTransparency = 1
        title.TextSize = 24
        title.TextXAlignment = Enum.TextXAlignment.Left

        local warn = Instance.new("TextLabel", frame)
        warn.Size = UDim2.new(1, -20, 0, 22)
        warn.Position = UDim2.new(0, 10, 0, 44)
        warn.Text = "⚠️ Only listing remotes. Dangerous remotes are NOT triggered."
        warn.Font = Enum.Font.Gotham
        warn.TextColor3 = Color3.fromRGB(255,220,140)
        warn.BackgroundTransparency = 1
        warn.TextSize = 16
        warn.TextXAlignment = Enum.TextXAlignment.Left

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1, -20, 1, -74)
        scroll.Position = UDim2.new(0, 10, 0, 66)
        scroll.BackgroundColor3 = Color3.fromRGB(20,20,20)
        scroll.BorderSizePixel = 0
        scroll.CanvasSize = UDim2.new(0,0,0,2000)
        scroll.ScrollBarThickness = 8
        roundify(scroll, 8)

        local y = 0
        local function logLine(txt, col)
            local label = Instance.new("TextLabel", scroll)
            label.Size = UDim2.new(1, -10, 0, 26)
            label.Position = UDim2.new(0, 5, 0, y)
            label.Text = txt
            label.TextColor3 = col or Color3.fromRGB(200,200,200)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Code
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextSize = 17
            y = y + 28
            scroll.CanvasSize = UDim2.new(0,0,0,y+30)
        end

        local function getFullPath(obj)
            if not obj or not obj.Parent then return obj.Name end
            local path = obj.Name
            local parent = obj.Parent
            while parent and parent ~= game do
                path = parent.Name .. "." .. path
                parent = parent.Parent
            end
            return path
        end

        local dangerous = {"kick", "ban", "admin", "devconsole", "delete", "reset", "shutdown", "punish", "log", "report", "exploit"}
        local likelySafe = {"probe", "test", "info", "get", "fetch", "load"}

        logLine("== Remote Security Probe ==", Color3.fromRGB(200,255,200))
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local path = getFullPath(obj)
                local lowerName = obj.Name:lower()
                local isDangerous = false
                for _, s in ipairs(dangerous) do
                    if lowerName:find(s) then
                        isDangerous = true
                        break
                    end
                end
                local isLikelySafe = false
                for _, s in ipairs(likelySafe) do
                    if lowerName:find(s) then
                        isLikelySafe = true
                        break
                    end
                end

                if isDangerous then
                    logLine("[DANGEROUS] "..(obj.ClassName).." "..path, Color3.fromRGB(255,80,80))
                elseif isLikelySafe then
                    logLine("[SAFE] "..(obj.ClassName).." "..path, Color3.fromRGB(150,255,100))
                    local ok, result = pcall(function()
                        if obj:IsA("RemoteEvent") then
                            obj:FireServer("probe", 123, true)
                            return "Fired test args"
                        elseif obj:IsA("RemoteFunction") then
                            return obj:InvokeServer("probe", 42, false)
                        end
                    end)
                    if ok then
                        logLine("   ✔️ Success: "..tostring(result), Color3.fromRGB(120,255,180))
                    else
                        logLine("   ⚠️ ERROR: "..tostring(result), Color3.fromRGB(255,120,120))
                    end
                else
                    logLine("[LISTED] "..(obj.ClassName).." "..path, Color3.fromRGB(120,180,255))
                end
            end
        end

        logLine("== Probe Complete ==", Color3.fromRGB(200,255,200))
        logLine("Only safe/test remotes were called. Anything marked [DANGEROUS] was NOT triggered.", Color3.fromRGB(255,255,150))
    end)
    contentY = contentY + 44

    -- Skip Time (Tp Walk)
    local function lightningAura(center, radius, duration)
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local NUM_BOLTS = 10
        local COLOR = ColorSequence.new(Color3.fromRGB(120, 190, 255), Color3.fromRGB(120, 190, 255))
        for i = 1, NUM_BOLTS do
            local angle = math.rad((i / NUM_BOLTS) * 360)
            local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * (radius + math.random()*1.5)
            local startPos = hrp.Position
            local endPos = hrp.Position + offset + Vector3.new(0, math.random()*3, 0)
            local part0 = Instance.new("Part", workspace)
            part0.Anchored = true
            part0.CanCollide = false
            part0.Transparency = 1
            part0.Size = Vector3.new(0.2, 0.2, 0.2)
            part0.Position = startPos

            local part1 = Instance.new("Part", workspace)
            part1.Anchored = true
            part1.CanCollide = false
            part1.Transparency = 1
            part1.Size = Vector3.new(0.2, 0.2, 0.2)
            part1.Position = endPos

            local att0 = Instance.new("Attachment", part0)
            local att1 = Instance.new("Attachment", part1)

            local beam = Instance.new("Beam", part0)
            beam.Attachment0 = att0
            beam.Attachment1 = att1
            beam.Width0 = 0.35 + math.random()*0.15
            beam.Width1 = 0.25 + math.random()*0.15
            beam.Color = COLOR
            beam.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0.5)})
            beam.LightEmission = 5
            beam.CurveSize0 = math.random(-4,4)
            beam.CurveSize1 = math.random(-4,4)
            beam.FaceCamera = true

            task.delay(duration or 0.13, function()
                part0:Destroy()
                part1:Destroy()
            end)
        end
    end
    local function summonForwardLightningBurst(skipDistance)
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local center = hrp.Position
        local forward = hrp.CFrame.LookVector
        local up = hrp.CFrame.UpVector
        local right = hrp.CFrame.RightVector
        local NUM_BOLTS = 20
        local LIGHTNING_COLOR = ColorSequence.new(Color3.fromRGB(120, 190, 255), Color3.fromRGB(120, 190, 230))
        local LIGHTNING_DURATION = 0.2

        local function zap(startPos, endPos, color)
            local part0 = Instance.new("Part", workspace)
            part0.Anchored = true
            part0.CanCollide = false
            part0.Transparency = 1
            part0.Size = Vector3.new(0.2, 0.2, 0.2)
            part0.Position = startPos

            local part1 = Instance.new("Part", workspace)
            part1.Anchored = true
            part1.CanCollide = false
            part1.Transparency = 1
            part1.Size = Vector3.new(0.2, 0.2, 0.2)
            part1.Position = endPos

            local att0 = Instance.new("Attachment", part0)
            local att1 = Instance.new("Attachment", part1)

            local beam = Instance.new("Beam", part0)
            beam.Attachment0 = att0
            beam.Attachment1 = att1
            beam.Width0 = 0.3 + math.random() * 0.2
            beam.Width1 = 0.2 + math.random() * 0.2
            beam.Color = color or LIGHTNING_COLOR
            beam.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0.5)})
            beam.LightEmission = 5
            beam.CurveSize0 = math.random(-8,8)
            beam.CurveSize1 = math.random(-8,8)
            beam.FaceCamera = true

            task.delay(LIGHTNING_DURATION, function()
                part0:Destroy()
                part1:Destroy()
            end)
        end

        for i = 1, NUM_BOLTS do
            local offsetRight = right * math.random(-3,3)
            local offsetUp = up * math.random(-1,1)
            local startOffset = offsetRight + offsetUp
            local startPos = center + startOffset
            local endOffset = forward * skipDistance
                + right * math.random(-2,2)
                + up * math.random(-1,1)
            local endPos = center + endOffset
            zap(startPos, endPos, LIGHTNING_COLOR)
        end
    end
    local SKIP_DISTANCE = 200 * 0.1
    local SKIP_SPEED = 200
    local SKIP_DURATION = 0.1
    local externalBtn = nil
    local function createExternalTpWalkBtn()
        if externalBtn and externalBtn.Parent then
            externalBtn.Visible = true
            return
        end
        local extScreenGui = player.PlayerGui:FindFirstChild("SyntaxzExternalTpBtnGui")
        if not extScreenGui then
            extScreenGui = Instance.new("ScreenGui")
            extScreenGui.Name = "SyntaxzExternalTpBtnGui"
            extScreenGui.ResetOnSpawn = false
            extScreenGui.Parent = player.PlayerGui
        end
        local btn = Instance.new("TextButton")
        btn.Name = "TpWalkButton"
        btn.Size = UDim2.new(0, 170, 0, 45)
        btn.Position = UDim2.new(1, -180, 1, -60)
        btn.AnchorPoint = Vector2.new(0,0)
        btn.BackgroundColor3 = Color3.fromRGB(65, 140, 180)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.Text = "Skip Time"
        btn.Parent = extScreenGui
        btn.Active = true
        btn.Draggable = not isMobile()
        roundify(btn, 15)
        strokify(btn, 1.2, Color3.fromRGB(180,220,255), 0.18)

        btn.MouseButton1Click:Connect(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (char and hrp and hum) then
                notify("Character not found!", Color3.fromRGB(200,50,50))
                return
            end
            lightningAura(hrp.Position, 6, 0.13)
            notify("Charging...", Color3.fromRGB(180,230,255))
            task.delay(0.1, function()
                local direction = hrp.CFrame.LookVector
                local speed = SKIP_SPEED
                local duration = SKIP_DURATION
                local start = tick()
                local connection
                connection = RunService.RenderStepped:Connect(function(dt)
                    if tick()-start > duration then
                        connection:Disconnect()
                        return
                    end
                    hrp.CFrame = hrp.CFrame + direction * speed * dt
                end)
                summonForwardLightningBurst(speed * duration)
                notify("TpWalked for 0.2s!", Color3.fromRGB(180,230,255))
            end)
        end)

        externalBtn = btn
    end
    local makeBtn = styledBtn(contentParent, 200, 94, 220, "Skip Time", Color3.fromRGB(65, 140, 180))
    makeBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            lightningAura(hrp.Position, 6, 0.13)
        end
        notify("Charging...", Color3.fromRGB(90,200,255))
        task.delay(0.1, function()
            createExternalTpWalkBtn()
            summonForwardLightningBurst(SKIP_DISTANCE)
            notify("TpWalk button created at bottom right!", Color3.fromRGB(90,200,255))
        end)
    end)
    player.CharacterAdded:Connect(function()
        wait(1)
        if externalBtn and externalBtn.Parent then
            externalBtn.Visible = true
        end
    end)
    contentY = contentY + 44

    -- Vibrate/Jitter Character
    local jitterBtn = styledBtn(contentParent, 200, 136, 220, "Vibrate (Jitter) Character: OFF", Color3.fromRGB(130, 120, 220))
    local JITTER_DISTANCE = 0.35
    local JITTER_SPEED = 5e9
    local HUMANOID_PART = "HumanoidRootPart"
    local lastJitterOffset = 0
    local function stopJitter()
        jitterVars.enabled = false
        jitterBtn.Text = "Vibrate (Jitter) Character: OFF"
        if jitterVars.connection then
            jitterVars.connection:Disconnect()
            jitterVars.connection = nil
        end
        lastJitterOffset = 0
    end
    local function startJitter()
        if jitterVars.connection then
            jitterVars.connection:Disconnect()
        end
        local char = player.Character
        if not (char and char:FindFirstChild(HUMANOID_PART)) then
            notify("Character not found!", Color3.fromRGB(200,50,50))
            jitterVars.enabled = false
            jitterBtn.Text = "Vibrate (Jitter) Character: OFF"
            return
        end
        local hrp = char[HUMANOID_PART]
        jitterVars.jitterTime = 0
        jitterVars.enabled = true
        jitterBtn.Text = "Vibrate (Jitter) Character: ON"
        lastJitterOffset = 0
        jitterVars.connection = RunService.RenderStepped:Connect(function(dt)
            if not jitterVars.enabled then return end
            if not (player.Character and player.Character:FindFirstChild(HUMANOID_PART)) then
                stopJitter()
                return
            end
            local hrp = player.Character[HUMANOID_PART]
            jitterVars.jitterTime = jitterVars.jitterTime + dt * JITTER_SPEED
            local offset = math.sin(jitterVars.jitterTime) * JITTER_DISTANCE
            local basePos = hrp.Position - hrp.CFrame.RightVector * lastJitterOffset
            local newPos = basePos + hrp.CFrame.RightVector * offset
            hrp.CFrame = CFrame.new(newPos, newPos + hrp.CFrame.LookVector)
            lastJitterOffset = offset
        end)
    end
    jitterBtn.MouseButton1Click:Connect(function()
        if jitterVars.enabled then
            stopJitter()
            notify("Jitter effect disabled.")
        else
            startJitter()
            notify("Jitter effect enabled! Everyone can see it, and you can walk while jittering.")
        end
    end)
    player.CharacterAdded:Connect(function()
        stopJitter()
        if jitterVars.enabled then
            wait(1)
            startJitter()
        end
    end)

-- Auto Dodge (Automatically makes you dodge when near a player) 

    local autoTpWalkVars = {
        enabled = false,
        direction = "Left",
        connection = nil,
        lastTp = 0,
        cooldown = 1.2,
    }
    local directions = {"Left", "Right", "Backward"}
    local directionVectors = {
        Left = function(hrp) return -hrp.CFrame.RightVector end,
        Right = function(hrp) return hrp.CFrame.RightVector end,
        Backward = function(hrp) return -hrp.CFrame.LookVector end,
    }

    local function autoTpWalk(direction)
        local char = player and player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Lightning effect
        local function lightningAura(center, radius, duration)
            local NUM_BOLTS = 40
            local COLOR = ColorSequence.new(Color3.fromRGB(120, 190, 255), Color3.fromRGB(120, 190, 255))
            for i = 1, NUM_BOLTS do
                local angle = math.rad((i / NUM_BOLTS) * 360)
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * (radius + math.random()*1.5)
                local startPos = hrp.Position
                local endPos = hrp.Position + offset + Vector3.new(0, math.random()*3, 0)
                local part0 = Instance.new("Part", workspace)
                part0.Anchored = true
                part0.CanCollide = false
                part0.Transparency = 1
                part0.Size = Vector3.new(0.2, 0.2, 0.2)
                part0.Position = startPos

                local part1 = Instance.new("Part", workspace)
                part1.Anchored = true
                part1.CanCollide = false
                part1.Transparency = 1
                part1.Size = Vector3.new(0.2, 0.2, 0.2)
                part1.Position = endPos

                local att0 = Instance.new("Attachment", part0)
                local att1 = Instance.new("Attachment", part1)

                local beam = Instance.new("Beam", part0)
                beam.Attachment0 = att0
                beam.Attachment1 = att1
                beam.Width0 = 0.35 + math.random()*0.15
                beam.Width1 = 0.25 + math.random()*0.15
                beam.Color = COLOR
                beam.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0.5)})
                beam.LightEmission = 7
                beam.CurveSize0 = math.random(-4,4)
                beam.CurveSize1 = math.random(-4,4)
                beam.FaceCamera = true

                task.delay(duration or 0.13, function()
                    part0:Destroy()
                    part1:Destroy()
                end)
            end
        end

        local SKIP_DISTANCE = 18 
        local SKIP_SPEED = 150
        local SKIP_DURATION = 0.1

        lightningAura(hrp.Position, 6, 0.13)
        if notify then
            notify("Auto TpWalk: "..direction.."!", Color3.fromRGB(90,200,255))
        end
        task.delay(0.1, function()
            local dirFunc = directionVectors[direction]
            if not dirFunc then return end
            local dirVec = dirFunc(hrp)
            local speed = SKIP_SPEED
            local duration = SKIP_DURATION
            local start = tick()
            local connection
            connection = RunService.RenderStepped:Connect(function(dt)
                if tick()-start > duration then
                    connection:Disconnect()
                    return
                end
                hrp.CFrame = hrp.CFrame + dirVec * speed * dt
            end)
        end)
    end

    -- Adds a button to Universal tab (layout fix)
local x = 14
local autoBtn = Instance.new("TextButton", contentParent)
autoBtn.Size = UDim2.new(0, 270, 0, 34)
autoBtn.Position = UDim2.new(0, x, 0, contentY)
autoBtn.BackgroundColor3 = Color3.fromRGB(80,140,80)
autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 16
autoBtn.Text = "Auto TpWalk on Proximity: OFF"
autoBtn.AutoButtonColor = true
autoBtn.BackgroundTransparency = 0.18
roundify(autoBtn, 12)
strokify(autoBtn, 1.1, Color3.fromRGB(100,200,120), 0.3)

-- Dropdown for direction
local dirDropdown = Instance.new("TextButton", contentParent)
dirDropdown.Size = UDim2.new(0, 120, 0, 28)
dirDropdown.Position = UDim2.new(0, x+280, 0, contentY+3)
dirDropdown.BackgroundColor3 = Color3.fromRGB(60,90,60)
dirDropdown.TextColor3 = Color3.fromRGB(255,255,200)
dirDropdown.Font = Enum.Font.Gotham
dirDropdown.TextSize = 15
dirDropdown.Text = "Direction: Left"
dirDropdown.AutoButtonColor = true
dirDropdown.BackgroundTransparency = 0.22
roundify(dirDropdown, 8)
strokify(dirDropdown, 1, Color3.fromRGB(120,220,130), 0.26)

local function updateDirDropdown()
    dirDropdown.Text = "Direction: " .. autoTpWalkVars.direction
end
dirDropdown.MouseButton1Click:Connect(function()
    local idx = table.find(directions, autoTpWalkVars.direction) or 1
    idx = idx + 1
    if idx > #directions then idx = 1 end
    autoTpWalkVars.direction = directions[idx]
    updateDirDropdown()
end)

contentY = contentY + 44
    -- Main loop for auto tp walk
    local function enableAutoTpWalk()
        if autoTpWalkVars.connection then autoTpWalkVars.connection:Disconnect() end
        autoTpWalkVars.enabled = true
        autoBtn.Text = "Auto TpWalk on Proximity: ON"
        autoTpWalkVars.connection = RunService.Heartbeat:Connect(function()
            if not autoTpWalkVars.enabled then return end
            local char = player and player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local myPos = hrp.Position
            for _,other in ipairs(Players:GetPlayers()) do
                if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
                    local oh = other.Character.HumanoidRootPart
                    if (oh.Position-myPos).Magnitude < 7 then
                        if tick()-autoTpWalkVars.lastTp > autoTpWalkVars.cooldown then
                            autoTpWalk(autoTpWalkVars.direction)
                            autoTpWalkVars.lastTp = tick()
                        end
                        break
                    end
                end
            end
        end)
        if notify then
            notify("Auto TpWalk enabled! Will move "..autoTpWalkVars.direction.." if a player is near.")
        end
    end
    local function disableAutoTpWalk()
        autoTpWalkVars.enabled = false
        autoBtn.Text = "Auto TpWalk on Proximity: OFF"
        if autoTpWalkVars.connection then
            autoTpWalkVars.connection:Disconnect()
            autoTpWalkVars.connection = nil
        end
        if notify then
            notify("Auto TpWalk disabled.")
        end
    end
    autoBtn.MouseButton1Click:Connect(function()
        if autoTpWalkVars.enabled then
            disableAutoTpWalk()
        else
            enableAutoTpWalk()
        end
    end)
    player.CharacterAdded:Connect(function()
        -- reset cooldown on respawn
        autoTpWalkVars.lastTp = 0
    end)
    -- End Auto TpWalk

-- Pocket Dimension
local OFFSET = Vector3.new(10000, 0, 0)
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local enterBtn = styledBtn(contentParent, 14, contentY, 220, "Enter Pocket Dimension", Color3.fromRGB(140,190,220))
enterBtn.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player and player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- 🌀 Spawn portal near player
    local portal = Instance.new("Part")
    portal.Size = Vector3.new(8,8,8)
    portal.Shape = Enum.PartType.Ball
    portal.Position = hrp.Position + hrp.CFrame.LookVector * 6 + Vector3.new(0, 4, 0)
    portal.Anchored = true
    portal.CanCollide = false
    portal.Material = Enum.Material.Neon
    portal.Color = Color3.fromRGB(100, 200, 255)
    portal.Name = "TeleportPortal"
    portal.Parent = workspace

    local swirl = Instance.new("ParticleEmitter", portal)
    swirl.Texture = "rbxassetid://296874871"
    swirl.Rate = 60
    swirl.Lifetime = NumberRange.new(0.6, 1)
    swirl.Speed = NumberRange.new(0.5, 1.2)
    swirl.Size = NumberSequence.new(1)
    swirl.Rotation = NumberRange.new(0, 360)
    swirl.Color = ColorSequence.new(Color3.fromRGB(90,180,255), Color3.fromRGB(255,255,255))
    swirl.LightEmission = 0.9

    -- 🌄 Function to build floating island
    local function buildSkyIsland()
        local folder = Instance.new("Folder")
        folder.Name = "ClientSkyIsland"
        folder.Parent = workspace

        -- Main platform
        local top = Instance.new("Part")
        top.Size = Vector3.new(300, 8, 300)
        top.Position = OFFSET + Vector3.new(0, 120, 0)
        top.Anchored = true
        top.Material = Enum.Material.Grass
        top.Color = Color3.fromRGB(80, 200, 120)
        top.TopSurface = Enum.SurfaceType.Smooth
        top.Name = "SkyIslandTop"
        top.Parent = folder

        -- Sloped edges
        for i = -1, 1 do
            for j = -1, 1 do
                local slope = Instance.new("WedgePart")
                slope.Size = Vector3.new(100, 20, 100)
                slope.Position = OFFSET + Vector3.new(i * 100, 110, j * 100)
                slope.Anchored = true
                slope.Material = Enum.Material.Ground
                slope.Color = Color3.fromRGB(101, 67, 33)
                slope.Name = "IslandSlope"
                slope.Orientation = Vector3.new(0, (i + j) * 45, 180)
                slope.Parent = folder
            end
        end

        -- Rounded corners
        for x = -140, 140, 280 do
            for z = -140, 140, 280 do
                local corner = Instance.new("Part")
                corner.Shape = Enum.PartType.Cylinder
                corner.Size = Vector3.new(20, 20, 20)
                corner.Position = OFFSET + Vector3.new(x, 110, z)
                corner.Anchored = true
                corner.Material = Enum.Material.Ground
                corner.Color = Color3.fromRGB(101, 67, 33)
                corner.Orientation = Vector3.new(0, 0, 90)
                corner.Parent = folder
            end
        end

        -- Tree
        local tree = Instance.new("Model", folder)
        tree.Name = "FantasyTree"

        local trunk = Instance.new("Part", tree)
        trunk.Size = Vector3.new(4, 25, 4)
        trunk.Position = OFFSET + Vector3.new(0, 132, 0)
        trunk.Anchored = true
        trunk.Material = Enum.Material.Wood
        trunk.Color = Color3.fromRGB(139, 69, 19)

        local leaves = Instance.new("Part", tree)
        leaves.Size = Vector3.new(20, 10, 20)
        leaves.Position = trunk.Position + Vector3.new(0, 15, 0)
        leaves.Anchored = true
        leaves.Material = Enum.Material.SmoothPlastic
        leaves.Color = Color3.fromRGB(60, 180, 75)
        leaves.Shape = Enum.PartType.Ball

        -- Cloud effect
        local cloudAnchor = Instance.new("Part")
        cloudAnchor.Size = Vector3.new(4, 1, 4)
        cloudAnchor.Position = OFFSET + Vector3.new(0, 150, 0)
        cloudAnchor.Anchored = true
        cloudAnchor.Transparency = 1
        cloudAnchor.Parent = folder

        local cloudEmitter = Instance.new("ParticleEmitter", cloudAnchor)
        cloudEmitter.Texture = "rbxassetid://258128463"
        cloudEmitter.Rate = 20
        cloudEmitter.Lifetime = NumberRange.new(6)
        cloudEmitter.Speed = NumberRange.new(1.2)
        cloudEmitter.Size = NumberSequence.new{ NumberSequenceKeypoint.new(0, 4), NumberSequenceKeypoint.new(1, 0) }
        cloudEmitter.Transparency = NumberSequence.new{ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) }
        cloudEmitter.LightEmission = 0.6
        cloudEmitter.Color = ColorSequence.new(Color3.fromRGB(220, 230, 255))

        -- 🔮 Floating return rune
        local rune = Instance.new("Part")
        rune.Size = Vector3.new(4, 1, 4)
        rune.Position = OFFSET + Vector3.new(0, 126, 0)
        rune.Anchored = true
        rune.Material = Enum.Material.Neon
        rune.Color = Color3.fromRGB(130, 0, 255)
        rune.Shape = Enum.PartType.Cylinder
        rune.Name = "ReturnRune"
        rune.Orientation = Vector3.new(90, 0, 0)
        rune.Parent = folder

        local glow = Instance.new("ParticleEmitter", rune)
        glow.Texture = "rbxassetid://296874871"
        glow.Rate = 30
        glow.Lifetime = NumberRange.new(1.5)
        glow.Speed = NumberRange.new(0.2, 0.6)
        glow.Size = NumberSequence.new{ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }
        glow.Color = ColorSequence.new(Color3.fromRGB(130,0,255), Color3.fromRGB(255,255,255))
        glow.LightEmission = 1

        -- Float animation
        local pulseTween = TweenService:Create(
            rune,
            TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            { Position = rune.Position + Vector3.new(0, 2, 0) }
        )
        pulseTween:Play()

        -- Teleport back to portal
        rune.Touched:Connect(function(hit)
            local char = hit.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum and root then
                local portalSpawn = workspace:FindFirstChild("TeleportPortal")
                if portalSpawn then
                    root.CFrame = portalSpawn.CFrame + Vector3.new(0, 4, 0)
                    notify("🔄 Returned to the portal gateway.")
                else
                    notify("⚠️ No portal found. You remain above the clouds.")
                end
            end
        end)
    end

    -- 🌀 Portal behavior
    portal.Touched:Connect(function(hit)
        local char = hit.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            buildSkyIsland()
            root.CFrame = CFrame.new(OFFSET + Vector3.new(0, 124, -100))

            -- 🔊 Music playback
            local theme = Instance.new("Sound")
            theme.SoundId = "rbxassetid://16322984843"
            theme.Volume = 1
            theme.Looped = true
            theme.Name = "SkyIslandTheme"
            theme.Parent = workspace
            theme:Play() 
    
end

-----------------------
-- Garden Tab (rounded/transparent style)
-----------------------
do
    local tf = tabFrames["Garden"]
    local function styledBtn(parent, x, y, w, text, col)
        local maxWidth = tf.AbsoluteSize.X - 40
        local width = math.min(w or 160, maxWidth)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, width, 0, 32)
        btn.Position = UDim2.new(0, x, 0, y)
        btn.BackgroundColor3 = col or Color3.fromRGB(70,100,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.Text = text
        btn.BackgroundTransparency = 0.2
        roundify(btn, 10)
        strokify(btn, 1, Color3.fromRGB(130,200,130), 0.39)
        btn.ClipsDescendants = true
        return btn
    end

    local dupBtn = styledBtn(tf, 14, 10, 170, "Duplicate Tools")
    dupBtn.MouseButton1Click:Connect(function()
        local backpack = player.Backpack
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local cloned = tool:Clone()
                cloned.Parent = backpack
            end
        end
        notify("Duplicated all tools in your backpack!")
    end)

    local box = Instance.new("TextBox", tf)
    box.Size = UDim2.new(0, 150, 0, 32)
    box.Position = UDim2.new(0, 14, 0, 52)
    box.BackgroundColor3 = Color3.fromRGB(60,80,110)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.PlaceholderText = "Username"
    box.Text = ""
    box.BackgroundTransparency = 0.24
    roundify(box, 10)
    strokify(box, 1, Color3.fromRGB(140,200,255), 0.33)

    local copyBtn = styledBtn(tf, 170, 52, 120, "Copy Tools", Color3.fromRGB(60,100,100))
    copyBtn.MouseButton1Click:Connect(function()
        local username = box.Text
        local targetPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #username) == username:lower() then
                targetPlayer = p
                break
            end
        end
        if not targetPlayer then
            notify("No player found: " .. username, Color3.fromRGB(120,60,60))
            return
        end
        local function copyTool(tool)
            local cloned = tool:Clone()
            cloned.Parent = player.Backpack
        end
        if targetPlayer.Character then
            for _, t in ipairs(targetPlayer.Character:GetChildren()) do
                if t:IsA("Tool") then
                    copyTool(t)
                end
            end
        end
        for _, t in ipairs(targetPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                copyTool(t)
            end
        end
        notify("Copied all tools from " .. targetPlayer.Name)
    end)
end

-- End of script (unless you want to add more) 
