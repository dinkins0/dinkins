-- Network.lua
Network = {}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")
    end
end

frame:SetScript("OnEvent", eventHandler)

local function outputRecord(target, player, dkp)
    if target == "guild" or target == "raid" then
        SendChatMessage(player .. ": " .. dkp, target.upper(), nil, "")
    elseif target ~= nil then
        SendChatMessage(player .. ": " .. dkp, "WHISPER", nil, target)
    else
        print(player .. ": " .. dkp)
    end
end

local function outputHeader(target)
    if target == "guild" or target == "raid" then
        SendChatMessage("Dinkins Kindness Points (DKP) List:", target.upper(), nil, "")
    elseif target ~= nil then
        SendChatMessage("Dinkins Kindness Points (DKP) List:", "WHISPER", nil, target)
    else
        print("Dinkins Kindness Points (DKP) List:")
    end
end

-- Function to send chat messages to the appropriate channel
function Network.SendChatMessageToChannel(message, target)
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

function Network.outputToChat(target, dkpTable)
    outputHeader(target)

    for i, entry in ipairs(dkpTable) do
        local playerName = entry.name
        local playerDKP = entry.dkp

        C_Timer.After(i, function()
            outputRecord(target, playerName, playerDKP)
        end)
    end
end
