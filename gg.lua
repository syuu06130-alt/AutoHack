-- 🔥 大砲を作ろう 全RemoteテストHub v2.0 🔥 (お金1~全Remote GUIテスト)
-- TurtleSpy + IY + 全ハック + AutoFarm試作

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- 🌟 Infinite Yield (;help / ;remotespy / ;fly / ;speed 200)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- 🕵️ TurtleSpy (ショップ触ってRemoteSpy&Fire)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()

-- 💰 全leaderstats 9兆ループ (お金/飛距離/全部)
spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if player.leaderstats then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    stat.Value = 9999999999999
                    print("💰 全stats無限: " .. stat.Name)
                end
            end
        end)
    end
end)

-- 👻 壁抜け + 超速 + フライ (自動)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 200
    hum.JumpPower = 200
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    print("👻 壁抜け+超速ON | ;fly で飛行")
end)

-- 🔍 全Remote自動収集 (ReplicatedStorage全探索)
local remotes = {}
for _, obj in ipairs(RS:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        table.insert(remotes, obj)
        print("Remote #" .. #remotes .. ": " .. obj:GetFullName())
    end
end
print("🔍 全Remote数: " .. #remotes .. "個 | GUIでテスト開始！")

-- 🚀 GUI作成 (お金1~お金20 ボタン | タップで全10パターンFireServer)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "RemoteTestHub"
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0.4, 0, 0.8, 0)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "🔥 Remoteテスト (お金1~)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local sf = Instance.new("ScrollingFrame", frame)
sf.Size = UDim2.new(1,0,0.85,0)
sf.Position = UDim2.new(0,0,0.1,0)
sf.BackgroundTransparency = 1
sf.ScrollBarThickness = 10

local autofarm = Instance.new("TextButton", frame)
autofarm.Size = UDim2.new(1,0,0.1,0)
autofarm.Position = UDim2.new(0,0,0.95,0)
autofarm.Text = "🚀 AutoFarm ON (全Remoteスパム)"
autofarm.TextColor3 = Color3.new(1,1,0)
autofarm.BackgroundColor3 = Color3.new(0,0.5,0)
autofarm.TextScaled = true

-- テストパターン (10種: ショップ系推測)
local testArgs = {
    {},  -- なし
    {"TNT", 999},
    {"Barrel", 999},
    {"Cannon", 999},
    {"Part", 999},
    {1, 999},
    {"Buy", true},
    {"Purchase", 1},
    {"Explosive", 999},
    {"Money", 999999}
}

-- ボタン生成 (お金1~20 or 全Remote)
local btnY = 0
local maxTest = math.min(20, #remotes)
for i = 1, maxTest do
    local btn = Instance.new("TextButton", sf)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0,5, 0, btnY)
    btn.Text = "💰 お金" .. i
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.new(0.2, 0.5, 1)
    btn.TextScaled = true
    btnY = btnY + 45
    
    btn.MouseButton1Click:Connect(function()
        print("🧪 テスト開始: お金" .. i .. " 全10パターン")
        for j, args in ipairs(testArgs) do
            pcall(function()
                remotes[i]:FireServer(unpack(args))
                print("   パターン" .. j .. ": " .. table.concat(args, ", "))
            end)
            task.wait(0.1)
        end
        print("✅ お金" .. i .. " テスト完了！ 金増えた？ Console見て！")
    end)
end
sf.CanvasSize = UDim2.new(0,0,0, btnY)

-- AutoFarm (全Remote全パターン無限スパム)
local afLoop = false
autofarm.MouseButton1Click:Connect(function()
    afLoop = not afLoop
    autofarm.Text = afLoop and "🚫 AutoFarm STOP" or "🚀 AutoFarm ON"
    autofarm.BackgroundColor3 = afLoop and Color3.new(0.8,0,0) or Color3.new(0,0.5,0)
    spawn(function()
        while afLoop do
            for i = 1, #remotes do
                for _, args in ipairs(testArgs) do
                    pcall(function() remotes[i]:FireServer(unpack(args)) end)
                end
            end
            task.wait(0.1)
        end
    end)
end)

print("🎉 Hubロード完了！ GUIタップ → Console確認 → 反応リプして！ | ;help でIYコマンド")
