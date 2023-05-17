-- Table.lua
local table = {}

function table.initialize()
    -- Define DKP storage table
    table.dkpTable = {}

    -- Add Global variable to store the add-on's namespace
    table.DinkinsDKP = {}
end

-- Function to save the 'dkpTable' data
function table.SaveData(dkpTable)
    table.dkpTable = dkpTable
end

return table