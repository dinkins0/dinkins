-- Events.lua
Events = {}

-- Required Libraries
local C_Timer = C_Timer

-- Dock DKP if someone outrolls Dinkins for Loot
-- Register for the LOOT_ROLLS_COMPLETE event
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("LOOT_ROLLS_COMPLETE")
frame:RegisterEvent("CHAT_MSG_WHISPER")

-- Use the functions from the required files
local function eventHandler(self, event, ...)
    if ... == "DinkinsDKP" then
        Events.handleAddonLoaded(self, event, ...)

        frame:UnregisterEvent("ADDON_LOADED")
    end

    if event == "CHAT_MSG_WHISPER" then
        Events.handleWhisper(self, event, ...)
    end

    if event == "LOOT_ROLLS_COMPLETE" then
        local numItems = select("#", ...)

        -- Loop through all the loot items
        for i = 1, numItems do
            local _, _, _, _, rollType, rollID = GetLootRollItemInfo(i)
            local winner, _, _, _, _ = GetLootRollItemInfo(i, rollID)

            -- Check if the user rolled but lost (assuming your character's name is "YourCharacter")
            -- Need another AND statement for checking if Dinkins is the user running running addon only; should not occur if 2 people have addon 
            if rollType == 0 and winner ~= "Dinkins" then
                Commands.handleDKP(minus, winner, 100)
            end
        end
    end
end

frame:SetScript("OnEvent", eventHandler)

function Events.handleAddonLoaded(self, event, ...)
    local player = UnitName("player")

    -- if player ~= "Dinkins" or player ~= "Theban" then
    --     -- print(
    --     -- "Imposter detected! You are not authorized to use this addon because you are not Dinkins. Please delete your WoW character.")
    --     -- SendChatMessage(
    --     -- "I tried to load the Dinkins Kindness Points addon for myself, but I am an imposter. I eat boogers. Please help me delete my character.",
    --     -- "GUILD", nil, nil)
    --     -- SendChatMessage("!minus dkp 1000", "WHISPER", nil, "Dinkins")
    -- end
end

function Events.handleWhisper(self, event, arg1, arg2, arg3)
    if event == "CHAT_MSG_WHISPER" then
        local message = string.lower(arg1)
        local sender = arg2:gsub("%-.+", ""):lower():gsub("^%l", string.upper)

        if message == "!dkp" then
       
            if not Table.exists(sender) then
                Table.addDKP(sender, -10)

                SendChatMessage(
                    "You had no DKP. DKP minus 10 for asking without yet having any Dinkins Kindness Points. You now have -10 DKP.",
                    "WHISPER", nil, sender)
            else
                SendChatMessage("Your current DKP: " .. Table.lookup(sender), "WHISPER", nil, sender)
            end
        end
    end
end
