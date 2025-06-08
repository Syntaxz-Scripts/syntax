print("SynTaxz Scripts Loaded!")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Syntaxz Scripts DEMO",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Syntaxz",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Syntaxz Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
Rayfield:SetVisibility(true)
Rayfield:IsVisible(true)

local MainTab = Window:CreateTab("Main", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Fun")

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
    -- Highlight all existing objects
    for _, obj in ipairs(workspace:GetDescendants()) do
        handle(obj)
    end
    -- Connect to new objects
    espConnection = workspace.DescendantAdded:Connect(handle)
end

local function DisableESP()
    -- Disconnect connection
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    -- Remove all highlights
    clearESP()
end

-- The Rayfield toggle (replace Tab with your actual tab variable, like MainTab)
local Toggle = Tab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "PlayerESP",
   Callback = function(Value)
      if Value then
         EnableESP()
      else
         DisableESP()
      end
   end,
})
