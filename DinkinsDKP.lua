-- Initialize the addon frame
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

-- Rainbow colors
local rainbowColors = {
    "|cFFFF0000", -- Red
    "|cFFFF7F00", -- Orange
    "|cFFFFFF00", -- Yellow
    "|cFF00FF00", -- Green
    "|cFF0000FF", -- Blue
    "|cFF4B0082", -- Indigo
    "|cFF8B00FF", -- Violet
}

-- Use the functions from the required files
local function eventHandler(self, event, ...)
    if ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")

        -- Console message with rainbow effect
        local message = "Dinkins Kindness Points addon loaded!!!! Version 1.0000. To see DKP, type /dinkinsdkp or /dinkinsdkp list !"
        local formattedMessage = ""

        local colorIndex = 1
        for i = 1, #message do
            formattedMessage = formattedMessage .. rainbowColors[colorIndex] .. string.sub(message, i, i)
            colorIndex = (colorIndex % #rainbowColors) + 1
        end

        formattedMessage = formattedMessage .. "|r" -- Reset text color

        print(formattedMessage)
    end
end

frame:SetScript("OnEvent", eventHandler)
