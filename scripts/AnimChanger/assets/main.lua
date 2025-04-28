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
    run="rbxassetid://782842708",
    walk="rbxassetid://782843345",
    jump="rbxassetid://782847020",
    idle1="rbxassetid://782841498",
    idle2="rbxassetid://782845736",
    idle3="rbxassetid://980952228",
    fall="rbxassetid://782846423",
    swim="rbxassetid://782844582",
    swimIdle="rbxassetid://782845186",
    climb="rbxassetid://782843869"
}

-- Apply the Toy animation pack
local function applyToyPack()
    local char = player.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    local function set(name, id)
        local part = animate:FindFirstChild(name)
        local anim = part and part:FindFirstChildWhichIsA("Animation")
        if anim then anim.AnimationId = id end
    end

    set("run", toyPack.run)
    set("walk", toyPack.walk)
    set("jump", toyPack.jump)
    for i = 1, 3 do
        local idleAnim = animate.idle and animate.idle:FindFirstChild("Animation" .. i)
        if idleAnim then idleAnim.AnimationId = toyPack["idle" .. i] end
    end
    set("fall", toyPack.fall)
    set("swim", toyPack.swim)
    set("swimidle", toyPack.swimIdle)
    set("climb", toyPack.climb)
end

-- Apply immediately if character exists
if player.Character then
    applyToyPack()
end

-- Re-apply on respawn
player.CharacterAdded:Connect(function()
    player.Character:WaitForChild("Humanoid")
    player.Character:WaitForChild("Animate")
    task.wait(0.1)
    applyToyPack()
end)

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Toy animation",
    Text = "Applied pack!",
    Duration = 5
})
