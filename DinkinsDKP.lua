-- Initialize the addon frame
local DinkinsDKP = CreateFrame("FRAME", "DinkinsDKPFrame")
DinkinsDKP:RegisterEvent("ADDON_LOADED")

local Commands = Commands
local Network = Network
local Table = Table
local Events = Events
local Utilities = Utilities

-- Use the functions from the required files
function DinkinsDKP:ADDON_LOADED(event, addon)
    if addon == "DinkinsDKP" then
        Commands.register()

        Network.initalize()
        Table.initialize()
        Events.initalize()
        Utilities.initialize()

        self:UnregisterEvent("ADDON_LOADED")
    end
end

SLASH_DINKINSDKP1 = "/dkp"
SLASH_DINKINSDKP2 = "/dinkinsdkp"

-- Register slash command handler
SlashCmdList["DINKINSDKP"] = function(msg)
    local command, target, amount = strsplit(" ", msg)
    if command == "set" or command == "add" or command == "minus" then
        Events.handleDKP(command, target, amount)
    elseif command == "list" then
        -- Sort the table
        local sortedTable = Table.SortDKPTable()
        -- Code for listing DKP
        if strtrim(target) == "raid" then
            SendChatMessage("Dinkins Kindness Points (DKP) List:", "RAID", nil, "")
            for i, entry in ipairs(sortedTable) do
                local playerName = entry.name
                local playerDKP = entry.dkp

                C_Timer.After(i, function()
                    SendChatMessage(playerName .. ": " .. playerDKP, "RAID", nil, "")
                end)
            end
        elseif strtrim(target) == "guild" then
            SendChatMessage("Dinkins Kindness Points (DKP) List:", "GUILD", nil, "")
            for i, entry in ipairs(sortedTable) do
                local playerName = entry.name
                local playerDKP = entry.dkp

                C_Timer.After(i, function()
                    SendChatMessage(playerName .. ": " .. playerDKP, "guild", nil, "")
                end)
            end
        elseif strtrim(target) ~= nil then
            SendChatMessage("Dinkins Kindness Points (DKP) List:", "WHISPER", nil, target)
            for i, entry in ipairs(sortedTable) do
                local playerName = entry.name
                local playerDKP = entry.dkp

                C_Timer.After(i, function()
                    SendChatMessage(playerName .. ": " .. playerDKP, "WHISPER", nil, target)
                end)
            end
        else
            SendChatMessageToChannel("Dinkins Kindness Points (DKP) List:", nil)
            for i, entry in ipairs(sortedTable) do
                local playerName = entry.name
                local playerDKP = entry.dkp

                C_Timer.After(i, function()
                    print(playerName .. ": " .. playerDKP)
                end)
            end
        end
    end
end

print("Dinkins Kindness Points addon loaded.")

DinkinsDKP:SetScript("OnEvent", Events.OnEvent)
