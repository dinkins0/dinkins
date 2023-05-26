-- Commands.lua
Commands = {}

local guiOpen = false

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")

local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        frame:UnregisterEvent("ADDON_LOADED")
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

    local execute = {
        ["add"] = function()
            if not Table.exists(target) then
                Table.addUser(target, amount)
                Network.SendChatMessageToChannel(
                    "Congratulations! You have been awarded Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                Table.addDKP(target, amount)
                Network.SendChatMessageToChannel("DKP plus " .. amount .. ". You now have " ..
                                                     (Table.lookup(target) or "?") .. " Dinkins Kindness Points.",
                    target)
            end
        end,
        ["minus"] = function()
            if not Table.exists(target) then
                Table.addUser(target, -amount)
                Network.SendChatMessageToChannel(
                    "Gross! You have been set at negative Dinkins Kindness Points (DKP). To see your DKP at any time, whisper Dinkins: !dkp",
                    target)
            else
                Table.addDKP(target, -amount)
                Network.SendChatMessageToChannel("DKP minus " .. amount .. ". You now have " ..
                                                     (Table.lookup(target) or "?") .. " Dinkins Kindness Points.",
                    target)
            end
        end,
        ["set"] = function()
            Table.setDKP(target, amount)
            Network.SendChatMessageToChannel("Your Dinkins Kindness Points (DKP) has been set to " .. amount, target)
        end,
        ["delete"] = function()
            Table.deleteUser(target)
            Network.SendChatMessageToChannel(
                "You have been obliterated by Dinkins, minus infinite DKP. You are The-Banned", target)
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
