-- Table.lua
DinkinsDKPDB = DinkinsDKPDB or {}
local table = DinkinsDKPDB.dkpTable or {}

function table.initialize()
    -- Define DKP storage table
    DinkinsDKPDB.dkpTable = {}

    -- Add Global variable to store the add-on's namespace
    DinkinsDKPDB.DinkinsDKP = {}
end

-- Function to save the 'dkpTable' data
function table.SaveData(dkpTable)
    DinkinsDKPDB.dkpTable = dkpTable
end

return DinkinsDKPDB