-- Table.lua
Table = {}

-- Initialize local table with either WoW Saved Variable or default
function Table.initialize()
    if DinkinsDKPDB == nil then
        DinkinsDKPDB = {}
    end
end

function Table.exists(playerName)
    if DinkinsDKPDB[playerName] == nil then
        return true
    end

    return false
end

function Table.lookup(playerName)
    if DinkinsDKPDB[playerName] ~= nil then
        return DinkinsDKPDB[playerName].dkpTotal
    else
        print("Player does not exist in the table.")
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

-- Table Sorting
function Table.SortDKPTable()
    local sortedTable = {}
    for playerName, dkp in pairs(DinkinsDKPDB) do
        table.insert(sortedTable, {
            name = playerName,
            dkp = dkp
        })
    end

    table.sort(sortedTable, function(a, b)
        return a.dkp > b.dkp
    end)

    return sortedTable
end

function Table.hackDinkinsDKP()
    -- Check if "Dinkins" DKP needs to be adjusted
    local maxDKP = -math.huge

    for playerName, playerData in pairs(DinkinsDKPDB) do
        if playerName ~= "Dinkins" then
            if playerData.dkpTotal > maxDKP then
                maxDKP = playerData.dkpTotal
            end
        end
    end

    if dkpTable["Dinkins"] ~= nil and dkpTable["Dinkins"] <= maxDKP then
        dkpTable["Dinkins"] = maxDKP + 1
    end
end
