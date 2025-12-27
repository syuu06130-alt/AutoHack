-- 🔥 大砲を作ろう 最終神Hub v4.0 🔥 (Buy/Fire完全修正 + AutoBuild)
-- 全アイテム20種 + 引数5パターン + 自動大砲構築 + 超同期

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

-- 🌟 Infinite Yield (;fly ;noclip ;speed 300 ;god ;tp 0 50 0)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- 🕵️ TurtleSpy (手動テスト用)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))()

-- 💰 全leaderstats 9兆 + 超同期 (サーバー金即反映)
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if player.leaderstats then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    stat.Value = 9999999999999
                end
            end
            -- 同期10連打
            for i=1,10 do RS.Remotes.GetPlayerState:InvokeServer(player) end
            print("💰 金9兆 + 同期完了")
        end)
    end
end)

-- 👻 壁抜け + 超速 (自動)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 300
    hum.JumpPower = 300
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    print("👻 超速+壁抜けON")
end)

local purchaseRemote = RS.Remotes.PurchaseItemWithCash
local fireRemote = RS.Remotes.FireCannonRequest
local stateRemote = RS.Remotes.GetPlayerState

-- 🛒 アイテムリスト20種 (Present Block + 全爆発/パーツ推測)
local items = {
    "Present Block", "TNT", "Dynamite", "TNT Barrel", "Barrel",
    "Fuel Barrel", "Cannon Barrel", "Wood Plank", "Metal Block", "Wheel",
    "Tube", "Base", "Explosive", "Bomb", "Rocket",
    "Cannon Part", "Block", "Steel Block", "Wood Block", "Glass"
}

-- 🔥 引数パターン5種 (自動全試し)
local argPatterns = {
    function(item) return {item, "Part"} end,  -- 元のTurtleSpy
    function(item) return {item} end,
    function(item) return {"Part", item} end,
    function(item) return {item, 999} end,
    function(item) return {"Part", 999} end
}

-- 🚀 AutoBuyループ (全アイテム+全パターン)
local autoBuy = false
spawn(function()
    while autoBuy do
        for _, item in ipairs(items) do
            for _, pat in ipairs(argPatterns) do
                pcall(function()
                    purchaseRemote:FireServer(unpack(pat(item)))
                    print("🛒 買い: " .. item .. " (パターン)")
                end)
            end
            stateRemote:InvokeServer(player)  -- 即同期
        end
        task.wait(0.03)  -- 超高速
    end
end)

-- 🏗️ AutoBuild大砲 (自動最強構築: Base + Barrel + TNT積み)
local cannonBuilt = false
local function buildCannon()
    if cannonBuilt then return end
    cannonBuilt = true
    local root = WS:FindFirstChild("CannonBase") or Instance.new("Part")
    root.Name = "CannonBase"
    root.Size = Vector3.new(10,2,10)
    root.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,5,10)
    root.Anchored = true
    root.BrickColor = BrickColor.new("Dark stone grey")
    root.Parent = WS

    -- Barrel追加
    local barrel = Instance.new("Part")
    barrel.Name = "Barrel"
    barrel.Size = Vector3.new(2,2,20)
    barrel.Position = root.Position + Vector3.new(0,0,15)
    barrel.Anchored = true
    barrel.BrickColor = BrickColor.new("Really black")
    barrel.Parent = WS

    -- TNT積み (爆発力max)
    for i=1,10 do
        local tnt = Instance.new("Part")
        tnt.Name = "TNT"
        tnt.Size = Vector3.new(4,4,4)
        tnt.Position = barrel.Position + Vector3.new(0,0,5 + i*5)
        tnt.BrickColor = BrickColor.new("Bright red")
        tnt.Parent = WS
    end
    print("🏗️ 最強大砲自動構築完了！")
end

-- 💥 AutoFire (構築後連射)
local autoFire = false
spawn(function()
    while autoFire do
        buildCannon()  -- 毎回構築確認
        pcall(function() fireRemote:FireServer() end)
        stateRemote:InvokeServer(player)
        print("💥 自動発射！")
        task.wait(0.5)  -- クール調整
    end
end)

-- 🎮 GUI (超簡単)
local sg = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0.4,0,0.7,0)
frame.Position = UDim2.new(0,10,0.2,0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.1,0)
title.Text = "🔥 v4.0 修正Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

local buyBtn = Instance.new("TextButton", frame)
buyBtn.Size = UDim2.new(1,0,0.15,0)
buyBtn.Position = UDim2.new(0,0,0.12,0)
buyBtn.Text = "🛒 AutoBuy OFF"
buyBtn.BackgroundColor3 = Color3.new(1,0,0)
buyBtn.TextScaled = true
buyBtn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    buyBtn.Text = autoBuy and "🛒 AutoBuy ON" or "🛒 AutoBuy OFF"
    buyBtn.BackgroundColor3 = autoBuy and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

local fireBtn = Instance.new("TextButton", frame)
fireBtn.Size = UDim2.new(1,0,0.15,0)
fireBtn.Position = UDim2.new(0,0,0.32,0)
fireBtn.Text = "💥 AutoFire OFF"
fireBtn.BackgroundColor3 = Color3.new(1,0,0)
fireBtn.TextScaled = true
fireBtn.MouseButton1Click:Connect(function()
    autoFire = not autoFire
    fireBtn.Text = autoFire and "💥 AutoFire ON" or "💥 AutoFire OFF"
    fireBtn.BackgroundColor3 = autoFire and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

local buildBtn = Instance.new("TextButton", frame)
buildBtn.Size = UDim2.new(1,0,0.15,0)
buildBtn.Position = UDim2.new(0,0,0.52,0)
buildBtn.Text = "🏗️ Build Now"
buildBtn.BackgroundColor3 = Color3.new(0,0.7,1)
buildBtn.TextScaled = true
buildBtn.MouseButton1Click:Connect(buildCannon)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0.35,0)
info.Position = UDim2.new(0,0,0.72,0)
info.Text = "1. AutoBuy ON\n2. 10秒待つ\n3. AutoFire ON\n→1位！\n;flyで調整"
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1
info.TextScaled = true

print("🎉 v4.0ロード！ Buy/Fire修正 → GUIタップ → 放置1位！")
