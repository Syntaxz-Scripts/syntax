-- Custom Chat Box + Chat Logs
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatSystem"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Chat Logs Frame
local logFrame = Instance.new("Frame")
logFrame.Size = UDim2.new(0, 300, 0, 400)
logFrame.Position = UDim2.new(1, -310, 0, 10)
logFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
logFrame.Parent = screenGui

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -10, 1, -10)
scrolling.Position = UDim2.new(0, 5, 0, 5)
scrolling.CanvasSize = UDim2.new(0,0,0,0)
scrolling.ScrollBarThickness = 6
scrolling.BackgroundTransparency = 1
scrolling.Parent = logFrame

-- Function to add log entry
local function addLog(plr, msg)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, -10, 0, 20)
    entry.Position = UDim2.new(0, 5, 0, scrolling.CanvasSize.Y.Offset)
    entry.BackgroundTransparency = 1
    entry.TextColor3 = Color3.fromRGB(255,255,255)
    entry.Font = Enum.Font.Code
    entry.TextSize = 14
    entry.Text = "["..plr.Name.."]: "..msg
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.Parent = scrolling

    scrolling.CanvasSize = UDim2.new(0,0,0,scrolling.CanvasSize.Y.Offset + 22)
end

-- Hook into chat events
Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        addLog(plr, msg)
    end)
end)

for _,plr in ipairs(Players:GetPlayers()) do
    plr.Chatted:Connect(function(msg)
        addLog(plr, msg)
    end)
end

-- Custom Chat Box
local chatFrame = Instance.new("Frame")
chatFrame.Size = UDim2.new(0, 300, 0, 60)
chatFrame.Position = UDim2.new(0.5, -150, 1, -70)
chatFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
chatFrame.Parent = screenGui

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.7, -10, 1, -10)
textBox.Position = UDim2.new(0, 5, 0, 5)
textBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.PlaceholderText = "Type message..."
textBox.Parent = chatFrame

local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.3, -10, 1, -10)
sendButton.Position = UDim2.new(0.7, 5, 0, 5)
sendButton.BackgroundColor3 = Color3.fromRGB(70,70,70)
sendButton.TextColor3 = Color3.fromRGB(255,255,255)
sendButton.Text = "Send"
sendButton.Parent = chatFrame

-- Function to send chat
local function sendChatMessage(text)
    if text ~= "" then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents
            .SayMessageRequest:FireServer(text, "All")
        addLog(player, text) -- also add to logs
    end
end

-- Hook button
sendButton.MouseButton1Click:Connect(function()
    sendChatMessage(textBox.Text)
    textBox.Text = ""
end)
