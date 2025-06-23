-- Syntaxz Scripts (Mercury UI Version)

local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/main/src.lua"))()

local UI = Mercury:CreateWindow({
    Title = "Syntaxz Scripts DEMO",
    Size = UDim2.fromOffset(400, 350)
})

-- Credits Tab
local Credits = UI:CreateTab({
    Name = "Credits",
    Icon = "rbxassetid://8569322835"
})
Credits:CreateTextbox({
    Name = "Credits",
    PlaceholderText = "Credits",
    Callback = function() end,
    Text = "ESP & UI: Syntaxz Scripts\nUI: Mercury UI\nDiscord: no discord too lazy to setup"
})

-- Forsaken Tab
local Forsaken = UI:CreateTab({
    Name = "Forsaken",
    Icon = "rbxassetid://8569322835"
})

-- Universal Tab
local Universal = UI:CreateTab({
    Name = "Universal",
    Icon = "rbxassetid://8569322835"
})

-- Grow a Garden Tab
local Garden = UI:CreateTab({
    Name = "Grow a Garden",
    Icon = "rbxassetid://8569322835"
})

Garden:CreateButton({
    Name = "Duplicate Tools",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local backpack = player.Backpack
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local cloned = tool:Clone()
                cloned.Parent = backpack
            end
        end
        Mercury:Notification({
            Title = "Garden",
            Text = "Duplicated all tools in your backpack!",
            Duration = 3
        })
    end
})

Garden:CreateTextbox({
    Name = "Copy Tools (ctools)",
    PlaceholderText = "Enter username",
    Callback = function(username)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local targetPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #username) == username:lower() then
                targetPlayer = p
                break
            end
        end

        if not targetPlayer then
            Mercury:Notification({Title = "Garden", Text = "No player found with the username: " .. username, Duration = 4})
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

        Mercury:Notification({Title = "Garden", Text = "Copied all tools from " .. targetPlayer.Name, Duration = 3})
    end
})

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

Forsaken:CreateToggle({
    Name = "Player ESP",
    StartingState = false,
    Callback = function(state)
        if state then
            EnableESP()
        else
            DisableESP()
        end
    end
})

-- Infinite Stamina Logic
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

Forsaken:CreateToggle({
    Name = "Infinite Stamina",
    StartingState = false,
    Callback = function(state)
        infiniteStaminaEnabled = state
    end
})

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

Universal:CreateToggle({
    Name = "Fullbright",
    StartingState = false,
    Callback = function(state)
        if state then
            enableFullbright()
        else
            disableFullbright()
        end
    end
})

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if fullbrightEnabled and Lighting.Ambient ~= Color3.new(1,1,1) then
        enableFullbright()
    end
end)

-- Universal Game Prober (Remote Security Probe)
Universal:CreateButton({
    Name = "Probe Remotes (Security Test)",
    Callback = function()
        local MercuryPopup = Instance.new("ScreenGui")
        MercuryPopup.Name = "ProbeResultsPopup"
        MercuryPopup.Parent = game:GetService("Players").LocalPlayer.PlayerGui
        local frame = Instance.new("Frame", MercuryPopup)
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
            MercuryPopup:Destroy()
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
    end
})

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
    Mercury:Prompt({
        Title = "Anti-Cheat Detector",
        Text = (#scripts == 0 and #remotes == 0) and "No obvious anti-cheat found." or
            ("Anti-cheat scripts: " .. (#scripts > 0 and "\n" .. table.concat(scripts, "\n") or "none") ..
            "\nRemotes: " .. (#remotes > 0 and "\n" .. table.concat(remotes, "\n") or "none")),
        Buttons = {"OK"}
    })
    disableAntiCheatScripts()
    hookRemotes()
    blockKickFunction()
    acDetectorEnabled = true
end

local function disableACDetectorBypass()
    unhookRemotes()
    unblockKickFunction()
    acDetectorEnabled = false
    Mercury:Notification({Title = "Anti-Cheat", Text = "Anti-cheat bypass disabled. (Some protections may require rejoin to fully reset.)", Duration = 4})
end

Universal:CreateToggle({
    Name = "Anti-Cheat Detector/Bypass",
    StartingState = false,
    Callback = function(state)
        if state then
            enableACDetectorBypass()
        else
            disableACDetectorBypass()
        end
    end
})
