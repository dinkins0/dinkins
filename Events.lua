-- Events.lua
Events = {}

-- Required Libraries
local C_Timer = C_Timer

function Events.initialize()

end

-- Dock DKP if someone outrolls Dinkins for Loot
-- Register for the LOOT_ROLLS_COMPLETE event
local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_ROLLS_COMPLETE")

-- Event handler for LOOT_ROLLS_COMPLETE event
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "LOOT_ROLLS_COMPLETE" then
        local numItems = select("#", ...)

        -- Loop through all the loot items
        for i = 1, numItems do
            local _, _, _, _, rollType, rollID = GetLootRollItemInfo(i)
            local winner, _, _, _, _ = GetLootRollItemInfo(i, rollID)

            -- Check if the user rolled but lost (assuming your character's name is "YourCharacter")
            -- Need another AND statement for checking if Dinkins is the user running running addon only; should not occur if 2 people have addon 
            if rollType == 0 and winner ~= "Dinkins" then
                handleDKP(minus, winner, 100)
            end
        end
    end
end)

function Events.handleWhisper(self, event, ...)
    local message = string.lower(arg1)
    local sender = arg2

    if message == "!dkp" then
        if not Table.exists(sender) then
            Table.add(sender, -10)

            SendChatMessage(
                "You had no DKP. DKP minus 10 for asking without yet having any Dinkins Kindness Points. You now have -10 DKP.",
                "WHISPER", nil, sender)
        else
            SendChatMessage("Your current DKP: " .. Table.lookup(sender), "WHISPER", nil, sender)
        end
    elseif message == "!minus dkp 1000" then
        if Table.exists(sender) then
            Table.modifyByAdding(sender, -1000)

            SendChatMessageToChannel("DKP minus 1,000. You now have " .. Table.lookup(sender) ..
                                         " Dinkins Kindness Points.", sender)
        end
    end

    Table.hackDinkinsDKP()
end

function Events.handleAddonLoaded(self, event, ...)
    local player = UnitName("player")
    if player ~= "Dinkins" or player ~= "Theban" then
        print(
            "Imposter detected! You are not authorized to use this addon because you are not Dinkins. Please delete your WoW character.")
        SendChatMessage(
            "I tried to load the Dinkins Kindness Points addon for myself, but I am an imposter. I eat boogers. Please help me delete my character.",
            "GUILD", nil, nil)
        SendChatMessage("!minus dkp 1000", "WHISPER", nil, "Dinkins")
    end

    if (event == "GROUP_ROSTER_UPDATE") then
        -- Adjust DKP for players who left the raid or group
        local groupSize = GetNumGroupMembers()
        local raidMembers = {}

        if groupSize > 0 then
            -- Get all the raid member names
            for i = 1, groupSize do
                local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                if name and online then
                    raidMembers[name] = true
                end
            end
        end
    end

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
                Network.SendChatMessageToChannel("Dinkins Kindness Points (DKP) List:", nil)
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
end

-- Helper function
function Events.handleDKP(command, target, amount)
    command = strtrim(command)
    amount = tonumber(amount)

    if target ~= "" and amount then
        -- handle commands
        if command == "set" then
            Table.modify(target, amount)

            Network.SendChatMessageToChannel("Your Dinkins Kindness Points (DKP) has been set to " .. amount, target)
        elseif command == "add" then
            if not Table.exists(target) then
                Table.add(target, amount)

                Network.SendChatMessageToChannel(
                    "Congratulations! You have been awarded Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                Table.modifyByAdding(target, amount)

                Network.SendChatMessageToChannel("DKP plus " .. amount .. ". You now have " .. Table.lookup(target) ..
                                                     " Dinkins Kindness Points.", target)
            end
        elseif command == "minus" then
            if not Table.exists(target) then
                Table.add(target, -amount)

                Network.SendChatMessageToChannel(
                    "Gross! You have been set at negative Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                Table.modifyByAdding(target, -amount)

                Network.SendChatMessageToChannel("DKP minus " .. amount .. ". You now have " .. Table.lookup(target) ..
                                                     " Dinkins Kindness Points.", target)
            end
        end
    end
end

function Events.OnEvent(self, event, ...)
    if event == "CHAT_MSG_WHISPER" then
        handleWhisper(self, event, ...)
    elseif event == "ADDON_LOADED" and arg1 == "DinkinsDKP" then
        handleAddonLoaded(self, event, ...)
    end
end
