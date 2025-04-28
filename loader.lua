-- Preventing any virtualize hook to ensure it behaves normally
local function NoVirtualize(f) return f end;

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Getgenv configuration
getgenv().yena = {
    Aimbot = {
        Enabled = true,
        ClosestPart = true,
        Keybind = "C",
        HitPart = "Head",
        FOV = {
            Visible = false,
            Transparency = 1,
            Thickness = 1,
            Radius = {Size = 150},
            Color = Color3.fromRGB(255, 255, 0)
        },
        TargetChecks = {
            Knocked = true,
            Dead = true,
            Grabbed = true
        },
        Smoothness = {Enabled = true, Value = {Factor = 0.06}},
        Prediction = {Enabled = true, Strength = {X = 6.5, Y = 7.7}},
    },
    SilentAim = {
        Enabled = true,
        ClosestPart = true,
        HitPart = "Head",
        Prediction = {Enabled = true, Strength = {X = 0.13, Y = 0.1322}},
        TargetChecks = {
            Knocked = true,
            Dead = true,
            Grabbed = true
        },
        Visualization = {
            FOV = {
                Enabled = false,
                Visible = false,
                Transparency = 1,
                Thickness = 1,
                Radius = {Size = 150},
                Color = Color3.fromRGB(255, 255, 255)
            },
            Dot = {
                Enabled = false,
                Color = Color3.fromRGB(255, 255, 255),
                Size = 5,
                Filled = true,
                Thickness = 10
            }
        },
        TargetMethod = "Target"
    }
}

local active = false
local currentTarget = nil
local currentPart = nil

-- Function to calculate the nearest enemy
local function getClosestEnemy()
    local closestDist = math.huge
    local closestPlayer, closestHitPart = nil, nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(getgenv().yena.Aimbot.HitPart)
            if targetPart then
                local screenPos = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(targetPart.Position)
                if screenPos then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPart.Position).Magnitude
                    if distance < closestDist then
                        closestPlayer = player
                        closestHitPart = targetPart
                        closestDist = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer, closestHitPart
end

-- Highlight the target player
local function applyHighlight(plr)
    if plr and plr.Character then
        -- Remove existing highlights
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetChildren()) do
                    if obj:IsA("Highlight") then
                        obj:Destroy()
                    end
                end
            end
        end
        
        -- Add highlight to the target player
        local highlight = Instance.new("Highlight")
        highlight.Parent = plr.Character
        highlight.FillColor = Color3.fromRGB(102, 102, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    end
end

-- UI setup (customizable button)
local ui = Instance.new("ScreenGui")
local button = Instance.new("ImageButton")
local uiCorner = Instance.new("UICorner")

ui.Name = "CustomUI"
ui.Parent = CoreGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.ResetOnSpawn = false

button.Name = "ControlButton"
button.Parent = ui
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.BackgroundTransparency = 0.3
button.Size = UDim2.new(0, 100, 0, 100)
button.Image = "rbxassetid://11322415498"
button.Position = UDim2.new(0.5, -50, 0.5, -50)

uiCorner.CornerRadius = UDim.new(0.2, 0)
uiCorner.Parent = button

-- Toggle feature on click
button.MouseButton1Click:Connect(function()
    active = not active
    if active then
        button.Image = "rbxassetid://11322415498"
        currentTarget, currentPart = getClosestEnemy()
        if currentTarget then
            applyHighlight(currentTarget)
        end
    else
        button.Image = "rbxassetid://134820707156642"
        if currentTarget and currentTarget.Character then
            for _, obj in pairs(currentTarget.Character:GetChildren()) do
                if obj:IsA("Highlight") then
                    obj:Destroy()
                end
            end
        end
        currentTarget, currentPart = nil, nil
    end
end)

-- Heartbeat function to handle shooting
RunService.Heartbeat:Connect(function()
    if getgenv().yena.Aimbot.Enabled and currentPart then
        -- Logic to force shooting (e.g., Simulate a shot or trigger an event)
        local localPosition = LocalPlayer.Character.HumanoidRootPart.Position
        local shootDirection = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
        local targetPosition = localPosition + shootDirection * 10
        
        local args = {
            [1] = "Shoot",
            [2] = {
                [1] = { ["Part"] = currentPart, ["Position"] = localPosition },
                [2] = { ["Part"] = currentPart, ["Position"] = targetPosition }
            }
        }
        
        -- Fire the shoot event
        ReplicatedStorage.MainEvent:FireServer(unpack(args))
    end
end)

-- Custom metatable hook for aim prediction (adjustments to 'Hit' property)
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

oldIndex = hookmetamethod(game, "__index", NoVirtualize(function(t, k)
    if not checkcaller() and active and typeof(t) == "Instance" and t:IsA("Mouse") and k == "Hit" then
        if getgenv().yena.Aimbot.Prediction.Enabled and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(getgenv().yena.Aimbot.HitPart) then
            local targetPart = currentTarget.Character[getgenv().yena.Aimbot.HitPart]
            local predictedPos = targetPart.Position + (currentTarget.Character.Head.Velocity * getgenv().yena.Aimbot.Prediction.Strength.X)
            return CFrame.new(predictedPos)
        end
    end
    return oldIndex(t, k)
end))

setreadonly(mt, true)
