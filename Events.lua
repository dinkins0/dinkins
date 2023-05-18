-- Events.lua
Events = {}

local dkpTable = Table
local chatNetwork = Network

-- Required Libraries
local C_Timer = C_Timer

function Events.initialize()

end

local function handleWhisper(self, event, ...)
    local message = string.lower(arg1)
    local sender = arg2

    if message == "!dkp" then
        if not dkpTable.exists(sender) then
            dkpTable.add(sender, -10)

            SendChatMessage(
                "You had no DKP. DKP minus 10 for asking without yet having any Dinkins Kindness Points. You now have -10 DKP.",
                "WHISPER", nil, sender)
        else
            SendChatMessage("Your current DKP: " .. dkpTable.lookup(sender), "WHISPER", nil, sender)
        end
    elseif message == "!minus dkp 1000" then
        if dkpTable.exists(sender) then
            dkpTable.modifyByAdding(sender, -1000)

            SendChatMessageToChannel(
                "DKP minus 1,000. You now have " .. dkpTable[sender] .. " Dinkins Kindness Points.", sender)
        end
    end

    dkpTable.hackDinkinsDKP()
end

local function handleAddonLoaded(self, event, ...)
    local player = UnitName("player")
    if player ~= "Dinkins" then
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
end

-- Helper function
local function handleDKP(command, target, amount)
    command = strtrim(command)
    amount = tonumber(amount)

    if target ~= "" and amount then
        -- handle commands
        if command == "set" then
            dkpTable.modify(target, amount)

            SendChatMessageToChannel("Your Dinkins Kindness Points (DKP) has been set to " .. amount, target)
        elseif command == "add" then
            if not dkpTable.exists(target) then
                dkpTable.add(target, amount)

                SendChatMessageToChannel(
                    "Congratulations! You have been awarded Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                dkpTable.modifyByAdding(target, amount)

                SendChatMessageToChannel("DKP plus " .. amount .. ". You now have " .. dkpTable[target] ..
                                             " Dinkins Kindness Points.", target)
            end
        elseif command == "minus" then
            if not dkpTable.exists(target) then
                dkpTable.add(target, -amount)

                SendChatMessageToChannel(
                    "Gross! You have been set at negative Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                dkpTable.modifyByAdding(target, -amount)

                SendChatMessageToChannel("DKP minus " .. amount .. ". You now have " .. dkpTable[target] ..
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
