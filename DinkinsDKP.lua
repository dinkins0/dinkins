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

        events.initalize()
        network.initalize()
        table.initialize()
        util.initialize()

        self:UnregisterEvent("ADDON_LOADED")
    end
end

SLASH_DINKINSDKP1 = "/dkp"
SLASH_DINKINSDKP2 = "/dinkinsdkp"

print("Dinkins Kindness Points addon loaded.")

DinkinsDKP:SetScript("OnEvent", events.OnEvent)
