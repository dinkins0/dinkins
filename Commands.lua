-- Commands.lua
local commands = {}

function commands.register()
    -- Register commands here
    frame:RegisterEvent("CHAT_MSG_WHISPER")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("PLAYER_LOGOUT")
    frame:RegisterEvent("PLAYER_LEAVING_WORLD")
end

return commands