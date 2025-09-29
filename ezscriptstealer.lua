local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FTaP_Utility"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local tabBar = Instance.new("Frame", frame)
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)

local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.BackgroundTransparency = 1

local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton", tabBar)
    tabBtn.Size = UDim2.new(0, 120, 1, 0)
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14

    local tabFrame = Instance.new("Frame", contentFrame)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false

    local layout = Instance.new("UIListLayout", tabFrame)
    layout.Padding = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.Frame.Visible = false
        end
        tabFrame.Visible = true
    end)

    table.insert(tabs, {Button = tabBtn, Frame = tabFrame})
    return tabFrame
end

local MainTab = createTab("Main")
local MovementTab = createTab("Movement")
local ExtrasTab = createTab("Extras")

local function createButton(tab, name, callback)
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

local function createToggle(tab, name, default, callback)
    local state = default
    local btn = Instance.new("TextButton", tab)
    btn.Size = UDim2.new(1, -12, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name .. ": " .. (state and "ON" or "OFF")

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
end

local function createSlider(tab, name, min, max, default, callback)
    local label = Instance.new("TextLabel", tab)
    label.Size = UDim2.new(1, -12, 0, 30)
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local slider = Instance.new("TextButton", tab)
    slider.Size = UDim2.new(1, -12, 0, 30)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Text = "Drag to adjust"
    slider.TextColor3 = Color3.fromRGB(200, 200, 200)
    slider.Font = Enum.Font.Gotham
    slider.TextSize = 12

    local value = default
    slider.MouseButton1Down:Connect(function()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local percent = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            label.Text = name .. ": " .. value
            callback(value)
        end)
        local release
        release = mouse.Button1Up:Connect(function()
            conn:Disconnect()
            release:Disconnect()
        end)
    end)
end

-- Fling Feature
local flingEnabled = false
local flingPower = 3000

createToggle(MainTab, "Enable Fling", false, function(state)
    flingEnabled = state
end)

createSlider(MainTab, "Fling Power", 0, 4000, flingPower, function(val)
    flingPower = val
end)

RunService.Heartbeat:Connect(function()
    if flingEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * flingPower
        end
    end
end)

-- Attach
createButton(MainTab, "Attach", function()
    local target = Players:GetPlayers()[2]
    local char = LocalPlayer.Character
    if target and char then
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = char:FindFirstChild("HumanoidRootPart")
        weld.Part1 = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        weld.Parent = char.HumanoidRootPart
    end
end)

-- God Mode
createButton(MainTab, "God Mode", function()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Anchored = true
            end
        end
    end
end)

-- Noclip
createToggle(MainTab, "Noclip", false, function(state)
    RunService.Stepped:Connect(function()
        if state then
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Teleport
createButton(MovementTab, "Teleport", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Position = Vector3.new(0, 100, 0)
    end
end)

-- Speed Control
local speed = 100
createSlider(MovementTab, "Speed", 16, 200, speed, function(val)
    speed = val
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end)
-- Spam Fling
local spamFlingEnabled = false
createToggle(ExtrasTab, "Spam Fling", false, function(state)
    spamFlingEnabled = state
end)

RunService.Heartbeat:Connect(function()
    if spamFlingEnabled then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * flingPower
        end
    end
end)

-- Auto Attach
local autoAttachEnabled = false
createToggle(ExtrasTab, "Auto Attach", false, function(state)
    autoAttachEnabled = state
end)

spawn(function()
    while true do
        if autoAttachEnabled then
            local players = Players:GetPlayers()
            local target = players[2]
            local char = LocalPlayer.Character
            if target and char then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = char:FindFirstChild("HumanoidRootPart")
                weld.Part1 = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                weld.Parent = char.HumanoidRootPart
            end
        end
        wait(1)
    end
end)

-- Reset
createButton(ExtrasTab, "Reset", function()
    local char = LocalPlayer.Character
    if char then
        char:BreakJoints()
    end
end)

-- Remove
createButton(ExtrasTab, "Remove Parts", function()
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                v:Destroy()
            end
        end
    end
end)

-- Boost
createButton(MovementTab, "Boost", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 500, 0)
    end
end)

-- Optional: Close GUI
createButton(ExtrasTab, "Close GUI", function()
    gui:Destroy()
end)
