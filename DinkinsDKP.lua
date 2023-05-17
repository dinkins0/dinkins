-- Initialize the addon frame
local DinkinsDKP = CreateFrame("FRAME", "DinkinsDKPFrame")
DinkinsDKP:RegisterEvent("ADDON_LOADED")

local commands = require("Commands")
local events = require("Events")
local network = require("Network")
local table = require("Table")
local util = require("Utilities")

-- Use the functions from the required files
function DinkinsDKP:ADDON_LOADED(event, addon)
    if addon == "DinkinsDKP" then
        commands.register()

        network.initalize()
        table.initialize()
        events.initalize(network, table)
        util.initialize()

        self:UnregisterEvent("ADDON_LOADED")
    end
end

SLASH_DINKINSDKP1 = "/dkp"
SLASH_DINKINSDKP2 = "/dinkinsdkp"

print("Dinkins Kindness Points addon loaded.")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGOUT" or event == "PLAYER_LEAVING_WORLD" then
        table.SaveData()
    end
end)

frame:SetScript("OnEvent", events.OnEvent)
