if not game:IsLoaded() then
    game.Loaded:Wait()
end

local yena = getgenv().yena

if not yena then
    return warn("[Yena Loader] No config found!")
end

if yena.Aimbot and yena.Aimbot.Enabled then
    print("[Aimbot] Enabled - HitPart: " .. yena.Aimbot.HitPart)
end

if yena.SilentAim and yena.SilentAim.Enabled then
    print("[SilentAim] Enabled")
end

if yena.TriggerBot and yena.TriggerBot.Enabled then
    print("[TriggerBot] Enabled")
end

if yena.Movement and yena.Movement.Enabled then
    print("[Movement] Enabled - Speed: " .. yena.Movement.WalkSpeed.Speed.Modified)
end
