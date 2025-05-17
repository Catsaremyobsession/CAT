-- troll/init.lua
-- Handles: folder setup, image & sound download, overlay + astlofo parts

--// Folder Setup
if not isfolder("astlofo") then makefolder("astlofo") end
if not isfolder("astlofo/imgs") then makefolder("astlofo/imgs") end
if not isfolder("astlofo/sounds") then makefolder("astlofo/sounds") end

--// File Download
local function downloadIfMissing(filename, url)
    if not isfile(filename) then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result then
            writefile(filename, result)
        else
            warn("Failed to download: " .. filename)
        end
    end
end

downloadIfMissing("astlofo/imgs/astlofo.png", "https://raw.githubusercontent.com/Catsaremyobsession/CAT/main/imgs/astlofo.png")
downloadIfMissing("astlofo/imgs/trollface.png", "https://raw.githubusercontent.com/Catsaremyobsession/CAT/main/imgs/trollface.png")
downloadIfMissing("astlofo/sounds/troll.mp3", "https://raw.githubusercontent.com/Catsaremyobsession/CAT/main/sounds/troll.mp3")

--// Show rick.png overlay with warning and sound
do
    local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
    sg.Name = "RickOverlay"
    sg.IgnoreGuiInset = true

    -- Fullscreen image
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Position = UDim2.new(0, 0, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = getcustomasset("astlofo/imgs/trollface.png")
    img.ZIndex = 10
    img.Parent = sg

    -- Warning text
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 0, 50)
    txt.Position = UDim2.new(0, 0, 1, -50)
    txt.BackgroundTransparency = 1
    txt.Text = "Run _G.reverse() to undo the effect"
    txt.TextColor3 = Color3.new(1, 0, 0)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBlack
    txt.TextScaled = true
    txt.ZIndex = 11
    txt.Parent = sg

    -- Play sound once (🔉 50% volume)
    local sound = Instance.new("Sound")
    sound.SoundId = getcustomasset("astlofo/sounds/troll.mp3")
    sound.Volume = 0.5
    sound.PlayOnRemove = true
    sound.Parent = workspace
    sound:Destroy()

    sg.Parent = game:GetService("CoreGui")
    task.delay(5, function() sg:Destroy() end)
end

--// Trolling loop
local originalProps = {}
local appliedTextures = {}
local running = true

local rickTexturePath = getcustomasset("astlofo/imgs/astlofo.png")

local function applyRickTexture(part)
    if not originalProps[part] then
        originalProps[part] = {
            Color = part.Color,
            Material = part.Material,
        }
    end

    part.Material = Enum.Material.SmoothPlastic
    part.Color = Color3.fromRGB(255, 255, 255)

    if not appliedTextures[part] then
        appliedTextures[part] = {}

        for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
            local tex = Instance.new("Texture")
            tex.Name = "RickTexture"
            tex.Face = face
            tex.Texture = rickTexturePath
            tex.StudsPerTileU = 1
            tex.StudsPerTileV = 1
            tex.Parent = part
            table.insert(appliedTextures[part], tex)
        end
    end
end

local function trollLoop()
    while running do
        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("BasePart") then
                applyRickTexture(inst)
            end
        end
        task.wait(0.5)
    end
end

--// Start trolling
task.spawn(trollLoop)

--// Reverse function
_G.reverse = function()
    running = false

    for part, props in pairs(originalProps) do
        if part and part.Parent then
            pcall(function()
                part.Color = props.Color
                part.Material = props.Material
            end)
        end
    end

    for part, textures in pairs(appliedTextures) do
        for _, tex in ipairs(textures) do
            pcall(function()
                if tex and tex.Parent then tex:Destroy() end
            end)
        end
    end

    originalProps = {}
    appliedTextures = {}
end
