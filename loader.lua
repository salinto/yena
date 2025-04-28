-- Function to handle no virtualization (for hooking metamethods)
function LPH_NO_VIRTUALIZE(f) return f end;

-- Roblox services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuration table (Updated for compatibility with exploits)
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
    },
}

-- Helper functions
local function findNearestEnemy()
    local ClosestDistance, ClosestPlayer, ClosestPart = math.huge, nil, nil
    for _, Player in pairs(game.Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                local Part = Character:FindFirstChild(getgenv().yena.Aimbot.HitPart)
                if Part then
                    local Position = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Part.Position)
                    if Position then
                        local Distance = (LocalPlayer.Character[getgenv().yena.Aimbot.HitPart].Position - Part.Position).Magnitude
                        if Distance < ClosestDistance then
                            ClosestPlayer = Player
                            ClosestPart = Part
                            ClosestDistance = Distance
                        end
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestPart
end

-- Function to draw FOV (if enabled)
local function drawFOV()
    if getgenv().yena.Aimbot.FOV.Visible then
        local radius = getgenv().yena.Aimbot.FOV.Radius.Size
        -- FOV drawing logic (create a circle GUI or use something similar for visualization)
    end
end

-- Metamethod hook for prediction in the aimbot
local function hookPrediction()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)

    hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(t, k)
        if not checkcaller() and getgenv().yena.Aimbot.Enabled then
            if typeof(t) == "Instance" and t:IsA("Mouse") and k == "Hit" then
                local Target = findNearestEnemy()
                if Target and Target[2] then
                    local predictedPos = Target[2].Position + (Target[2].Velocity * getgenv().yena.Aimbot.Prediction.Strength.X)
                    return CFrame.new(predictedPos)
                end
            end
        end
        return oldIndex(t, k)
    end))
end

-- Toggle aimbot and silent aim
local aimbotEnabled = false
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        -- Enable aimbot
        -- Call any function to enable features
        hookPrediction()
    else
        -- Disable aimbot
        -- Disable any active features
    end
end

-- User Input
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode[getgenv().yena.Aimbot.Keybind] then
        toggleAimbot()
    end
end)

-- Main execution loop
RunService.Heartbeat:Connect(function()
    -- If aimbot is enabled, execute prediction and smooth aiming logic
    if aimbotEnabled then
        local TargetPlayer, TargetPart = findNearestEnemy()
        if TargetPlayer and TargetPart then
            -- Additional aimbot logic such as smoothness, etc.
            -- Execute any other actions like fire server events or apply other logic
        end
    end

    -- FOV drawing and visualization
    drawFOV()
end)

-- Set default metatable (ensure compatibility with exploits)
local mt = getrawmetatable(game)
setreadonly(mt, true)
