-- Syntaxz Scripts V4.1

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local guiName = "SyntaxzScriptsUI"
local function getOrCreateGui()
    local gui = player.PlayerGui:FindFirstChild(guiName)
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = guiName
        gui.ResetOnSpawn = false
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

-- Lightning Aura for skip time startup
local function lightningAura(center, radius, duration)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local NUM_BOLTS = 10
    local COLOR = ColorSequence.new(Color3.fromRGB(180, 230, 255), Color3.fromRGB(180, 230, 255))
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

local universalVars = {fullbright = false, acBypass = false, infHealth = false}
-- Jitter state
local jitterVars = {enabled = false, connection = nil, origPos = nil, jitterTime = 0}

do
    local tf = tabFrames["Universal"]

    -----------------------------------------------------------------------------
    -- Forward Lightning Burst for Skip Time effect
    -----------------------------------------------------------------------------
    local function summonForwardLightningBurst(skipDistance)
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local center = hrp.Position
        local forward = hrp.CFrame.LookVector
        local up = hrp.CFrame.UpVector
        local right = hrp.CFrame.RightVector
        local NUM_BOLTS = 20
        local LIGHTNING_COLOR = ColorSequence.new(Color3.fromRGB(180, 230, 255), Color3.fromRGB(40, 80, 255))
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

    -----------------------------------------------------------------------------
    -- Time skip button (TpWalk external GUI button)
    -----------------------------------------------------------------------------
    local externalBtn = nil
    local SKIP_DISTANCE = 200 * 0.1
    local SKIP_SPEED = 200
    local SKIP_DURATION = 0.1

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
        btn.Draggable = true

        btn.MouseButton1Click:Connect(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not (char and hrp and hum) then
                notify("Character not found!", Color3.fromRGB(200,50,50))
                return
            end
            -- Startup VFX
            lightningAura(hrp.Position, 6, 0.13)
            notify("Charging...", Color3.fromRGB(180,230,255))
            task.delay(0.1, function()
                -- Move forward for skip duration
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

    local makeBtn = Instance.new("TextButton", tf)
    makeBtn.Size = UDim2.new(0, 220, 0, 32)
    makeBtn.Position = UDim2.new(0, 200, 0, 94)
    makeBtn.BackgroundColor3 = Color3.fromRGB(65, 140, 180)
    makeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    makeBtn.Font = Enum.Font.GothamBold
    makeBtn.TextSize = 16
    makeBtn.Text = "Skip Time"

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

    -----------------------------------------------------------------------------
    -- Vibrate/Jitter Character
    -----------------------------------------------------------------------------
    local jitterBtn = Instance.new("TextButton", tf)
    jitterBtn.Size = UDim2.new(0, 220, 0, 32)
    jitterBtn.Position = UDim2.new(0, 200, 0, 136)
    jitterBtn.BackgroundColor3 = Color3.fromRGB(130, 120, 220)
    jitterBtn.TextColor3 = Color3.fromRGB(255,255,255)
    jitterBtn.Font = Enum.Font.GothamBold
    jitterBtn.TextSize = 16
    jitterBtn.Text = "Vibrate (Jitter) Character: OFF"

    -- Jitter settings
    local JITTER_DISTANCE = 0.35-- studs
    local JITTER_SPEED = 5e9 -- higher = faster
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
            -- Remove last frame's jitter offset to get the real base position
            local basePos = hrp.Position - hrp.CFrame.RightVector * lastJitterOffset
            -- Apply new offset and keep facing forward
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

    -- Anti-Cheat Detector/Bypass (Safe)
    local acBtn = Instance.new("TextButton", tf)
    acBtn.Size = UDim2.new(0, 220, 0, 32)
    acBtn.Position = UDim2.new(0, 200, 0, 10)
    acBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
    acBtn.TextColor3 = Color3.fromRGB(255,255,255)
    acBtn.Font = Enum.Font.Gotham
    acBtn.TextSize = 16
    acBtn.Text = "Anti-Cheat Detector/Bypass: OFF"

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

    -- SAFER: Just disables LocalScripts named "anticheat"
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

    -- Fire all remote events
    local probeBtn = Instance.new("TextButton", tf)
    probeBtn.Size = UDim2.new(0, 220, 0, 32)
    probeBtn.Position = UDim2.new(0, 200, 0, 52)
    probeBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 120)
    probeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    probeBtn.Font = Enum.Font.Gotham
    probeBtn.TextSize = 16
    probeBtn.Text = "Fire all Remotes"
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

    -- Infinite Health Button & Logic
    local infHealthBtn = Instance.new("TextButton", tf)
    infHealthBtn.Size = UDim2.new(0, 170, 0, 32)
    infHealthBtn.Position = UDim2.new(0, 10, 0, 52)
    infHealthBtn.BackgroundColor3 = Color3.fromRGB(90, 60, 90)
    infHealthBtn.TextColor3 = Color3.fromRGB(255,255,255)
    infHealthBtn.Font = Enum.Font.Gotham
    infHealthBtn.TextSize = 16
    infHealthBtn.Text = "Infinite Health: OFF"

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
end 
-----------------------
-- Grow a Garden Tab
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
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

-- ==========================
-- TOGGLE KEYBIND (RightShift)
-- ==========================
local toggling = false
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed and not toggling then
        toggling = true
        gui.Enabled = not gui.Enabled
        wait(0.2)
        toggling = false
    end
end)

-- ==========================
-- Make GUI re-appear on respawn!
-- ==========================
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

-- Add a floating toggle button for the main UI
local toggleBtnGui = Instance.new("ScreenGui")
toggleBtnGui.Name = "SyntaxzToggleBtnGui"
toggleBtnGui.ResetOnSpawn = false
toggleBtnGui.Parent = player.PlayerGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "UIToggleButton"
toggleBtn.Size = UDim2.new(0, 54, 0, 54)
toggleBtn.Position = UDim2.new(0, 12, 1, -66)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 120)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 24
toggleBtn.Text = "☰"
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = toggleBtnGui

toggleBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)
