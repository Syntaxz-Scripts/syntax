-- Ui Loader by xHeptc with Advanced Anti-Cheat Detector/Bypass by Syntaxz Scripts

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
CreditsSection:NewLabel("Discord: no discord too lazy to setup") -- Change to your Discord if you want

-- Forsaken Tab (SECOND)
local ForsakenTab = Window:NewTab("Forsaken")
local ForsakenSection = ForsakenTab:NewSection("Fun")

-- Universal Tab (THIRD)
local UniversalTab = Window:NewTab("Universal")
local UniversalSection = UniversalTab:NewSection("Universal Features")

-- Grow a Garden Tab (FOURTH)
local GardenTab = Window:NewTab("Grow a Garden")
local GardenSection = GardenTab:NewSection("Garden Tools")

GardenSection:NewButton("Duplicate Tools", "Duplicates all tools in your backpack", function()
    local player = ClonedService("Players").LocalPlayer
    local backpack = player.Backpack

    -- Duplicate each tool in the backpack
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

    -- Copy tools from character
    if targetPlayer.Character then
        for _, t in ipairs(targetPlayer.Character:GetChildren()) do
            if t:IsA("Tool") then
                copyTool(t)
            end
        end
    end

    -- Copy tools from backpack
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

-- Anti-Cheat Detector/Bypass Logic
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
            local oldKick = player.Kick
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
    -- Scan & notify
    local scripts = scanForAntiCheat()
    local remotes = scanForSuspiciousRemotes()
    if #scripts == 0 and #remotes == 0 then
        Library:Notify("No obvious anti-cheat found.")
    else
        Library:Notify("Anti-cheat scripts: " .. (#scripts > 0 and "\n" .. table.concat(scripts, "\n") or "none") ..
            "\nRemotes: " .. (#remotes > 0 and "\n" .. table.concat(remotes, "\n") or "none"))
    end
    -- Disable suspicious scripts
    disableAntiCheatScripts()
    -- Block suspicious remotes
    hookRemotes()
    -- Prevent .Kick()
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

-- END SCRIPT
