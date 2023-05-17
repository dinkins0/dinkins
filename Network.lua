-- Network.lua
local network = {}

function network.initialize()

end

-- Function to send chat messages to the appropriate channel
function network.SendChatMessageToChannel(message, target)
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

return network