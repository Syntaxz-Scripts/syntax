-- Mini Script Executor with Red Outlines, Black Background, Drag Anywhere Except Execute Area

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Executor UI
local ExecutorUI = Instance.new("ScreenGui")
ExecutorUI.Name = "RedOutlineExecutorUI"
ExecutorUI.Parent = playerGui
ExecutorUI.ResetOnSpawn = false
ExecutorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Parent = ExecutorUI
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)   -- Red outline
Frame.BorderSizePixel = 4
Frame.Position = UDim2.new(0.5, -160, 0.2, 0)
Frame.Size = UDim2.new(0, 320, 0, 220)
Frame.Name = "MainFrame"

local FrameCorner = Instance.new("UICorner", Frame)
FrameCorner.CornerRadius = UDim.new(0, 8)

-- Label
local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0, 0, 0, 8)
Label.Size = UDim2.new(1, 0, 0, 32)
Label.Font = Enum.Font.Highway
Label.Text = "Red Outline Executor"
Label.TextColor3 = Color3.fromRGB(255, 0, 0)
Label.TextSize = 20
Label.TextWrapped = true

-- Close Button
local Close = Instance.new("TextButton")
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -36, 0, 8)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.Font = Enum.Font.Highway
Close.TextScaled = true
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 8)

-- Script Box
local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TextBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
TextBox.BorderSizePixel = 2
TextBox.Position = UDim2.new(0, 12, 0, 48)
TextBox.Size = UDim2.new(1, -24, 0, 100)
TextBox.Font = Enum.Font.Code
TextBox.Text = "print('Hello World!')"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.ClearTextOnFocus = false
local TextBoxCorner = Instance.new("UICorner", TextBox)
TextBoxCorner.CornerRadius = UDim.new(0, 6)

-- Execute Button
local ExecuteButton = Instance.new("TextButton")
ExecuteButton.Parent = Frame
ExecuteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Position = UDim2.new(0.05, 0, 1, -56)
ExecuteButton.Size = UDim2.new(0.4, -6, 0, 36)
ExecuteButton.Font = Enum.Font.Highway
ExecuteButton.Text = "Execute"
ExecuteButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ExecuteButton.TextScaled = true
local ExecCorner = Instance.new("UICorner", ExecuteButton)
ExecCorner.CornerRadius = UDim.new(0, 8)

-- Clear Button
local ClearButton = Instance.new("TextButton")
ClearButton.Parent = Frame
ClearButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ClearButton.BorderSizePixel = 0
ClearButton.Position = UDim2.new(0.55, 6, 1, -56)
ClearButton.Size = UDim2.new(0.4, -6, 0, 36)
ClearButton.Font = Enum.Font.Highway
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearButton.TextScaled = true
local ClearCorner = Instance.new("UICorner", ClearButton)
ClearCorner.CornerRadius = UDim.new(0, 8)

-- Drag logic (everywhere except Execute and Clear area)
local userInput = game:GetService("UserInputService")
local dragging, dragStart, startPos

local dragArea = Instance.new("Frame")
dragArea.Parent = Frame
dragArea.BackgroundTransparency = 1
dragArea.Size = UDim2.new(1, 0, 1, -56)
dragArea.Position = UDim2.new(0, 0, 0, 0)
dragArea.ZIndex = 2

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
dragArea.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Notifications
local function notify(title, text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = title, Text = text, Duration = duration or 2})
    end)
end

-- Button functions
Close.MouseButton1Click:Connect(function()
    ExecutorUI.Enabled = false
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
