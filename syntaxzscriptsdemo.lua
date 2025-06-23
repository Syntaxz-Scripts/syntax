-- Syntaxz Scripts All Features Custom GUI

-- Setup
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SyntaxzScriptsUI"
gui.Parent = player:FindFirstChildOfClass("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 440, 0, 380)
frame.Position = UDim2.new(0.5, -220, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "Syntaxz Scripts"
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(200, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28

-- TABS
local tabNames = {"Credits", "Forsaken", "Universal", "Garden"}
local tabButtons, tabFrames = {}, {}

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 100, 0, 28)
    btn.Position = UDim2.new(0, 10 + (idx-1)*110, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = name
    return btn
end

local function createTabFrame()
    local tf = Instance.new("Frame", frame)
    tf.Size = UDim2.new(1, -20, 1, -82)
    tf.Position = UDim2.new(0, 10, 0, 74)
    tf.BackgroundTransparency = 1
    tf.Visible = false
    return tf
end

for i, name in ipairs(tabNames) do
    tabButtons[name] = createTabButton(name, i)
    tabFrames[name] = createTabFrame()
end

local function showTab(tab)
    for _, name in ipairs(tabNames) do
        tabFrames[name].Visible = (name == tab)
        tabButtons[name].BackgroundColor3 = name == tab and Color3.fromRGB(80, 110, 140) or Color3.fromRGB(60, 60, 80)
    end
end
for _, name in ipairs(tabNames) do
    tabButtons[name].MouseButton1Click:Connect(function() showTab(name) end)
end
showTab("Credits")

-- Notification label
local notif = Instance.new("TextLabel", frame)
notif.BackgroundTransparency = 0.3
notif.BackgroundColor3 = Color3.fromRGB(45, 100, 60)
notif.Size = UDim2.new(1, -40, 0, 26)
notif.Position = UDim2.new(0, 20, 1, -34)
notif.Visible = false
notif.TextColor3 = Color3.fromRGB(250, 255, 250)
notif.Font = Enum.Font.GothamBold
notif.TextSize = 15

local function notify(msg, col)
    notif.Text = msg
    notif.BackgroundColor3 = col or Color3.fromRGB(45, 100, 60)
    notif.Visible = true
    delay(2, function() notif.Visible = false end)
end

-----------------------
-- Credits Tab
-----------------------
do
    local tf = tabFrames["Credits"]
    local function label(txt, ypos)
        local l = Instance.new("TextLabel", tf)
        l.Size = UDim2.new(1, -20, 0, 28)
        l.Position = UDim2.new(0, 10, 0, ypos)
        l.BackgroundTransparency = 1
        l.TextColor3 = Color3.fromRGB(230, 230, 200)
        l.Font = Enum.Font.Gotham
        l.TextSize = 18
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = txt
        return l
    end
    label("ESP & UI: Syntaxz Scripts", 10)
    label("UI: Custom Roblox GUI", 38)
    label("Discord: no discord too lazy to setup", 66)
end

-----------------------
-- Forsaken Tab
-----------------------
local forsakenVars = {
    esp = false,
    stamina = false
}
do
    local tf = tabFrames["Forsaken"]

    -- ESP
    local espBtn = Instance.new("TextButton", tf)
    espBtn.Size = UDim2.new(0, 170, 0, 32)
    espBtn.Position = UDim2.new(0, 10, 0, 10)
    espBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 90)
    espBtn.TextColor3 = Color3.fromRGB(255,255,255)
    espBtn.Font = Enum.Font.Gotham
    espBtn.TextSize = 16
    espBtn.Text = "Player ESP: OFF"

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
    local staminaBtn = Instance.new("TextButton", tf)
    staminaBtn.Size = UDim2.new(0, 170, 0, 32)
    staminaBtn.Position = UDim2.new(0, 10, 0, 52)
    staminaBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 60)
    staminaBtn.TextColor3 = Color3.fromRGB(255,255,255)
    staminaBtn.Font = Enum.Font.Gotham
    staminaBtn.TextSize = 16
    staminaBtn.Text = "Infinite Stamina: OFF"

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
local universalVars = {fullbright = false, acBypass = false}
do
    local tf = tabFrames["Universal"]
    -- Fullbright
    local fbBtn = Instance.new("TextButton", tf)
    fbBtn.Size = UDim2.new(0, 170, 0, 32)
    fbBtn.Position = UDim2.new(0, 10, 0, 10)
    fbBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
    fbBtn.TextColor3 = Color3.fromRGB(255,255,255)
    fbBtn.Font = Enum.Font.Gotham
    fbBtn.TextSize = 16
    fbBtn.Text = "Fullbright: OFF"
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

    -- Anti-Cheat Detector/Bypass
    local acBtn = Instance.new("TextButton", tf)
    acBtn.Size = UDim2.new(0, 220, 0, 32)
    acBtn.Position = UDim2.new(0, 200, 0, 10)
    acBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
    acBtn.TextColor3 = Color3.fromRGB(255,255,255)
    acBtn.Font = Enum.Font.Gotham
    acBtn.TextSize = 16
    acBtn.Text = "Anti-Cheat Detector/Bypass: OFF"
    local acDetectorEnabled, mt, oldNamecall, hookSet = false, nil, nil, false
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
            if (obj:IsA("LocalScript") or obj:IsA("Script")) and obj.Name:lower():find("anticheat") then
                obj.Disabled = true
            end
        end
    end
    local function hookRemotes()
        if hookSet then return end
        mt = getrawmetatable(game)
        oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (self.Name:lower():find("kick") or self.Name:lower():find("ban") or self.Name:lower():find("cheat")) and (method == "FireServer" or method == "InvokeServer") then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
        hookSet = true
    end
    local function unhookRemotes()
        if not hookSet or not mt or not oldNamecall then return end
        setreadonly(mt, false)
        mt.__namecall = oldNamecall
        setreadonly(mt, true)
        hookSet = false
    end
    local function blockKickFunction()
        if not player then return end
        if hookfunction then
            if not player.__kickHooked then
                hookfunction(player.Kick, function() return end)
                player.__kickHooked = true
            end
        else
            player.Kick = function() return end
        end
    end
    local function unblockKickFunction() end
    local function enableACDetectorBypass()
        local scripts = scanForAntiCheat()
        local remotes = scanForSuspiciousRemotes()
        if #scripts == 0 and #remotes == 0 then
            notify("No obvious anti-cheat found.", Color3.fromRGB(60,120,60))
        else
            notify("Anti-cheat scripts/remotes found!", Color3.fromRGB(150,100,50))
        end
        disableAntiCheatScripts()
        hookRemotes()
        blockKickFunction()
        acDetectorEnabled = true
    end
    local function disableACDetectorBypass()
        unhookRemotes()
        unblockKickFunction()
        acDetectorEnabled = false
        notify("Anti-cheat bypass disabled.", Color3.fromRGB(120,60,60))
    end
    acBtn.MouseButton1Click:Connect(function()
        acDetectorEnabled = not acDetectorEnabled
        acBtn.Text = "Anti-Cheat Detector/Bypass: " .. (acDetectorEnabled and "ON" or "OFF")
        if acDetectorEnabled then enableACDetectorBypass() else disableACDetectorBypass() end
    end)

    -- Probe Remotes Button
    local probeBtn = Instance.new("TextButton", tf)
    probeBtn.Size = UDim2.new(0, 220, 0, 32)
    probeBtn.Position = UDim2.new(0, 200, 0, 52)
    probeBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 120)
    probeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    probeBtn.Font = Enum.Font.Gotham
    probeBtn.TextSize = 16
    probeBtn.Text = "Probe Remotes (Security Test)"
    probeBtn.MouseButton1Click:Connect(function()
        local popup = Instance.new("ScreenGui")
        popup.Name = "ProbeResultsPopup"
        popup.Parent = player.PlayerGui
        local frame = Instance.new("Frame", popup)
        frame.Size = UDim2.new(0, 520, 0, 380)
        frame.Position = UDim2.new(0.5, -260, 0.5, -190)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.Draggable = true

        local closeBtn = Instance.new("TextButton", frame)
        closeBtn.Size = UDim2.new(0, 80, 0, 34)
        closeBtn.Position = UDim2.new(1, -90, 0, 10)
        closeBtn.Text = "Close"
        closeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.TextSize = 18
        closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)

        local title = Instance.new("TextLabel", frame)
        title.Size = UDim2.new(1, -20, 0, 34)
        title.Position = UDim2.new(0, 10, 0, 10)
        title.Text = "Probe Remotes Results"
        title.Font = Enum.Font.GothamBold
        title.TextColor3 = Color3.fromRGB(200,255,200)
        title.BackgroundTransparency = 1
        title.TextSize = 24
        title.TextXAlignment = Enum.TextXAlignment.Left

        local scroll = Instance.new("ScrollingFrame", frame)
        scroll.Size = UDim2.new(1, -20, 1, -64)
        scroll.Position = UDim2.new(0, 10, 0, 54)
        scroll.BackgroundColor3 = Color3.fromRGB(20,20,20)
        scroll.BorderSizePixel = 0
        scroll.CanvasSize = UDim2.new(0,0,0,2000)
        scroll.ScrollBarThickness = 8

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

        logLine("== Remote Security Probe ==", Color3.fromRGB(200,255,200))
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local path = getFullPath(obj)
                logLine("[RemoteEvent] "..path, Color3.fromRGB(255,200,100))
                local ok, err = pcall(function()
                    obj:FireServer("probe", 123, true)
                end)
                if ok then
                    logLine("  Fired with test args.", Color3.fromRGB(150,255,100))
                else
                    logLine("  ERROR: "..tostring(err), Color3.fromRGB(255,100,100))
                end
            elseif obj:IsA("RemoteFunction") then
                local path = getFullPath(obj)
                logLine("[RemoteFunction] "..path, Color3.fromRGB(100,200,255))
                local ok, ret = pcall(function()
                    return obj:InvokeServer("probe", 42, false)
                end)
                if ok then
                    logLine("  Invoked, returned: "..tostring(ret), Color3.fromRGB(150,255,200))
                else
                    logLine("  ERROR: "..tostring(ret), Color3.fromRGB(255,100,100))
                end
            end
        end
        logLine("== Probe Complete ==", Color3.fromRGB(200,255,200))
        logLine("Check for remotes that change stats/items, unexpected effects, or errors.", Color3.fromRGB(255,255,150))
    end)
end

-----------------------
-- Garden Tab
-----------------------
do
    local tf = tabFrames["Garden"]
    -- Duplicate Tools
    local dupBtn = Instance.new("TextButton", tf)
    dupBtn.Size = UDim2.new(0, 170, 0, 32)
    dupBtn.Position = UDim2.new(0, 10, 0, 10)
    dupBtn.BackgroundColor3 = Color3.fromRGB(70,100,70)
    dupBtn.TextColor3 = Color3.fromRGB(255,255,255)
    dupBtn.Font = Enum.Font.Gotham
    dupBtn.TextSize = 16
    dupBtn.Text = "Duplicate Tools"

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

    -- Copy Tools from user
    local box = Instance.new("TextBox", tf)
    box.Size = UDim2.new(0, 150, 0, 32)
    box.Position = UDim2.new(0, 10, 0, 52)
    box.BackgroundColor3 = Color3.fromRGB(60,80,110)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.PlaceholderText = "Username"
    box.Text = ""

    local copyBtn = Instance.new("TextButton", tf)
    copyBtn.Size = UDim2.new(0, 120, 0, 32)
    copyBtn.Position = UDim2.new(0, 170, 0, 52)
    copyBtn.BackgroundColor3 = Color3.fromRGB(60,100,100)
    copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    copyBtn.Font = Enum.Font.Gotham
    copyBtn.TextSize = 16
    copyBtn.Text = "Copy Tools"

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

-- Close Button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 100, 0, 28)
closeBtn.Position = UDim2.new(1, -110, 1, -38)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "Close"
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
