-- 🔥 大砲を作ろう $Cash無限Farm v6.0 🔥 (AutoFire + Projectile神ハック)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

-- 🌟 Infinite Yield (;fly ;noclip ;speed 300 ;tp 0 100 500 ;unanchor ;fling)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- 👻 壁抜け + 超速 (自動)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 300
    hum.JumpPower = 300
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    print("👻 超速+壁抜けON | ;fly ;tp で調整")
end)

local fireRemote = RS.Remotes.FireCannonRequest
local stateRemote = RS.Remotes.GetPlayerState
local purchaseRemote = RS.Remotes.PurchaseItemWithCash

-- 💰 Cash監視print (変化即確認)
spawn(function()
    local lastCash = 0
    while task.wait(1) do
        pcall(function()
            local cash = player.leaderstats and player.leaderstats:FindFirstChild("cash")
            if cash then
                if cash.Value > lastCash then
                    print("💵 $Cash増加: " .. lastCash .. " → " .. cash.Value .. " (+ " .. (cash.Value - lastCash) .. ")")
                end
                lastCash = cash.Value
            end
            stateRemote:InvokeServer(player)  -- 同期
        end)
    end
end)

-- 🏗️ 本物大砲AutoBuild (Base + Barrel + TNT15個積み)
local function buildCannon()
    local charRoot = player.Character.HumanoidRootPart
    local pos = charRoot.Position + Vector3.new(0, 5, 20)
    
    -- Base (Anchored)
    local base = Instance.new("Part", WS)
    base.Name = "CannonBase"
    base.Size = Vector3.new(10, 2, 10)
    base.Position = pos
    base.Anchored = true
    base.BrickColor = BrickColor.new("Dark stone grey")
    
    -- Barrel (長め)
    local barrel = Instance.new("Part", WS)
    barrel.Name = "CannonBarrel"
    barrel.Size = Vector3.new(3, 3, 30)
    barrel.Position = pos + Vector3.new(0, 2, 20)
    barrel.Anchored = true
    barrel.BrickColor = BrickColor.new("Really black")
    
    -- TNT爆発物15個 (管内積み)
    for i = 1, 15 do
        local tnt = Instance.new("Part", WS)
        tnt.Name = "TNT"
        tnt.Size = Vector3.new(2.5, 2.5, 2.5)
        tnt.Position = barrel.Position + Vector3.new(0, 0, -10 + i * 1.8)
        tnt.BrickColor = BrickColor.new("Bright red")
    end
    print("🏗️ 最強大砲構築完了！ Fireで$Cash稼ぎ開始")
end

-- 💥 Projectile（砲弾）神ハック監視 (生成即無限飛距離)
local projectileNames = {"Projectile", "Cannonball", "Shell", "Blast", "Cannon", "Rocket"}
WS.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") then
        for _, name in ipairs(projectileNames) do
            if string.find(child.Name:lower(), name:lower()) then
                spawn(function()
                    task.wait(0.1)  -- 生成待機
                    if child.Parent then
                        child.AssemblyLinearVelocity = Vector3.new(0, 50, 1000000)  -- 超高速前方
                        child.Position = child.Position + Vector3.new(0, 0, 100000)  -- TP遠く
                        child.CanCollide = false
                        print("🚀 Projectile神ハック: " .. child.Name .. " → 無限飛距離！")
                    end
                end)
                break
            end
        end
    end
end)

-- 🔥 Auto Cash Farm (Fire無限 + Build)
local farmLoop = false
spawn(function()
    while farmLoop do
        buildCannon()  -- 毎回再構築
        pcall(function() fireRemote:FireServer() end)
        stateRemote:InvokeServer(player)
        print("💥 AutoFire → $Cash増加待機...")
        task.wait(0.8)  -- クールダウン（調整）
    end
end)

-- 🛒 オプション: 無料/安パーツAutoBuy (初回cash貯め)
local freeItems = {"Wood Block", "Basic Part", "Present Block", "Part"}
local autoBuy = false
spawn(function()
    while autoBuy do
        for _, item in ipairs(freeItems) do
            pcall(function()
                purchaseRemote:FireServer(item, "Part")
            end)
        end
        task.wait(0.2)
    end
end)

-- 🎮 GUI (ドラッグOK・Cash特化)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "CashGodHub"
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0.4,0,0.6,0)
frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(0,20,50)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.12,0)
title.Text = "💵 $Cash無限 v6.0"
title.TextColor3 = Color3.new(1,1,0)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

local farmBtn = Instance.new("TextButton", frame)
farmBtn.Size = UDim2.new(1,0,0.18,0)
farmBtn.Position = UDim2.new(0,0,0.15,0)
farmBtn.Text = "💥 $Cash Farm OFF"
farmBtn.BackgroundColor3 = Color3.new(1,0,0)
farmBtn.TextScaled = true
farmBtn.Parent = frame
farmBtn.MouseButton1Click:Connect(function()
    farmLoop = not farmLoop
    farmBtn.Text = farmLoop and "💥 $Cash Farm ON" or "💥 $Cash Farm OFF"
    farmBtn.BackgroundColor3 = farmLoop and Color3.new(0,1,0) or Color3.new(1,0,0)
end)

local buyBtn = Instance.new("TextButton", frame)
buyBtn.Size = UDim2.new(1,0,0.18,0)
buyBtn.Position = UDim2.new(0,0,0.38,0)
buyBtn.Text = "🛒 無料パーツBuy OFF"
buyBtn.BackgroundColor3 = Color3.new(0.5,0.5,1)
buyBtn.TextScaled = true
buyBtn.Parent = frame
buyBtn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    buyBtn.Text = autoBuy and "🛒 無料パーツBuy ON" or "🛒 無料パーツBuy OFF"
    buyBtn.BackgroundColor3 = autoBuy and Color3.new(0,0.8,1) or Color3.new(0.5,0.5,1)
end)

local buildBtn = Instance.new("TextButton", frame)
buildBtn.Size = UDim2.new(1,0,0.18,0)
buildBtn.Position = UDim2.new(0,0,0.61,0)
buildBtn.Text = "🏗️ 大砲構築"
buildBtn.BackgroundColor3 = Color3.new(0,0.8,0)
buildBtn.TextScaled = true
buildBtn.Parent = frame
buildBtn.MouseButton1Click:Connect(buildCannon)

local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(1,0,0.25,0)
info.Position = UDim2.new(0,0,0.82,0)
info.Text = "1. 🏗️構築\n2. 💥 Farm ON\n3. Consoleで$Cash増加確認\n→放置で兆！\n;flyで狙い"
info.TextColor3 = Color3.new(1,1,1)
info.BackgroundTransparency = 1
info.TextScaled = true
info.TextWrapped = true
info.Parent = frame

print("🎉 v6.0ロード！ Consoleで「$Cash増加」待機 → 1位+金持ち！")
