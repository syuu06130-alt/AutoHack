-- 🔥 大砲を作ろう OP Hub v1.0 by Grok (2025/12/27) 🔥
-- 解析: ReplicatedStorage Remotes自動検出 / Leaderstats AutoHack / 物理チート全載

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 🌟 Infinite Yield (全コマンド解放: ;money 1e12 / ;fly / ;speed 100 / ;noclip / ;remotespy / ;help)
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- 💰 Infinite Money Auto (金/ Cash/ Money/ コイン検出→1兆ループ)
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if player:FindFirstChild("leaderstats") then
                for _, stat in pairs(player.leaderstats:GetChildren()) do
                    local name = string.lower(stat.Name)
                    if name:find("money") or name:find("cash") or name:find("金") or name:find("coin") or name:find("コイン") then
                        stat.Value = 9.999999999e12
                    end
                    -- 飛距離も弄る（念のため）
                    if name:find("distance") or name:find("飛距離") or name:find("farthest") then
                        stat.Value = 9.999999999e12
                    end
                end
            end
        end)
    end
end)

-- ✈️ Fly (Fキー: カメラ連動高速飛行 / 大砲調整神)
local flying = false
local flySpeed = 100
local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
bodyVelocity.Parent = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or nil

UIS.InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.F then
        flying = not flying
        print("Fly:", flying and "ON" or "OFF")
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        bodyVelocity.Parent = root
        if flying then
            local cam = workspace.CurrentCamera
            local dir = (cam.CFrame.LookVector * (UIS:IsKeyDown(Enum.KeyCode.W) and flySpeed or 0)) +
                        (cam.CFrame.RightVector * (UIS:IsKeyDown(Enum.KeyCode.D) and flySpeed or (UIS:IsKeyDown(Enum.KeyCode.A) and -flySpeed or 0))) +
                        (cam.CFrame.UpVector * (UIS:IsKeyDown(Enum.KeyCode.Space) and flySpeed or (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and -flySpeed or 0)))
            bodyVelocity.Velocity = dir
        else
            bodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- 👻 Noclip (Xキー: 壁/床抜け / 障害物回避100%)
local noclipping = false
UIS.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.X then
        noclipping = not noclipping
        print("Noclip:", noclipping and "ON" or "OFF")
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not noclipping
                end
            end
        end
    end
end)
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    char.ChildAdded:Connect(function(child)
        if noclipping and child:IsA("BasePart") then
            child.CanCollide = false
        end
    end)
end)

-- 🔍 Remote全自動検出&Print (F9でBuy系探せ→IY ;loopremote でSpam)
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print("🛒 Remote:", obj:GetFullName())
    end
end

-- ⚡ Speed/Jumpブースト (自動)
player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = 100
    hum.JumpPower = 100
    hum.JumpHeight = 100
end)

print("🎉 【大砲を作ろう Hub LOADED】 F:Fly | X:Noclip | ;help (IY) | Console(F9)でRemote確認！1位取れ！")
