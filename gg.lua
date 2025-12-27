-- 🔥 大砲を作ろう モバイル全無限チート v1.2 🔥
-- 全leaderstats自動9兆！ RemoteSpy + 壁抜け + スピード

-- RemoteSpy（ショップRemote自動確認）
loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()

-- 🌟 全leaderstats無限ループ（金/飛距離/全部9兆！）
local player = game.Players.LocalPlayer
spawn(function()
    while task.wait(0.3) do  -- 速くループ
        pcall(function()
            if player:FindFirstChild("leaderstats") then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        stat.Value = 9999999999999  -- 9兆！
                        -- 名前表示（Consoleで確認）
                        print("💰 無限にした: " .. stat.Name .. " = 9兆")
                    end
                end
            end
        end)
    end
end)

-- 🛒 全Remote一覧（Consoleで金/ショップRemote探せ）
print("🔍 全Remote一覧（Console見て！）:")
for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print("🛒 Remote: " .. obj:GetFullName())
    end
end

-- ⚡ 壁抜け + スピード + ジャンプ無限
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 200  -- 超速
    hum.JumpPower = 200
    hum.JumpHeight = 200
    -- 壁抜け全パーツ
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    print("👻 壁抜け + 超速ON！")
end)

print("🎉 全無限チート実行完了！ Console開いてstats/Remote確認→1位取れ！")
