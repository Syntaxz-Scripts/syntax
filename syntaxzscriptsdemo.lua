-- ILY COPILOT <3
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Syntaxz Scripts DEMO", "DarkTheme")

-- Make UI draggable
local function makeDraggable(frame)
    local UIS = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Wait for Kavo's GUI to load and find the frame
task.spawn(function()
    local mainFrame
    repeat
        for _,v in pairs(game.CoreGui:GetDescendants()) do
            if v:IsA("Frame") and v.Name == "Main" and v.Parent and v.Parent.Name == "KavoUI" then
                mainFrame = v
                break
            end
        end
        task.wait(0.1)
    until mainFrame
    makeDraggable(mainFrame)
end)

-- Credits Tab (FIRST)
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Script by Syntaxz Scripts")
CreditsSection:NewLabel("ESP & UI: Syntaxz Scripts")
CreditsSection:NewLabel("UI Library: Kavo UI Library by xHeptc")
CreditsSection:NewLabel("Discord: discord.gg/yourserver") -- Change to your Discord if you want

-- Main Tab (SECOND)
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Fun")

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
MainSection:NewToggle("Player ESP", "Toggles ESP", function(state)
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

MainSection:NewToggle("Infinite Stamina", "Toggle Infinite Stamina", function(state)
    infiniteStaminaEnabled = state
end)
