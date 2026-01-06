-- 🔥 タートルスパイ V1.5.3, クレジット: Intrer#0421 🔥
-- (TurtleSpy V1.5.3, credits to Intrer#0421)

local 色設定 =
-- (colorSettings)
{
    ["メイン"] = {
    -- (["Main"])
        ["ヘッダー色"] = Color3.fromRGB(0, 168, 255),
        -- (["HeaderColor"])
        ["ヘッダーシェーディング色"] = Color3.fromRGB(0, 151, 230),
        -- (["HeaderShadingColor"])
        ["ヘッダーテキスト色"] = Color3.fromRGB(47, 54, 64),
        -- (["HeaderTextColor"])
        ["メイン背景色"] = Color3.fromRGB(47, 54, 64),
        -- (["MainBackgroundColor"])
        ["情報スクロールフレーム背景色"] = Color3.fromRGB(47, 54, 64),
        -- (["InfoScrollingFrameBgColor"])
        ["スクロールバー画像色"] = Color3.fromRGB(127, 143, 166)
        -- (["ScrollBarImageColor"])
    },
    ["リモートボタン"] = {
    -- (["RemoteButtons"])
        ["境界色"] = Color3.fromRGB(113, 128, 147),
        -- (["BorderColor"])
        ["背景色"] = Color3.fromRGB(53, 59, 72),
        -- (["BackgroundColor"])
        ["テキスト色"] = Color3.fromRGB(220, 221, 225),
        -- (["TextColor"])
        ["数字テキスト色"] = Color3.fromRGB(203, 204, 207)
        -- (["NumberTextColor"])
    },
    ["メインボタン"] = { 
    -- (["MainButtons"])
        ["境界色"] = Color3.fromRGB(113, 128, 147),
        -- (["BorderColor"])
        ["背景色"] = Color3.fromRGB(53, 59, 72),
        -- (["BackgroundColor"])
        ["テキスト色"] = Color3.fromRGB(220, 221, 225)
        -- (["TextColor"])
    },
    ['コード'] = {
    -- (['Code'])
        ['背景色'] = Color3.fromRGB(35, 40, 48),
        -- (['BackgroundColor'])
        ['テキスト色'] = Color3.fromRGB(220, 221, 225),
        -- (['TextColor'])
        ['クレジット色'] = Color3.fromRGB(108, 108, 108)
        -- (['CreditsColor'])
    },
}

local 設定 = {
-- (settings)
["キーバインド"] = "P"
-- (["Keybind"])
}

if PROTOSMASHER_LOADED then
    getgenv().isfile = newcclosure(function(ファイル)
    -- (File)
        local 成功, エラー = pcall(readfile, ファイル)
        -- (Suc, Er) (File)
        if not 成功 then
        -- (Suc)
            return false
        end
        return true
    end)
end

local Httpサービス = game:GetService("HttpService")
-- (HttpService)
-- キーバインドの設定を読み込む
-- (read settings for keybind)
if not isfile("TurtleSpySettings.json") then
    writefile("TurtleSpySettings.json", Httpサービス:JSONEncode(設定))
    -- (HttpService) (settings)
else
    if Httpサービス:JSONDecode(readfile("TurtleSpySettings.json"))["Main"] then
    -- (HttpService)
        writefile("TurtleSpySettings.json", Httpサービス:JSONEncode(設定))
        -- (HttpService) (settings)
    else
        設定 = Httpサービス:JSONDecode(readfile("TurtleSpySettings.json"))
        -- (settings) (HttpService)
    end
end

-- プロトスマッシャーの互換性: sdjsdj (v3rm username) にクレジット
-- (Compatibility for protosmasher: credits to sdjsdj (v3rm username) for converting to proto)

function isSynapse()
    if PROTOSMASHER_LOADED then
        return false
    else
    return true
    end
end
function 親(GUI)
-- (Parent)
    if syn and syn.protect_gui then
        syn.protect_gui(GUI)
        GUI.Parent = game:GetService("CoreGui")
    elseif PROTOSMASHER_LOADED then
        GUI.Parent = get_hidden_gui()
    else
        GUI.Parent = game:GetService("CoreGui")
    end
end

local クライアント = game.Players.LocalPlayer
-- (client)
local function toUnicode(文字列)
-- (string)
    local コードポイント = "utf8.char("
    -- (codepoints)
    
    for _i, v in utf8.codes(文字列) do
    -- (string)
        コードポイント = コードポイント .. v .. ', '
        -- (codepoints)
    end
    
    return コードポイント:sub(1, -3) .. ')'
    -- (codepoints)
end
local function インスタンスのフルパスを取得(インスタンス)
-- (GetFullPathOfAnInstance) (instance)
    local 名前 = インスタンス.Name
    -- (name) (instance)
    local ヘッド = (#名前 > 0 and '.' .. 名前) or "['']"
    -- (head) (name) (name)
    
    if not インスタンス.Parent and インスタンス ~= game then
    -- (instance) (instance)
        return ヘッド .. " --[[ 親がnilまたは破壊された ]]"
        -- (head) (PARENTED TO NIL OR DESTROYED)
    end
    
    if インスタンス == game then
    -- (instance)
        return "game"
    elseif インスタンス == workspace then
    -- (instance)
        return "workspace"
    else
        local _成功, 結果 = pcall(game.GetService, game, インスタンス.ClassName)
        -- (_success, result) (instance)
        
        if 結果 then
        -- (result)
            ヘッド = ':GetService("' .. インスタンス.ClassName .. '")'
            -- (head) (instance)
        elseif インスタンス == クライアント then
        -- (instance) (client)
            ヘッド = '.LocalPlayer' 
            -- (head)
        else
            local 非英数字 = 名前:gsub('[%w_]', '')
            -- (nonAlphaNum) (name)
            local 句読点なし = 非英数字:gsub('[%s%p]', '')
            -- (noPunct) (nonAlphaNum)
            
            if tonumber(名前:sub(1, 1)) or (#非英数字 ~= 0 and #句読点なし == 0) then
            -- (name) (nonAlphaNum) (noPunct)
                ヘッド = '["' .. 名前:gsub('"', '\\"'):gsub('\\', '\\\\') .. '"]'
                -- (head) (name)
            elseif #非英数字 ~= 0 and #句読点なし > 0 then
            -- (nonAlphaNum) (noPunct)
                ヘッド = '[' .. toUnicode(名前) .. ']'
                -- (head) (name)
            end
        end
    end
    
    return インスタンスのフルパスを取得(インスタンス.Parent) .. ヘッド
    -- (GetFullPathOfAnInstance) (instance) (head)
end
-- メインスクリプト
-- (Main Script)

-- game関数の参照 (namecallフック内のnamecallを防ぐため)
-- (references to game functions (to prevent using namecall inside of a namecall hook))
local isA = game.IsA
local clone = game.Clone

local テキストサービス = game:GetService("TextService")
-- (TextService)
local テキストサイズ取得 = テキストサービス.GetTextSize
-- (getTextSize) (TextService)
game.StarterGui.ResetPlayerGuiOnSpawn = false
local マウス = game.Players.LocalPlayer:GetMouse()
-- (mouse)

-- 以前のTurtleSpyインスタンスを削除
-- (delete the previous instances of turtlespy)
if game.CoreGui:FindFirstChild("TurtleSpyGUI") then
    game.CoreGui.TurtleSpyGUI:Destroy()
end

-- 重要なテーブルとGUIオフセット
-- (Important tables and GUI offsets)
local ボタンオフセット = -25
-- (buttonOffset)
local スクロールサイズオフセット = 287
-- (scrollSizeOffset)
local 関数画像 = "http://www.roblox.com/asset/?id=413369623"
-- (functionImage)
local イベント画像 = "http://www.roblox.com/asset/?id=413369506"
-- (eventImage)
local リモート = {}
-- (remotes)
local リモート引数 = {}
-- (remoteArgs)
local リモートボタン = {}
-- (remoteButtons)
local リモートスクリプト = {}
-- (remoteScripts)
local 無視リスト = {}
-- (IgnoreList)
local ブロックリスト = {}
-- (BlockList)
local 無視リスト = {}
-- (IgnoreList)
local 接続 = {}
-- (connections)
local 非スタック = {}
-- (unstacked)

-- (mostly) generated code by Gui to lua
local TurtleSpyGUI = Instance.new("ScreenGui")
local メインフレーム = Instance.new("Frame")
-- (mainFrame)
local ヘッダー = Instance.new("Frame")
-- (Header)
local ヘッダーシェーディング = Instance.new("Frame")
-- (HeaderShading)
local ヘッダーテキストラベル = Instance.new("TextLabel")
-- (HeaderTextLabel)
local リモートスクロールフレーム = Instance.new("ScrollingFrame")
-- (RemoteScrollFrame)
local リモートボタン = Instance.new("TextButton")
-- (RemoteButton)
local 数字 = Instance.new("TextLabel")
-- (Number)
local リモート名 = Instance.new("TextLabel")
-- (RemoteName)
local リモートアイコン = Instance.new("ImageLabel")
-- (RemoteIcon)
local 情報フレーム = Instance.new("Frame")
-- (InfoFrame)
local 情報フレームヘッダー = Instance.new("Frame")
-- (InfoFrameHeader)
local 情報タイトルシェーディング = Instance.new("Frame")
-- (InfoTitleShading)
local コードフレーム = Instance.new("ScrollingFrame")
-- (CodeFrame)
local コード = Instance.new("TextLabel")
-- (Code)
local コードコメント = Instance.new("TextLabel")
-- (CodeComment)
local 情報ヘッダーテキスト = Instance.new("TextLabel")
-- (InfoHeaderText)
local 情報ボタンスクロール = Instance.new("ScrollingFrame")
-- (InfoButtonsScroll)
local コードコピー = Instance.new("TextButton")
-- (CopyCode)
local コード実行 = Instance.new("TextButton")
-- (RunCode)
local スクリプトパスコピー = Instance.new("TextButton")
-- (CopyScriptPath)
local デコンパイルコピー = Instance.new("TextButton")
-- (CopyDecompiled)
local リモート無視 = Instance.new("TextButton")
-- (IgnoreRemote)
local リモートブロック = Instance.new("TextButton")
-- (BlockRemote)
local ループ生成 = Instance.new("TextButton")
-- (WhileLoop)
local リターンコピー = Instance.new("TextButton")
-- (CopyReturn)
local クリア = Instance.new("TextButton")
-- (Clear)
local フレーム区切り = Instance.new("Frame")
-- (FrameDivider)
local 情報フレーム閉じる = Instance.new("TextButton")
-- (CloseInfoFrame)
local 情報フレーム開く = Instance.new("TextButton")
-- (OpenInfoFrame)
local 最小化 = Instance.new("TextButton")
-- (Minimize)
local 非スタック設定 = Instance.new("TextButton")
-- (DoNotStack)
local 画像ボタン = Instance.new("ImageButton")
-- (ImageButton)

-- リモートブラウザ
-- (Remote browser)
local ブラウザヘッダー = Instance.new("Frame")
-- (BrowserHeader)
local ブラウザヘッダーフレーム = Instance.new("Frame")
-- (BrowserHeaderFrame)
local ブラウザヘッダーテキスト = Instance.new("TextLabel")
-- (BrowserHeaderText)
local 情報フレーム閉じる2 = Instance.new("TextButton")
-- (CloseInfoFrame2)
local リモートブラウザフレーム = Instance.new("ScrollingFrame")
-- (RemoteBrowserFrame)
local リモートボタン2 = Instance.new("TextButton")
-- (RemoteButton2)
local リモート名2 = Instance.new("TextLabel")
-- (RemoteName2)
local リモートアイコン2 = Instance.new("ImageLabel")
-- (RemoteIcon2)

TurtleSpyGUI.Name = "TurtleSpyGUI"

親(TurtleSpyGUI)
-- (Parent)

メインフレーム.Name = "mainFrame"
-- (mainFrame)
メインフレーム.Parent = TurtleSpyGUI
-- (mainFrame)
メインフレーム.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
-- (mainFrame)
メインフレーム.BorderColor3 = Color3.fromRGB(53, 59, 72)
-- (mainFrame)
メインフレーム.Position = UDim2.new(0.100000001, 0, 0.239999995, 0)
-- (mainFrame)
メインフレーム.Size = UDim2.new(0, 207, 0, 35)
-- (mainFrame)
メインフレーム.ZIndex = 8
-- (mainFrame)
メインフレーム.Active = true
-- (mainFrame)
メインフレーム.Draggable = true
-- (mainFrame)

-- リモートブラウザのプロパティ
-- (Remote browser properties)

ブラウザヘッダー.Name = "BrowserHeader"
-- (BrowserHeader)
ブラウザヘッダー.Parent = TurtleSpyGUI
-- (BrowserHeader)
ブラウザヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (BrowserHeader) (colorSettings["Main"]["HeaderShadingColor"])
ブラウザヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (BrowserHeader) (colorSettings["Main"]["HeaderShadingColor"])
ブラウザヘッダー.Position = UDim2.new(0.712152421, 0, 0.339464903, 0)
-- (BrowserHeader)
ブラウザヘッダー.Size = UDim2.new(0, 207, 0, 33)
-- (BrowserHeader)
ブラウザヘッダー.ZIndex = 20
-- (BrowserHeader)
ブラウザヘッダー.Active = true
-- (BrowserHeader)
ブラウザヘッダー.Draggable = true
-- (BrowserHeader)
ブラウザヘッダー.Visible = false
-- (BrowserHeader)

ブラウザヘッダーフレーム.Name = "BrowserHeaderFrame"
-- (BrowserHeaderFrame)
ブラウザヘッダーフレーム.Parent = ブラウザヘッダー
-- (BrowserHeaderFrame) (BrowserHeader)
ブラウザヘッダーフレーム.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (BrowserHeaderFrame) (colorSettings["Main"]["HeaderColor"])
ブラウザヘッダーフレーム.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (BrowserHeaderFrame) (colorSettings["Main"]["HeaderColor"])
ブラウザヘッダーフレーム.Position = UDim2.new(0, 0, -0.0202544238, 0)
-- (BrowserHeaderFrame)
ブラウザヘッダーフレーム.Size = UDim2.new(0, 207, 0, 26)
-- (BrowserHeaderFrame)
ブラウザヘッダーフレーム.ZIndex = 21
-- (BrowserHeaderFrame)

ブラウザヘッダーテキスト.Name = "InfoHeaderText"
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.Parent = ブラウザヘッダーフレーム
-- (BrowserHeaderText) (BrowserHeaderFrame)
ブラウザヘッダーテキスト.BackgroundTransparency = 1.000
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.Position = UDim2.new(0, 0, -0.00206991332, 0)
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.Size = UDim2.new(0, 206, 0, 33)
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.ZIndex = 22
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.Font = Enum.Font.SourceSans
-- (BrowserHeaderText)
ブラウザヘッダーテキスト.Text = "リモートブラウザ"
-- (BrowserHeaderText) (Remote Browser)
ブラウザヘッダーテキスト.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"]
-- (BrowserHeaderText) (colorSettings["Main"]["HeaderTextColor"])
ブラウザヘッダーテキスト.TextSize = 17.000
-- (BrowserHeaderText)

情報フレーム閉じる2.Name = "CloseInfoFrame"
-- (CloseInfoFrame2)
情報フレーム閉じる2.Parent = ブラウザヘッダーフレーム
-- (CloseInfoFrame2) (BrowserHeaderFrame)
情報フレーム閉じる2.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (CloseInfoFrame2) (colorSettings["Main"]["HeaderColor"])
情報フレーム閉じる2.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (CloseInfoFrame2) (colorSettings["Main"]["HeaderColor"])
情報フレーム閉じる2.Position = UDim2.new(0, 185, 0, 2)
-- (CloseInfoFrame2)
情報フレーム閉じる2.Size = UDim2.new(0, 22, 0, 22)
-- (CloseInfoFrame2)
情報フレーム閉じる2.ZIndex = 38
-- (CloseInfoFrame2)
情報フレーム閉じる2.Font = Enum.Font.SourceSansLight
-- (CloseInfoFrame2)
情報フレーム閉じる2.Text = "X"
-- (CloseInfoFrame2)
情報フレーム閉じる2.TextColor3 = Color3.fromRGB(0, 0, 0)
-- (CloseInfoFrame2)
情報フレーム閉じる2.TextSize = 20.000
-- (CloseInfoFrame2)
情報フレーム閉じる2.MouseButton1Click:Connect(function()
-- (CloseInfoFrame2)
    ブラウザヘッダー.Visible = not ブラウザヘッダー.Visible
    -- (BrowserHeader) (BrowserHeader)
end)

リモートブラウザフレーム.Name = "RemoteBrowserFrame"
-- (RemoteBrowserFrame)
リモートブラウザフレーム.Parent = ブラウザヘッダー
-- (RemoteBrowserFrame) (BrowserHeader)
リモートブラウザフレーム.Active = true
-- (RemoteBrowserFrame)
リモートブラウザフレーム.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
-- (RemoteBrowserFrame)
リモートブラウザフレーム.BorderColor3 = Color3.fromRGB(47, 54, 64)
-- (RemoteBrowserFrame)
リモートブラウザフレーム.Position = UDim2.new(-0.004540205, 0, 1.03504682, 0)
-- (RemoteBrowserFrame)
リモートブラウザフレーム.Size = UDim2.new(0, 207, 0, 286)
-- (RemoteBrowserFrame)
リモートブラウザフレーム.ZIndex = 19
-- (RemoteBrowserFrame)
リモートブラウザフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
-- (RemoteBrowserFrame)
リモートブラウザフレーム.ScrollBarThickness = 8
-- (RemoteBrowserFrame)
リモートブラウザフレーム.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
-- (RemoteBrowserFrame)
リモートブラウザフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"]
-- (RemoteBrowserFrame) (colorSettings["Main"]["ScrollBarImageColor"])

リモートボタン2.Name = "RemoteButton"
-- (RemoteButton2)
リモートボタン2.Parent = リモートブラウザフレーム
-- (RemoteButton2) (RemoteBrowserFrame)
リモートボタン2.BackgroundColor3 = 色設定["リモートボタン"]["背景色"]
-- (RemoteButton2) (colorSettings["RemoteButtons"]["BackgroundColor"])
リモートボタン2.BorderColor3 = 色設定["リモートボタン"]["境界色"]
-- (RemoteButton2) (colorSettings["RemoteButtons"]["BorderColor"])
リモートボタン2.Position = UDim2.new(0, 17, 0, 10)
-- (RemoteButton2)
リモートボタン2.Size = UDim2.new(0, 182, 0, 26)
-- (RemoteButton2)
リモートボタン2.ZIndex = 20
-- (RemoteButton2)
リモートボタン2.Selected = true
-- (RemoteButton2)
リモートボタン2.Font = Enum.Font.SourceSans
-- (RemoteButton2)
リモートボタン2.Text = ""
-- (RemoteButton2)
リモートボタン2.TextSize = 18.000
-- (RemoteButton2)
リモートボタン2.TextStrokeTransparency = 123.000
-- (RemoteButton2)
リモートボタン2.TextWrapped = true
-- (RemoteButton2)
リモートボタン2.TextXAlignment = Enum.TextXAlignment.Left
-- (RemoteButton2)
リモートボタン2.Visible = false
-- (RemoteButton2)

リモート名2.Name = "RemoteName2"
-- (RemoteName2)
リモート名2.Parent = リモートボタン2
-- (RemoteName2) (RemoteButton2)
リモート名2.BackgroundTransparency = 1.000
-- (RemoteName2)
リモート名2.Position = UDim2.new(0, 5, 0, 0)
-- (RemoteName2)
リモート名2.Size = UDim2.new(0, 155, 0, 26)
-- (RemoteName2)
リモート名2.ZIndex = 21
-- (RemoteName2)
リモート名2.Font = Enum.Font.SourceSans
-- (RemoteName2)
リモート名2.Text = "RemoteEventaasdadad"
-- (RemoteName2)
リモート名2.TextColor3 = 色設定["リモートボタン"]["テキスト色"]
-- (RemoteName2) (colorSettings["RemoteButtons"]["TextColor"])
リモート名2.TextSize = 16.000
-- (RemoteName2)
リモート名2.TextXAlignment = Enum.TextXAlignment.Left
-- (RemoteName2)
リモート名2.TextTruncate = 1
-- (RemoteName2)


リモートアイコン2.Name = "RemoteIcon2"
-- (RemoteIcon2)
リモートアイコン2.Parent = リモートボタン2
-- (RemoteIcon2) (RemoteButton2)
リモートアイコン2.BackgroundTransparency = 1.000
-- (RemoteIcon2)
リモートアイコン2.Position = UDim2.new(0.840260386, 0, 0.0225472748, 0)
-- (RemoteIcon2)
リモートアイコン2.Size = UDim2.new(0, 24, 0, 24)
-- (RemoteIcon2)
リモートアイコン2.ZIndex = 21
-- (RemoteIcon2)
リモートアイコン2.Image = 関数画像
-- (RemoteIcon2) (functionImage)

local ブラウズされたリモート = {}
-- (browsedRemotes)
local ブラウズされた接続 = {}
-- (browsedConnections)
local ブラウズボタンオフセット = 10
-- (browsedButtonOffset)
local ブラウザキャンバスサイズ = 286
-- (browserCanvasSize)

画像ボタン.Parent = ヘッダー
-- (ImageButton) (Header)
画像ボタン.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
-- (ImageButton)
画像ボタン.BackgroundTransparency = 1.000
-- (ImageButton)
画像ボタン.Position = UDim2.new(0, 8, 0, 8)
-- (ImageButton)
画像ボタン.Size = UDim2.new(0, 18, 0, 18)
-- (ImageButton)
画像ボタン.ZIndex = 9
-- (ImageButton)
画像ボタン.Image = "rbxassetid://169476802"
-- (ImageButton)
画像ボタン.ImageColor3 = Color3.fromRGB(53, 53, 53)
-- (ImageButton)
画像ボタン.MouseButton1Click:Connect(function()
-- (ImageButton)
    ブラウザヘッダー.Visible = not ブラウザヘッダー.Visible
    -- (BrowserHeader) (BrowserHeader)
    for i, v in pairs(game:GetDescendants()) do
        if isA(v, "RemoteEvent") or isA(v, "RemoteFunction") then
            local bボタン = clone(リモートボタン2)
            -- (bButton) (RemoteButton2)
            bボタン.Parent = リモートブラウザフレーム
            -- (bButton) (RemoteBrowserFrame)
            bボタン.Visible = true
            -- (bButton)
            bボタン.Position = UDim2.new(0, 17, 0, ブラウズボタンオフセット)
            -- (bButton) (browsedButtonOffset)
            local 発火関数 = ""
            -- (fireFunction)
            if isA(v, "RemoteEvent") then
                発火関数 = ":FireServer()"
                -- (fireFunction)
                bボタン.RemoteIcon2.Image = イベント画像
                -- (bButton) (eventImage)
            else
                発火関数 = ":InvokeServer()"
                -- (fireFunction)
            end
            bボタン.RemoteName2.Text = v.Name
            -- (bButton)
            local 接続 = bボタン.MouseButton1Click:Connect(function()
            -- (connection) (bButton)
                setclipboard(インスタンスのフルパスを取得(v)..発火関数)
                -- (GetFullPathOfAnInstance) (fireFunction)
            end)
            table.insert(ブラウズされた接続, 接続)
            -- (browsedConnections, connection)
            ブラウズボタンオフセット = ブラウズボタンオフセット + 35
            -- (browsedButtonOffset)

            if #ブラウズされた接続 > 8 then
            -- (browsedConnections)
                ブラウザキャンバスサイズ = ブラウザキャンバスサイズ + 35
                -- (browserCanvasSize)
                リモートブラウザフレーム.CanvasSize = UDim2.new(0, 0, 0, ブラウザキャンバスサイズ)
                -- (RemoteBrowserFrame) (browserCanvasSize)
            end
        end
    end
end)

マウス.KeyDown:Connect(function(キー)
-- (mouse) (key)
    if キー:lower() == 設定["キーバインド"]:lower() then
    -- (key) (settings["Keybind"])
        TurtleSpyGUI.Enabled = not TurtleSpyGUI.Enabled
    end
end)

ヘッダー.Name = "Header"
-- (Header)
ヘッダー.Parent = メインフレーム
-- (Header) (mainFrame)
ヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (Header) (colorSettings["Main"]["HeaderColor"])
ヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (Header) (colorSettings["Main"]["HeaderColor"])
ヘッダー.Size = UDim2.new(0, 207, 0, 26)
-- (Header)
ヘッダー.ZIndex = 9
-- (Header)

ヘッダーシェーディング.Name = "HeaderShading"
-- (HeaderShading)
ヘッダーシェーディング.Parent = ヘッダー
-- (HeaderShading) (Header)
ヘッダーシェーディング.BackgroundColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (HeaderShading) (colorSettings["Main"]["HeaderShadingColor"])
ヘッダーシェーディング.BorderColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (HeaderShading) (colorSettings["Main"]["HeaderShadingColor"])
ヘッダーシェーディング.Position = UDim2.new(1.46719131e-07, 0, 0.285714358, 0)
-- (HeaderShading)
ヘッダーシェーディング.Size = UDim2.new(0, 207, 0, 27)
-- (HeaderShading)
ヘッダーシェーディング.ZIndex = 8
-- (HeaderShading)

ヘッダーテキストラベル.Name = "HeaderTextLabel"
-- (HeaderTextLabel)
ヘッダーテキストラベル.Parent = ヘッダーシェーディング
-- (HeaderTextLabel) (HeaderShading)
ヘッダーテキストラベル.BackgroundTransparency = 1.000
-- (HeaderTextLabel)
ヘッダーテキストラベル.Position = UDim2.new(-0.00507604145, 0, -0.202857122, 0)
-- (HeaderTextLabel)
ヘッダーテキストラベル.Size = UDim2.new(0, 215, 0, 29)
-- (HeaderTextLabel)
ヘッダーテキストラベル.ZIndex = 10
-- (HeaderTextLabel)
ヘッダーテキストラベル.Font = Enum.Font.SourceSans
-- (HeaderTextLabel)
ヘッダーテキストラベル.Text = "Turtle Spy"
-- (HeaderTextLabel)
ヘッダーテキストラベル.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"]
-- (HeaderTextLabel) (colorSettings["Main"]["HeaderTextColor"])
ヘッダーテキストラベル.TextSize = 17.000
-- (HeaderTextLabel)

リモートスクロールフレーム.Name = "RemoteScrollFrame"
-- (RemoteScrollFrame)
リモートスクロールフレーム.Parent = メインフレーム
-- (RemoteScrollFrame) (mainFrame)
リモートスクロールフレーム.Active = true
-- (RemoteScrollFrame)
リモートスクロールフレーム.BackgroundColor3 = Color3.fromRGB(47, 54, 64)
-- (RemoteScrollFrame)
リモートスクロールフレーム.BorderColor3 = Color3.fromRGB(47, 54, 64)
-- (RemoteScrollFrame)
リモートスクロールフレーム.Position = UDim2.new(0, 0, 1.02292562, 0)
-- (RemoteScrollFrame)
リモートスクロールフレーム.Size = UDim2.new(0, 207, 0, 286)
-- (RemoteScrollFrame)
リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
-- (RemoteScrollFrame)
リモートスクロールフレーム.ScrollBarThickness = 8
-- (RemoteScrollFrame)
リモートスクロールフレーム.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
-- (RemoteScrollFrame)
リモートスクロールフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"]
-- (RemoteScrollFrame) (colorSettings["Main"]["ScrollBarImageColor"])

リモートボタン.Name = "RemoteButton"
-- (RemoteButton)
リモートボタン.Parent = リモートスクロールフレーム
-- (RemoteButton) (RemoteScrollFrame)
リモートボタン.BackgroundColor3 = 色設定["リモートボタン"]["背景色"]
-- (RemoteButton) (colorSettings["RemoteButtons"]["BackgroundColor"])
リモートボタン.BorderColor3 = 色設定["リモートボタン"]["境界色"]
-- (RemoteButton) (colorSettings["RemoteButtons"]["BorderColor"])
リモートボタン.Position = UDim2.new(0, 17, 0, 10)
-- (RemoteButton)
リモートボタン.Size = UDim2.new(0, 182, 0, 26)
-- (RemoteButton)
リモートボタン.Selected = true
-- (RemoteButton)
リモートボタン.Font = Enum.Font.SourceSans
-- (RemoteButton)
リモートボタン.Text = ""
-- (RemoteButton)
リモートボタン.TextColor3 = Color3.fromRGB(220, 221, 225)
-- (RemoteButton)
リモートボタン.TextSize = 18.000
-- (RemoteButton)
リモートボタン.TextStrokeTransparency = 123.000
-- (RemoteButton)
リモートボタン.TextWrapped = true
-- (RemoteButton)
リモートボタン.TextXAlignment = Enum.TextXAlignment.Left
-- (RemoteButton)
リモートボタン.Visible = false
-- (RemoteButton)

数字.Name = "Number"
-- (Number)
数字.Parent = リモートボタン
-- (Number) (RemoteButton)
数字.BackgroundTransparency = 1.000
-- (Number)
数字.Position = UDim2.new(0, 5, 0, 0)
-- (Number)
数字.Size = UDim2.new(0, 300, 0, 26)
-- (Number)
数字.ZIndex = 2
-- (Number)
数字.Font = Enum.Font.SourceSans
-- (Number)
数字.Text = "1"
-- (Number)
数字.TextColor3 = 色設定["リモートボタン"]["数字テキスト色"]
-- (Number) (colorSettings["RemoteButtons"]["NumberTextColor"])
数字.TextSize = 16.000
-- (Number)
数字.TextWrapped = true
-- (Number)
数字.TextXAlignment = Enum.TextXAlignment.Left
-- (Number)

リモート名.Name = "RemoteName"
-- (RemoteName)
リモート名.Parent = リモートボタン
-- (RemoteName) (RemoteButton)
リモート名.BackgroundTransparency = 1.000
-- (RemoteName)
リモート名.Position = UDim2.new(0, 20, 0, 0)
-- (RemoteName)
リモート名.Size = UDim2.new(0, 134, 0, 26)
-- (RemoteName)
リモート名.Font = Enum.Font.SourceSans
-- (RemoteName)
リモート名.Text = "RemoteEvent"
-- (RemoteName)
リモート名.TextColor3 = 色設定["リモートボタン"]["テキスト色"]
-- (RemoteName) (colorSettings["RemoteButtons"]["TextColor"])
リモート名.TextSize = 16.000
-- (RemoteName)
リモート名.TextXAlignment = Enum.TextXAlignment.Left
-- (RemoteName)
リモート名.TextTruncate = 1
-- (RemoteName)

リモートアイコン.Name = "RemoteIcon"
-- (RemoteIcon)
リモートアイコン.Parent = リモートボタン
-- (RemoteIcon) (RemoteButton)
リモートアイコン.BackgroundTransparency = 1.000
-- (RemoteIcon)
リモートアイコン.Position = UDim2.new(0.840260386, 0, 0.0225472748, 0)
-- (RemoteIcon)
リモートアイコン.Size = UDim2.new(0, 24, 0, 24)
-- (RemoteIcon)
リモートアイコン.Image = "http://www.roblox.com/asset/?id=413369506"
-- (RemoteIcon)

情報フレーム.Name = "InfoFrame"
-- (InfoFrame)
情報フレーム.Parent = メインフレーム
-- (InfoFrame) (mainFrame)
情報フレーム.BackgroundColor3 = 色設定["メイン"]["メイン背景色"]
-- (InfoFrame) (colorSettings["Main"]["MainBackgroundColor"])
情報フレーム.BorderColor3 = 色設定["メイン"]["メイン背景色"]
-- (InfoFrame) (colorSettings["Main"]["MainBackgroundColor"])
情報フレーム.Position = UDim2.new(0.368141592, 0, -5.58035717e-05, 0)
-- (InfoFrame)
情報フレーム.Size = UDim2.new(0, 357, 0, 322)
-- (InfoFrame)
情報フレーム.Visible = false
-- (InfoFrame)
情報フレーム.ZIndex = 6
-- (InfoFrame)

情報フレームヘッダー.Name = "InfoFrameHeader"
-- (InfoFrameHeader)
情報フレームヘッダー.Parent = 情報フレーム
-- (InfoFrameHeader) (InfoFrame)
情報フレームヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (InfoFrameHeader) (colorSettings["Main"]["HeaderColor"])
情報フレームヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (InfoFrameHeader) (colorSettings["Main"]["HeaderColor"])
情報フレームヘッダー.Size = UDim2.new(0, 357, 0, 26)
-- (InfoFrameHeader)
情報フレームヘッダー.ZIndex = 14
-- (InfoFrameHeader)

情報タイトルシェーディング.Name = "InfoTitleShading"
-- (InfoTitleShading)
情報タイトルシェーディング.Parent = 情報フレーム
-- (InfoTitleShading) (InfoFrame)
情報タイトルシェーディング.BackgroundColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (InfoTitleShading) (colorSettings["Main"]["HeaderShadingColor"])
情報タイトルシェーディング.BorderColor3 = 色設定["メイン"]["ヘッダーシェーディング色"]
-- (InfoTitleShading) (colorSettings["Main"]["HeaderShadingColor"])
情報タイトルシェーディング.Position = UDim2.new(-0.00280881394, 0, 0, 0)
-- (InfoTitleShading)
情報タイトルシェーディング.Size = UDim2.new(0, 358, 0, 34)
-- (InfoTitleShading)
情報タイトルシェーディング.ZIndex = 13
-- (InfoTitleShading)

コードフレーム.Name = "CodeFrame"
-- (CodeFrame)
コードフレーム.Parent = 情報フレーム
-- (CodeFrame) (InfoFrame)
コードフレーム.Active = true
-- (CodeFrame)
コードフレーム.BackgroundColor3 = 色設定["コード"]["背景色"]
-- (CodeFrame) (colorSettings["Code"]["BackgroundColor"])
コードフレーム.BorderColor3 = 色設定["コード"]["背景色"]
-- (CodeFrame) (colorSettings["Code"]["BackgroundColor"])
コードフレーム.Position = UDim2.new(0.0391303748, 0, 0.141156405, 0)
-- (CodeFrame)
コードフレーム.Size = UDim2.new(0, 329, 0, 63)
-- (CodeFrame)
コードフレーム.ZIndex = 16
-- (CodeFrame)
コードフレーム.CanvasSize = UDim2.new(0, 670, 2, 0)
-- (CodeFrame)
コードフレーム.ScrollBarThickness = 8
-- (CodeFrame)
コードフレーム.ScrollingDirection = 1
-- (CodeFrame)
コードフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"]
-- (CodeFrame) (colorSettings["Main"]["ScrollBarImageColor"])

コード.Name = "Code"
-- (Code)
コード.Parent = コードフレーム
-- (Code) (CodeFrame)
コード.BackgroundTransparency = 1.000
-- (Code)
コード.Position = UDim2.new(0.00888902973, 0, 0.0394801199, 0)
-- (Code)
コード.Size = UDim2.new(0, 100000, 0, 25)
-- (Code)
コード.ZIndex = 18
-- (Code)
コード.Font = Enum.Font.SourceSans
-- (Code)
コード.Text = "Turtle Spyを使ってくれてありがとう！ :D"
-- (Code) (Thanks for using Turtle Spy! :D)
コード.TextColor3 = 色設定["コード"]["テキスト色"]
-- (Code) (colorSettings["Code"]["TextColor"])
コード.TextSize = 14.000
-- (Code)
コード.TextWrapped = true
-- (Code)
コード.TextXAlignment = Enum.TextXAlignment.Left
-- (Code)

コードコメント.Name = "CodeComment"
-- (CodeComment)
コードコメント.Parent = コードフレーム
-- (CodeComment) (CodeFrame)
コードコメント.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
-- (CodeComment)
コードコメント.BackgroundTransparency = 1.000
-- (CodeComment)
コードコメント.Position = UDim2.new(0.0119285434, 0, -0.001968503, 0)
-- (CodeComment)
コードコメント.Size = UDim2.new(0, 1000, 0, 25)
-- (CodeComment)
コードコメント.ZIndex = 18
-- (CodeComment)
コードコメント.Font = Enum.Font.SourceSans
-- (CodeComment)
コードコメント.Text = "-- TurtleSpyによって生成されたスクリプト, 作成者: Intrer#0421"
-- (CodeComment) (-- Script generated by TurtleSpy, made by Intrer#0421)
コードコメント.TextColor3 = 色設定["コード"]["クレジット色"]
-- (CodeComment) (colorSettings["Code"]["CreditsColor"])
コードコメント.TextSize = 14.000
-- (CodeComment)
コードコメント.TextXAlignment = Enum.TextXAlignment.Left
-- (CodeComment)

情報ヘッダーテキスト.Name = "InfoHeaderText"
-- (InfoHeaderText)
情報ヘッダーテキスト.Parent = 情報フレーム
-- (InfoHeaderText) (InfoFrame)
情報ヘッダーテキスト.BackgroundTransparency = 1.000
-- (InfoHeaderText)
情報ヘッダーテキスト.Position = UDim2.new(0.0391303934, 0, -0.00206972216, 0)
-- (InfoHeaderText)
情報ヘッダーテキスト.Size = UDim2.new(0, 342, 0, 35)
-- (InfoHeaderText)
情報ヘッダーテキスト.ZIndex = 18
-- (InfoHeaderText)
情報ヘッダーテキスト.Font = Enum.Font.SourceSans
-- (InfoHeaderText)
情報ヘッダーテキスト.Text = "情報: RemoteFunction"
-- (InfoHeaderText) (Info: RemoteFunction)
情報ヘッダーテキスト.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"]
-- (InfoHeaderText) (colorSettings["Main"]["HeaderTextColor"])
情報ヘッダーテキスト.TextSize = 17.000
-- (InfoHeaderText)

情報ボタンスクロール.Name = "InfoButtonsScroll"
-- (InfoButtonsScroll)
情報ボタンスクロール.Parent = 情報フレーム
-- (InfoButtonsScroll) (InfoFrame)
情報ボタンスクロール.Active = true
-- (InfoButtonsScroll)
情報ボタンスクロール.BackgroundColor3 = 色設定["メイン"]["メイン背景色"]
-- (InfoButtonsScroll) (colorSettings["Main"]["MainBackgroundColor"])
情報ボタンスクロール.BorderColor3 = 色設定["メイン"]["メイン背景色"]
-- (InfoButtonsScroll) (colorSettings["Main"]["MainBackgroundColor"])
情報ボタンスクロール.Position = UDim2.new(0.0391303748, 0, 0.355857909, 0)
-- (InfoButtonsScroll)
情報ボタンスクロール.Size = UDim2.new(0, 329, 0, 199)
-- (InfoButtonsScroll)
情報ボタンスクロール.ZIndex = 11
-- (InfoButtonsScroll)
情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1, 0)
-- (InfoButtonsScroll)
情報ボタンスクロール.ScrollBarThickness = 8
-- (InfoButtonsScroll)
情報ボタンスクロール.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
-- (InfoButtonsScroll)
情報ボタンスクロール.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"]
-- (InfoButtonsScroll) (colorSettings["Main"]["ScrollBarImageColor"])

コードコピー.Name = "CopyCode"
-- (CopyCode)
コードコピー.Parent = 情報ボタンスクロール
-- (CopyCode) (InfoButtonsScroll)
コードコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (CopyCode) (colorSettings["MainButtons"]["BackgroundColor"])
コードコピー.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (CopyCode) (colorSettings["MainButtons"]["BorderColor"])
コードコピー.Position = UDim2.new(0.0645, 0, 0, 10)
-- (CopyCode)
コードコピー.Size = UDim2.new(0, 294, 0, 26)
-- (CopyCode)
コードコピー.ZIndex = 15
-- (CopyCode)
コードコピー.Font = Enum.Font.SourceSans
-- (CopyCode)
コードコピー.Text = "コードをコピー"
-- (CopyCode) (Copy code)
コードコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (CopyCode)
コードコピー.TextSize = 16.000
-- (CopyCode)

コード実行.Name = "RunCode"
-- (RunCode)
コード実行.Parent = 情報ボタンスクロール
-- (RunCode) (InfoButtonsScroll)
コード実行.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (RunCode) (colorSettings["MainButtons"]["BackgroundColor"])
コード実行.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (RunCode) (colorSettings["MainButtons"]["BorderColor"])
コード実行.Position = UDim2.new(0.0645, 0, 0, 45)
-- (RunCode)
コード実行.Size = UDim2.new(0, 294, 0, 26)
-- (RunCode)
コード実行.ZIndex = 15
-- (RunCode)
コード実行.Font = Enum.Font.SourceSans
-- (RunCode)
コード実行.Text = "実行"
-- (RunCode) (Execute)
コード実行.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (RunCode)
コード実行.TextSize = 16.000
-- (RunCode)

スクリプトパスコピー.Name = "CopyScriptPath"
-- (CopyScriptPath)
スクリプトパスコピー.Parent = 情報ボタンスクロール
-- (CopyScriptPath) (InfoButtonsScroll)
スクリプトパスコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (CopyScriptPath) (colorSettings["MainButtons"]["BackgroundColor"])
スクリプトパスコピー.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (CopyScriptPath) (colorSettings["MainButtons"]["BorderColor"])
スクリプトパスコピー.Position = UDim2.new(0.0645, 0, 0, 80)
-- (CopyScriptPath)
スクリプトパスコピー.Size = UDim2.new(0, 294, 0, 26)
-- (CopyScriptPath)
スクリプトパスコピー.ZIndex = 15
-- (CopyScriptPath)
スクリプトパスコピー.Font = Enum.Font.SourceSans
-- (CopyScriptPath)
スクリプトパスコピー.Text = "スクリプトパスをコピー"
-- (CopyScriptPath) (Copy script path)
スクリプトパスコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (CopyScriptPath)
スクリプトパスコピー.TextSize = 16.000
-- (CopyScriptPath)

デコンパイルコピー.Name = "CopyDecompiled"
-- (CopyDecompiled)
デコンパイルコピー.Parent = 情報ボタンスクロール
-- (CopyDecompiled) (InfoButtonsScroll)
デコンパイルコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (CopyDecompiled) (colorSettings["MainButtons"]["BackgroundColor"])
デコンパイルコピー.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (CopyDecompiled) (colorSettings["MainButtons"]["BorderColor"])
デコンパイルコピー.Position = UDim2.new(0.0645, 0, 0, 115)
-- (CopyDecompiled)
デコンパイルコピー.Size = UDim2.new(0, 294, 0, 26)
-- (CopyDecompiled)
デコンパイルコピー.ZIndex = 15
-- (CopyDecompiled)
デコンパイルコピー.Font = Enum.Font.SourceSans
-- (CopyDecompiled)
デコンパイルコピー.Text = "デコンパイルスクリプトをコピー"
-- (CopyDecompiled) (Copy decompiled script)
デコンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (CopyDecompiled)
デコンパイルコピー.TextSize = 16.000
-- (CopyDecompiled)

リモート無視.Name = "IgnoreRemote"
-- (IgnoreRemote)
リモート無視.Parent = 情報ボタンスクロール
-- (IgnoreRemote) (InfoButtonsScroll)
リモート無視.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (IgnoreRemote) (colorSettings["MainButtons"]["BackgroundColor"])
リモート無視.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (IgnoreRemote) (colorSettings["MainButtons"]["BorderColor"])
リモート無視.Position = UDim2.new(0.0645, 0, 0, 185)
-- (IgnoreRemote)
リモート無視.Size = UDim2.new(0, 294, 0, 26)
-- (IgnoreRemote)
リモート無視.ZIndex = 15
-- (IgnoreRemote)
リモート無視.Font = Enum.Font.SourceSans
-- (IgnoreRemote)
リモート無視.Text = "リモートを無視"
-- (IgnoreRemote) (Ignore remote)
リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (IgnoreRemote)
リモート無視.TextSize = 16.000
-- (IgnoreRemote)

リモートブロック.Name = "Block Remote"
-- (BlockRemote)
リモートブロック.Parent = 情報ボタンスクロール
-- (BlockRemote) (InfoButtonsScroll)
リモートブロック.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (BlockRemote) (colorSettings["MainButtons"]["BackgroundColor"])
リモートブロック.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (BlockRemote) (colorSettings["MainButtons"]["BorderColor"])
リモートブロック.Position = UDim2.new(0.0645, 0, 0, 220)
-- (BlockRemote)
リモートブロック.Size = UDim2.new(0, 294, 0, 26)
-- (BlockRemote)
リモートブロック.ZIndex = 15
-- (BlockRemote)
リモートブロック.Font = Enum.Font.SourceSans
-- (BlockRemote)
リモートブロック.Text = "リモートの発火をブロック"
-- (BlockRemote) (Block remote from firing)
リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (BlockRemote)
リモートブロック.TextSize = 16.000
-- (BlockRemote)

ループ生成.Name = "WhileLoop"
-- (WhileLoop)
ループ生成.Parent = 情報ボタンスクロール
-- (WhileLoop) (InfoButtonsScroll)
ループ生成.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (WhileLoop) (colorSettings["MainButtons"]["BackgroundColor"])
ループ生成.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (WhileLoop) (colorSettings["MainButtons"]["BorderColor"])
ループ生成.Position = UDim2.new(0.0645, 0, 0, 290)
-- (WhileLoop)
ループ生成.Size = UDim2.new(0, 294, 0, 26)
-- (WhileLoop)
ループ生成.ZIndex = 15
-- (WhileLoop)
ループ生成.Font = Enum.Font.SourceSans
-- (WhileLoop)
ループ生成.Text = "whileループスクリプトを生成"
-- (WhileLoop) (Generate while loop script)
ループ生成.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (WhileLoop)
ループ生成.TextSize = 16.000
-- (WhileLoop)

クリア.Name = "Clear"
-- (Clear)
クリア.Parent = 情報ボタンスクロール
-- (Clear) (InfoButtonsScroll)
クリア.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (Clear) (colorSettings["MainButtons"]["BackgroundColor"])
クリア.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (Clear) (colorSettings["MainButtons"]["BorderColor"])
クリア.Position = UDim2.new(0.0645, 0, 0, 255)
-- (Clear)
クリア.Size = UDim2.new(0, 294, 0, 26)
-- (Clear)
クリア.ZIndex = 15
-- (Clear)
クリア.Font = Enum.Font.SourceSans
-- (Clear)
クリア.Text = "ログをクリア"
-- (Clear) (Clear logs)
クリア.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (Clear)
クリア.TextSize = 16.000
-- (Clear)

リターンコピー.Name = "CopyReturn"
-- (CopyReturn)
リターンコピー.Parent = 情報ボタンスクロール
-- (CopyReturn) (InfoButtonsScroll)
リターンコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (CopyReturn) (colorSettings["MainButtons"]["BackgroundColor"])
リターンコピー.BorderColor3 = 色設定["メインボタン"]["境界色"]
-- (CopyReturn) (colorSettings["MainButtons"]["BorderColor"])
リターンコピー.Position = UDim2.new(0.0645, 0, 0, 325)
-- (CopyReturn)
リターンコピー.Size = UDim2.new(0, 294, 0, 26)
-- (CopyReturn)
リターンコピー.ZIndex = 15
-- (CopyReturn)
リターンコピー.Font = Enum.Font.SourceSans
-- (CopyReturn)
リターンコピー.Text = "実行して戻り値をコピー"
-- (CopyReturn) (Execute and copy return value)
リターンコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (CopyReturn)
リターンコピー.TextSize = 16.000
-- (CopyReturn)

非スタック設定.Name = "CopyReturn"
-- (DoNotStack)
非スタック設定.Parent = 情報ボタンスクロール
-- (DoNotStack) (InfoButtonsScroll)
非スタック設定.BackgroundColor3 = 色設定["メインボタン"]["背景色"]
-- (DoNotStack) (colorSettings["MainButtons"]["BackgroundColor"])
非スタック設定.BorderColor3 =  色設定["メインボタン"]["境界色"]
-- (DoNotStack) (colorSettings["MainButtons"]["BorderColor"])
非スタック設定.Position = UDim2.new(0.0645, 0, 0, 150)
-- (DoNotStack)
非スタック設定.Size = UDim2.new(0, 294, 0, 26)
-- (DoNotStack)
非スタック設定.ZIndex = 15
-- (DoNotStack)
非スタック設定.Font = Enum.Font.SourceSans
-- (DoNotStack)
非スタック設定.Text = "新しい引数で発火されたときにリモートを非スタック"
-- (DoNotStack) (Unstack remote when fired with new args)
非スタック設定.TextColor3 = Color3.fromRGB(250, 251, 255)
-- (DoNotStack)
非スタック設定.TextSize = 16.000
-- (DoNotStack)

フレーム区切り.Name = "FrameDivider"
-- (FrameDivider)
フレーム区切り.Parent = 情報フレーム
-- (FrameDivider) (InfoFrame)
フレーム区切り.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
-- (FrameDivider)
フレーム区切り.BorderColor3 = Color3.fromRGB(53, 59, 72)
-- (FrameDivider)
フレーム区切り.Position = UDim2.new(0, 3, 0, 0)
-- (FrameDivider)
フレーム区切り.Size = UDim2.new(0, 4, 0, 322)
-- (FrameDivider)
フレーム区切り.ZIndex = 7
-- (FrameDivider)

local 情報フレーム開いている = false
-- (InfoFrameOpen)
情報フレーム閉じる.Name = "CloseInfoFrame"
-- (CloseInfoFrame)
情報フレーム閉じる.Parent = 情報フレーム
-- (CloseInfoFrame) (InfoFrame)
情報フレーム閉じる.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (CloseInfoFrame) (colorSettings["Main"]["HeaderColor"])
情報フレーム閉じる.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (CloseInfoFrame) (colorSettings["Main"]["HeaderColor"])
情報フレーム閉じる.Position = UDim2.new(0, 333, 0, 2)
-- (CloseInfoFrame)
情報フレーム閉じる.Size = UDim2.new(0, 22, 0, 22)
-- (CloseInfoFrame)
情報フレーム閉じる.ZIndex = 18
-- (CloseInfoFrame)
情報フレーム閉じる.Font = Enum.Font.SourceSansLight
-- (CloseInfoFrame)
情報フレーム閉じる.Text = "X"
-- (CloseInfoFrame)
情報フレーム閉じる.TextColor3 = Color3.fromRGB(0, 0, 0)
-- (CloseInfoFrame)
情報フレーム閉じる.TextSize = 20.000
-- (CloseInfoFrame)
情報フレーム閉じる.MouseButton1Click:Connect(function()
-- (CloseInfoFrame)
    情報フレーム.Visible = false
    -- (InfoFrame)
    情報フレーム開いている = false
    -- (InfoFrameOpen)
    メインフレーム.Size = UDim2.new(0, 207, 0, 35)
    -- (mainFrame)
end)

情報フレーム開く.Name = "OpenInfoFrame"
-- (OpenInfoFrame)
情報フレーム開く.Parent = メインフレーム
-- (OpenInfoFrame) (mainFrame)
情報フレーム開く.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (OpenInfoFrame) (colorSettings["Main"]["HeaderColor"])
情報フレーム開く.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (OpenInfoFrame) (colorSettings["Main"]["HeaderColor"])
情報フレーム開く.Position = UDim2.new(0, 185, 0, 2)
-- (OpenInfoFrame)
情報フレーム開く.Size = UDim2.new(0, 22, 0, 22)
-- (OpenInfoFrame)
情報フレーム開く.ZIndex = 18
-- (OpenInfoFrame)
情報フレーム開く.Font = Enum.Font.SourceSans
-- (OpenInfoFrame)
情報フレーム開く.Text = ">"
-- (OpenInfoFrame)
情報フレーム開く.TextColor3 = Color3.fromRGB(0, 0, 0)
-- (OpenInfoFrame)
情報フレーム開く.TextSize = 16.000
-- (OpenInfoFrame)
情報フレーム開く.MouseButton1Click:Connect(function()
-- (OpenInfoFrame)
	if not 情報フレーム.Visible then
	-- (InfoFrame)
		メインフレーム.Size = UDim2.new(0, 565, 0, 35)
		-- (mainFrame)
		情報フレーム開く.Text = "<"
		-- (OpenInfoFrame)
	elseif リモートスクロールフレーム.Visible then
	-- (RemoteScrollFrame)
		メインフレーム.Size = UDim2.new(0, 207, 0, 35)
		-- (mainFrame)
		情報フレーム開く.Text = ">"
		-- (OpenInfoFrame)
	end
	情報フレーム.Visible = not 情報フレーム.Visible
	-- (InfoFrame) (InfoFrame)
	情報フレーム開いている = not 情報フレーム開いている
	-- (InfoFrameOpen) (InfoFrameOpen)
end)

最小化.Name = "Minimize"
-- (Minimize)
最小化.Parent = メインフレーム
-- (Minimize) (mainFrame)
最小化.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"]
-- (Minimize) (colorSettings["Main"]["HeaderColor"])
最小化.BorderColor3 = 色設定["メイン"]["ヘッダー色"]
-- (Minimize) (colorSettings["Main"]["HeaderColor"])
最小化.Position = UDim2.new(0, 164, 0, 2)
-- (Minimize)
最小化.Size = UDim2.new(0, 22, 0, 22)
-- (Minimize)
最小化.ZIndex = 18
-- (Minimize)
最小化.Font = Enum.Font.SourceSans
-- (Minimize)
最小化.Text = "_"
-- (Minimize)
最小化.TextColor3 = Color3.fromRGB(0, 0, 0)
-- (Minimize)
最小化.TextSize = 16.000
-- (Minimize)
最小化.MouseButton1Click:Connect(function()
-- (Minimize)
	-- 閉じる
	-- (Close)
	if リモートスクロールフレーム.Visible then
	-- (RemoteScrollFrame)
		メインフレーム.Size = UDim2.new(0, 207, 0, 35)
		-- (mainFrame)
		情報フレーム開く.Text = "<"
		-- (OpenInfoFrame)
		情報フレーム.Visible = false
		-- (InfoFrame)
	else
		-- 開く
		-- (Open)
		if 情報フレーム開いている then
		-- (InfoFrameOpen)
		    メインフレーム.Size = UDim2.new(0, 565, 0, 35)
		    -- (mainFrame)
		    情報フレーム開く.Text = "<"
			-- (OpenInfoFrame)
			情報フレーム.Visible = true
			-- (InfoFrame)
		else
			メインフレーム.Size = UDim2.new(0, 207, 0, 35)
			-- (mainFrame)
			情報フレーム開く.Text = ">"
			-- (OpenInfoFrame)
			情報フレーム.Visible = false
			-- (InfoFrame)
		end
	end
	リモートスクロールフレーム.Visible = not リモートスクロールフレーム.Visible
	-- (RemoteScrollFrame) (RemoteScrollFrame)
end)

local function リモート検索(リモート, 引数)
-- (FindRemote) (remote, args)
    local 現在のID = (get_thread_context or syn.get_thread_identity)()
    -- (currentId)
    ;(set_thread_context or syn.set_thread_identity)(7)
    local i
    if table.find(非スタック, リモート) then
    -- (unstacked, remote)
    local リモート数 = 0
    -- (numOfRemotes)
        for b, v in pairs(リモート) do
        -- (remotes)
            if v == リモート then
            -- (remote)
                リモート数 = リモート数 + 1
                -- (numOfRemotes)
                for i2, v2 in pairs(リモート引数) do
                -- (remoteArgs)
                    if table.unpack(リモート引数[b]) == table.unpack(引数) then
                    -- (remoteArgs, args)
                        i = b
                    end
                end
            end
        end
    else
        i = table.find(リモート, リモート)
        -- (remotes, remote)
    end
    ;(set_thread_context or syn.set_thread_identity)(現在のID)
    -- (currentId)
    return i
end

-- シンプルな色とテキスト変更効果を作成
-- (creates a simple color and text change effect)
local function ボタン効果(テキストラベル, テキスト)
-- (ButtonEffect) (textlabel, text)
    if not テキスト then
    -- (text)
        テキスト = "コピーしました！"
        -- (text) (Copied!)
    end
    local 元テキスト = テキストラベル.Text
    -- (orgText) (textlabel)
    local 元色 = テキストラベル.TextColor3
    -- (orgColor) (textlabel)
    テキストラベル.Text = テキスト
    -- (textlabel) (text)
    テキストラベル.TextColor3 = Color3.fromRGB(76, 209, 55)
    -- (textlabel)
    wait(0.8)
    テキストラベル.Text = 元テキスト
    -- (textlabel) (orgText)
    テキストラベル.TextColor3 = 元色
    -- (textlabel) (orgColor)
end

-- 重要な値
-- (important values for later)
local 見ている
-- (lookingAt)
local 見ている引数
-- (lookingAtArgs)
local 見ているボタン
-- (lookingAtButton)

コードコピー.MouseButton1Click:Connect(function()
-- (CopyCode)
    if not 見ている then return end
    -- (lookingAt)
    -- ユーザーがリモートを見ている場合、コードのテキストをクリップボードにコピー
    -- (copy the code's text to clipboard if the user is lookin at a remote)
    setclipboard(コードコメント.Text.. "\n\n"..コード.Text)
    -- (CodeComment) (Code)
    ボタン効果(コードコピー)
    -- (ButtonEffect) (CopyCode)
end)

コード実行.MouseButton1Click:Connect(function()
-- (RunCode)
    -- ユーザーが見ているリモートのインデックスを探す
    -- (find the index of the remote the user is looking at)
    if 見ている then
    -- (lookingAt)
    if isA(見ている, "RemoteFunction") then
    -- (lookingAt)
        -- 引数でリモートを発火
        -- (fire remote with its args)
        見ている:InvokeServer(unpack(見ている引数))
        -- (lookingAt) (lookingAtArgs)
    elseif isA(見ている, "RemoteEvent") then
    -- (lookingAt)
        見ている:FireServer(unpack(見ている引数))
        -- (lookingAt) (lookingAtArgs)
    end
    end
end)
スクリプトパスコピー.MouseButton1Click:Connect(function()
-- (CopyScriptPath)
    -- リモートインデックスを取得
    -- (get remote index)
    local リモート = リモート検索(見ている, 見ている引数)
    -- (remote) (FindRemote) (lookingAt, lookingAtArgs)
    if リモート and 見ている then
    -- (remote) (lookingAt)
        -- そのインデックスのスクリプト名をコピー
        -- (copy the script name at that index)
        setclipboard(インスタンスのフルパスを取得(リモートスクリプト[リモート]))
        -- (GetFullPathOfAnInstance) (remoteScripts[remote])
        ボタン効果(スクリプトパスコピー)
        -- (ButtonEffect) (CopyScriptPath)
    end
end)
-- デコンパイルが同時に実行されないようにするbool
-- (bool to make decompilations queue instead of running simultaneously)
local デコンパイル中
-- (decompiling)
デコンパイルコピー.MouseButton1Click:Connect(function()
-- (CopyDecompiled)
    local リモート = リモート検索(見ている, 見ている引数)
    -- (remote) (FindRemote) (lookingAt, lookingAtArgs)
    if not isSynapse() then
        デコンパイルコピー.Text = "このエクスプロイトはデコンパイルをサポートしていません！"
        -- (CopyDecompiled) (This exploit doesn't support decompilation!)
        デコンパイルコピー.TextColor3 = Color3.fromRGB(232, 65, 24)
        -- (CopyDecompiled)
        wait(1.6)
        デコンパイルコピー.Text = "デコンパイルスクリプトをコピー"
        -- (CopyDecompiled) (Copy decompiled script)
        デコンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
        -- (CopyDecompiled)
        return
    end
    if not デコンパイル中 and リモート and 見ている then
    -- (decompiling) (remote) (lookingAt)
        デコンパイル中 = true
        -- (decompiling)

        -- ボタン効果
        -- (button effect)
        spawn(function()
            while true do
                if デコンパイル中 == false then return end
                -- (decompiling)
                デコンパイルコピー.Text = "デコンパイル中."
                -- (CopyDecompiled) (Decompiling.)
                wait(0.8)
                if デコンパイル中 == false then return end
                -- (decompiling)
                デコンパイルコピー.Text = "デコンパイル中.."
                -- (CopyDecompiled) (Decompiling..)
                wait(0.8)
                if デコンパイル中 == false then return end
                -- (decompiling)
                デコンパイルコピー.Text = "デコンパイル中..."
                -- (CopyDecompiled) (Decompiling...)
                wait(0.8)
            end
        end)

        -- リモートスクリプトをデコンパイル
        -- (Decompile the remotescript of the remote)
        local 成功 = { pcall(function()setclipboard(decompile(リモートスクリプト[リモート]))end) }
        -- (success) (remoteScripts[remote])
        デコンパイル中 = false
        -- (decompiling)
        if 成功[1] then
        -- (success)
            デコンパイルコピー.Text = "デコンパイルをコピーしました！"
            -- (CopyDecompiled) (Copied decompilation!)
            デコンパイルコピー.TextColor3 = Color3.fromRGB(76, 209, 55)
            -- (CopyDecompiled)
        else
            warn(成功[2], 成功[3])
            -- (success)
            デコンパイルコピー.Text = "デコンパイルエラー！ エラーを確認するにはF9をチェック。"
            -- (CopyDecompiled) (Decompilation error! Check F9 to see the error.)
            デコンパイルコピー.TextColor3 = Color3.fromRGB(232, 65, 24)
            -- (CopyDecompiled)
        end
        wait(1.6)
        デコンパイルコピー.Text = "デコンパイルスクリプトをコピー"
        -- (CopyDecompiled) (Copy decompiled script)
        デコンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
        -- (CopyDecompiled)
    end
end)

リモートブロック.MouseButton1Click:Connect(function()
-- (BlockRemote)
    -- ユーザーが見ているリモートを探し、ブロックされているかを確認
    -- (find the remote the user is looking at and check whether it's blocked or not)
    local bリモート = table.find(ブロックリスト, 見ている)
    -- (bRemote) (BlockList, lookingAt)

    if 見ている and not bリモート then
    -- (lookingAt) (bRemote)
        -- リモートがブロックされていない場合、ブロックリストに追加
        -- (remote isn't blocked, add it to the blocklist)
        table.insert(ブロックリスト, 見ている)
        -- (BlockList, lookingAt)
        リモートブロック.Text = "リモートをアンブロック"
        -- (BlockRemote) (Unblock remote)
        リモートブロック.TextColor3 = Color3.fromRGB(251, 197, 49)
        -- (BlockRemote)
        local リモート = table.find(リモート, 見ている)
        -- (remote) (remotes, lookingAt)
        if リモート then
        -- (remote)
            リモートボタン[リモート].Parent.RemoteName.TextColor3 = Color3.fromRGB(225, 177, 44)
            -- (remoteButtons[remote])
        end
    elseif 見ている and bリモート then
    -- (lookingAt) (bRemote)
        -- リモートがブロックされている場合
        -- (remote is)
        table.remove(ブロックリスト, bリモート)
        -- (BlockList, bRemote)
        リモートブロック.Text = "リモートの発火をブロック"
        -- (BlockRemote) (Block remote from firing)
        リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
        -- (BlockRemote)
        local リモート = table.find(リモート, 見ている)
        -- (remote) (remotes, lookingAt)
        if リモート then
        -- (remote)
            リモートボタン[リモート].Parent.RemoteName.TextColor3 = Color3.fromRGB(245, 246, 250)
            -- (remoteButtons[remote])
        end
    end
end)

リモート無視.MouseButton1Click:Connect(function()
-- (IgnoreRemote)
    -- リモートがブロックされているかを確認
    -- (check if remote is blocked)
    local iリモート = table.find(無視リスト, 見ている)
    -- (iRemote) (IgnoreList, lookingAt)
    if 見ている and not iリモート then
    -- (lookingAt) (iRemote)
        table.insert(無視リスト, 見ている)
        -- (IgnoreList, lookingAt)
        リモート無視.Text = "リモートの無視を停止"
        -- (IgnoreRemote) (Stop ignoring remote)
        リモート無視.TextColor3 = Color3.fromRGB(127, 143, 166)
        -- (IgnoreRemote)
        local リモート = table.find(リモート, 見ている)
        -- (remote) (remotes, lookingAt)
        local 非スタック = table.find(非スタック, 見ている)
        -- (unstacked) (unstacked, lookingAt)
        if リモート then
        -- (remote)
            リモートボタン[リモート].Parent.RemoteName.TextColor3 = Color3.fromRGB(127, 143, 166)
            -- (remoteButtons[remote])
        end
    elseif 見ている and iリモート then
    -- (lookingAt) (iRemote)
        table.remove(無視リスト, iリモート)
        -- (IgnoreList, iRemote)
        リモート無視.Text = "リモートを無視"
        -- (IgnoreRemote) (Ignore remote)
        リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
        -- (IgnoreRemote)
        local リモート = table.find(リモート, 見ている)
        -- (remote) (remotes, lookingAt)
        if リモート then
        -- (remote)
            リモートボタン[リモート].Parent.RemoteName.TextColor3 = Color3.fromRGB(245, 246, 250)
            -- (remoteButtons[remote])
        end
    end
end)

ループ生成.MouseButton1Click:Connect(function()
-- (WhileLoop)
    if not 見ている then return end
    -- (lookingAt)
    setclipboard("while wait() do\n   "..コード.Text.."\nend")
    -- (Code)
    ボタン効果(ループ生成)
    -- (ButtonEffect) (WhileLoop)
end)

クリア.MouseButton1Click:Connect(function()
-- (Clear)
    for i, v in pairs(リモートスクロールフレーム:GetChildren()) do
    -- (RemoteScrollFrame)
        if i > 1 then 
        v:Destroy()
        end
    end
    for i, v in pairs(接続) do
    -- (connections)
        v:Disconnect()
    end
    -- すべてをリセット
    -- (reset everything)
    ボタンオフセット = -25
    -- (buttonOffset)
    スクロールサイズオフセット = 0
    -- (scrollSizeOffset)
    リモート = {}
    -- (remotes)
    リモート引数 = {}
    -- (remoteArgs)
    リモートボタン = {}
    -- (remoteButtons)
    リモートスクリプト = {}
    -- (remoteScripts)
    無視リスト = {}
    -- (IgnoreList)
    ブロックリスト = {}
    -- (BlockList)
    無視リスト = {}
    -- (IgnoreList)
    リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
    -- (RemoteScrollFrame)
    非スタック = {}
    -- (unstacked)
    接続 = {}
    -- (connections)

    ボタン効果(クリア, "クリアしました！")
    -- (ButtonEffect) (Clear) (Cleared!)
end)

非スタック設定.MouseButton1Click:Connect(function()
-- (DoNotStack)
    if 見ている then
    -- (lookingAt)
        local 非スタックされている = table.find(非スタック, 見ている)
        -- (isUnstacked) (unstacked, lookingAt)
        if 非スタックされている then
        -- (isUnstacked)
            table.remove(非スタック, 非スタックされている)
            -- (unstacked, isUnstacked)
            非スタック設定.Text = "新しい引数で発火されたときにリモートを非スタック"
            -- (DoNotStack) (Unstack remote when fired with new args)
            非スタック設定.TextColor3 = Color3.fromRGB(245, 246, 250)
            -- (DoNotStack)
        else
            table.insert(非スタック, 見ている)
            -- (unstacked, lookingAt)
            非スタック設定.Text = "リモートをスタック"
            -- (DoNotStack) (Stack remote)
            非スタック設定.TextColor3 = Color3.fromRGB(251, 197, 49)
            -- (DoNotStack)
        end
    end
end)

local function 長さ(t)
-- (len)
    local n = 0

    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

-- テーブルを文字列に変換、引数のフォーマットに便利
-- (converts tables to a string, good for formatting arguments)
local function テーブルを文字列に変換(引数)
-- (convertTableToString) (args)
    local 文字列 = ""
    -- (string)
    local インデックス = 1
    -- (index)
    for i,v in pairs(引数) do
    -- (args)
        if type(i) == "string" then
            文字列 = 文字列 .. '["' .. tostring(i) .. '"] = '
            -- (string)
        elseif type(i) == "userdata" and typeof(i) ~= "Instance" then
            文字列 = 文字列 .. "[" .. typeof(i) .. ".new(" .. tostring(i) .. ")] = "
            -- (string)
        elseif type(i) == "userdata" then
            文字列 = 文字列 .. "[" .. インスタンスのフルパスを取得(i) .. "] = "
            -- (string) (GetFullPathOfAnInstance)
        end
        if v == nil then
            文字列 = 文字列 ..  "nil"
            -- (string)
        elseif typeof(v) == "Instance"  then
            文字列 = 文字列 .. インスタンスのフルパスを取得(v)
            -- (string) (GetFullPathOfAnInstance)
        elseif type(v) == "number" or type(v) == "function" then
            文字列 = 文字列 .. tostring(v)
            -- (string)
        elseif type(v) == "userdata" then
            文字列 = 文字列 .. typeof(v)..".new("..tostring(v)..")"
            -- (string)
        elseif type(v) == "string" then
            文字列 = 文字列 .. [["]]..v..[["]]
            -- (string)
        elseif type(v) == "table" then
            文字列 = 文字列 .. "{"
            -- (string)
            文字列 = 文字列 .. テーブルを文字列に変換(v)
            -- (string) (convertTableToString)
            文字列 = 文字列 .. "}"
            -- (string)
        elseif type(v) == 'boolean' then
            if v then
                文字列 = 文字列..'true'
                -- (string)
            else
                文字列 = 文字列..'false'
                -- (string)
            end
        end
        if 長さ(引数) > 1 and インデックス < 長さ(引数) then
        -- (len(args)) (index) (len(args))
            文字列 =  文字列 .. ","
            -- (string)
        end
        インデックス = インデックス + 1
        -- (index)
    end
return 文字列
-- (string)
end
リターンコピー.MouseButton1Click:Connect(function()
-- (CopyReturn)
    local リモート = リモート検索(見ている, 見ている引数)
    -- (remote) (FindRemote) (lookingAt, lookingAtArgs)
    if 見ている and リモート then
    -- (lookingAt) (remote)
    if isA(見ている, "RemoteFunction") then
    -- (lookingAt)
        -- リモートを実行し、戻り値をコピー
        -- (execute the remote and copy the return value, pretty easy stuff)
        local 結果 = リモート[リモート]:InvokeServer(unpack(リモート引数[リモート]))
        -- (result) (remotes[remote]) (remoteArgs[remote])
        setclipboard(テーブルを文字列に変換(table.pack(結果)))
        -- (convertTableToString) (result)
        ボタン効果(リターンコピー)
        -- (ButtonEffect) (CopyReturn)
    end
    end
end)

-- リモートスクロールフレームに子が追加されたときに検知し、マウスボタン1クリックシグナルを追加 (addToList関数でこれをするとRobloxスレッドのため問題が発生)
-- (detect when a child is added to the remotescrollframe and add a mousebutton1click signal (doing this in the addToList function causes problems since it's in a roblox thread))
リモートスクロールフレーム.ChildAdded:Connect(function(子)
-- (RemoteScrollFrame) (child)
    -- ユーザーがボタンを押したときに後で有用になるすべての必須情報を取得
    -- (get all essential info that will be useful later when the user presses the button)
    local リモート = リモート[#リモート]
    -- (remote) (remotes)
    local 引数 = リモート引数[#リモート引数]
    -- (args) (remoteArgs)
    local イベント = true
    -- (event)
    local 発火関数 = ":FireServer("
    -- (fireFunction)
    if isA(リモート, "RemoteFunction") then
    -- (remote)
        イベント = false
        -- (event)
        発火関数 = ":InvokeServer("
        -- (fireFunction)
    end
    local 接続 = 子.MouseButton1Click:Connect(function()
    -- (connection) (child)
        
        情報ヘッダーテキスト.Text = "情報: "..リモート.Name
        -- (InfoHeaderText) (remote)
        if イベント then 
        -- (event)
            情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1, 0)
            -- (InfoButtonsScroll)
        else
            -- リモート関数なので、実行と戻り値コピーボタンのスペースを作成
            -- (make space for the execute and copy return button since it's a remote function)
            情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1.1, 0)
            -- (InfoButtonsScroll)
        end
        メインフレーム.Size = UDim2.new(0, 565, 0, 35)
        -- (mainFrame)
        情報フレーム開く.Text = ">"
        -- (OpenInfoFrame)
        情報フレーム.Visible = true
        -- (InfoFrame)
        コード.Text = インスタンスのフルパスを取得(リモート)..発火関数..テーブルを文字列に変換(引数)..")"
        -- (Code) (GetFullPathOfAnInstance) (remote) (fireFunction) (convertTableToString) (args)
        -- テキストサイズを取得し、それに応じてコードボックスのサイズを更新
        -- (gets text size and updates code box's size accordingly)
        local テキストサイズ = テキストサービス:GetTextSize(コード.Text, コード.TextSize, コード.Font, Vector2.new(math.huge, math.huge))
        -- (textsize) (TextService) (Code) (Code) (Code)
        コードフレーム.CanvasSize = UDim2.new(0, テキストサイズ.X + 11, 2, 0)
        -- (CodeFrame) (textsize)
        見ている = リモート
        -- (lookingAt) (remote)
        見ている引数 = 引数
        -- (lookingAtArgs) (args)
        見ているボタン = 子.Number
        -- (lookingAtButton) (child)

        -- リモートが無視/ブロックされているか？ その場合、それらのボタンを変更
        -- (is the remote ignored/blocked? in that case, change those buttons)
        local ブロックされている = table.find(ブロックリスト, リモート)
        -- (blocked) (BlockList, remote)
        if ブロックされている then
        -- (blocked)
            リモートブロック.Text = "リモートをアンブロック"
            -- (BlockRemote) (Unblock remote)
            リモートブロック.TextColor3 = Color3.fromRGB(251, 197, 49)
            -- (BlockRemote)
        else
            リモートブロック.Text = "リモートの発火をブロック"
            -- (BlockRemote) (Block remote from firing)
            リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
            -- (BlockRemote)
        end
        local iリモート = table.find(無視リスト, 見ている)
        -- (iRemote) (IgnoreList, lookingAt)
        if iリモート then
        -- (iRemote)
            リモート無視.Text = "リモートの無視を停止"
            -- (IgnoreRemote) (Stop ignoring remote)
            リモート無視.TextColor3 = Color3.fromRGB(127, 143, 166)
            -- (IgnoreRemote)
        else
            リモート無視.Text = "リモートを無視"
            -- (IgnoreRemote) (Ignore remote)
            リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
            -- (IgnoreRemote)
        end
        情報フレーム開いている = true
        -- (InfoFrameOpen)
    end)
    -- 接続テーブルに挿入してすべての接続を切断できるようにする
    -- (insert them into a connections table in order to be able to disconnect all of them)
    table.insert(接続, 接続)
    -- (connections, connection)
end)


-- メイン関数: リモートをリストに追加 (event: RemoteEventか？, remote: 発火されたリモート, ...: 引数)
-- (Main function: add a remote to the list (event: is it a RemoteEvent?, remote: the remote fired, ...: the args))
function リストに追加(イベント, リモート, ...)
-- (addToList) (event, remote)
    -- ゲームスレッドで実行されているため、スレッドコンテキストを設定
    -- (set thread context since this is running in a game thread)
    local 現在のID = (get_thread_context or syn.get_thread_identity)()
    -- (currentId)
    ;(set_thread_context or syn.set_thread_identity)(7)
    if not リモート then return end
    -- (remote)

    -- 重要な変数
    -- (important variables)
    local 名前 = リモート.Name
    -- (name) (remote)
    local 引数 = {...}
    -- (args)

    -- これらの引数でこの特定のリモートを探すためにFindRemote関数を呼び出す
    -- (call the FindRemote function to find this specific remote with these args)
    local i = リモート検索(リモート, 引数)
    -- (FindRemote) (remote, args)

    -- リモートが見つからなかった場合
    -- (if the remote hasn't been found)
    if not i then
        -- リモートをリモートテーブルに追加 (重要)
        -- (add remote to remotes table (important))
        table.insert(リモート, リモート)
        -- (remotes, remote)

        local rボタン = clone(リモートボタン)
        -- (rButton) (RemoteButton)
        -- リモートに関するすべての有用な情報をテーブルに追加
        -- (add all useful info about the remote to tables)
        リモートボタン[#リモート] = rボタン.Number
        -- (remoteButtons) (remotes) (rButton)
        リモート引数[#リモート] = 引数
        -- (remoteArgs) (remotes) (args)
        リモートスクリプト[#リモート] = (isSynapse() and getcallingscript() or rawget(getfenv(0), "script"))
        -- (remoteScripts) (remotes)

        -- リモートボタンの小さなクローンを作成
        -- (clone a little baby of the remotebutton)
        rボタン.Parent = リモートスクロールフレーム
        -- (rButton) (RemoteScrollFrame)
        rボタン.Visible = true
        -- (rButton)
        local 数字テキストサイズ = テキストサイズ取得(テキストサービス, rボタン.Number.Text, rボタン.Number.TextSize, rボタン.Number.Font, Vector2.new(math.huge, math.huge))
        -- (numberTextsize) (getTextSize) (TextService) (rButton) (rButton) (rButton)
        rボタン.RemoteName.Position = UDim2.new(0,数字テキストサイズ.X + 10, 0, 0)
        -- (rButton) (numberTextsize)
        if 名前 then
        -- (name)
            rボタン.RemoteName.Text = 名前
            -- (rButton) (name)
        end
        if not イベント then
        -- (event)
            rボタン.RemoteIcon.Image = "http://www.roblox.com/asset/?id=413369623"
            -- (rButton)
        end
        ボタンオフセット = ボタンオフセット + 35
        -- (buttonOffset)
        rボタン.Position = UDim2.new(0.0912411734, 0, 0, ボタンオフセット)
        -- (rButton) (buttonOffset)
        if #リモート > 8 then
        -- (remotes)
            スクロールサイズオフセット = スクロールサイズオフセット + 35
            -- (scrollSizeOffset)
            リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, スクロールサイズオフセット)
            -- (RemoteScrollFrame) (scrollSizeOffset)
        end
    else
        -- リモートが見つかった場合、リモートのボタンの数字テキストを増分
        -- (the remote has been found, increment the remote's button's number text)
        リモートボタン[i].Text = tostring(tonumber(リモートボタン[i].Text) + 1)
        -- (remoteButtons) (remoteButtons)
        -- 数字テキストのピクセルサイズを取得し、それに応じて名前の位置を変更
        -- (get the size in pixels of the number text and change the name's position accordingly)
        local 数字テキストサイズ = テキストサイズ取得(テキストサービス, リモートボタン[i].Text, リモートボタン[i].TextSize, リモートボタン[i].Font, Vector2.new(math.huge, math.huge))
        -- (numberTextsize) (getTextSize) (TextService) (remoteButtons) (remoteButtons) (remoteButtons)
        リモートボタン[i].Parent.RemoteName.Position = UDim2.new(0,数字テキストサイズ.X + 10, 0, 0)
        -- (remoteButtons) (numberTextsize)
        リモートボタン[i].Parent.RemoteName.Size = UDim2.new(0, 149 -数字テキストサイズ.X, 0, 26)
        -- (remoteButtons) (numberTextsize)

        -- 引数を更新
        -- (update the arguments)
        リモート引数[i] = 引数
        -- (remoteArgs) (args)

        -- プレイヤーがそれを見ている場合、コードボックスを更新
        -- (update the codebox if the player is looking at it)
        if 見ている and 見ている == リモート and 見ているボタン == リモートボタン[i] and 情報フレーム.Visible then
        -- (lookingAt) (lookingAt) (remote) (lookingAtButton) (remoteButtons) (InfoFrame)
            local 発火関数 = ":FireServer("
            -- (fireFunction)
            if isA(リモート, "RemoteFunction") then
            -- (remote)
                発火関数 = ":InvokeServer("
                -- (fireFunction)
            end
            コード.Text = インスタンスのフルパスを取得(リモート)..発火関数..テーブルを文字列に変換(リモート引数[i])..")"
            -- (Code) (GetFullPathOfAnInstance) (remote) (fireFunction) (convertTableToString) (remoteArgs)
            local テキストサイズ = テキストサイズ取得(テキストサービス, コード.Text, コード.TextSize, コード.Font, Vector2.new(math.huge, math.huge))
            -- (textsize) (getTextSize) (TextService) (Code) (Code) (Code)
            コードフレーム.CanvasSize = UDim2.new(0, テキストサイズ.X + 11, 2, 0)
            -- (CodeFrame) (textsize)
        end
    end
    ;(set_thread_context or syn.set_thread_identity)(現在のID)
    -- (currentId)
end

local 古いイベント
-- (OldEvent)
古いイベント = hookfunction(Instance.new("RemoteEvent").FireServer, function(Self, ...)
-- (OldEvent)
    if not checkcaller() and table.find(ブロックリスト, Self) then
    -- (BlockList)
        return
    elseif table.find(無視リスト, Self) then
    -- (IgnoreList)
        -- 無視されている場合、addToListを呼び出さない
        -- (if ignored then don't call the addToList)
        return 古いイベント(Self, ...)
        -- (OldEvent)
    end
    リストに追加(true, Self, ...)
    -- (addToList)
end)

local 古い関数
-- (OldFunction)
古い関数 = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(Self, ...)
-- (OldFunction)
    if not checkcaller() and table.find(ブロックリスト, Self) then
    -- (BlockList)
        return
    elseif table.find(無視リスト, Self) then
    -- (IgnoreList)
        -- 無視されている場合、addToListを呼び出さない
        -- (if ignored then don't call the addToList)
        return 古い関数(Self, ...)
        -- (OldFunction)
    end
    リストに追加(false, Self, ...)
    -- (addToList)
end)

-- game namecallフック (スクリプトがリモートを検知するようにする、基本的に)
-- (game namecall hook (makes the script detect the remotes, basically))
local 古い名前呼び出し
-- (OldNamecall)
古い名前呼び出し = hookmetamethod(game,"__namecall",function(...)
-- (OldNamecall)
    local 引数 = {...}
    -- (args)
    local Self = 引数[1]
    -- (args)
    local 方法 = (getnamecallmethod or get_namecall_method)()
    -- (method)
    if 方法 == "FireServer" and isA(Self, "RemoteEvent")  then
    -- (method)
        -- リモートがブロックされており、ゲームによって発火されている場合、ブロック
        -- (if the remote is blocked and the remote is being fired by the game then block it)
        if not checkcaller() and table.find(ブロックリスト, Self) then
        -- (BlockList)
            return
        elseif table.find(無視リスト, Self) then
        -- (IgnoreList)
            -- 無視されている場合、addToListを呼び出さない
            -- (if ignored then don't call the addToList)
            return 古い名前呼び出し(...)
            -- (OldNamecall)
        end
        リストに追加(true, ...)
        -- (addToList)
    elseif 方法 == "InvokeServer" and isA(Self, 'RemoteFunction') then
    -- (method)
        if not checkcaller() and table.find(ブロックリスト, Self) then
        -- (BlockList)
            return
        elseif table.find(無視リスト, Self) then
        -- (IgnoreList)
            return 古い名前呼び出し(...)
            -- (OldNamecall)
        end
        リストに追加(false, ...)
        -- (addToList)
    end

    return 古い名前呼び出し(...)
    -- (OldNamecall)
end)
