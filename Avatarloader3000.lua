local Accessories = {}

local function createAccessory(name, meshId, meshType, color, attachmentName, assetId)
    local accessory = Instance.new("Accessory")
    accessory.Name = name
    accessory:SetAttribute("OriginalAssetId", assetId)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1.5, 1.5, 1.5)
    handle.Color = color or Color3.fromRGB(100, 100, 100)
    handle.Anchored = false
    handle.CanCollide = false
    handle.TopSurface = Enum.SurfaceType.Smooth
    handle.BottomSurface = Enum.SurfaceType.Smooth
    handle.Parent = accessory

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = meshId or ""
    mesh.MeshType = meshType or Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
    mesh.Parent = handle

    local attachment = Instance.new("Attachment")
    attachment.Name = attachmentName or "ShoulderAttachment"
    attachment.Parent = handle

    return accessory
end

-- 🦾 Genos Arm R (Blue)
Accessories["GenosArmR"] = createAccessory(
    "GenosArmR",
    "",
    Enum.MeshType.Cylinder,
    Color3.fromRGB(0, 180, 255),
    "RightShoulderAttachment",
    "136470500788503"
)

-- 🦾 Genos Arm L (Blue)
Accessories["GenosArmL"] = createAccessory(
    "GenosArmL",
    "",
    Enum.MeshType.Cylinder,
    Color3.fromRGB(0, 180, 255),
    "LeftShoulderAttachment",
    "105639766288180"
)

-- 🛡️ Igris Chestplate
Accessories["IgrisChestplate"] = createAccessory(
    "IgrisChestplate",
    "",
    Enum.MeshType.Brick,
    Color3.fromRGB(50, 50, 60),
    "FrontAttachment",
    "72131859927934"
)

-- 🎭 Silent Noir Shoulder Pad – L
Accessories["SilentNoirL"] = createAccessory(
    "SilentNoirL",
    "",
    Enum.MeshType.Sphere,
    Color3.fromRGB(60, 40, 80),
    "LeftShoulderAttachment",
    "18835391472"
)

-- 🎭 Silent Noir Shoulder Pad – R
Accessories["SilentNoirR"] = createAccessory(
    "SilentNoirR",
    "",
    Enum.MeshType.Sphere,
    Color3.fromRGB(60, 40, 80),
    "RightShoulderAttachment",
    "18835398302"
)

-- 💥 CoreEmitter (Accessory #6)
Accessories["CoreEmitter"] = createAccessory(
    "CoreEmitter",
    "",
    Enum.MeshType.Sphere,
    Color3.fromRGB(255, 120, 200),
    "BackAttachment",
    "14528148289"
)

-- 👕 Shirt
local shirt = Instance.new("Shirt")
shirt.Name = "CyberShirt"
shirt.ShirtTemplate = "rbxassetid://14534692851"
Accessories["CyberShirt"] = shirt

-- 👖 Pants
local pants = Instance.new("Pants")
pants.Name = "CyberPants"
pants.PantsTemplate = "rbxassetid://14534689181"
Accessories["CyberPants"] = pants

return Accessories
