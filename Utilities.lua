-- Utilities.lua
Utilities = {}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")
    end
end

frame:SetScript("OnEvent", eventHandler)

function Utilities.isEmpty(s)
    return s == nil or s == ''
end
