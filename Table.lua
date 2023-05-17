-- Table.lua
local Table = {}

-- Initialize local table with either WoW Saved Variable or default
function Table.initialize()
    if DinkinsDKPDB == nil then
        DinkinsDKPDB = {}
    end
end

-- Allow adding records to the table
function Table.add(playerName, dkpTotal)
    if DinkinsDKPDB[playerName] == nil then
        DinkinsDKPDB[playerName] = {
            dkpTotal = dkpTotal
        }
    else
        print("Player already exists in the table.")
    end
end

-- Allow modifying records in the table
function Table.modify(playerName, dkpTotal)
    if DinkinsDKPDB[playerName] ~= nil then
        DinkinsDKPDB[playerName].dkpTotal = dkpTotal
    else
        print("Player does not exist in the table.")
    end
end

-- Allow modifying records in the table by adding to the existing dkpTotal
function Table.modifyByAdding(playerName, dkpToAdd)
    if DinkinsDKPDB[playerName] ~= nil then
        DinkinsDKPDB[playerName].dkpTotal = DinkinsDKPDB[playerName].dkpTotal + dkpToAdd
    else
        print("Player does not exist in the table.")
    end
end

-- Allow deleting records from the table
function Table.delete(playerName)
    if DinkinsDKPDB[playerName] ~= nil then
        DinkinsDKPDB[playerName] = nil
    else
        print("Player does not exist in the table.")
    end
end

return Table
