-- Initialize the addon frame
local frame = CreateFrame("FRAME", "DinkinsDKPFrame")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:RegisterEvent("PLAYER_LEAVING_WORLD")

-- Define DKP storage table
local dkpTable = {}

-- Add Global variable to store the add-on's namespace
DinkinsDKP = {}

-- Required Libraries
local C_Timer = C_Timer

-- Table Sorting
local function SortDKPTable()
    local sortedTable = {}
    for playerName, dkp in pairs(dkpTable) do
        table.insert(sortedTable, {name = playerName, dkp = dkp})
    end

    table.sort(sortedTable, function(a, b)
        return a.dkp > b.dkp
    end)

    return sortedTable
end

-- Function to send chat messages to the appropriate channel
local function SendChatMessageToChannel(message, target)
    if target ~= nil then
        if target == "raid" then
            SendChatMessage(message, "RAID", nil, nil)
        elseif target == "guild" then
            SendChatMessage(message, "GUILD", nil, nil)
        else
            SendChatMessage(message, "WHISPER", nil, target)
        end
    else
        print(message) -- Output the message to the default chat frame if no target is specified
    end
end

-- Function to save the 'dkpTable' data when add-on is unloaded
local function SaveData()
    DinkinsDKP.dkpTable = dkpTable
end

-- Event handling function
local function OnEvent(self, event, ...)
    local arg1, arg2, arg3 = ...

    if event == "CHAT_MSG_WHISPER" then
        local message = string.lower(arg1)
        local sender = arg2

        if message == "!dkp" then
            if dkpTable[sender] == nil then
                dkpTable[sender] = -10
                SendChatMessage("You had no DKP. DKP minus 10 for asking without yet having any Dinkins Kindness Points. You now have -10 DKP.", "WHISPER", nil, sender)
            else
                local dkp = dkpTable[sender]
                SendChatMessage("Your current DKP: " .. dkp, "WHISPER", nil, sender)
            end
        elseif message == "!minus dkp 1000" then
            if dkpTable[sender] ~= nil then
                dkpTable[sender] = dkpTable[sender] - 1000
                SendChatMessageToChannel("DKP minus 1,000. You now have " .. dkpTable[sender] .. " Dinkins Kindness Points.", sender)
            end
        end

        -- Check if "Dinkins" DKP needs to be adjusted
        local maxDKP = -math.huge
        for _, dkp in pairs(dkpTable) do
            if dkp > maxDKP then
                maxDKP = dkp
            end
        end
        if dkpTable["Dinkins"] ~= nil and dkpTable["Dinkins"] <= maxDKP then
            dkpTable["Dinkins"] = maxDKP + 1
        end
    elseif event == "ADDON_LOADED" and arg1 == "DinkinsDKP" then
        local player = UnitName("player")
        if player ~= "Dinkins" then
            print("Imposter detected. You are not authorized to use this addon because you are not Dinkins. Please delete your WoW character.")
            SendChatMessage("I tried to load the Dinkins Kindness Points addon for myself, but I am an imposter. I eat boogers. Please help me delete my character.", "GUILD", nil, nil)
            SendChatMessage("!minus dkp 1000", "WHISPER", nil, "Dinkins")
        end
            -- Load the table data from SavedVariables
        if DinkinsDKP and DinkinsDKP.dkpTable then
                dkpTable = DinkinsDKP.dkpTable
        else
             -- If the table data doesn't exist, create a new table
             dkpTable = {}
        end
        elseif event == "GROUP_ROSTER_UPDATE" then
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

    -- Register slash command handler
    SlashCmdList["DINKINSDKP"] = function(msg)
    local command, target, amount = strsplit(" ", msg)
    if command == "set" then
    -- Code for setting DKP
    if target and amount then
        command = strtrim(command)
        amount = tonumber(amount)

        if target ~= "" and amount then
            dkpTable[target] = amount
            SendChatMessageToChannel("Your Dinkins Kindness Points (DKP) has been set to " .. amount, target)
        end
    end
    elseif command == "add" then
        -- Code for adding DKP
        if target and amount then
            command = strtrim(command)
            amount = tonumber(amount)

            if target ~= "" and amount then
                if dkpTable[target] == nil then
                    dkpTable[target] = amount
                    SendChatMessageToChannel("Congratulations! You have been awarded Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp", target)
                else
                    dkpTable[target] = dkpTable[target] + amount
                end
                SendChatMessageToChannel("DKP plus " .. amount .. ". You now have " .. dkpTable[target] .. " Dinkins Kindness Points.", target)
            end
        end
    elseif command == "minus" then
    -- Code for subtracting DKP
        if target and amount then
            command = strtrim(command)
            amount = tonumber(amount)

            if target ~= "" and amount then
                if dkpTable[target] == nil then
                    dkpTable[target] = -amount
                    SendChatMessageToChannel("Gross! You have been set at negative Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp", target)
                else
                    dkpTable[target] = dkpTable[target] - amount
                end
                SendChatMessageToChannel("DKP minus " .. amount .. ". You now have " .. dkpTable[target] .. " Dinkins Kindness Points.", target)
            end
        end
    elseif command == "list" then
        -- Sort the table
        local sortedTable = SortDKPTable()
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
                -- Delayed printing of each player's DKP with message throttling

    end
end
SLASH_DINKINSDKP1 = "/dkp"
SLASH_DINKINSDKP2 = "/dinkinsdkp"

print("Dinkins Kindness Points addon loaded.")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGOUT" or event == "PLAYER_LEAVING_WORLD" then
        SaveData()
    end
end)

frame:SetScript("OnEvent", OnEvent)