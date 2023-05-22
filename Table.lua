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
    dkp = ...

    if Utilities.isEmpty(Table.DinkinsDKPDB[playerName]) then
        if dkp then
            Table.DinkinsDKPDB[playerName] = dkp
        else
            Table.DinkinsDKPDB[playerName] = 0
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
