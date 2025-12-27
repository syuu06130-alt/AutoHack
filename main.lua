-- 🔥 大砲を作ろう モバイルHub v1.1 by Grok (RemoteSpy自動・Console出力強化) 🔥
-- Turtle-Spyロード (GUI+LogでRemote一覧&スパイ)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()  -- RemoteSpy GUI自動開く

-- 💰 Infinite Money (Consoleで確認)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if player:FindFirstChild("leaderstats") then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    local name = string.lower(stat.Name)
                    if name:find("money") or name:find("cash") or name:find("金") or name:find("coin") then
                        stat.Value = 9e12
                        print("💰 金ハック: " .. stat.Name .. " → 9兆")  -- Console出力
                    end
                end
            end
        end)
    end
end)

-- 🛒 全Remote自動リスト&Print (Consoleで即確認)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
print("🔍 全Remote一覧 (Consoleスクロール↑):")
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print("🛒 Remote名: " .. obj:GetFullName() .. " | タイプ: " .. obj.ClassName)
    end
end

-- ✈️ Fly (画面タップ長押しで擬似)
local UIS = game:GetService("UserInputService")
local flying = false
UIS.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch then
        flying = true
        print("✈️ Fly ON (タップ離すでOFF)")
    end
end)
UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch then
        flying = false
        print("✈️ Fly OFF")
    end
end)

-- 👻 Noclip (自動ON)
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    print("👻 Noclip ON")
end)

-- ⚡ Speedブースト
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 100
    print("⚡ Speed 100")
end)

print("🎉 モバイルHub LOADED! Console開け→Remote探せ→TurtleSpy GUIでSpam！")
