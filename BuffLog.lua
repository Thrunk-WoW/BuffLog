local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_TEXT_UPDATE")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local isBuffZone = false  -- Default: off
local isAutoLogOn = false --Default: off

local function UpdateZone()
    local zone = GetRealZoneText()  -- Get current zone name
    if zone == "Orgrimmar" or zone == "Stranglethorn Vale" or zone == "Stormwind" then
        isBuffZone = true
		if isAutoLogOn then
			DEFAULT_CHAT_FRAME:AddMessage("Auto Buff Logout currently enabled in " .. zone .. "", 1, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage("Type \"/bufflog on\" to enable Auto Buff Logout in " .. zone .. "", 1, 1, 0)
		end
    else
        isBuffZone = false
    end
end

local function SlashCmdHandler(msg)
    if msg == "on" then
        isAutoLogOn = true
        DEFAULT_CHAT_FRAME:AddMessage("Auto Buff Logout enabled", 1, 1, 0)
    elseif msg == "off" then
        isAutoLogOn = false
        DEFAULT_CHAT_FRAME:AddMessage("Auto Buff Logout disabled", 1, 1, 0)
    else
        DEFAULT_CHAT_FRAME:AddMessage("Usage: /bufflog on | off", 1, 1, 0)
    end
end

SLASH_BUFFLOG1 = "/bufflog"
SlashCmdList["BUFFLOG"] = SlashCmdHandler

frame:SetScript("OnEvent", function()
    if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
        UpdateZone()
    elseif event == "COMBAT_TEXT_UPDATE" and isBuffZone and isAutoLogOn then
        if arg1 == "AURA_START" then
            if arg2 == "Rallying Cry of the Dragonslayer" or 
               arg2 == "Warchief's Blessing" or 
               arg2 == "Spirit of Zandalar" then
                Logout()
            end
        end
    end
end)
