local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_TEXT_UPDATE")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

local isBuffLogEnabled = false  -- Default: off
local isUserAfk = false --Default: off

local function UpdateBuffLogState()
    local zone = GetRealZoneText()  -- Get current zone name
    if zone == "Orgrimmar" or zone == "Stranglethorn Vale" or zone == "Stormwind" then
        isBuffLogEnabled = true
        --DEFAULT_CHAT_FRAME:AddMessage("Buff logout enabled in " .. zone .. ".", 1, 1, 0)
    else
        isBuffLogEnabled = false
        --DEFAULT_CHAT_FRAME:AddMessage("Buff logout disabled outside Orgrimmar/Booty Bay.", 1, 1, 0)
    end
end

local function SlashCmdHandler(msg)
    if msg == "on" then
        isUserAFK = true
        DEFAULT_CHAT_FRAME:AddMessage("Buff logout enabled.", 1, 1, 0)
    elseif msg == "off" then
        isUserAFK = false
        DEFAULT_CHAT_FRAME:AddMessage("Buff logout disabled.", 1, 1, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Usage: /bufflog on | off", 1, 0, 0)
    end
end

SLASH_BUFFLOG1 = "/bufflog"
SlashCmdList["BUFFLOG"] = SlashCmdHandler

frame:SetScript("OnEvent", function()
    if event == "ZONE_CHANGED_NEW_AREA" then
        UpdateBuffLogState()
    elseif event == "COMBAT_TEXT_UPDATE" and isBuffLogEnabled and isUserAFK then
        if arg1 == "AURA_START" then
            if arg2 == "Rallying Cry of the Dragonslayer" or 
               arg2 == "Warchief's Blessing" or 
               arg2 == "Spirit of Zandalar" then
                Logout()
            end
        end
    end
end)

-- Run on load to check the zone immediately
UpdateBuffLogState()
