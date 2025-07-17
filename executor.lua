local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local coreGui = game:GetService("CoreGui")

-- Executor UI
local ExecutorUI = Instance.new("ScreenGui", playerGui)
ExecutorUI.Name = "RedOutlineExecutorUI"
ExecutorUI.ResetOnSpawn = false
ExecutorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame", ExecutorUI)
Frame.Size = UDim2.new(0, 480, 0, 300) -- 🩳 reduced height
Frame.Position = UDim2.new(0.5, -240, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 4
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- 🖱️ DragZone (for reliable drag)
local dragZone = Instance.new("Frame", Frame)
dragZone.Size = UDim2.new(1, 0, 0, 32)
dragZone.Position = UDim2.new(0, 0, 0, 0)
dragZone.BackgroundTransparency = 1
dragZone.ZIndex = 10

local UIS = game:GetService("UserInputService")
local dragging, dragStart, startPos

dragZone.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- External Toggle Button
local ToggleBtn = Instance.new("TextButton", coreGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 12, 0, 12)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleBtn.Text = "◀"
ToggleBtn.Font = Enum.Font.Highway
ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.TextScaled = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    ExecutorUI.Enabled = not ExecutorUI.Enabled
    ToggleBtn.Text = ExecutorUI.Enabled and "◀" or "▶"
end)

-- Title
local Label = Instance.new("TextLabel", Frame)
Label.Size = UDim2.new(1, 0, 0, 32)
Label.Position = UDim2.new(0, 0, 0, 8)
Label.Text = "😝 coul gui 😝"
Label.Font = Enum.Font.Highway
Label.TextSize = 20
Label.TextColor3 = Color3.fromRGB(255, 0, 0)
Label.BackgroundTransparency = 1

-- Buttons
local Close = Instance.new("TextButton", Frame)
Close.Position = UDim2.new(1, -36, 0, 8)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Text = "X"
Close.Font = Enum.Font.Highway
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.TextScaled = true
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local ExecuteButton = Instance.new("TextButton", Frame)
ExecuteButton.Position = UDim2.new(0.05, 0, 1, -56)
ExecuteButton.Size = UDim2.new(0.4, -6, 0, 36)
ExecuteButton.Text = "Execute"
ExecuteButton.Font = Enum.Font.Highway
ExecuteButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ExecuteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ExecuteButton.TextScaled = true
Instance.new("UICorner", ExecuteButton).CornerRadius = UDim.new(0, 8)

local ClearButton = Instance.new("TextButton", Frame)
ClearButton.Position = UDim2.new(0.55, 6, 1, -56)
ClearButton.Size = UDim2.new(0.4, -6, 0, 36)
ClearButton.Text = "Clear"
ClearButton.Font = Enum.Font.Highway
ClearButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ClearButton.TextScaled = true
Instance.new("UICorner", ClearButton).CornerRadius = UDim.new(0, 8)

-- TextBox (adjusted height)
local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -24, 0, 150)
TextBox.Position = UDim2.new(0, 12, 0, 48)
TextBox.Text = "print('Hello World!')"
TextBox.TextSize = 18
TextBox.Font = Enum.Font.Code
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
TextBox.BorderSizePixel = 2
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.ClearTextOnFocus = false
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

-- Logger
local LoggerBox = Instance.new("TextBox", Frame)
LoggerBox.Size = UDim2.new(1, -24, 0, 50)
LoggerBox.Position = UDim2.new(0, 12, 0, 210)
LoggerBox.Text = "[Logger Initialized]\n"
LoggerBox.TextSize = 14
LoggerBox.Font = Enum.Font.Code
LoggerBox.TextColor3 = Color3.fromRGB(255, 0, 0)
LoggerBox.BackgroundTransparency = 1
LoggerBox.TextXAlignment = Enum.TextXAlignment.Left
LoggerBox.TextYAlignment = Enum.TextYAlignment.Top
LoggerBox.TextWrapped = true
LoggerBox.ClearTextOnFocus = false

-- Notifications
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = duration or 2
        })
    end)
end

-- Function Hooks
local oldHttpGet = game.HttpGet
game.HttpGet = function(self, url, ...)
    LoggerBox.Text = LoggerBox.Text .. "\n[HttpGet] " .. url
    return oldHttpGet(self, url, ...)
end

local oldLoadstring = loadstring
loadstring = function(code, ...)
    LoggerBox.Text = LoggerBox.Text .. "\n[loadstring] " .. code:sub(1, 120) .. "..."
    return oldLoadstring(code, ...)
end

-- Buttons Logic
Close.MouseButton1Click:Connect(function()
    ExecutorUI.Enabled = false
    ToggleBtn.Text = "▶"
end)

ClearButton.MouseButton1Click:Connect(function()
    TextBox.Text = ""
    LoggerBox.Text = "[Logger Cleared]\n"
    notify("Executor", "Cleared!", 2)
end)

ExecuteButton.MouseButton1Click:Connect(function()
    local code = TextBox.Text
    if code == "" then
        notify("Error", "No code to execute!", 2)
        return
    end
    local func, err = loadstring(code)
    if not func then
        notify("Error", "Syntax error: " .. err, 3)
        return
    end
    local ok, res = pcall(func)
    if ok then
        notify("Success", "Code ran successfully!", 2)
    else
        notify("Error", "Runtime error: " .. tostring(res), 3)
    end
end)
