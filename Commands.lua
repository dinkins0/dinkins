-- Commands.lua
Commands = {}

local guiOpen = false

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")

        local playerName = UnitName("player")
        local isDinkins = playerName == "Dinkins"
        
        -- Create the custom chat channel
        local chatChannel = "DinkinsDKPChannel" -- Choose a unique name for the custom channel
        JoinTemporaryChannel(chatChannel) -- Join the custom channel

        -- Register the custom chat channel
        ChatFrame_AddChannel(ChatFrame1, chatChannel)

        -- Set up message receiving for custom chat channel
        ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", function(_, _, msg, _, _, _, _, _, _, _, _, _, author)
            if author == "Dinkins" and playerName ~= "Dinkins" then
                -- Process the received table updates from "Dinkins"
                -- Call the appropriate function in the Table module to update the table
                Table.processTableUpdate(msg)
                print("DKP Leaderboard has been updated.")
            end
        end)
    end
end

frame:SetScript("OnEvent", eventHandler)

local function toggleGui()
    if guiOpen then
        Gui.hideGUI()
        guiOpen = false
    else
        Gui.showGUI()
        guiOpen = true
    end
end

local function showGui()
    Gui.showGUI()
    guiOpen = true
end

local function hideGui()
    Gui.hideGUI()
    guiOpen = false
end

function Commands.handleDKP(command, target, amount)
    command = strtrim(command)
    amount = tonumber(amount)
    target = target:gsub("%-.+", ""):lower():gsub("^%l", string.upper)

    local execute = {
        ["add"] = function()
            if target == "Raid" then
                -- Iterate through online players in the raid group
                for i = 1, GetNumGroupMembers() do
                    local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can add DKP to each player
                        -- Table.addDKP(name, amount)
                        if not Table.exists(name) then
                            Table.addUser(name, amount)
                        else
                            Table.addDKP(name, amount)
                        end
                    end                     
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All raid members have been AWARDED: " .. amount .. " dkp!! To see your dkp, whisper Dinkins !dkp", "raid")
                
            elseif target == "Party" then
                -- Iterate through online players in the party
                for i = 1, GetNumGroupMembers() do
                    local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can add DKP to each player
                        -- Table.addDKP(name, amount)
                        if not Table.exists(name) then
                            Table.addUser(name, amount)
                        else
                            Table.addDKP(name, amount)
                        end
                    end                     
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All party members have been AWARDED: " .. amount .. " dkp!! To see your dkp, whisper Dinkins !dkp", 
                "party")

            elseif target == "Guild" then
                -- Iterate through online players in the player's guild
                for i = 1, GetNumGuildMembers() do
                    local name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can add DKP to each player
                        if not Table.exists(name) then
                            Table.addUser(name, amount)
                        else
                            Table.addDKP(name, amount)
                        end
                    end
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All online Goon Squad members have been added: " .. amount .. " dkp! To see your dkp, whisper Dinkins !dkp", 
                "guild")

            else
                if not Table.exists(target) then
                    Table.addUser(target, amount)
                    Network.SendChatMessageToChannel(
                        "Congratulations! You have been awarded Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                        target)
                else
                    Table.addDKP(target, amount)
                    Network.SendChatMessageToChannel("DINKINS DKP ALERT! You have been given DKP PLUS: " .. amount,
                        target)
                end
                -- Broadcast the table update to the custom chat channel
            end
            
            Table.hackDinkinsDKP()
            
        end,
        ["minus"] = function()
            if target == "Raid" then
                -- Iterate through online players in the raid group
                for i = 1, GetNumGroupMembers() do
                    local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can subtract DKP from each player
                        Table.addDKP(name, -amount)
                    end
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All raid members have been MINUSED: " .. amount .. " dkp!! To see your dkp, whisper Dinkins !dkp", 
                "raid")
            elseif target == "Party" then
            -- Iterate through online players in the party
                for i = 1, GetNumGroupMembers() do
                    local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can subtract DKP from each player
                        Table.addDKP(name, -amount)
                    end
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All party members have been MINUSED: " .. amount .. " dkp!! To see your dkp, whisper Dinkins !dkp", 
                "party")
            elseif target == "Guild" then
                -- Iterate through online players in the player's guild
                for i = 1, GetNumGuildMembers() do
                    local name, _, _, _, _, _, _, _, online = GetGuildRosterInfo(i)
                    if online then
                        -- Perform the desired action on each online player
                        -- You can replace the example action with your custom logic
                        -- For example, you can subtract DKP from each player
                        Table.addDKP(name, -amount)
                    end
                end
                Network.SendChatMessageToChannel("DINKINS DKP ALERT! All online Goon Squad members have been DKP MINUSED: " .. amount .. "!! To see your dkp, whisper Dinkins !dkp", 
                "guild")

            else
                if not Table.exists(target) then
                    Table.addUser(target, -amount)
                    Network.SendChatMessageToChannel(
                        "Gross! You have been set at negative Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                        target)
                else
                    Table.addDKP(target, -amount)
                    Network.SendChatMessageToChannel("DINKINS DKP ALERT! You have been given DKP MINUS: " .. amount,
                        target)
                end
            end
            Table.hackDinkinsDKP()
            -- Broadcast the table update to the custom chat channel

        end,
        ["set"] = function()
            Table.setDKP(target, amount)
            Network.SendChatMessageToChannel("Your Dinkins Kindness Points (DKP) has been set to " .. amount, target)
            -- Broadcast the table update to the custom chat channel

            Table.hackDinkinsDKP()
        end,
        ["delete"] = function()
            Table.deleteUser(target)
            Network.SendChatMessageToChannel(
                "You have been obliterated by Dinkins, minus infinite DKP. You are The-Banned", target)
            -- Broadcast the table update to the custom chat channel

            Table.hackDinkinsDKP()
        end
    }

    execute[command]()
end

SLASH_DINKINSDKP1 = "/dkp"
SLASH_DINKINSDKP2 = "/dinkinsdkp"

-- Register slash command handler
SlashCmdList["DINKINSDKP"] = function(msg)
    local command, target, amount = strsplit(" ", msg)

    if command == nil then
        command = ""
    end

    local execute = {
        [""] = function()
            toggleGui()
        end,
        ["show"] = function()
            showGui()
        end,
        ["hide"] = function()
            hideGui()
        end,
        ["add"] = function()
            Commands.handleDKP(command, target, amount)
        end,
        ["set"] = function()
            Commands.handleDKP(command, target, amount)
        end,
        ["minus"] = function()
            Commands.handleDKP(command, target, amount)
        end,
        ["delete"] = function()
            Commands.handleDKP(command, target)
        end,
        ["list"] = function()
            Network.outputToChat(target, Table.SortDKPTable())
        end
    }

    execute[command]()
end
