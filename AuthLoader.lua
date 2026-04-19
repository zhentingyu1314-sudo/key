    -- [[ MOD8 AUTHENTICATION LOADER ]] --
local input_key = ... -- 獲取傳入的參數 (即 script_key)

local player = game.Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local api_url = "http://111.184.210.45:3000/verify" -- 更新為你的 API 網址

-- 檢查 Key 是否為空
if not input_key or input_key == "" then
    player:Kick("\n🛡️ AUTH SECURITY 🛡️\n\nMissing License Key.")
    return
end

local check_url = api_url .. "?key=" .. input_key .. "&hwid=" .. hwid

local success, result = pcall(function()
    return game:HttpGet(check_url)
end)

if success then
    if result == "success" then
        print("✅ [AUTH] License Verified.")
        
        -- 驗證成功後載入主程式
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Aphroslarping/RIVALSRAGINGCOMPS/refs/heads/main/RivalsRagingComp"))()
    
    elseif result == "hwid_mismatch" then
        player:Kick("\n🛡️ AUTH SECURITY 🛡️\n\nHWID Mismatch.\nReset your key in Discord.")
    
    elseif result == "invalid_key" then
        player:Kick("\n🛡️ AUTH SECURITY 🛡️\n\nInvalid Key.")
    
    else
        player:Kick("Auth Server Error: " .. tostring(result))
    end
else
    player:Kick("Failed to connect to Auth Server.")
end
