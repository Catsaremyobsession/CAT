if not isfolder("ape") then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Creating folder",
            Text = "main.lua",
            Duration = 5
        })
    makefolder("ape")
    if isfolder("ape") then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Created folder",
            Text = "ape",
            Duration = 5
        })
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Failed to folder",
            Text = "ape",
            Duration = 5
        })
    end
else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Folder already exists",
            Text = "ape",
            Duration = 5
        })
end

-- Test file creation
writefile("ape/testfile.txt", "This is a test file to see if file creation works.")
if isfile("ape/testfile.txt") then
    print("Deleting test file")
    delfile("ape/testfile.txt")
end

if isfolder("ape") then
    if isfile("ape/main.lua") then
        loadfile("ape/main.lua")()
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Downloading file",
            Text = "main.lua",
            Duration = 5
        })
        wait(5)
        local Script = game:HttpGet('https://raw.githubusercontent.com/Catsaremyobsession/CAT/refs/heads/main/scripts/AnimChanger/assets/main.lua', true)
        writefile("ape/main.lua", Script)

        -- Check if the file has been written
        if isfile("ape/main.lua") then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Downloaded file",
            Text = "main.lua",
            Duration = 5
        })
        else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Failed to download file",
            Text = "main.lua",
            Duration = 5
        })
        end
        loadfile("ape/main.lua")()
    end
end
