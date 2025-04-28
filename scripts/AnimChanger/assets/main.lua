-- Wait until the game is fully loaded
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- SERVICES
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- LOCAL PLAYER
local player = Players.LocalPlayer

-- TOY PACK ANIMATIONS
local toyPack = {
    run = "rbxassetid://782842708",
    walk = "rbxassetid://782843345",
    jump = "rbxassetid://782847020",
    idle1 = "rbxassetid://782841498",
    idle2 = "rbxassetid://782845736",
    idle3 = "rbxassetid://980952228",
    fall = "rbxassetid://782846423",
    swim = "rbxassetid://782844582",
    swimIdle = "rbxassetid://782845186",
    climb = "rbxassetid://782843869"
}

-- Default Roblox Animations
local defaultAnimations = {
    run = "rbxassetid://18042557",
    walk = "rbxassetid://18042585",
    jump = "rbxassetid://18042610",
    idle1 = "rbxassetid://18042647",
    idle2 = "rbxassetid://18042692",
    idle3 = "rbxassetid://18042721",
    fall = "rbxassetid://18042773",
    swim = "rbxassetid://18042808",
    swimIdle = "rbxassetid://18042839",
    climb = "rbxassetid://18042862"
}

-- Apply the Toy animation pack
local function applyToyPack()
    local char = player.Character
    if not char then
        return false  -- No character found
    end

    -- Wait for Animate object to be fully loaded
    local animate = char:FindFirstChild("Animate")
    if not animate then
        return false  -- No Animate object found
    end

    -- Function to apply animation
    local function set(name, id)
        local part = animate:FindFirstChild(name)
        if not part then return end

        local anim = part:FindFirstChildWhichIsA("Animation")
        if anim then
            anim.AnimationId = id
        else
            print("Animation object not found for: " .. name)
        end
    end

    -- Apply animations
    set("run", toyPack.run)
    set("walk", toyPack.walk)
    set("jump", toyPack.jump)
    for i = 1, 3 do
        local idleAnim = animate.idle and animate.idle:FindFirstChild("Animation" .. i)
        if idleAnim then
            idleAnim.AnimationId = toyPack["idle" .. i]
        else
            print("Idle animation " .. i .. " not found.")
        end
    end
    set("fall", toyPack.fall)
    set("swim", toyPack.swim)
    set("swimidle", toyPack.swimIdle)
    set("climb", toyPack.climb)

    return true  -- Animation applied successfully
end

-- Destroy animations and revert to original ones
local function destroyAnim()
    local char = player.Character
    if not char then return end

    -- Wait for Animate object to be fully loaded
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    -- Function to reset animation to default Roblox animations
    local function reset(name)
        local part = animate:FindFirstChild(name)
        if not part then return end

        local anim = part:FindFirstChildWhichIsA("Animation")
        if anim then
            anim.AnimationId = defaultAnimations[name]  -- Reset to default animation
        end
    end

    -- Reset all animations to default
    reset("run")
    reset("walk")
    reset("jump")
    for i = 1, 3 do
        local idleAnim = animate.idle and animate.idle:FindFirstChild("Animation" .. i)
        if idleAnim then
            idleAnim.AnimationId = defaultAnimations["idle" .. i]  -- Reset to default idle
        end
    end
    reset("fall")
    reset("swim")
    reset("swimidle")
    reset("climb")

    -- Notify the player that the animations were removed
    StarterGui:SetCore("SendNotification", {
        Title = "Toy animation",
        Text = "Animations reverted to default!",
        Duration = 5
    })
end

-- Apply immediately if character exists
if player.Character then
    local success = applyToyPack()
    if success then
        -- Send notification if animations applied successfully
        StarterGui:SetCore("SendNotification", {
            Title = "Toy animation",
            Text = "Applied pack successfully!",
            Duration = 5
        })
    else
        -- Send notification if failed to apply the animation
        StarterGui:SetCore("SendNotification", {
            Title = "Toy animation",
            Text = "Failed to apply pack.",
            Duration = 5
        })
    end
end

-- Re-apply on respawn
player.CharacterAdded:Connect(function()
    player.Character:WaitForChild("Humanoid")
    player.Character:WaitForChild("Animate")
    task.wait(0.5)  -- Wait a bit longer for the character's animations to fully load
    local success = applyToyPack()
    if success then
        -- Send notification if animations applied successfully
        StarterGui:SetCore("SendNotification", {
            Title = "Toy animation",
            Text = "Applied pack successfully!",
            Duration = 5
        })
    else
        -- Send notification if failed to apply the animation
        StarterGui:SetCore("SendNotification", {
            Title = "Toy animation",
            Text = "Failed to apply pack.",
            Duration = 5
        })
    end
end)

-- Example usage of destroyAnim function (can be called based on some condition)
-- destroyAnim()  -- Call this when you want to reset to default animations
