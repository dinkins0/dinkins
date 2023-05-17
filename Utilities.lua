-- Utilities.lua
local util = {}

function util.initialize()
    -- Initialization code here
end

-- Table Sorting
function util.SortDKPTable(dkpTable)
    local sortedTable = {}
    for playerName, dkp in pairs(dkpTable) do
        table.insert(sortedTable, {name = playerName, dkp = dkp})
    end

    table.sort(sortedTable, function(a, b)
        return a.dkp > b.dkp
    end)

    return sortedTable
end

return util