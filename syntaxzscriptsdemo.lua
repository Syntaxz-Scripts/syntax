-- V1 Made by Syntaxz Scripts, Ui Loader by xHeptc

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Utility: ClonedService for executor compatibility
local function ClonedService(name)
    local Reference = (cloneref) or function(reference) return reference end
    return Reference(game:GetService(name))
end

-- Create a single window with four tabs: Credits, Forsaken, Universal, Grow a Garden
local Window = Library.CreateLib("Syntaxz Scripts DEMO", "DarkTheme")

-- Credits Tab (FIRST)
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Script by Syntaxz Scripts")
CreditsSection:NewLabel("ESP & UI: Syntaxz Scripts")
CreditsSection:NewLabel("UI Library: Kavo UI Library by xHeptc")
CreditsSection:NewLabel("Discord: no discord too lazy to setup")

-- Forsaken Tab (SECOND)
local ForsakenTab = Window:NewTab("Forsaken")
local ForsakenSection = ForsakenTab:NewSection("Fun")

-- UNIVERSAL & GARDEN TABS (as before)
local UniversalTab = Window:NewTab("Universal")
local UniversalSection = UniversalTab:NewSection("Universal Features")

local GardenTab = Window:NewTab("Grow a Garden")
local GardenSection = GardenTab:NewSection("Garden Tools")

GardenSection:NewButton("Duplicate Tools", "Duplicates all tools in your backpack", function()
    local player = ClonedService("Players").LocalPlayer
    local backpack = player.Backpack

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local cloned = tool:Clone()
            cloned.Parent = backpack
        end
    end

    Library:Notify("Duplicated all tools in your backpack!")
end)

GardenSection:NewTextBox("Copy Tools (ctools)", "Type a username and click to copy their tools!", function(username)
    local Players = ClonedService("Players")
    local LocalPlayer = Players.LocalPlayer
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #username) == username:lower() then
            targetPlayer = p
            break
        end
    end

    if not targetPlayer then
        Library:Notify("No player found with the username: " .. username)
        return
    end

    local function copyTool(tool)
        local cloned = tool:Clone()
        cloned.Parent = LocalPlayer.Backpack
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

    Library:Notify("Copied all tools from " .. targetPlayer.Name)
end)

-- ESP Script Logic
local highlighted = {}
local espConnection
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
    for obj, _ in pairs(highlighted) do
        local part = obj:FindFirstChildWhichIsA("BasePart")
        if part then
            local gui = part:FindFirstChild(ESP_LABEL_NAME)
            if gui then gui:Destroy() end
        end
        highlighted[obj] = nil
    end
end

local function EnableESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        handle(obj)
    end
    espConnection = workspace.DescendantAdded:Connect(handle)
end

local function DisableESP()
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    clearESP()
end

ForsakenSection:NewToggle("Player ESP", "Toggles ESP", function(state)
    if state then
        EnableESP()
    else
        DisableESP()
    end
end)

-- Infinite Stamina Logic
local ReplicatedStorage = ClonedService("ReplicatedStorage")
local Sprinting = ReplicatedStorage:FindFirstChild("Systems")
    and ReplicatedStorage.Systems:FindFirstChild("Character")
    and ReplicatedStorage.Systems.Character:FindFirstChild("Game")
    and ReplicatedStorage.Systems.Character.Game:FindFirstChild("Sprinting")
local m = Sprinting and require(Sprinting)
local infiniteStaminaEnabled = false

local function monitorStamina()
    while true do
        while infiniteStaminaEnabled and m do
            if m.Stamina <= 5 then
                m.Stamina = 20
            end
            task.wait(0.1)
        end
        task.wait(0.5)
    end
end

task.spawn(monitorStamina)

ForsakenSection:NewToggle("Infinite Stamina", "Toggle Infinite Stamina", function(state)
    infiniteStaminaEnabled = state
end)

-- Fullbright Logic (toggleable)
local Lighting = game:GetService("Lighting")
local originalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd
}

local fullbrightEnabled = false

local function enableFullbright()
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 5
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.FogEnd = 100000
    fullbrightEnabled = true
end

local function disableFullbright()
    for property, value in pairs(originalLighting) do
        Lighting[property] = value
    end
    fullbrightEnabled = false
end

UniversalSection:NewToggle("Fullbright", "Toggle Fullbright", function(state)
    if state then
        enableFullbright()
    else
        disableFullbright()
    end
end)

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if fullbrightEnabled and Lighting.Ambient ~= Color3.new(1,1,1) then
        enableFullbright()
    end
end)

-- Universal Game Prober (Remote Security Probe)
UniversalSection:NewButton("Probe Remotes (Security Test)", "Scan for remotes and test for flaws. Use on your own game!", function()
    local sg = Instance.new("ScreenGui")
    sg.Name = "ProbeResultsPopup"
    sg.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    local frame = Instance.new("Frame", sg)
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
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy()
    end)

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
    logLine("Check for: remotes that change stats/items, unexpected effects, or errors.", Color3.fromRGB(255,255,150))
end)

-- Anti-Cheat Detector/Bypass Logic (in Universal Tab)
local acDetectorEnabled = false
local acBypassConnections = {}
local mt, oldNamecall, hookSet = nil, nil, false

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
            return -- Block the call
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
    local player = game:GetService("Players").LocalPlayer
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

local function unblockKickFunction()
    -- Can't truly restore, recommend rejoining to reset if needed
end

local function enableACDetectorBypass()
    local scripts = scanForAntiCheat()
    local remotes = scanForSuspiciousRemotes()
    if #scripts == 0 and #remotes == 0 then
        Library:Notify("No obvious anti-cheat found.")
    else
        Library:Notify("Anti-cheat scripts: " .. (#scripts > 0 and "\n" .. table.concat(scripts, "\n") or "none") ..
            "\nRemotes: " .. (#remotes > 0 and "\n" .. table.concat(remotes, "\n") or "none"))
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
    Library:Notify("Anti-cheat bypass disabled. (Some protections may require rejoin to fully reset.)")
end

UniversalSection:NewToggle("Anti-Cheat Detector/Bypass", "Detects and disables basic anti-cheats, blocks suspicious remotes and client kicks. Use if game bans/kicks for no reason.", function(state)
    if state then
        enableACDetectorBypass()
    else
        disableACDetectorBypass()
    end
end)

-- EMOTE MENU FOR FORSAKEN TAB --
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = ClonedService("ReplicatedStorage")
local Players = ClonedService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

local assetsFolder = ReplicatedStorage:FindFirstChild("Assets")
local emotesFolder = assetsFolder and assetsFolder:FindFirstChild("Emotes")

local emotes = {}
if emotesFolder then
    for _, module in pairs(emotesFolder:GetChildren()) do
        if module:IsA("ModuleScript") then
            local success, emoteData = pcall(require, module)
            if success and typeof(emoteData) == "table" and typeof(emoteData.AssetID) == "string" then
                emotes[module.Name] = emoteData
            end
        end
    end
end

local emoteButtons = {}
local menuOpen = false
local charConn

local currentAnimation = nil
local currentSound = nil
local currentClones = {}

local function playEmote(emoteName, data)
    if not humanoid then return end
    if currentAnimation then
        currentAnimation:Stop()
        currentAnimation = nil
    end
    if currentSound then
        currentSound:Stop()
        currentSound = nil
    end
    for _, entry in pairs(currentClones) do
        if entry.connection then entry.connection:Disconnect() end
        if entry.clone then entry.clone:Destroy() end
    end
    currentClones = {}

    local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
    if animator then
        local animation = Instance.new("Animation")
        animation.AnimationId = data.AssetID
        currentAnimation = animator:LoadAnimation(animation)
        currentAnimation:Play()
    end
    if data.SFX then
        currentSound = Instance.new("Sound")
        currentSound.SoundId = data.SFX
        currentSound.Parent = character
        currentSound.Looped = data.SFXProperties and data.SFXProperties.Looped or false
        currentSound.Volume = 2
        currentSound:Play()
        currentSound.Ended:Connect(function()
            currentSound:Destroy()
        end)
    end
    if emoteName == "Locked" and data.LockedEffect then
        local lockedClone = data.LockedEffect:Clone()
        lockedClone.Parent = character:FindFirstChild("HumanoidRootPart")
        for _, part in ipairs(lockedClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = true
            end
        end
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                if lockedClone.PrimaryPart then
                    lockedClone:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame)
                else
                    for _, part in ipairs(lockedClone:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CFrame = character.HumanoidRootPart.CFrame
                        end
                    end
                end
            else
                connection:Disconnect()
            end
        end)
        table.insert(currentClones, {clone = lockedClone, connection = connection})
    end
    if emoteName == "MissTheQuiet" and data.EmoteLighting then
        local lightingPart = data.EmoteLighting:FindFirstChild("lighting")
        if lightingPart then
            local cloneLighting = lightingPart:Clone()
            cloneLighting.Parent = character:FindFirstChild("HumanoidRootPart")
            cloneLighting.CanCollide = false
            cloneLighting.Transparency = 1
            cloneLighting.Anchored = true
            cloneLighting.Position = character.HumanoidRootPart.Position
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    cloneLighting.CFrame = character.HumanoidRootPart.CFrame
                else
                    connection:Disconnect()
                end
            end)
            table.insert(currentClones, {clone = cloneLighting, connection = connection})
        end
    end
    if emoteName == "HakariDance" and data.HakariBeamEffect then
        local cloneBeam = data.HakariBeamEffect:Clone()
        cloneBeam.Parent = character:FindFirstChild("HumanoidRootPart")
        cloneBeam.CanCollide = false
        cloneBeam.Transparency = 0
        cloneBeam.Anchored = true
        cloneBeam.Position = character.HumanoidRootPart.Position
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                cloneBeam.CFrame = character.HumanoidRootPart.CFrame
            else
                connection:Disconnect()
            e
