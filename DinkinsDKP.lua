-- Initialize the addon frame
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

-- Use the functions from the required files
local function eventHandler(self, event, ...)
    if ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")

        print("Dinkins Kindness Points addon loaded.")
    end
end

frame:SetScript("OnEvent", eventHandler)
