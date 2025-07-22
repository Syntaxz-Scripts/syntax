local Accessories = {}

local function createAccessory(name, color, attachmentType)
    local accessory = Instance.new("Accessory")
    accessory.Name = name

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.2, 1.2, 1.2)
    handle.Color = color or Color3.fromRGB(80, 80, 80)
    handle.CanCollide = false
    handle.Anchored = false
    handle.TopSurface = Enum.SurfaceType.Smooth
    handle.BottomSurface = Enum.SurfaceType.Smooth
    handle.Parent = accessory

    local attachment = Instance.new("Attachment")
    attachment.Name = attachmentType or "ShoulderAttachment"
    attachment.Parent = handle

    return accessory
end

-- 🦾 Accessories
Accessories["GenosArmR"] = createAccessory("GenosArmR", Color3.fromRGB(0, 180, 255), "RightShoulderAttachment")
Accessories["GenosArmL"] = createAccessory("GenosArmL", Color3.fromRGB(0, 180, 255), "LeftShoulderAttachment")
Accessories["IgrisChestplate"] = createAccessory("IgrisChestplate", Color3.fromRGB(60, 60, 60), "FrontAttachment")
Accessories["SilentNoirL"] = createAccessory("SilentNoirL", Color3.fromRGB(40, 40, 60), "LeftShoulderAttachment")
Accessories["SilentNoirR"] = createAccessory("SilentNoirR", Color3.fromRGB(40, 40, 60), "RightShoulderAttachment")
Accessories["CyberHalo"] = createAccessory("CyberHalo", Color3.fromRGB(150, 120, 255), "HatAttachment")

-- 👕 Clothing (Prebuilt Instances)
local shirt = Instance.new("Shirt")
shirt.Name = "CyberShirt"
shirt.ShirtTemplate = "rbxassetid://14534692851"
Accessories["CyberShirt"] = shirt

local pants = Instance.new("Pants")
pants.Name = "CyberPants"
pants.PantsTemplate = "rbxassetid://14534689181"
Accessories["CyberPants"] = pants

return Accessories
