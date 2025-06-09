-- Kavo UI Loader
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Create a single window with three tabs: Credits, Forsaken, and Universal
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

UniversalSection:NewLabel("TEST")

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

-- ESP Toggle
ForsakenSection:NewToggle("Player ESP", "Toggles ESP", function(state)
    if state then
        EnableESP()
    else
        DisableESP()
    end
end)

-- Infinite Stamina Logic
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Sprinting = ReplicatedStorage.Systems.Character.Game.Sprinting
local m = require(Sprinting)

local infiniteStaminaEnabled = false

local function monitorStamina()
    while true do
        while infiniteStaminaEnabled do
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

-- Move Fullbright Toggle to Universal Tab
UniversalSection:NewToggle("Fullbright", "Toggle Fullbright", function(state)
    if state then
        enableFullbright()
    else
        disableFullbright()
    end
end)

-- Optional: Auto-reapply fullbright if Lighting changes (anti-detection/anti-interference)
Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
    if fullbrightEnabled and Lighting.Ambient ~= Color3.new(1,1,1) then
        enableFullbright()
    end
end)
