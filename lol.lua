-- 🔥 大砲を作ろう 神AutoFarm Hub v3.0 🔥 (Purchase + Fire + 全ハック)
-- TurtleSpy Remote直撃！ 自動1位確定

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- 🌟 Infinite Yield (;fly / ;speed 200 / ;noclip / ;god / ;tp)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- 🕵️ TurtleSpy (さらにRemote確認)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()

-- 💰 全leaderstats 9兆ループ（金/飛距離即無限）
spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if player.leaderstats then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    stat.Value = 9999999999999
                    print("💰 " .. stat.Name .. " = 9兆")
                end
            end
        end)
    end
end)

-- 👻 壁抜け + 超速 + 無敵（自動）
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 200
    hum.JumpPower = 200
    hum.JumpHeight = 200
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    print("👻 壁抜け+超速ON | ;god で無敵")
end)

-- 🛒 購入Remote (PurchaseItemWithCash)
local purchaseRemote = RS.Remotes.PurchaseItemWithCash

-- 🔥 アイテムリスト（ゲーム説明+Present Blockから推測・全買いOK）
local items = {
    "Present Block",  -- 君のキャプチャ
    "TNT", "Explosive", "Bomb",  -- 爆発物
    "Barrel", "Fuel Barrel",  -- バレル
    "Cannon Part", "Tube", "Base", "Wheel", "Part"  -- パーツ
}

-- 🚀 AutoBuyループ（全アイテムSpam買い）
local autoBuyLoop = false
spawn(function()
    while autoBuyLoop do
        for _, item in ipairs(items) do
            pcall(function()
                purchaseRemote:FireServer(item, "Part")
                print("🛒 自動買い: " .. item)
            end)
        end
        RS.Remotes.GetPlayerState:InvokeServer(player)  -- ステート更新
        task.wait(0.05)  -- 高速Spam
    end
end)

-- 💥 発射Remote (FireCannonRequest)
local fireRemote = RS.Remotes.FireCannonRequest

-- ⚡ AutoFireループ（飛距離爆増）
local autoFireLoop = false
spawn(function()
    while autoFireLoop do
        pcall(function()
            fireRemote:FireServer()
            print("💥 自動発射！")
        end)
        RS.Remotes.GetPlayerState:InvokeServer(player)
        task.wait(1)  -- 発射クールダウン調整（調整して）
    end
end)

-- 🎮 GUI（ON/OFF超簡単）
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "CannonGodHub"
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0.35,0,0.6,0)
frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.12,0)
title.Text = "🔥 神AutoFarm v3.0"
title.TextColor3 = Color3.new(1,1,0)
title.BackgroundTransparency = 1
title.TextScaled = true

local buyBtn = Instance.new("TextButton", frame)
buyBtn.Size = UDim2.new(1,0,0.15,0)
buyBtn.Position = UDim2.new(0,0,0.15,0)
buyBtn.Text = "🛒 AutoBuy OFF"
buyBtn.BackgroundColor3 = Color3.new(1,0,0)
buyBtn.TextScaled = true
buyBtn.MouseButton1Click:Connect(function()
    autoBuyLoop = not autoBuyLoop
    buyBtn.Text = autoBuyLoop and "🛒 AutoBuy ON" or "🛒 AutoBuy OFF"
    buyBtn.BackgroundColor3 = autoBuyLoop and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

local fireBtn = Instance.new("TextButton", frame)
fireBtn.Size = UDim2.new(1,0,0.15,0)
fireBtn.Position = UDim2.new(0,0,0.35,0)
fireBtn.Text = "💥 AutoFire OFF"
fireBtn.BackgroundColor3 = Color3.new(1,0,0)
fireBtn.TextScaled = true
fireBtn.MouseButton1Click:Connect(function()
    autoFireLoop = not autoFireLoop
    fireBtn.Text = autoFireLoop and "💥 AutoFire ON" or "💥 AutoFire OFF"
    fireBtn.BackgroundColor3 = autoFireLoop and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

local itemsList = Instance.new("TextLabel", frame)
itemsList.Size = UDim2.new(1,0,0.5,0)
itemsList.Position = UDim2.new(0,0,0.55,0)
itemsList.Text = "アイテム: Present Block, TNT, Barrel...\nConsoleで確認！"
itemsList.TextColor3 = Color3.new(1,1,1)
itemsList.BackgroundTransparency = 1
itemsList.TextScaled = true

print("🎉 v3.0ロード完了！ GUIタップ → AutoBuy ON → AutoFire ON → 放置で1位！")

-- ステート同期ループ（バックグラウンド）
spawn(function()
    while task.wait(2) do
        RS.Remotes.GetPlayerState:InvokeServer(player)
    end
end)
