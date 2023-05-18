-- Table.lua
Table = {}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

-- Initialize local table with either WoW Saved Variable or default
local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        Table.DinkinsDKPDB = DinkinsDKPDB
        frame:UnregisterEvent("ADDON_LOADED")
    end

    if event == "PLAYER_LOGOUT" then
        DinkinsDKPDB = Table.DinkinsDKPDB
    end
end

frame:SetScript("OnEvent", eventHandler)

function Table.exists(playerName)
    if Table.DinkinsDKPDB[playerName] ~= nil then
        return true
    end

    return false
end

function Table.lookup(playerName)
    if Table.DinkinsDKPDB[playerName] ~= nil then
        return Table.DinkinsDKPDB[playerName]
    else
        print("Player does not exist in the table.")
    end
end

-- Allow adding records to the table
function Table.add(playerName, dkpTotal)
    if Table.DinkinsDKPDB[playerName] == nil then
        Table.DinkinsDKPDB[playerName] = dkpTotal
    else
        print("Player already exists in the table.")
    end
end

-- Allow modifying records in the table
function Table.modify(playerName, dkpTotal)
    if Table.DinkinsDKPDB[playerName] ~= nil then
        Table.DinkinsDKPDB[playerName] = dkpTotal
    else
        print("Player does not exist in the table.")
    end
end

-- Allow modifying records in the table by adding to the existing dkpTotal
function Table.modifyByAdding(playerName, dkpToAdd)
    if Table.DinkinsDKPDB[playerName] ~= nil then
        Table.DinkinsDKPDB[playerName] = Table.DinkinsDKPDB[playerName] + dkpToAdd
    else
        print("Player does not exist in the table.")
    end
end

-- Allow deleting records from the table
function Table.delete(playerName)
    if Table.DinkinsDKPDB[playerName] ~= nil then
        Table.DinkinsDKPDB[playerName] = nil
    else
        print("Player does not exist in the table.")
    end
end

-- Table Sorting
function Table.SortDKPTable()
    local sortedTable = {}
    for playerName, dkp in pairs(Table.DinkinsDKPDB) do
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

    for playerName, playerData in pairs(Table.DinkinsDKPDB) do
        if playerName ~= "Dinkins" then
            if playerData.dkpTotal > maxDKP then
                maxDKP = playerData.dkpTotal
            end
        end
    end

    if Table.DinkinsDKPDB["Dinkins"] ~= nil and Table.DinkinsDKPDB["Dinkins"] <= maxDKP then
        Table.DinkinsDKPDB["Dinkins"] = maxDKP + 1
    end
end
