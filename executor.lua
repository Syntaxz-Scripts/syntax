-- yo if ur seeing this ur handsome
local TopBarUI = Instance.new("ScreenGui")
local TopbarContainer = Instance.new("Frame")
local OpenClose = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ExecuteRunCode = Instance.new("TextButton")
local ClearurTextBox = Instance.new("TextButton")
local UICornerExecutor = Instance.new("UICorner")
local TextBox = Instance.new("TextBox")
local TextLabel = Instance.new("TextLabel")
local Close = Instance.new("TextButton")
local UICornerClose = Instance.new("UICorner")
local ImageLabel = Instance.new("ImageLabel")

-- TopBar Properties:
TopBarUI.Name = "TopBarUI"
TopBarUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TopBarUI.DisplayOrder = 10
TopBarUI.ResetOnSpawn = false

TopbarContainer.Name = "TopbarContainer"
TopbarContainer.Parent = TopBarUI
TopbarContainer.BackgroundTransparency = 1.000
TopbarContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
TopbarContainer.Size = UDim2.new(1, 0, 0, 36)

OpenClose.Name = "Open/Close"
OpenClose.Parent = TopbarContainer
OpenClose.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
OpenClose.BackgroundTransparency = 0.200
OpenClose.BorderColor3 = Color3.fromRGB(27, 42, 53)
OpenClose.BorderSizePixel = 0
OpenClose.Position = UDim2.new(0, 104, 0, 4)
OpenClose.Size = UDim2.new(0, 100, 0, 32)
OpenClose.ZIndex = 10
OpenClose.AutoButtonColor = false
OpenClose.Font = Enum.Font.Highway
OpenClose.Text = "Open Executor"
OpenClose.TextColor3 = Color3.fromRGB(0, 0, 0)
OpenClose.TextScaled = true
OpenClose.TextWrapped = true

UICorner.Parent = OpenClose

-- Executor Properties:
ScreenGui.Name = "ExecutorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = false -- Initially hidden

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.239081323, 0, 0.18776077, 0)
Frame.Size = UDim2.new(0, 553, 0, 358)

ExecuteRunCode.Name = "Execute Run Code"
ExecuteRunCode.Parent = Frame
ExecuteRunCode.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
ExecuteRunCode.BorderColor3 = Color3.fromRGB(0, 0, 0)
ExecuteRunCode.BorderSizePixel = 0
ExecuteRunCode.Position = UDim2.new(0.0795660019, 0, 0.812849164, 0)
ExecuteRunCode.Size = UDim2.new(0, 200, 0, 50)
ExecuteRunCode.Font = Enum.Font.SourceSans
ExecuteRunCode.Text = "Execute"
ExecuteRunCode.TextColor3 = Color3.fromRGB(0, 0, 0)
ExecuteRunCode.TextScaled = true
ExecuteRunCode.TextSize = 14.000
ExecuteRunCode.TextWrapped = true

ClearurTextBox.Name = "Clear ur Text Box"
ClearurTextBox.Parent = Frame
ClearurTextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
ClearurTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
ClearurTextBox.BorderSizePixel = 0
ClearurTextBox.Position = UDim2.new(0.553345382, 0, 0.812849164, 0)
ClearurTextBox.Size = UDim2.new(0, 200, 0, 50)
ClearurTextBox.Font = Enum.Font.SourceSans
ClearurTextBox.Text = "Clear"
ClearurTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
ClearurTextBox.TextScaled = true
ClearurTextBox.TextSize = 14.000
ClearurTextBox.TextWrapped = true

UICornerExecutor.Parent = Frame

TextBox.Parent = Frame
TextBox.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.0327339396, 0, 0.107947834, 0)
TextBox.Size = UDim2.new(0, 517, 0, 241)
TextBox.Font = Enum.Font.SourceSans
TextBox.Text = "Examples: print(\"Hello\")"
TextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
TextBox.TextSize = 20.000
TextBox.TextWrapped = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.0669077784, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 38)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Script Executor"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

ImageLabel.Parent = Frame
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Size = UDim2.new(0, 37, 0, 38)
ImageLabel.Image = "rbxassetid://4998267428" -- Replace with your image asset ID

Close.Name = "Close"
Close.Parent = Frame
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(0.929475605, 0, 0, 0)
Close.Size = UDim2.new(0, 39, 0, 32)
Close.Font = Enum.Font.SourceSans
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(0, 0, 0)
Close.TextScaled = true
Close.TextSize = 14.000
Close.TextWrapped = true

UICornerClose.Parent = Close

-- Drag Functionality
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopbarContainer.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if not dragging then return end
            updateDrag(input)
        end)
    end
end)

TopbarContainer.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Notification Functionality
local function showNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
    })
end

-- Toggle Executor Visibility
OpenClose.MouseButton1Click:Connect(function()
    if ScreenGui.Enabled then
        ScreenGui.Enabled = false
        OpenClose.Text = "Open Executor"
    else
        ScreenGui.Enabled = true
        OpenClose.Text = "Close Executor"
        showNotification("Executor", "Opened Executor!", 3) -- Notification for opening
    end
end)

-- Close Button Functionality
Close.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    OpenClose.Text = "Open Executor"
    showNotification("Executor", "Closed Executor!", 3) -- Notification for closing
end)

-- Clear Button Functionality
ClearurTextBox.MouseButton1Click:Connect(function()
    TextBox.Text = ""
    showNotification("Executor", "Cleared TextBox!", 3) -- Notification for clearing
end)

-- Execute Button Functionality
ExecuteRunCode.MouseButton1Click:Connect(function()
    local code = TextBox.Text
    if code == "" then
        showNotification("Error", "No code entered!", 3)
        return
    end
    local func, err = loadstring(code)
    if not func then
        showNotification("Error", "Syntax Error: " .. err, 5)
        return
    end
    local success, execErr = pcall(func)
    if not success then
        showNotification("Error", "Runtime Error: " .. execErr, 5)
    else
        showNotification("Success", "Code executed successfully!", 3)
    end
end)
