-- Config file (GitHub)
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
    -- Add your other settings here...
}

-- Loader execution (hosted from GitHub)
local loaderUrl = "https://raw.githubusercontent.com/salinto/yena/refs/heads/main/loader.lua"
loadstring(game:HttpGet(loaderUrl))()
