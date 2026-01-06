-- TurtleSpy V1.5.3日本語版 / TurtleSpy V1.5.3 Japanese Version
-- 作成者: Intrer#0421 / Credits to Intrer#0421

local 色設定 = {
    ["メイン"] = {
        ["ヘッダー色"] = Color3.fromRGB(0, 168, 255),
        ["ヘッダー陰影色"] = Color3.fromRGB(0, 151, 230),
        ["ヘッダーテキスト色"] = Color3.fromRGB(47, 54, 64),
        ["メイン背景色"] = Color3.fromRGB(47, 54, 64),
        ["情報スクロールフレーム背景色"] = Color3.fromRGB(47, 54, 64),
        ["スクロールバー画像色"] = Color3.fromRGB(127, 143, 166)
    },
    ["リモートボタン"] = {
        ["境界線色"] = Color3.fromRGB(113, 128, 147),
        ["背景色"] = Color3.fromRGB(53, 59, 72),
        ["テキスト色"] = Color3.fromRGB(220, 221, 225),
        ["数字テキスト色"] = Color3.fromRGB(203, 204, 207)
    },
    ["メインボタン"] = { 
        ["境界線色"] = Color3.fromRGB(113, 128, 147),
        ["背景色"] = Color3.fromRGB(53, 59, 72),
        ["テキスト色"] = Color3.fromRGB(220, 221, 225)
    },
    ['コード'] = {
        ['背景色'] = Color3.fromRGB(35, 40, 48),
        ['テキスト色'] = Color3.fromRGB(220, 221, 225),
        ['クレジット色'] = Color3.fromRGB(108, 108, 108)
    },
}

local 設定 = {
    ["キーバインド"] = "P" -- Keybind
}

if PROTOSMASHER_LOADED then
    getgenv().isfile = newcclosure(function(ファイル) -- File
        local 成功, エラー = pcall(readfile, ファイル)
        if not 成功 then
            return false
        end
        return true
    end)
end

local HTTPサービス = game:GetService("HttpService") -- HttpService
-- キーバインドの設定を読み込む / Read settings for keybind
if not isfile("TurtleSpy設定.json") then -- TurtleSpySettings.json
    writefile("TurtleSpy設定.json", HTTPサービス:JSONEncode(設定)) -- TurtleSpySettings.json
else
    if HTTPサービス:JSONDecode(readfile("TurtleSpy設定.json"))["メイン"] then -- Main
        writefile("TurtleSpy設定.json", HTTPサービス:JSONEncode(設定)) -- TurtleSpySettings.json
    else
        設定 = HTTPサービス:JSONDecode(readfile("TurtleSpy設定.json"))
    end
end

-- プロトスマッシャー互換性 / Compatibility for protosmasher
-- クレジット: sdjsdj (v3rmユーザー名) / credits to sdjsdj (v3rm username) for converting to proto

function isSynapse()
    if PROTOSMASHER_LOADED then
        return false
    else
        return true
    end
end

function 親に設定(ギューアイ) -- Parent(GUI)
    if syn and syn.protect_gui then
        syn.protect_gui(ギューアイ)
        ギューアイ.Parent = game:GetService("CoreGui")
    elseif PROTOSMASHER_LOADED then
        ギューアイ.Parent = get_hidden_gui()
    else
        ギューアイ.Parent = game:GetService("CoreGui")
    end
end

local クライアント = game.Players.LocalPlayer -- client
local function ユニコードに変換(文字列) -- toUnicode(string)
    local コードポイント = "utf8.char(" -- codepoints
    
    for _索引, 値 in utf8.codes(文字列) do -- _i, v
        コードポイント = コードポイント .. 値 .. ', '
    end
    
    return コードポイント:sub(1, -3) .. ')'
end

local function インスタンスの完全パスを取得(インスタンス) -- GetFullPathOfAnInstance(instance)
    local 名前 = インスタンス.Name -- name
    local ヘッド = (#名前 > 0 and '.' .. 名前) or "['']" -- head
    
    if not インスタンス.Parent and インスタンス ~= game then
        return ヘッド .. " --[[ 親がnilまたは破棄されました ]] --[[ PARENTED TO NIL OR DESTROYED ]]"
    end
    
    if インスタンス == game then
        return "game"
    elseif インスタンス == workspace then
        return "workspace"
    else
        local _成功, 結果 = pcall(game.GetService, game, インスタンス.ClassName) -- _success, result
        
        if 結果 then -- result
            ヘッド = ':GetService("' .. インスタンス.ClassName .. '")'
        elseif インスタンス == クライアント then -- client
            ヘッド = '.LocalPlayer' 
        else
            local 英数字以外 = 名前:gsub('[%w_]', '') -- nonAlphaNum
            local 句読点なし = 英数字以外:gsub('[%s%p]', '') -- noPunct
            
            if tonumber(名前:sub(1, 1)) or (#英数字以外 ~= 0 and #句読点なし == 0) then
                ヘッド = '["' .. 名前:gsub('"', '\\"'):gsub('\\', '\\\\') .. '"]'
            elseif #英数字以外 ~= 0 and #句読点なし > 0 then
                ヘッド = '[' .. ユニコードに変換(名前) .. ']'
            end
        end
    end
    
    return インスタンスの完全パスを取得(インスタンス.Parent) .. ヘッド
end

-- メインスクリプト / Main Script

-- ゲーム関数への参照 / references to game functions (to prevent using namecall inside of a namecall hook)
local タイプ確認 = game.IsA -- isA
local 複製 = game.Clone -- clone

local テキストサービス = game:GetService("TextService") -- TextService
local テキストサイズ取得 = テキストサービス.GetTextSize -- getTextSize
game.StarterGui.ResetPlayerGuiOnSpawn = false
local マウス = game.Players.LocalPlayer:GetMouse() -- mouse

-- 以前のTurtleSpyインスタンスを削除 / delete the previous instances of turtlespy
if game.CoreGui:FindFirstChild("TurtleSpyGUI") then
    game.CoreGui.TurtleSpyGUI:Destroy()
end

-- 重要なテーブルとGUIオフセット / Important tables and GUI offsets
local ボタンオフセット = -25 -- buttonOffset
local スクロールサイズオフセット = 287 -- scrollSizeOffset
local 関数画像 = "http://www.roblox.com/asset/?id=413369623" -- functionImage
local イベント画像 = "http://www.roblox.com/asset/?id=413369506" -- eventImage
local リモート一覧 = {} -- remotes
local リモート引数 = {} -- remoteArgs
local リモートボタン一覧 = {} -- remoteButtons
local リモートスクリプト一覧 = {} -- remoteScripts
local 無視リスト = {} -- IgnoreList
local ブロックリスト = {} -- BlockList
local 接続一覧 = {} -- connections
local 非積み上げリスト = {} -- unstacked

-- (主に) Gui to luaによって生成されたコード / (mostly) generated code by Gui to lua
local TurtleSpyGUI = Instance.new("ScreenGui")
local メインフレーム = Instance.new("Frame") -- mainFrame
local ヘッダー = Instance.new("Frame") -- Header
local ヘッダー陰影 = Instance.new("Frame") -- HeaderShading
local ヘッダーテキストラベル = Instance.new("TextLabel") -- HeaderTextLabel
local リモートスクロールフレーム = Instance.new("ScrollingFrame") -- RemoteScrollFrame
local リモートボタン = Instance.new("TextButton") -- RemoteButton
local 数字 = Instance.new("TextLabel") -- Number
local リモート名 = Instance.new("TextLabel") -- RemoteName
local リモートアイコン = Instance.new("ImageLabel") -- RemoteIcon
local 情報フレーム = Instance.new("Frame") -- InfoFrame
local 情報フレームヘッダー = Instance.new("Frame") -- InfoFrameHeader
local 情報タイトル陰影 = Instance.new("Frame") -- InfoTitleShading
local コードフレーム = Instance.new("ScrollingFrame") -- CodeFrame
local コード = Instance.new("TextLabel") -- Code
local コードコメント = Instance.new("TextLabel") -- CodeComment
local 情報ヘッダーテキスト = Instance.new("TextLabel") -- InfoHeaderText
local 情報ボタンスクロール = Instance.new("ScrollingFrame") -- InfoButtonsScroll
local コードコピー = Instance.new("TextButton") -- CopyCode
local コード実行 = Instance.new("TextButton") -- RunCode
local スクリプトパスコピー = Instance.new("TextButton") -- CopyScriptPath
local 逆コンパイルコピー = Instance.new("TextButton") -- CopyDecompiled
local リモート無視 = Instance.new("TextButton") -- IgnoreRemote
local リモートブロック = Instance.new("TextButton") -- BlockRemote
local 無限ループ生成 = Instance.new("TextButton") -- WhileLoop
local 戻り値コピー = Instance.new("TextButton") -- CopyReturn
local クリア = Instance.new("TextButton") -- Clear
local フレーム仕切り = Instance.new("Frame") -- FrameDivider
local 情報フレーム閉じる = Instance.new("TextButton") -- CloseInfoFrame
local 情報フレーム開く = Instance.new("TextButton") -- OpenInfoFrame
local 最小化 = Instance.new("TextButton") -- Minimize
local 積み上げ無効 = Instance.new("TextButton") -- DoNotStack
local 画像ボタン = Instance.new("ImageButton") -- ImageButton

-- リモートブラウザ / Remote browser
local ブラウザヘッダー = Instance.new("Frame") -- BrowserHeader
local ブラウザヘッダーフレーム = Instance.new("Frame") -- BrowserHeaderFrame
local ブラウザヘッダーテキスト = Instance.new("TextLabel") -- BrowserHeaderText
local ブラウザ閉じる = Instance.new("TextButton") -- CloseInfoFrame2
local リモートブラウザフレーム = Instance.new("ScrollingFrame") -- RemoteBrowserFrame
local ブラウザリモートボタン = Instance.new("TextButton") -- RemoteButton2
local ブラウザリモート名 = Instance.new("TextLabel") -- RemoteName2
local ブラウザリモートアイコン = Instance.new("ImageLabel") -- RemoteIcon2

TurtleSpyGUI.Name = "TurtleSpyGUI"
TurtleSpyGUI.Name = "TurtleSpyGUI"
親に設定(TurtleSpyGUI) -- Parent(TurtleSpyGUI)

メインフレーム.Name = "メインフレーム" -- mainFrame
メインフレーム.Parent = TurtleSpyGUI
メインフレーム.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
メインフレーム.BorderColor3 = Color3.fromRGB(53, 59, 72)
メインフレーム.Position = UDim2.new(0.100000001, 0, 0.239999995, 0)
メインフレーム.Size = UDim2.new(0, 207, 0, 35)
メインフレーム.ZIndex = 8
メインフレーム.Active = true
メインフレーム.Draggable = true

-- リモートブラウザプロパティ / Remote browser properties

ブラウザヘッダー.Name = "ブラウザヘッダー" -- BrowserHeader
ブラウザヘッダー.Parent = TurtleSpyGUI
ブラウザヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
ブラウザヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
ブラウザヘッダー.Position = UDim2.new(0.712152421, 0, 0.339464903, 0)
ブラウザヘッダー.Size = UDim2.new(0, 207, 0, 33)
ブラウザヘッダー.ZIndex = 20
ブラウザヘッダー.Active = true
ブラウザヘッダー.Draggable = true
ブラウザヘッダー.Visible = false

ブラウザヘッダーフレーム.Name = "ブラウザヘッダーフレーム" -- BrowserHeaderFrame
ブラウザヘッダーフレーム.Parent = ブラウザヘッダー
ブラウザヘッダーフレーム.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ブラウザヘッダーフレーム.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ブラウザヘッダーフレーム.Position = UDim2.new(0, 0, -0.0202544238, 0)
ブラウザヘッダーフレーム.Size = UDim2.new(0, 207, 0, 26)
ブラウザヘッダーフレーム.ZIndex = 21

ブラウザヘッダーテキスト.Name = "情報ヘッダーテキスト" -- InfoHeaderText
ブラウザヘッダーテキスト.Parent = ブラウザヘッダーフレーム
ブラウザヘッダーテキスト.BackgroundTransparency = 1.000
ブラウザヘッダーテキスト.Position = UDim2.new(0, 0, -0.00206991332, 0)
ブラウザヘッダーテキスト.Size = UDim2.new(0, 206, 0, 33)
ブラウザヘッダーテキスト.ZIndex = 22
ブラウザヘッダーテキスト.Font = Enum.Font.SourceSans
ブラウザヘッダーテキスト.Text = "リモートブラウザ / Remote Browser"
ブラウザヘッダーテキスト.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"] -- colorSettings["Main"]["HeaderTextColor"]
ブラウザヘッダーテキスト.TextSize = 17.000

ブラウザ閉じる.Name = "ブラウザ閉じる" -- CloseInfoFrame
ブラウザ閉じる.Parent = ブラウザヘッダーフレーム
ブラウザ閉じる.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ブラウザ閉じる.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ブラウザ閉じる.Position = UDim2.new(0, 185, 0, 2)
ブラウザ閉じる.Size = UDim2.new(0, 22, 0, 22)
ブラウザ閉じる.ZIndex = 38
ブラウザ閉じる.Font = Enum.Font.SourceSansLight
ブラウザ閉じる.Text = "X"
ブラウザ閉じる.TextColor3 = Color3.fromRGB(0, 0, 0)
ブラウザ閉じる.TextSize = 20.000
ブラウザ閉じる.MouseButton1Click:Connect(function()
    ブラウザヘッダー.Visible = not ブラウザヘッダー.Visible
end)

リモートブラウザフレーム.Name = "リモートブラウザフレーム" -- RemoteBrowserFrame
リモートブラウザフレーム.Parent = ブラウザヘッダー
リモートブラウザフレーム.Active = true
リモートブラウザフレーム.BackgroundColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
リモートブラウザフレーム.BorderColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
リモートブラウザフレーム.Position = UDim2.new(-0.004540205, 0, 1.03504682, 0)
リモートブラウザフレーム.Size = UDim2.new(0, 207, 0, 286)
リモートブラウザフレーム.ZIndex = 19
リモートブラウザフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
リモートブラウザフレーム.ScrollBarThickness = 8
リモートブラウザフレーム.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
リモートブラウザフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"] -- colorSettings["Main"]["ScrollBarImageColor"]

ブラウザリモートボタン.Name = "ブラウザリモートボタン" -- RemoteButton
ブラウザリモートボタン.Parent = リモートブラウザフレーム
ブラウザリモートボタン.BackgroundColor3 = 色設定["リモートボタン"]["背景色"] -- colorSettings["RemoteButtons"]["BackgroundColor"]
ブラウザリモートボタン.BorderColor3 = 色設定["リモートボタン"]["境界線色"] -- colorSettings["RemoteButtons"]["BorderColor"]
ブラウザリモートボタン.Position = UDim2.new(0, 17, 0, 10)
ブラウザリモートボタン.Size = UDim2.new(0, 182, 0, 26)
ブラウザリモートボタン.ZIndex = 20
ブラウザリモートボタン.Selected = true
ブラウザリモートボタン.Font = Enum.Font.SourceSans
ブラウザリモートボタン.Text = ""
ブラウザリモートボタン.TextSize = 18.000
ブラウザリモートボタン.TextStrokeTransparency = 123.000
ブラウザリモートボタン.TextWrapped = true
ブラウザリモートボタン.TextXAlignment = Enum.TextXAlignment.Left
ブラウザリモートボタン.Visible = false

ブラウザリモート名.Name = "ブラウザリモート名" -- RemoteName2
ブラウザリモート名.Parent = ブラウザリモートボタン
ブラウザリモート名.BackgroundTransparency = 1.000
ブラウザリモート名.Position = UDim2.new(0, 5, 0, 0)
ブラウザリモート名.Size = UDim2.new(0, 155, 0, 26)
ブラウザリモート名.ZIndex = 21
ブラウザリモート名.Font = Enum.Font.SourceSans
ブラウザリモート名.Text = "RemoteEventaasdadad"
ブラウザリモート名.TextColor3 = 色設定["リモートボタン"]["テキスト色"] -- colorSettings["RemoteButtons"]["TextColor"]
ブラウザリモート名.TextSize = 16.000
ブラウザリモート名.TextXAlignment = Enum.TextXAlignment.Left
ブラウザリモート名.TextTruncate = 1

ブラウザリモートアイコン.Name = "ブラウザリモートアイコン" -- RemoteIcon2
ブラウザリモートアイコン.Parent = ブラウザリモートボタン
ブラウザリモートアイコン.BackgroundTransparency = 1.000
ブラウザリモートアイコン.Position = UDim2.new(0.840260386, 0, 0.0225472748, 0)
ブラウザリモートアイコン.Size = UDim2.new(0, 24, 0, 24)
ブラウザリモートアイコン.ZIndex = 21
ブラウザリモートアイコン.Image = 関数画像 -- functionImage

local 閲覧済みリモート = {} -- browsedRemotes
local 閲覧済み接続 = {} -- browsedConnections
local ブラウザボタンオフセット = 10 -- browsedButtonOffset
local ブラウザキャンバスサイズ = 286 -- browserCanvasSize

画像ボタン.Parent = ヘッダー
画像ボタン.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
画像ボタン.BackgroundTransparency = 1.000
画像ボタン.Position = UDim2.new(0, 8, 0, 8)
画像ボタン.Size = UDim2.new(0, 18, 0, 18)
画像ボタン.ZIndex = 9
画像ボタン.Image = "rbxassetid://169476802"
画像ボタン.ImageColor3 = Color3.fromRGB(53, 53, 53)
画像ボタン.MouseButton1Click:Connect(function()
    ブラウザヘッダー.Visible = not ブラウザヘッダー.Visible
    for i, v in pairs(game:GetDescendants()) do
        if タイプ確認(v, "RemoteEvent") or タイプ確認(v, "RemoteFunction") then
            local ブラウザボタン = 複製(ブラウザリモートボタン) -- bButton
            ブラウザボタン.Parent = リモートブラウザフレーム
            ブラウザボタン.Visible = true
            ブラウザボタン.Position = UDim2.new(0, 17, 0, ブラウザボタンオフセット)
            local 発火関数 = "" -- fireFunction
            if タイプ確認(v, "RemoteEvent") then
                発火関数 = ":FireServer()" -- fireFunction
                ブラウザボタン.ブラウザリモートアイコン.Image = イベント画像 -- eventImage
            else
                発火関数 = ":InvokeServer()" -- fireFunction
            end
            ブラウザボタン.ブラウザリモート名.Text = v.Name
            local 接続 = ブラウザボタン.MouseButton1Click:Connect(function() -- connection
                setclipboard(インスタンスの完全パスを取得(v)..発火関数) -- fireFunction
            end)
            table.insert(閲覧済み接続, 接続) -- browsedConnections
            ブラウザボタンオフセット = ブラウザボタンオフセット + 35

            if #閲覧済み接続 > 8 then -- browsedConnections
                ブラウザキャンバスサイズ = ブラウザキャンバスサイズ + 35 -- browserCanvasSize
                リモートブラウザフレーム.CanvasSize = UDim2.new(0, 0, 0, ブラウザキャンバスサイズ) -- browserCanvasSize
            end
        end
    end
end)

マウス.KeyDown:Connect(function(キー) -- key
    if キー:lower() == 設定["キーバインド"]:lower() then -- settings["Keybind"]
        TurtleSpyGUI.Enabled = not TurtleSpyGUI.Enabled
    end
end)

ヘッダー.Name = "ヘッダー" -- Header
ヘッダー.Parent = メインフレーム
ヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
ヘッダー.Size = UDim2.new(0, 207, 0, 26)
ヘッダー.ZIndex = 9

ヘッダー陰影.Name = "ヘッダー陰影" -- HeaderShading
ヘッダー陰影.Parent = ヘッダー
ヘッダー陰影.BackgroundColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
ヘッダー陰影.BorderColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
ヘッダー陰影.Position = UDim2.new(1.46719131e-07, 0, 0.285714358, 0)
ヘッダー陰影.Size = UDim2.new(0, 207, 0, 27)
ヘッダー陰影.ZIndex = 8

ヘッダーテキストラベル.Name = "ヘッダーテキストラベル" -- HeaderTextLabel
ヘッダーテキストラベル.Parent = ヘッダー陰影
ヘッダーテキストラベル.BackgroundTransparency = 1.000
ヘッダーテキストラベル.Position = UDim2.new(-0.00507604145, 0, -0.202857122, 0)
ヘッダーテキストラベル.Size = UDim2.new(0, 215, 0, 29)
ヘッダーテキストラベル.ZIndex = 10
ヘッダーテキストラベル.Font = Enum.Font.SourceSans
ヘッダーテキストラベル.Text = "タートルスパイ / Turtle Spy"
ヘッダーテキストラベル.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"] -- colorSettings["Main"]["HeaderTextColor"]
ヘッダーテキストラベル.TextSize = 17.000

リモートスクロールフレーム.Name = "リモートスクロールフレーム" -- RemoteScrollFrame
リモートスクロールフレーム.Parent = メインフレーム
リモートスクロールフレーム.Active = true
リモートスクロールフレーム.BackgroundColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
リモートスクロールフレーム.BorderColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
リモートスクロールフレーム.Position = UDim2.new(0, 0, 1.02292562, 0)
リモートスクロールフレーム.Size = UDim2.new(0, 207, 0, 286)
リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
リモートスクロールフレーム.ScrollBarThickness = 8
リモートスクロールフレーム.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
リモートスクロールフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"] -- colorSettings["Main"]["ScrollBarImageColor"]

リモートボタン.Name = "リモートボタン" -- RemoteButton
リモートボタン.Parent = リモートスクロールフレーム
リモートボタン.BackgroundColor3 = 色設定["リモートボタン"]["背景色"] -- colorSettings["RemoteButtons"]["BackgroundColor"]
リモートボタン.BorderColor3 = 色設定["リモートボタン"]["境界線色"] -- colorSettings["RemoteButtons"]["BorderColor"]
リモートボタン.Position = UDim2.new(0, 17, 0, 10)
リモートボタン.Size = UDim2.new(0, 182, 0, 26)
リモートボタン.Selected = true
リモートボタン.Font = Enum.Font.SourceSans
リモートボタン.Text = ""
リモートボタン.TextColor3 = Color3.fromRGB(220, 221, 225)
リモートボタン.TextSize = 18.000
リモートボタン.TextStrokeTransparency = 123.000
リモートボタン.TextWrapped = true
リモートボタン.TextXAlignment = Enum.TextXAlignment.Left
リモートボタン.Visible = false

数字.Name = "数字" -- Number
数字.Parent = リモートボタン
数字.BackgroundTransparency = 1.000
数字.Position = UDim2.new(0, 5, 0, 0)
数字.Size = UDim2.new(0, 300, 0, 26)
数字.ZIndex = 2
数字.Font = Enum.Font.SourceSans
数字.Text = "1"
数字.TextColor3 = 色設定["リモートボタン"]["数字テキスト色"] -- colorSettings["RemoteButtons"]["NumberTextColor"]
数字.TextSize = 16.000
数字.TextWrapped = true
数字.TextXAlignment = Enum.TextXAlignment.Left

リモート名.Name = "リモート名" -- RemoteName
リモート名.Parent = リモートボタン
リモート名.BackgroundTransparency = 1.000
リモート名.Position = UDim2.new(0, 20, 0, 0)
リモート名.Size = UDim2.new(0, 134, 0, 26)
リモート名.Font = Enum.Font.SourceSans
リモート名.Text = "RemoteEvent"
リモート名.TextColor3 = 色設定["リモートボタン"]["テキスト色"] -- colorSettings["RemoteButtons"]["TextColor"]
リモート名.TextSize = 16.000
リモート名.TextXAlignment = Enum.TextXAlignment.Left
リモート名.TextTruncate = 1

リモートアイコン.Name = "リモートアイコン" -- RemoteIcon
リモートアイコン.Parent = リモートボタン
リモートアイコン.BackgroundTransparency = 1.000
リモートアイコン.Position = UDim2.new(0.840260386, 0, 0.0225472748, 0)
リモートアイコン.Size = UDim2.new(0, 24, 0, 24)
リモートアイコン.Image = "http://www.roblox.com/asset/?id=413369506"

情報フレーム.Name = "情報フレーム" -- InfoFrame
情報フレーム.Parent = メインフレーム
情報フレーム.BackgroundColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
情報フレーム.BorderColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
情報フレーム.Position = UDim2.new(0.368141592, 0, -5.58035717e-05, 0)
情報フレーム.Size = UDim2.new(0, 357, 0, 322)
情報フレーム.Visible = false
情報フレーム.ZIndex = 6

情報フレームヘッダー.Name = "情報フレームヘッダー" -- InfoFrameHeader
情報フレームヘッダー.Parent = 情報フレーム
情報フレームヘッダー.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレームヘッダー.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレームヘッダー.Size = UDim2.new(0, 357, 0, 26)
情報フレームヘッダー.ZIndex = 14

情報タイトル陰影.Name = "情報タイトル陰影" -- InfoTitleShading
情報タイトル陰影.Parent = 情報フレーム
情報タイトル陰影.BackgroundColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
情報タイトル陰影.BorderColor3 = 色設定["メイン"]["ヘッダー陰影色"] -- colorSettings["Main"]["HeaderShadingColor"]
情報タイトル陰影.Position = UDim2.new(-0.00280881394, 0, 0, 0)
情報タイトル陰影.Size = UDim2.new(0, 358, 0, 34)
情報タイトル陰影.ZIndex = 13

コードフレーム.Name = "コードフレーム" -- CodeFrame
コードフレーム.Parent = 情報フレーム
コードフレーム.Active = true
コードフレーム.BackgroundColor3 = 色設定["コード"]["背景色"] -- colorSettings["Code"]["BackgroundColor"]
コードフレーム.BorderColor3 = 色設定["コード"]["背景色"] -- colorSettings["Code"]["BackgroundColor"]
コードフレーム.Position = UDim2.new(0.0391303748, 0, 0.141156405, 0)
コードフレーム.Size = UDim2.new(0, 329, 0, 63)
コードフレーム.ZIndex = 16
コードフレーム.CanvasSize = UDim2.new(0, 670, 2, 0)
コードフレーム.ScrollBarThickness = 8
コードフレーム.ScrollingDirection = 1
コードフレーム.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"] -- colorSettings["Main"]["ScrollBarImageColor"]

コード.Name = "コード" -- Code
コード.Parent = コードフレーム
コード.BackgroundTransparency = 1.000
コード.Position = UDim2.new(0.00888902973, 0, 0.0394801199, 0)
コード.Size = UDim2.new(0, 100000, 0, 25)
コード.ZIndex = 18
コード.Font = Enum.Font.SourceSans
コード.Text = "Turtle Spyをご利用いただきありがとうございます！ :D / Thanks for using Turtle Spy! :D"
コード.TextColor3 = 色設定["コード"]["テキスト色"] -- colorSettings["Code"]["TextColor"]
コード.TextSize = 14.000
コード.TextWrapped = true
コード.TextXAlignment = Enum.TextXAlignment.Left

コードコメント.Name = "コードコメント" -- CodeComment
コードコメント.Parent = コードフレーム
コードコメント.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
コードコメント.BackgroundTransparency = 1.000
コードコメント.Position = UDim2.new(0.0119285434, 0, -0.001968503, 0)
コードコメント.Size = UDim2.new(0, 1000, 0, 25)
コードコメント.ZIndex = 18
コードコメント.Font = Enum.Font.SourceSans
コードコメント.Text = "-- TurtleSpyによって生成されたスクリプト、作成者: Intrer#0421 / -- Script generated by TurtleSpy, made by Intrer#0421"
コードコメント.TextColor3 = 色設定["コード"]["クレジット色"] -- colorSettings["Code"]["CreditsColor"]
コードコメント.TextSize = 14.000
コードコメント.TextXAlignment = Enum.TextXAlignment.Left

情報ヘッダーテキスト.Name = "情報ヘッダーテキスト" -- InfoHeaderText
情報ヘッダーテキスト.Parent = 情報フレーム
情報ヘッダーテキスト.BackgroundTransparency = 1.000
情報ヘッダーテキスト.Position = UDim2.new(0.0391303934, 0, -0.00206972216, 0)
情報ヘッダーテキスト.Size = UDim2.new(0, 342, 0, 35)
情報ヘッダーテキスト.ZIndex = 18
情報ヘッダーテキスト.Font = Enum.Font.SourceSans
情報ヘッダーテキスト.Text = "情報: RemoteFunction / Info: RemoteFunction"
情報ヘッダーテキスト.TextColor3 = 色設定["メイン"]["ヘッダーテキスト色"] -- colorSettings["Main"]["HeaderTextColor"]
情報ヘッダーテキスト.TextSize = 17.000

情報ボタンスクロール.Name = "情報ボタンスクロール" -- InfoButtonsScroll
情報ボタンスクロール.Parent = 情報フレーム
情報ボタンスクロール.Active = true
情報ボタンスクロール.BackgroundColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
情報ボタンスクロール.BorderColor3 = 色設定["メイン"]["メイン背景色"] -- colorSettings["Main"]["MainBackgroundColor"]
情報ボタンスクロール.Position = UDim2.new(0.0391303748, 0, 0.355857909, 0)
情報ボタンスクロール.Size = UDim2.new(0, 329, 0, 199)
情報ボタンスクロール.ZIndex = 11
情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1, 0)
情報ボタンスクロール.ScrollBarThickness = 8
情報ボタンスクロール.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
情報ボタンスクロール.ScrollBarImageColor3 = 色設定["メイン"]["スクロールバー画像色"] -- colorSettings["Main"]["ScrollBarImageColor"]

コードコピー.Name = "コードコピー" -- CopyCode
コードコピー.Parent = 情報ボタンスクロール
コードコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
コードコピー.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
コードコピー.Position = UDim2.new(0.0645, 0, 0, 10)
コードコピー.Size = UDim2.new(0, 294, 0, 26)
コードコピー.ZIndex = 15
コードコピー.Font = Enum.Font.SourceSans
コードコピー.Text = "コードをコピー / Copy code"
コードコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
コードコピー.TextSize = 16.000

コード実行.Name = "コード実行" -- RunCode
コード実行.Parent = 情報ボタンスクロール
コード実行.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
コード実行.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
コード実行.Position = UDim2.new(0.0645, 0, 0, 45)
コード実行.Size = UDim2.new(0, 294, 0, 26)
コード実行.ZIndex = 15
コード実行.Font = Enum.Font.SourceSans
コード実行.Text = "実行 / Execute"
コード実行.TextColor3 = Color3.fromRGB(250, 251, 255)
コード実行.TextSize = 16.000

スクリプトパスコピー.Name = "スクリプトパスコピー" -- CopyScriptPath
スクリプトパスコピー.Parent = 情報ボタンスクロール
スクリプトパスコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
スクリプトパスコピー.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
スクリプトパスコピー.Position = UDim2.new(0.0645, 0, 0, 80)
スクリプトパスコピー.Size = UDim2.new(0, 294, 0, 26)
スクリプトパスコピー.ZIndex = 15
スクリプトパスコピー.Font = Enum.Font.SourceSans
スクリプトパスコピー.Text = "スクリプトパスをコピー / Copy script path"
スクリプトパスコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
スクリプトパスコピー.TextSize = 16.000

逆コンパイルコピー.Name = "逆コンパイルコピー" -- CopyDecompiled
逆コンパイルコピー.Parent = 情報ボタンスクロール
逆コンパイルコピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
逆コンパイルコピー.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
逆コンパイルコピー.Position = UDim2.new(0.0645, 0, 0, 115)
逆コンパイルコピー.Size = UDim2.new(0, 294, 0, 26)
逆コンパイルコピー.ZIndex = 15
逆コンパイルコピー.Font = Enum.Font.SourceSans
逆コンパイルコピー.Text = "逆コンパイルスクリプトをコピー / Copy decompiled script"
逆コンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
逆コンパイルコピー.TextSize = 16.000

リモート無視.Name = "リモート無視" -- IgnoreRemote
リモート無視.Parent = 情報ボタンスクロール
リモート無視.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
リモート無視.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
リモート無視.Position = UDim2.new(0.0645, 0, 0, 185)
リモート無視.Size = UDim2.new(0, 294, 0, 26)
リモート無視.ZIndex = 15
リモート無視.Font = Enum.Font.SourceSans
リモート無視.Text = "リモートを無視 / Ignore remote"
リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
リモート無視.TextSize = 16.000

リモートブロック.Name = "リモートブロック" -- Block Remote
リモートブロック.Parent = 情報ボタンスクロール
リモートブロック.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
リモートブロック.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
リモートブロック.Position = UDim2.new(0.0645, 0, 0, 220)
リモートブロック.Size = UDim2.new(0, 294, 0, 26)
リモートブロック.ZIndex = 15
リモートブロック.Font = Enum.Font.SourceSans
リモートブロック.Text = "リモートの発火をブロック / Block remote from firing"
リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
リモートブロック.TextSize = 16.000

無限ループ生成.Name = "無限ループ生成" -- WhileLoop
無限ループ生成.Parent = 情報ボタンスクロール
無限ループ生成.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
無限ループ生成.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
無限ループ生成.Position = UDim2.new(0.0645, 0, 0, 290)
無限ループ生成.Size = UDim2.new(0, 294, 0, 26)
無限ループ生成.ZIndex = 15
無限ループ生成.Font = Enum.Font.SourceSans
無限ループ生成.Text = "無限ループスクリプトを生成 / Generate while loop script"
無限ループ生成.TextColor3 = Color3.fromRGB(250, 251, 255)
無限ループ生成.TextSize = 16.000

クリア.Name = "クリア" -- Clear
クリア.Parent = 情報ボタンスクロール
クリア.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
クリア.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
クリア.Position = UDim2.new(0.0645, 0, 0, 255)
クリア.Size = UDim2.new(0, 294, 0, 26)
クリア.ZIndex = 15
クリア.Font = Enum.Font.SourceSans
クリア.Text = "ログをクリア / Clear logs"
クリア.TextColor3 = Color3.fromRGB(250, 251, 255)
クリア.TextSize = 16.000

戻り値コピー.Name = "戻り値コピー" -- CopyReturn
戻り値コピー.Parent = 情報ボタンスクロール
戻り値コピー.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
戻り値コピー.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
戻り値コピー.Position = UDim2.new(0.0645, 0, 0, 325)
戻り値コピー.Size = UDim2.new(0, 294, 0, 26)
戻り値コピー.ZIndex = 15
戻り値コピー.Font = Enum.Font.SourceSans
戻り値コピー.Text = "実行して戻り値をコピー / Execute and copy return value"
戻り値コピー.TextColor3 = Color3.fromRGB(250, 251, 255)
戻り値コピー.TextSize = 16.000

積み上げ無効.Name = "積み上げ無効" -- DoNotStack
積み上げ無効.Parent = 情報ボタンスクロール
積み上げ無効.BackgroundColor3 = 色設定["メインボタン"]["背景色"] -- colorSettings["MainButtons"]["BackgroundColor"]
積み上げ無効.BorderColor3 = 色設定["メインボタン"]["境界線色"] -- colorSettings["MainButtons"]["BorderColor"]
積み上げ無効.Position = UDim2.new(0.0645, 0, 0, 150)
積み上げ無効.Size = UDim2.new(0, 294, 0, 26)
積み上げ無効.ZIndex = 15
積み上げ無効.Font = Enum.Font.SourceSans
積み上げ無効.Text = "新しい引数で発火されたら積み上げない / Unstack remote when fired with new args"
積み上げ無効.TextColor3 = Color3.fromRGB(250, 251, 255)
積み上げ無効.TextSize = 16.000

フレーム仕切り.Name = "フレーム仕切り" -- FrameDivider
フレーム仕切り.Parent = 情報フレーム
フレーム仕切り.BackgroundColor3 = Color3.fromRGB(53, 59, 72)
フレーム仕切り.BorderColor3 = Color3.fromRGB(53, 59, 72)
フレーム仕切り.Position = UDim2.new(0, 3, 0, 0)
フレーム仕切り.Size = UDim2.new(0, 4, 0, 322)
フレーム仕切り.ZIndex = 7

local 情報フレーム開いている = false -- InfoFrameOpen
情報フレーム閉じる.Name = "情報フレーム閉じる" -- CloseInfoFrame
情報フレーム閉じる.Parent = 情報フレーム
情報フレーム閉じる.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレーム閉じる.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレーム閉じる.Position = UDim2.new(0, 333, 0, 2)
情報フレーム閉じる.Size = UDim2.new(0, 22, 0, 22)
情報フレーム閉じる.ZIndex = 18
情報フレーム閉じる.Font = Enum.Font.SourceSansLight
情報フレーム閉じる.Text = "X"
情報フレーム閉じる.TextColor3 = Color3.fromRGB(0, 0, 0)
情報フレーム閉じる.TextSize = 20.000
情報フレーム閉じる.MouseButton1Click:Connect(function()
    情報フレーム.Visible = false
    情報フレーム開いている = false -- InfoFrameOpen
    メインフレーム.Size = UDim2.new(0, 207, 0, 35)
end)

情報フレーム開く.Name = "情報フレーム開く" -- OpenInfoFrame
情報フレーム開く.Parent = メインフレーム
情報フレーム開く.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレーム開く.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
情報フレーム開く.Position = UDim2.new(0, 185, 0, 2)
情報フレーム開く.Size = UDim2.new(0, 22, 0, 22)
情報フレーム開く.ZIndex = 18
情報フレーム開く.Font = Enum.Font.SourceSans
情報フレーム開く.Text = ">"
情報フレーム開く.TextColor3 = Color3.fromRGB(0, 0, 0)
情報フレーム開く.TextSize = 16.000
情報フレーム開く.MouseButton1Click:Connect(function()
    if not 情報フレーム.Visible then
        メインフレーム.Size = UDim2.new(0, 565, 0, 35)
        情報フレーム開く.Text = "<"
    elseif リモートスクロールフレーム.Visible then
        メインフレーム.Size = UDim2.new(0, 207, 0, 35)
        情報フレーム開く.Text = ">"
    end
    情報フレーム.Visible = not 情報フレーム.Visible
    情報フレーム開いている = not 情報フレーム開いている -- InfoFrameOpen
end)

最小化.Name = "最小化" -- Minimize
最小化.Parent = メインフレーム
最小化.BackgroundColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
最小化.BorderColor3 = 色設定["メイン"]["ヘッダー色"] -- colorSettings["Main"]["HeaderColor"]
最小化.Position = UDim2.new(0, 164, 0, 2)
最小化.Size = UDim2.new(0, 22, 0, 22)
最小化.ZIndex = 18
最小化.Font = Enum.Font.SourceSans
最小化.Text = "_"
最小化.TextColor3 = Color3.fromRGB(0, 0, 0)
最小化.TextSize = 16.000
最小化.MouseButton1Click:Connect(function()
    -- 閉じる / Close
    if リモートスクロールフレーム.Visible then
        メインフレーム.Size = UDim2.new(0, 207, 0, 35)
        情報フレーム開く.Text = "<"
        情報フレーム.Visible = false
    else
        -- 開く / Open
        if 情報フレーム開いている then -- InfoFrameOpen
            メインフレーム.Size = UDim2.new(0, 565, 0, 35)
            情報フレーム開く.Text = "<"
            情報フレーム.Visible = true
        else
            メインフレーム.Size = UDim2.new(0, 207, 0, 35)
            情報フレーム開く.Text = ">"
            情報フレーム.Visible = false
        end
    end
    リモートスクロールフレーム.Visible = not リモートスクロールフレーム.Visible
end)

local function リモートを検索(リモート, 引数) -- FindRemote(remote, args)
    local 現在のID = (get_thread_context or syn.get_thread_identity)() -- currentId
    ;(set_thread_context or syn.set_thread_identity)(7)
    local 索引 -- i
    if table.find(非積み上げリスト, リモート) then -- unstacked
        local リモート数 = 0 -- numOfRemotes
        for b, v in pairs(リモート一覧) do -- remotes
            if v == リモート then
                リモート数 = リモート数 + 1
                for i2, v2 in pairs(リモート引数) do -- remoteArgs
                    if table.unpack(リモート引数[b]) == table.unpack(引数) then
                        索引 = b -- i
                    end
                end
            end
        end
    else
        索引 = table.find(リモート一覧, リモート) -- i
    end
    ;(set_thread_context or syn.set_thread_identity)(現在のID) -- currentId
    return 索引 -- i
end

-- シンプルな色とテキスト変更効果を作成 / creates a simple color and text change effect
local function ボタン効果(テキストラベル, テキスト) -- ButtonEffect(textlabel, text)
    if not テキスト then
        テキスト = "コピーしました！ / Copied!"
    end
    local 元のテキスト = テキストラベル.Text -- orgText
    local 元の色 = テキストラベル.TextColor3 -- orgColor
    テキストラベル.Text = テキスト
    テキストラベル.TextColor3 = Color3.fromRGB(76, 209, 55)
    wait(0.8)
    テキストラベル.Text = 元のテキスト -- orgText
    テキストラベル.TextColor3 = 元の色 -- orgColor
end

-- 後で使用する重要な値 / important values for later
local 閲覧中リモート -- lookingAt
local 閲覧中引数 -- lookingAtArgs
local 閲覧中ボタン -- lookingAtButton

コードコピー.MouseButton1Click:Connect(function()
    if not 閲覧中リモート then return end
    -- ユーザーがリモートを閲覧中の場合、コードのテキストをクリップボードにコピー / copy the code's text to clipboard if the user is looking at a remote
    setclipboard(コードコメント.Text.. "\n\n"..コード.Text)
    ボタン効果(コードコピー) -- ButtonEffect
end)

コード実行.MouseButton1Click:Connect(function()
    -- ユーザーが閲覧中のリモートのインデックスを検索 / find the index of the remote the user is looking at
    if 閲覧中リモート then
        if タイプ確認(閲覧中リモート, "RemoteFunction") then
            -- 引数を使用してリモートを発火 / fire remote with its args
            閲覧中リモート:InvokeServer(unpack(閲覧中引数)) -- lookingAtArgs
        elseif タイプ確認(閲覧中リモート, "RemoteEvent") then
            閲覧中リモート:FireServer(unpack(閲覧中引数)) -- lookingAtArgs
        end
    end
end)

スクリプトパスコピー.MouseButton1Click:Connect(function()
    -- リモートインデックスを取得 / get remote index
    local リモート = リモートを検索(閲覧中リモート, 閲覧中引数) -- FindRemote(lookingAt, lookingAtArgs)
    if リモート and 閲覧中リモート then
        -- そのインデックスのスクリプト名をコピー / copy the script name at that index
        setclipboard(インスタンスの完全パスを取得(リモートスクリプト一覧[リモート])) -- remoteScripts[remote]
        ボタン効果(スクリプトパスコピー) -- ButtonEffect
    end
end)

-- 逆コンパイルをキューに入れるためのブール値 / bool to make decompilations queue instead of running simultaneously
local 逆コンパイル中 -- decompiling

逆コンパイルコピー.MouseButton1Click:Connect(function()
    local リモート = リモートを検索(閲覧中リモート, 閲覧中引数) -- FindRemote(lookingAt, lookingAtArgs)
    if not isSynapse() then
        逆コンパイルコピー.Text = "このエクスプロイトは逆コンパイルをサポートしていません！ / This exploit doesn't support decompilation!"
        逆コンパイルコピー.TextColor3 = Color3.fromRGB(232, 65, 24)
        wait(1.6)
        逆コンパイルコピー.Text = "逆コンパイルスクリプトをコピー / Copy decompiled script"
        逆コンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
        return
    end
    if not 逆コンパイル中 and リモート and 閲覧中リモート then -- decompiling
        逆コンパイル中 = true -- decompiling

        -- ボタン効果 / button effect
        spawn(function()
            while true do
                if 逆コンパイル中 == false then return end -- decompiling
                逆コンパイルコピー.Text = "逆コンパイル中. / Decompiling."
                wait(0.8)
                if 逆コンパイル中 == false then return end -- decompiling
                逆コンパイルコピー.Text = "逆コンパイル中.. / Decompiling.."
                wait(0.8)
                if 逆コンパイル中 == false then return end -- decompiling
                逆コンパイルコピー.Text = "逆コンパイル中... / Decompiling..."
                wait(0.8)
            end
        end)

        -- リモートのリモートスクリプトを逆コンパイル / Decompile the remotescript of the remote
        local 成功 = { pcall(function()setclipboard(decompile(リモートスクリプト一覧[リモート]))end) } -- remoteScripts[remote], success
        逆コンパイル中 = false -- decompiling
        if 成功[1] then -- success[1]
            逆コンパイルコピー.Text = "逆コンパイルをコピーしました！ / Copied decompilation!"
            逆コンパイルコピー.TextColor3 = Color3.fromRGB(76, 209, 55)
        else
            warn(成功[2], 成功[3]) -- success[2], success[3]
            逆コンパイルコピー.Text = "逆コンパイルエラー！ F9でエラーを確認してください。 / Decompilation error! Check F9 to see the error."
            逆コンパイルコピー.TextColor3 = Color3.fromRGB(232, 65, 24)
        end
        wait(1.6)
        逆コンパイルコピー.Text = "逆コンパイルスクリプトをコピー / Copy decompiled script"
        逆コンパイルコピー.TextColor3 = Color3.fromRGB(250, 251, 255)
    end
end)

リモートブロック.MouseButton1Click:Connect(function()
    -- ユーザーが閲覧中のリモートを検索し、ブロックされているか確認 / find the remote the user is looking at and check whether it's blocked or not
    local ブロック済みリモート = table.find(ブロックリスト, 閲覧中リモート) -- bRemote

    if 閲覧中リモート and not ブロック済みリモート then -- bRemote
        -- リモートはブロックされていない、ブロックリストに追加 / remote isn't blocked, add it to the blocklist
        table.insert(ブロックリスト, 閲覧中リモート)
        リモートブロック.Text = "リモートのブロックを解除 / Unblock remote"
        リモートブロック.TextColor3 = Color3.fromRGB(251, 197, 49)
        local リモート = table.find(リモート一覧, 閲覧中リモート) -- remote
        if リモート then
            リモートボタン一覧[リモート].Parent.リモート名.TextColor3 = Color3.fromRGB(225, 177, 44) -- remoteButtons[remote]
        end
    elseif 閲覧中リモート and ブロック済みリモート then -- bRemote
        -- リモートはブロック済み、ブロックを解除 / remote is blocked, remove from blocklist
        table.remove(ブロックリスト, ブロック済みリモート) -- bRemote
        リモートブロック.Text = "リモートの発火をブロック / Block remote from firing"
        リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
        local リモート = table.find(リモート一覧, 閲覧中リモート) -- remote
        if リモート then
            リモートボタン一覧[リモート].Parent.リモート名.TextColor3 = Color3.fromRGB(245, 246, 250) -- remoteButtons[remote]
        end
    end
end)

リモート無視.MouseButton1Click:Connect(function()
    -- リモートがブロックされているか確認 / check if remote is ignored
    local 無視済みリモート = table.find(無視リスト, 閲覧中リモート) -- iRemote
    if 閲覧中リモート and not 無視済みリモート then -- iRemote
        table.insert(無視リスト, 閲覧中リモート)
        リモート無視.Text = "リモートの無視を停止 / Stop ignoring remote"
        リモート無視.TextColor3 = Color3.fromRGB(127, 143, 166)
        local リモート = table.find(リモート一覧, 閲覧中リモート) -- remote
        if リモート then
            リモートボタン一覧[リモート].Parent.リモート名.TextColor3 = Color3.fromRGB(127, 143, 166) -- remoteButtons[remote]
        end
    elseif 閲覧中リモート and 無視済みリモート then -- iRemote
        table.remove(無視リスト, 無視済みリモート) -- iRemote
        リモート無視.Text = "リモートを無視 / Ignore remote"
        リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
        local リモート = table.find(リモート一覧, 閲覧中リモート) -- remote
        if リモート then
            リモートボタン一覧[リモート].Parent.リモート名.TextColor3 = Color3.fromRGB(245, 246, 250) -- remoteButtons[remote]
        end
    end
end)

無限ループ生成.MouseButton1Click:Connect(function()
    if not 閲覧中リモート then return end
    setclipboard("while wait() do\n   "..コード.Text.."\nend")
    ボタン効果(無限ループ生成) -- ButtonEffect
end)

クリア.MouseButton1Click:Connect(function()
    for i, v in pairs(リモートスクロールフレーム:GetChildren()) do -- RemoteScrollFrame
        if i > 1 then 
            v:Destroy()
        end
    end
    for i, v in pairs(接続一覧) do -- connections
        v:Disconnect()
    end
    -- すべてをリセット / reset everything
    ボタンオフセット = -25 -- buttonOffset
    スクロールサイズオフセット = 0 -- scrollSizeOffset
    リモート一覧 = {} -- remotes
    リモート引数 = {} -- remoteArgs
    リモートボタン一覧 = {} -- remoteButtons
    リモートスクリプト一覧 = {} -- remoteScripts
    無視リスト = {} -- IgnoreList
    ブロックリスト = {} -- BlockList
    リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, 287)
    非積み上げリスト = {} -- unstacked
    接続一覧 = {} -- connections

    ボタン効果(クリア, "クリアしました！ / Cleared!") -- ButtonEffect
end)

積み上げ無効.MouseButton1Click:Connect(function()
    if 閲覧中リモート then
        local 非積み上げ済み = table.find(非積み上げリスト, 閲覧中リモート) -- isUnstacked
        if 非積み上げ済み then -- isUnstacked
            table.remove(非積み上げリスト, 非積み上げ済み) -- isUnstacked
            積み上げ無効.Text = "新しい引数で発火されたら積み上げない / Unstack remote when fired with new args"
            積み上げ無効.TextColor3 = Color3.fromRGB(245, 246, 250)
        else
            table.insert(非積み上げリスト, 閲覧中リモート)
            積み上げ無効.Text = "リモートを積み上げる / Stack remote"
            積み上げ無効.TextColor3 = Color3.fromRGB(251, 197, 49)
        end
    end
end)

local function 長さ(テーブル) -- len(t)
    local n = 0

    for _ in pairs(テーブル) do
        n = n + 1
    end
    return n
end

-- テーブルを文字列に変換、引数のフォーマットに便利 / converts tables to a string, good for formatting arguments
local function テーブルを文字列に変換(引数) -- convertTableToString(args)
    local 文字列 = "" -- string
    local インデックス = 1 -- index
    for i, v in pairs(引数) do
        if type(i) == "string" then
            文字列 = 文字列 .. '["' .. tostring(i) .. '"] = ' -- string
        elseif type(i) == "userdata" and typeof(i) ~= "Instance" then
            文字列 = 文字列 .. "[" .. typeof(i) .. ".new(" .. tostring(i) .. ")] = " -- string
        elseif type(i) == "userdata" then
            文字列 = 文字列 .. "[" .. インスタンスの完全パスを取得(i) .. "] = " -- string
        end
        if v == nil then
            文字列 = 文字列 ..  "nil" -- string
        elseif typeof(v) == "Instance"  then
            文字列 = 文字列 .. インスタンスの完全パスを取得(v) -- string
        elseif type(v) == "number" or type(v) == "function" then
            文字列 = 文字列 .. tostring(v) -- string
        elseif type(v) == "userdata" then
            文字列 = 文字列 .. typeof(v)..".new("..tostring(v)..")" -- string
        elseif type(v) == "string" then
            文字列 = 文字列 .. [["]]..v..[["]] -- string
        elseif type(v) == "table" then
            文字列 = 文字列 .. "{" -- string
            文字列 = 文字列 .. テーブルを文字列に変換(v) -- convertTableToString
            文字列 = 文字列 .. "}" -- string
        elseif type(v) == 'boolean' then
            if v then
                文字列 = 文字列..'true' -- string
            else
                文字列 = 文字列..'false' -- string
            end
        end
        if 長さ(引数) > 1 and インデックス < 長さ(引数) then -- len(args)
            文字列 = 文字列 .. "," -- string
        end
        インデックス = インデックス + 1
    end
    return 文字列 -- string
end

戻り値コピー.MouseButton1Click:Connect(function()
    local リモート = リモートを検索(閲覧中リモート, 閲覧中引数) -- FindRemote(lookingAt, lookingAtArgs)
    if 閲覧中リモート and リモート then
        if タイプ確認(閲覧中リモート, "RemoteFunction") then
            -- リモートを実行して戻り値をコピー、簡単な処理 / execute the remote and copy the return value, pretty easy stuff
            local 結果 = リモート一覧[リモート]:InvokeServer(unpack(リモート引数[リモート])) -- remotes[remote], remoteArgs[remote], result
            setclipboard(テーブルを文字列に変換(table.pack(結果))) -- convertTableToString
            ボタン効果(戻り値コピー) -- ButtonEffect
        end
    end
end)

-- リモートスクロールフレームに子が追加されたときの検出とMouseButton1Clickシグナルの追加 / detect when a child is added to the remotescrollframe and add a mousebutton1click signal
リモートスクロールフレーム.ChildAdded:Connect(function(子) -- child
    -- 後にユーザーがボタンを押したときに役立つすべての重要な情報を取得 / get all essential info that will be useful later when the user presses the button
    local リモート = リモート一覧[#リモート一覧] -- remote
    local 引数 = リモート引数[#リモート一覧] -- args
    local イベント = true -- event
    local 発火関数 = ":FireServer(" -- fireFunction
    if タイプ確認(リモート, "RemoteFunction") then
        イベント = false -- event
        発火関数 = ":InvokeServer(" -- fireFunction
    end
    local 接続 = 子.MouseButton1Click:Connect(function() -- connection
        
        情報ヘッダーテキスト.Text = "情報: "..リモート.Name.." / Info: "..リモート.Name -- Info: RemoteFunction
        if イベント then -- event
            情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1, 0) -- InfoButtonsScroll
        else
            -- リモート関数の場合は、実行して戻り値をコピーボタンのスペースを作成 / make space for the execute and copy return button since it's a remote function
            情報ボタンスクロール.CanvasSize = UDim2.new(0, 0, 1.1, 0) -- InfoButtonsScroll
        end
        メインフレーム.Size = UDim2.new(0, 565, 0, 35)
        情報フレーム開く.Text = ">"
        情報フレーム.Visible = true
        コード.Text = インスタンスの完全パスを取得(リモート)..発火関数..テーブルを文字列に変換(引数)..")" -- GetFullPathOfAnInstance, fireFunction, convertTableToString
        -- テキストサイズを取得し、コードボックスのサイズを更新 / gets text size and updates code box's size accordingly
        local テキストサイズ = テキストサービス:GetTextSize(コード.Text, コード.TextSize, コード.Font, Vector2.new(math.huge, math.huge)) -- textsize
        コードフレーム.CanvasSize = UDim2.new(0, テキストサイズ.X + 11, 2, 0) -- textsize
        閲覧中リモート = リモート -- lookingAt
        閲覧中引数 = 引数 -- lookingAtArgs
        閲覧中ボタン = 子.数字 -- lookingAtButton = child.Number

        -- リモートは無視/ブロックされていますか？その場合、それらのボタンを変更 / is the remote ignored/blocked? in that case, change those buttons
        local ブロック済み = table.find(ブロックリスト, リモート) -- blocked
        if ブロック済み then -- blocked
            リモートブロック.Text = "リモートのブロックを解除 / Unblock remote"
            リモートブロック.TextColor3 = Color3.fromRGB(251, 197, 49)
        else
            リモートブロック.Text = "リモートの発火をブロック / Block remote from firing"
            リモートブロック.TextColor3 = Color3.fromRGB(250, 251, 255)
        end
        local 無視済みリモート = table.find(無視リスト, 閲覧中リモート) -- iRemote
        if 無視済みリモート then -- iRemote
            リモート無視.Text = "リモートの無視を停止 / Stop ignoring remote"
            リモート無視.TextColor3 = Color3.fromRGB(127, 143, 166)
        else
            リモート無視.Text = "リモートを無視 / Ignore remote"
            リモート無視.TextColor3 = Color3.fromRGB(250, 251, 255)
        end
        情報フレーム開いている = true -- InfoFrameOpen
    end)
    -- 接続テーブルに挿入して、すべての接続を切断できるようにする / insert them into a connections table in order to be able to disconnect all of them
    table.insert(接続一覧, 接続) -- connections
end)

-- メイン関数：リストにリモートを追加 / Main function: add a remote to the list
function リストに追加(イベント, リモート, ...) -- addToList(event, remote, ...)
    -- これはゲームスレッドで実行されているため、スレッドコンテキストを設定 / set thread context since this is running in a game thread
    local 現在のID = (get_thread_context or syn.get_thread_identity)() -- currentId
    ;(set_thread_context or syn.set_thread_identity)(7)
    if not リモート then return end -- remote

    -- 重要な変数 / important variables
    local 名前 = リモート.Name -- name
    local 引数 = {...} -- args

    -- これらの引数でこの特定のリモートを検索するFindRemote関数を呼び出す / call the FindRemote function to find this specific remote with these args
    local 索引 = リモートを検索(リモート, 引数) -- i

    -- リモートが見つからなかった場合 / if the remote hasn't been found
    if not 索引 then -- i
        -- リモートをリモートテーブルに追加（重要） / add remote to remotes table (important)
        table.insert(リモート一覧, リモート) -- remotes

        local リモートボタン = 複製(リモートボタン) -- rButton
        -- リモートに関するすべての有用な情報をテーブルに追加 / add all useful info about the remote to tables
        リモートボタン一覧[#リモート一覧] = リモートボタン.数字 -- remoteButtons
        リモート引数[#リモート一覧] = 引数 -- remoteArgs
        リモートスクリプト一覧[#リモート一覧] = (isSynapse() and getcallingscript() or rawget(getfenv(0), "script")) -- remoteScripts

        -- リモートボタンの小さな複製を作成 / clone a little baby of the remotebutton
        リモートボタン.Parent = リモートスクロールフレーム -- rButton
        リモートボタン.Visible = true -- rButton
        local 数字テキストサイズ = テキストサイズ取得(テキストサービス, リモートボタン.数字.Text, リモートボタン.数字.TextSize, リモートボタン.数字.Font, Vector2.new(math.huge, math.huge)) -- numberTextsize
        リモートボタン.リモート名.Position = UDim2.new(0, 数字テキストサイズ.X + 10, 0, 0) -- numberTextsize
        if 名前 then -- name
            リモートボタン.リモート名.Text = 名前 -- rButton
        end
        if not イベント then -- event
            リモートボタン.リモートアイコン.Image = "http://www.roblox.com/asset/?id=413369623" -- rButton
        end
        ボタンオフセット = ボタンオフセット + 35 -- buttonOffset
        リモートボタン.Position = UDim2.new(0.0912411734, 0, 0, ボタンオフセット) -- rButton, buttonOffset
        if #リモート一覧 > 8 then -- remotes
            スクロールサイズオフセット = スクロールサイズオフセット + 35 -- scrollSizeOffset
            リモートスクロールフレーム.CanvasSize = UDim2.new(0, 0, 0, スクロールサイズオフセット) -- scrollSizeOffset
        end
    else
        -- リモートが見つかった、リモートのボタンの数字テキストを増加 / the remote has been found, increment the remote's button's number text
        リモートボタン一覧[索引].Text = tostring(tonumber(リモートボタン一覧[索引].Text) + 1) -- remoteButtons[i]
        -- 数字テキストのピクセルサイズを取得し、それに応じて名前の位置を変更 / get the size in pixels of the number text and change the name's position accordingly
        local 数字テキストサイズ = テキストサイズ取得(テキストサービス, リモートボタン一覧[索引].Text, リモートボタン一覧[索引].TextSize, リモートボタン一覧[索引].Font, Vector2.new(math.huge, math.huge)) -- numberTextsize
        リモートボタン一覧[索引].Parent.リモート名.Position = UDim2.new(0, 数字テキストサイズ.X + 10, 0, 0) -- remoteButtons[i], numberTextsize
        リモートボタン一覧[索引].Parent.リモート名.Size = UDim2.new(0, 149 - 数字テキストサイズ.X, 0, 26) -- remoteButtons[i], numberTextsize

        -- 引数を更新 / update the arguments
        リモート引数[索引] = 引数 -- remoteArgs[i]

        -- プレイヤーがそれを見ている場合はコードボックスを更新 / update the codebox if the player is looking at it
        if 閲覧中リモート and 閲覧中リモート == リモート and 閲覧中ボタン == リモートボタン一覧[索引] and 情報フレーム.Visible then
            local 発火関数 = ":FireServer(" -- fireFunction
            if タイプ確認(リモート, "RemoteFunction") then
                発火関数 = ":InvokeServer(" -- fireFunction
            end
            コード.Text = インスタンスの完全パスを取得(リモート)..発火関数..テーブルを文字列に変換(リモート引数[索引])..")" -- GetFullPathOfAnInstance, fireFunction, convertTableToString, remoteArgs[i]
            local テキストサイズ = テキストサイズ取得(テキストサービス, コード.Text, コード.TextSize, コード.Font, Vector2.new(math.huge, math.huge)) -- textsize
            コードフレーム.CanvasSize = UDim2.new(0, テキストサイズ.X + 11, 2, 0) -- textsize
        end
    end
    ;(set_thread_context or syn.set_thread_identity)(現在のID) -- currentId
end

local 古いイベント -- OldEvent
古いイベント = hookfunction(Instance.new("RemoteEvent").FireServer, function(自身, ...) -- Self
    if not checkcaller() and table.find(ブロックリスト, 自身) then -- Self
        return
    elseif table.find(無視リスト, 自身) then -- Self
        -- 無視されている場合はaddToListを呼び出さない / if ignored then don't call the addToList
        return 古いイベント(自身, ...) -- OldEvent(Self, ...)
    end
    リストに追加(true, 自身, ...) -- addToList(true, Self, ...)
end)

local 古い関数 -- OldFunction
古い関数 = hookfunction(Instance.new("RemoteFunction").InvokeServer, function(自身, ...) -- Self
    if not checkcaller() and table.find(ブロックリスト, 自身) then -- Self
        return
    elseif table.find(無視リスト, 自身) then -- Self
        -- 無視されている場合はaddToListを呼び出さない / if ignored then don't call the addToList
        return 古い関数(自身, ...) -- OldFunction(Self, ...)
    end
    リストに追加(false, 自身, ...) -- addToList(false, Self, ...)
end)

-- ゲームnamecallフック（基本的にスクリプトがリモートを検出できるようにする） / game namecall hook (makes the script detect the remotes, basically)
local 古いNamecall -- OldNamecall
古いNamecall = hookmetamethod(game,"__namecall",function(...)
    local 引数 = {...} -- args
    local 自身 = 引数[1] -- Self
    local メソッド = (getnamecallmethod or get_namecall_method)() -- method
    if メソッド == "FireServer" and タイプ確認(自身, "RemoteEvent")  then -- method, Self
        -- リモートがブロックされていて、リモートがゲームによって発火されている場合はブロック / if the remote is blocked and the remote is being fired by the game then block it
        if not checkcaller() and table.find(ブロックリスト, 自身) then -- Self
            return
        elseif table.find(無視リスト, 自身) then -- Self
            -- 無視されている場合はaddToListを呼び出さない / if ignored then don't call the addToList
            return 古いNamecall(...) -- OldNamecall
        end
        リストに追加(true, ...) -- addToList
    elseif メソッド == "InvokeServer" and タイプ確認(自身, 'RemoteFunction') then -- method, Self
        if not checkcaller() and table.find(ブロックリスト, 自身) then -- Self
            return
        elseif table.find(無視リスト, 自身) then -- Self
            return 古いNamecall(...) -- OldNamecall
        end
        リストに追加(false, ...) -- addToList
    end

    return 古いNamecall(...) -- OldNamecall
end)
