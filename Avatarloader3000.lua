local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local LocalPlayer = Players.LocalPlayer

local accessoryIds = {
    136470500788503, -- Genos Right Arm Blue [R6]
    72131859927934,  -- Shadow Igris Chestplate
    18835391472,     -- Silent Noir Shoulder Pad L
    18835398302,     -- Silent Noir Shoulder Pad R
    105639766288180, -- Genos Arm Blue (L)
    14528148289      -- Additional Insertable Accessory
}

local function addAuraToTorso(char, color, textureId)
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if torso then
        local aura = Instance.new("ParticleEmitter")
        aura.Texture = "rbxassetid://" .. (textureId or "243098098")
        aura.Rate = 24
        aura.Lifetime = NumberRange.new(1)
        aura.Speed = NumberRange.new(0.1)
        aura.Size = NumberSequence.new(1.2)
        aura.Color = ColorSequence.new(color or Color3.fromRGB(120, 0, 255), Color3.fromRGB(255, 255, 255))
        aura.LightEmission = 0.9
        aura.Transparency = NumberSequence.new(0.3)
        aura.Parent = torso
    end
end

local function equipCyberAura()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    -- 💅 Clear old look
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("Shirt") or item:IsA("Pants") then
            item:Destroy()
        end
    end

    -- 👕 Apply shirt & pants
    local shirt = Instance.new("Shirt")
    shirt.ShirtTemplate = "rbxassetid://14534692851"
    shirt.Parent = char

    local pants = Instance.new("Pants")
    pants.PantsTemplate = "rbxassetid://14534689181"
    pants.Parent = char

    -- 🖤 Override skin tone
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Really black")
        end
    end

    -- 🎩 Insert accessories
    local validAccessories = {}
    for _, accId in ipairs(accessoryIds) do
        local success, model = pcall(function()
            return InsertService:LoadAsset(accId)
        end)
        if success and model then
            local accessory = model:FindFirstChildOfClass("Accessory")
            if accessory then
                accessory.Parent = char
                table.insert(validAccessories, accId)
            end
        end
    end

    -- 🌌 Add aura emitter
    addAuraToTorso(char)

    print("✅ Cyber Aura deployed. Accessories equipped:", validAccessories)
end

return equipCyberAura
