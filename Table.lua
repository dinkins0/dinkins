-- Table.lua
Table = {}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

local function eventHandler(self, event, ...)
    if event == "ADDON_LOADED" and ... == "DinkinsDKP" then
        Table.DinkinsDKPDB = DinkinsDKPDB or {}
        Table.hackDinkinsDKP()

        print(Table.size() .. " DKPDB entries loaded.")

        frame:UnregisterEvent("ADDON_LOADED")
    end

    if event == "PLAYER_LOGOUT" then
        Table.hackDinkinsDKP()
        DinkinsDKPDB = Table.DinkinsDKPDB

        frame:UnregisterEvent("PLAYER_LOGOUT")
    end
end

frame:SetScript("OnEvent", eventHandler)

function Table.exists(playerName)
    if not Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        return true
    end

    return false
end

function Table.lookup(playerName)
    return Table.DinkinsDKPDB[playerName]
end

function Table.addUser(playerName, ...)
    local dkp = ...
    local mergedName = playerName:gsub("%-.+", ""):lower():gsub("^%l", string.upper)

    if Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        -- Check for duplicates with different cases
        for name, _ in pairs(Table.DinkinsDKPDB) do
            if name:lower() == mergedName then
                mergedName = name
                break
            end
        end

        -- Merge duplicate entries or create a new entry
        if dkp then
            if mergedName ~= playerName then
                Table.DinkinsDKPDB[mergedName] = dkp + (Table.DinkinsDKPDB[mergedName] or 0)
                Table.DinkinsDKPDB[playerName] = nil
            else
                Table.DinkinsDKPDB[playerName] = dkp
            end
        else
            if mergedName ~= playerName then
                Table.DinkinsDKPDB[mergedName] = Table.DinkinsDKPDB[mergedName] or 0
                Table.DinkinsDKPDB[playerName] = nil
            else
                Table.DinkinsDKPDB[playerName] = 0
            end
        end
    end
end

function Table.setDKP(playerName, dkpTotal)
    if not Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        Table.DinkinsDKPDB[playerName] = dkpTotal
    else
        Table.addUser(playerName, dkpTotal)
    end
end

function Table.addDKP(playerName, dkp)
    if not Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        Table.DinkinsDKPDB[playerName] = Table.DinkinsDKPDB[playerName] + dkp
    else
        Table.addUser(playerName, dkp)
    end
end

function Table.deleteUser(playerName)
    if not Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        Table.DinkinsDKPDB[playerName] = nil
    end
end

function Table.size()
    local count = 0

    for _ in pairs(Table.DinkinsDKPDB) do
        count = count + 1
    end

    return count
end

function Table.SortDKPTable()
    -- Merge and clean up duplicate entries
    local mergedTable = {}
    for playerName, dkp in pairs(Table.DinkinsDKPDB) do
        local mergedName = playerName:gsub("%-.+", ""):lower():gsub("^%l", string.upper)
        mergedName = mergedName:gsub("(%a)([%w_']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end)

        if mergedTable[mergedName] then
            mergedTable[mergedName].dkp = mergedTable[mergedName].dkp + dkp
        else
            mergedTable[mergedName] = {
                name = mergedName,
                dkp = dkp
            }
        end
    end

    -- Sort the merged table
    local sortedTable = {}
    for _, data in pairs(mergedTable) do
        table.insert(sortedTable, data)
    end

    table.sort(sortedTable, function(a, b)
        return a.dkp > b.dkp
    end)

    return sortedTable
end



function Table.hackDinkinsDKP()
    local maxDKP = -math.huge

    for name, dkp in pairs(Table.DinkinsDKPDB) do
        if name ~= "Dinkins" then
            if dkp > maxDKP then
                maxDKP = dkp
            end
        end
    end

    if Table.DinkinsDKPDB["Dinkins"] ~= nil and Table.DinkinsDKPDB["Dinkins"] <= maxDKP then
        Table.DinkinsDKPDB["Dinkins"] = maxDKP + 1
    end
end
