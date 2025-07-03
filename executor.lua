-- Simple, Colored, Draggable Mini Script Executor

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- TopBar UI
local TopBarUI = Instance.new("ScreenGui")
TopBarUI.Name = "TopBarUI"
TopBarUI.Parent = playerGui
TopBarUI.DisplayOrder = 10
TopBarUI.ResetOnSpawn = false

local TopbarContainer = Instance.new("Frame")
TopbarContainer.Name = "TopbarContainer"
TopbarContainer.Parent = TopBarUI
TopbarContainer.BackgroundTransparency = 0
TopbarContainer.BackgroundColor3 = Color3.fromRGB(55, 120, 200) -- Blue top bar
TopbarContainer.BorderSizePixel = 0
TopbarContainer.Size = UDim2.new(0, 300, 0, 30)
TopbarContainer.Position = UDim2.new(0.5, -150, 0.1, 0)

local UICorner = Instance.new("UICorner", TopbarContainer)
UICorner.CornerRadius = UDim.new(0, 10)

local OpenClose = Instance.new("TextButton")
OpenClose.Name = "Open/Close"
OpenClose.Parent = TopbarContainer
OpenClose.BackgroundColor3 = Color3.fromRGB(85, 200, 120) -- Green button
OpenClose.BorderSizePixel = 0
OpenClose.Position = UDim2.new(1, -80, 0.1, 0)
OpenClose.Size = UDim2.new(0, 70, 0, 22)
OpenClose.Font = Enum.Font.Highway
OpenClose.Text = "Open"
OpenClose.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenClose.TextScaled = true
OpenClose.TextWrapped = true
local ButtonCorner = Instance.new("UICorner", OpenClose)
ButtonCorner.CornerRadius = UDim.new(0, 8)

-- Executor UI
local ExecutorUI = Instance.new("ScreenGui")
ExecutorUI.Name = "ExecutorUI"
ExecutorUI.ResetOnSpawn = false
ExecutorUI.Parent = playerGui
ExecutorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ExecutorUI.Enabled = false

local Frame = Instance.new("Frame")
Frame.Parent = ExecutorUI
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 70) -- Deep blue/purple
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -150, 0.15, 0)
Frame.Size = UDim2.new(0, 300, 0, 200)
local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 12)

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, -40, 0, 30)
TextLabel.Position = UDim2.new(0, 20, 0, 0)
TextLabel.Font = Enum.Font.Highway
TextLabel.Text = "Mini Executor"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 18
TextLabel.TextWrapped = true

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(230, 60, 60) -- Red
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -30, 0, 0)
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.Font = Enum.Font.Highway
Close.TextScaled = true
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 8)

local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 90)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0, 12, 0, 40)
TextBox.Size = UDim2.new(1, -24, 0, 80)
TextBox.Font = Enum.Font.Code
TextBox.Text = "print('Hello!')"
TextBox.TextColor3 = Color3.fromRGB(220, 255, 220)
TextBox.TextSize = 16
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.ClearTextOnFocus = false
local TextBoxCorner = Instance.new("UICorner", TextBox)
TextBoxCorner.CornerRadius = UDim.new(0, 8)

local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Name = "Execute"
ExecuteButton.Parent = Frame
ExecuteButton.BackgroundColor3 = Color3.fromRGB(85, 200, 120)
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Position = UDim2.new(0.05, 0, 1, -55)
ExecuteButton.Size = UDim2.new(0.4, -8, 0, 36)
ExecuteButton.Font = Enum.Font.Highway
ExecuteButton.Text = "Execute"
ExecuteButton.TextColor3 = Color3.fromRGB(255,255,255)
ExecuteButton.TextScaled = true
local ExecCorner = Instance.new("UICorner", ExecuteButton)
ExecCorner.CornerRadius = UDim.new(0, 8)

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "Clear"
ClearButton.Parent = Frame
ClearButton.BackgroundColor3 = Color3.fromRGB(230, 170, 60)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0.55, 4, 1, -55)
ClearButton.Size = UDim2.new(0.4, -8, 0, 36)
ClearButton.Font = Enum.Font.Highway
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(255,255,255)
ClearButton.TextScaled = true
local ClearCorner = Instance.new("UICorner", ClearButton)
ClearCorner.CornerRadius = UDim.new(0, 8)

-- Drag logic for both UI windows
local function makeDraggable(frame, dragHandle)
    local dragToggle = {active = false}
    local dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle.active = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle.active = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle.active then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(TopbarContainer, TopbarContainer)
makeDraggable(Frame, Frame)

-- Notifications
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = duration or 2})
    end)
end

-- Button functions
OpenClose.MouseButton1Click:Connect(function()
    ExecutorUI.Enabled = not ExecutorUI.Enabled
    OpenClose.Text = ExecutorUI.Enabled and "Close" or "Open"
    if ExecutorUI.Enabled then
        notify("Executor", "Opened!", 2)
    end
end)

Close.MouseButton1Click:Connect(function()
    ExecutorUI.Enabled = false
    OpenClose.Text = "Open"
    notify("Executor", "Closed!", 2)
end)

ClearButton.MouseButton1Click:Connect(function()
    TextBox.Text = ""
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
