-- Kavo UI Loader
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Create the window and tab
local Window = Library.CreateLib("Syntaxz Scripts DEMO", "DarkTheme")
local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Fun")

-- ESP Script Logic
local RunService = game:GetService("RunService")
local highlighted = {}
local espConnection

local function highlight(part, text, color)
    if not part:FindFirstChildOfClass("BillboardGui") then
        local gui = Instance.new("BillboardGui")
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
            for _, v in ipairs(part:GetChildren()) do
                if v:IsA("BillboardGui") then
                    v:Destroy()
                end
            end
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

-- Kavo Toggle for ESP
Section:NewToggle("Player ESP", "Toggles ESP", function(state)
    if state then
        EnableESP()
    else
        DisableESP()
    end
end)
-- Infinite Stamina Toggle Script using Kavo UI (Single Tab/Section)

--// Dependencies
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Sprinting = ReplicatedStorage.Systems.Character.Game.Sprinting
local m = require(Sprinting)

--// Kavo UI Setup (assume Kavo UI is already loaded)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("My Script Hub", "Midnight") -- You can rename this

local MainTab = Window:NewTab("Main") -- Only one tab is created
local MainSection = MainTab:NewSection("Stamina") -- Only one section

--// Toggle State
local infiniteStaminaEnabled = false
m.Stamina = 100

--// Stamina Monitor Function
local function monitorStamina()
    while true do
        if infiniteStaminaEnabled then
            if m.Stamina <= 5 then
                m.Stamina = 20
            end
        end
        task.wait(0.1)
    end
end

--// Spawn the monitor in its own thread
task.spawn(monitorStamina)

--// UI Toggle
MainSection:NewToggle("Infinite Stamina", "Toggle Infinite Stamina", function(state)
    infiniteStaminaEnabled = state
end)    
